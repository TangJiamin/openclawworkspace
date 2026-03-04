# Agent 矩阵系统（实际可用方案）

基于 OpenClaw 的 **`sessions_spawn` 工具函数** 实现真正的多 Agent 协同。

## 🔍 技术现实检查

### ✅ 可用的能力

1. **`sessions_spawn` 工具函数**（Main Agent 可用）
   - 创建独立的 Agent sessions
   - 支持自定义 agentId
   - 支持超时控制
   - 支持独立记忆

2. **已有 Skills**（9个）
   - requirement-analyzer
   - material-collector（新建）
   - content-planner
   - visual-generator
   - seedance-storyboard
   - quality-reviewer
   - metaso-search
   - ai-daily-digest
   - agent-canvas-confirm

### ❌ 不可用的能力

1. **CLI 命令** `openclaw sessions spawn`
   - 不存在这个命令
   - 无法通过 shell 调用

2. **预配置的 Sub-Agents**
   - `agents_list` 返回只有 `main` agent
   - 需要通过 `sessions_spawn` 动态创建

## 🏗️ 可用的架构

### 方案：Main Agent 作为编排器

```
用户
  ↓
Main Agent（编排器）
  ↓
使用 sessions_spawn 工具
  ↓
┌──────────────────────────────────┐
│ Sub-Agent 1: 需求理解             │
│ - sessions_spawn 创建             │
│ - agentId: requirement-agent      │
│ - task: "分析需求..."             │
│ - timeout: 60s                    │
└──────────────────────────────────┘
  ↓ (Main Agent 读取结果)
┌──────────────────────────────────┐
│ Sub-Agent 2: 资料收集             │
│ - sessions_spawn 创建             │
│ - agentId: research-agent         │
│ - task: "收集资料..."             │
│ - timeout: 120s                   │
└──────────────────────────────────┘
  ↓ (Main Agent 读取结果)
... (继续其他 Agents)
  ↓
Main Agent 整合结果
  ↓
返回给用户
```

### 关键点

1. **Main Agent 是编排器**
   - 协调各个 Sub-Agents
   - 传递上下文
   - 整合结果

2. **Sub-Agents 是独立 sessions**
   - 通过 `sessions_spawn` 创建
   - 每个有独立的上下文和记忆
   - 并行执行（如果需要）

3. **不是 shell 脚本**
   - 不能用 `exec` 调用 CLI
   - 必须用 `sessions_spawn` 工具函数

## 📋 实现方式

### 方式1: 使用 orchestrate 工具（推荐）

在 TOOLS.md 中定义的 `orchestrate` 工具：

```javascript
// Main Agent 调用
orchestrate("生成小红书内容，推荐5个AI工具")
```

**内部实现**：
```javascript
async function orchestrate(userInput) {
  // 1. 需求理解
  const requirement = await sessions_spawn({
    agentId: "requirement-agent",
    task: userInput,
    timeout: 60
  });

  // 2. 资料收集
  const materials = await sessions_spawn({
    agentId: "research-agent",
    task: requirement.taskSpec,
    timeout: 120
  });

  // 3. 内容策划
  const content = await sessions_spawn({
    agentId: "content-agent",
    task: { requirement, materials },
    timeout: 90
  });

  // 4. 视觉生成
  const visual = await sessions_spawn({
    agentId: "visual-agent",
    task: { requirement, materials, content },
    timeout: 60
  });

  // 5. 质量审核
  const quality = await sessions_spawn({
    agentId: "quality-agent",
    task: { content, visual },
    timeout: 30
  });

  // 整合结果
  return { requirement, materials, content, visual, quality };
}
```

### 方式2: 手动调用 sessions_spawn

```javascript
// 创建单个 Sub-Agent
const result = await sessions_spawn({
  agentId: "requirement-agent",
  task: "分析需求: 生成小红书内容",
  timeout: 60,
  model: "default/glm-4.7", // 可选：指定模型
  thinking: "low" // 可选：指定思考级别
});
```

### 方式3: 并行执行

```javascript
// 并行创建多个 Sub-Agents
const [visual, video] = await Promise.all([
  sessions_spawn({
    agentId: "visual-agent",
    task: "生成封面图",
    timeout: 60
  }),
  sessions_spawn({
    agentId: "video-agent",
    task: "生成视频",
    timeout: 120
  })
]);
```

## 🎯 Sub-Agent 设计

### 1. 需求理解 Agent

**agentId**: `requirement-agent`
**skill**: `requirement-analyzer`
**timeout**: 60秒

