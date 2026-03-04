# Orchestrator 使用指南

## 🚀 快速开始

### 1. 理解架构

Orchestrator 通过 `sessions_spawn` 创建**真正的独立 Agent sessions**：

```
用户 → main Agent
         ↓
    调用 orchestrate 工具
         ↓
    创建多个独立 sessions
         ├─ requirement-agent session (独立)
         ├─ research-agent session (独立)
         ├─ content-agent session (独立)
         ├─ visual-agent session (独立)
         └─ quality-agent session (独立)
         ↓
    整合结果 → 返回用户
```

### 2. 核心原理

每个子 Agent 都是**真正的独立 session**：
- ✅ 独立的上下文
- ✅ 独立的记忆
- ✅ 独立的超时控制
- ✅ 可以并行执行

**关键代码**:
```javascript
const agentSession = await sessions_spawn({
  task: "你是 requirement-agent。分析需求...",
  label: "requirement-agent",
  agentId: "main",
  timeout: 60,
  thinking: "low",
  cleanup: "keep"
});
// agentSession 是一个真正的独立 session！
```

## 📖 使用方法

### 基本调用

```
orchestrate("生成小红书内容，推荐5个提升效率的AI工具")
```

### 不同类型的内容

```
# 图文内容
orchestrate("生成小红书内容，介绍ChatGPT")

# 视频内容
orchestrate("生成抖音视频，展示AI工具使用技巧")

# 微信文章
orchestrate("写微信文章，分析2025年AI趋势")

# 多平台（未来支持）
orchestrate("同时生成小红书图文和抖音视频")
```

## 🔍 工作流程详解

### Step 1: 需求理解 (requirement-agent)

**任务**: 分析用户需求，生成任务规范

**输入**: 
```javascript
{
  userInput: "生成小红书内容，推荐5个AI工具"
}
```

**输出**:
```javascript
{
  task_id: "req-001",
  content_type: ["文案", "图片"],
  platforms: ["小红书"],
  topic: "5个AI工具推荐",
  style: "轻松",
  tone: "友好",
  length: { min: 100, max: 200 }
}
```

### Step 2: 资料收集 (research-agent)

**任务**: 基于任务规范收集相关资料

**输入**:
```javascript
{
  task_spec: {...},  // 上一步的结果
  keywords: ["AI工具", "效率"]
}
```

**输出**:
```javascript
{
  materials: [
    { name: "ChatGPT", description: "...", relevance: 0.95 },
    { name: "Midjourney", description: "...", relevance: 0.90 }
  ],
  total: 15
}
```

### Step 3: 内容生产 (content-agent)

**任务**: 基于需求和资料生成内容

**输入**:
```javascript
{
  task_spec: {...},
  materials: [...]
}
```

**输出**:
```javascript
{
  title: "【5个效率翻倍的AI工具】✨",
  body: "还在为工作效率低烦恼？...",
  hashtags: ["#AI工具", "#效率提升"],
  length: 156
}
```

### Step 4: 视觉/视频生成 (visual-agent/video-agent)

**任务**: 生成视觉参数或视频分镜

**输入**:
```javascript
{
  content: {...}  // 上一步的内容
}
```

**输出** (visual-agent):
```javascript
{
  content_analysis: { type: "列表型", item_count: 5 },
  recommended_params: {
    style: "fresh",
    layout: "list",
    palette: "warm"
  }
}
```

**输出** (video-agent):
```javascript
{
  storyboard: {
    total_duration: "60秒",
    scenes: [...]
  }
}
```

### Step 5: 质量审核 (quality-agent)

**任务**: 多维度质量检查

**输入**:
```javascript
{
  content: {...},
  visual: {...}
}
```

**输出**:
```javascript
{
  overall_score: 88,
  grade: "良好",
  passed: true,
  checks: {
    content_quality: { score: 35, max: 40 },
    platform_compliance: { score: 28, max: 30 },
    brand_consistency: { score: 17, max: 20 },
    requirement_match: { score: 8, max: 10 }
  }
}
```

## 🎨 输出示例

### 成功输出

```markdown
🎯 生成结果

📋 任务规范:
{
  "content_type": ["文案", "图片"],
  "platforms": ["小红书"],
  "topic": "5个AI工具推荐"
}

📚 收集资料: 15条

✍️  生成内容:
【5个效率翻倍的AI工具】✨

还在为工作效率低烦恼？这5个AI工具帮你搞定！

1️⃣ ChatGPT - 万能文字助手
2️⃣ Midjourney - 一键生成惊艳图片
3️⃣ Notion AI - 智能笔记整理神器
4️⃣ Gamma - 快速制作精美PPT
5️⃣ Cursor - AI编程助手，代码效率飙升

💡 使用技巧：明确指令 + 善用迭代 + 组合使用

🚀 关注我，每天分享AI干货

#AI工具 #效率提升 #职场必备

🎨 视觉参数:
- 风格: fresh (清新)
- 布局: list (列表)
- 配色: warm (暖色)

✅ 质量评分: 88/100 (良好)
- 内容质量: 35/40
- 平台合规: 28/30
- 品牌一致性: 17/20
- 用户要求匹配: 8/10

📊 执行统计:
- 耗时: 4.5分钟
- 完成 Agents: 5个
```

## ⚙️ 高级用法

### 1. 自定义平台

```
orchestrate("生成B站专栏文章，介绍AI绘画工具，平台:B站")
```

### 2. 指定风格

```
orchestrate("生成小红书内容，风格:专业，介绍AI编程工具")
```

### 3. 控制长度

```
orchestrate("生成微信长文，2000字，深度分析AI行业")
```

## 🐛 故障排查

### 问题 1: sessions_spawn 未定义

**原因**: 不在 OpenClaw 环境中运行

**解决**: 确保在 main Agent session 中调用

### 问题 2: Agent 超时

**原因**: 任务太复杂或网络问题

**解决**: 
- 增加 timeout 参数
- 简化任务描述
- 检查网络连接

### 问题 3: 结果格式错误

**原因**: Agent 返回格式不符合预期

**解决**:
- 在 Agent 任务中明确要求 JSON 格式
- 添加格式验证和错误处理

## 📊 性能优化

### 1. 并行执行（未来）

```javascript
// 同时生成多个平台内容
const [xhs, douyin] = await Promise.all([
  spawnAgent('content-agent', { platform: '小红书' }),
  spawnAgent('content-agent', { platform: '抖音' })
]);
```

### 2. 缓存机制

```javascript
// 缓存已收集的资料
if (cache.has(topic)) {
  return cache.get(topic);
}
```

### 3. 增量生成

```javascript
// 只重新生成失败的部分
if (results['visual-agent'].failed) {
  results['visual-agent'] = await spawnAgent('visual-agent', input);
}
```

## 🎯 最佳实践

1. **明确需求**: 输入越具体，输出越准确
2. **合理预期**: 每个 Agent 需要时间，不要期望秒级响应
3. **检查结果**: 查看质量评分，必要时重新生成
4. **反馈优化**: 根据实际效果调整 Agent 任务描述

---

**准备开始使用了吗？** 在 main Agent session 中输入：

```
orchestrate("生成小红书内容，推荐5个提升效率的AI工具")
```