```javascript
const requirement = await sessions_spawn({
  agentId: "requirement-agent",
  task: "分析需求: 生成小红书内容，推荐5个AI工具",
  timeout: 60
});

// 返回
{
  "task_id": "uuid",
  "content_type": ["文案", "图片"],
  "platforms": ["小红书"],
  "keywords": ["AI工具", "效率"]
}
```

### 2. 资料收集 Agent

**agentId**: `research-agent`
**skill**: `material-collector`
**timeout**: 120秒

```javascript
const materials = await sessions_spawn({
  agentId: "research-agent",
  task: JSON.stringify({
    keywords: ["AI工具", "效率"],
    year: 2026,
    sources: ["metaso-search", "feishu-doc"]
  }),
  timeout: 120
});

// 返回
{
  "total_collected": 25,
  "final_count": 12,
  "materials": [...],
  "timeline_check": {
    "status": "fresh",
    "note": "所有资料均在2025-2026年"
  }
}
```

### 3. 内容策划 Agent

**agentId**: `content-agent`
**skill**: `content-planner`
**timeout**: 90秒

```javascript
const content = await sessions_spawn({
  agentId: "content-agent",
  task: JSON.stringify({
    requirement: requirement,
    materials: materials
  }),
  timeout: 90
});

// 返回
{
  "content_strategy": {
    "hook": "用痛点开场",
    "structure": "引入-5个工具-总结-CTA"
  },
  "production_plan": [...]
}
```

### 4. 视觉生成 Agent

**agentId**: `visual-agent`
**skill**: `visual-generator`
**timeout**: 60秒

```javascript
const visual = await sessions_spawn({
  agentId: "visual-agent",
  task: JSON.stringify({
    content_strategy: content.content_strategy,
    materials: materials
  }),
  timeout: 60
});

// 返回
{
  "visual_params": {
    "style": "minimal",
    "layout": "sparse",
    "color_palette": "modern"
  }
}
```

### 5. 质量审核 Agent

**agentId**: `quality-agent`
**skill**: `quality-reviewer`
**timeout**: 30秒

```javascript
const quality = await sessions_spawn({
  agentId: "quality-agent",
  task: JSON.stringify({
    content: content,
    visual: visual,
    requirement: requirement
  }),
  timeout: 30
});

// 返回
{
  "overall_score": 88,
  "passed": true,
  "checks": {
    "content_quality": 90,
    "platform_compliance": 85
  }
}
```

## 🚀 使用示例

### 示例1: 生成小红书图文

```
用户: 生成小红书内容，推荐5个AI工具

Main Agent:
1. 调用 orchestrate("生成小红书内容，推荐5个AI工具")
2. 内部创建 5 个 Sub-Agents
3. 整合结果

输出:
🎯 生成结果

📋 任务规范: {...}
📚 收集资料: 12条
✍️  内容策略: 引入-5个工具-总结-CTA
🎨 视觉参数: {style: "minimal", layout: "sparse"}
✅ 质量评分: 88/100 (良好)
```

### 示例2: 生成抖音视频

```
用户: 制作抖音视频，介绍ChatGPT技巧

Main Agent:
1. 检测到"视频"需求
2. 路由到视频流程
3. 调用 seedance-storyboard agent

输出:
🎯 生成结果

📋 任务规范: {...}
📚 收集资料: 8条
🎬 视频分镜: 30秒，5个场景
✅ 质量评分: 85/100 (良好)
```

## 📊 性能评估

| 指标 | 数值 |
|------|------|
| Sub-Agent 数量 | 5个 |
| 总执行时间 | 约4-7分钟（线性） |
| 并行能力 | 支持（Promise.all） |
| 独立记忆 | ✅ 每个 Agent 独立 |
| 超时控制 | ✅ 每个 Agent 独立 |

## ⚠️ 限制和注意事项

### 1. agentId 限制

- 可以使用任意字符串作为 agentId
- 不需要预配置
- 但建议使用有意义的命名

### 2. 超时时间

- 每个 Agent 有独立的超时
- 建议设置合理的超时时间
- 超时后 Agent 会被终止

### 3. 上下文传递

- 需要手动序列化/反序列化
- 建议使用 JSON 格式
- 注意数据大小限制

### 4. 并行执行

- 使用 Promise.all 可以并行
- 但要注意资源消耗
- 建议 2-3 个 Agent 并行

## 🎯 下一步

1. ✅ 确认 `sessions_spawn` 可用
2. ✅ 创建 material-collector skill
3. ⏳ 测试单个 Sub-Agent
4. ⏳ 测试完整工作流
5. ⏳ 优化错误处理

---

**创建时间**: 2026-03-02
**技术**: OpenClaw sessions_spawn 工具函数
**关键**: 不是 CLI，是工具函数
