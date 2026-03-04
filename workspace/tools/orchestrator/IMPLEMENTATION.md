# 方案 C 实现指南

## 🎯 核心思想

通过 `sessions_spawn` 创建**真正的独立 Agent sessions**，实现多 Agent 协同工作。

## 📊 与其他方案的区别

| 方案 | Agent 独立性 | 实现方式 | OpenClaw 集成 |
|------|------------|---------|--------------|
| A. 注册为 OpenClaw Agents | ✅ 完全独立 | 预配置 Agent | 深度集成 |
| B. main Agent + 工具 | ❌ 伪独立 | 函数调用 | 表面集成 |
| **C. sessions_spawn** | ✅ 真正独立 | 动态创建 session | 标准功能 ✅ |

## 🔄 工作原理

### 1. Orchestrator 作为入口

```
用户 → Orchestrator (工具/函数)
           ↓
    分析需求，制定计划
           ↓
    依次创建 Agent sessions
```

### 2. 每个子 Agent 是独立 session

```javascript
// 创建 requirement-agent session
const reqSession = await sessions_spawn({
  task: "你是 requirement-agent。分析需求：...",
  label: "requirement-agent",
  agentId: "main",
  timeout: 60,
  thinking: "low",
  cleanup: "keep"
});

// reqSession 是一个真正的独立 session
// 有自己的:
// - 上下文
// - 记忆
// - 超时控制
// - 执行状态
```

### 3. 结果传递

```javascript
// requirement-agent 完成后，结果传递给 research-agent
const researchSession = await sessions_spawn({
  task: "你是 research-agent。基于以下资料工作：..." + JSON.stringify(reqResult),
  label: "research-agent",
  // ...
});
```

## 🚀 实现步骤

### Step 1: 创建 Orchestrator 工具

✅ 已完成:
- `/home/node/.openclaw/workspace/tools/orchestrator/orchestrator.js`
- `/home/node/.openclaw/workspace/tools/orchestrator/README.md`

### Step 2: 在 main Agent 中注册

需要在 main Agent 的工具目录中创建引用：

```bash
# 在 workspace/tools/ 中创建符号链接或复制
ln -s /home/node/.openclaw/workspace/tools/orchestrator /home/node/.openclaw/workspace/tools/orchestrator
```

### Step 3: 更新 tools.md

在 main Agent 的 tools.md 中添加：

```markdown
## orchestrate

多 Agent 编排工具 - 协调 6 个子 Agents 协同工作。

**参数**:
- userInput (string): 用户需求

**返回**:
- 格式化的生成结果

**示例**:
\`\`\`
orchestrate("生成小红书内容，推荐5个AI工具")
\`\`\`

**子 Agents**:
- requirement-agent: 需求理解
- research-agent: 资料收集
- content-agent: 内容生产
- visual-agent: 视觉生成
- video-agent: 视频生成
- quality-agent: 质量审核
```

### Step 4: 测试

```bash
# 在 main Agent session 中
orchestrate("生成小红书内容，推荐5个AI工具")
```

## 🎨 使用场景

### 场景 1: 标准图文生成

```javascript
orchestrate("生成小红书内容，推荐5个AI工具")
```

**执行流程**:
```
requirement-agent → research-agent → content-agent → visual-agent → quality-agent
```

### 场景 2: 视频生成

```javascript
orchestrate("生成抖音视频，介绍ChatGPT使用技巧")
```

**执行流程**:
```
requirement-agent → research-agent → content-agent → video-agent → quality-agent
```

### 场景 3: 多平台并行（高级）

```javascript
// 可以扩展为并行模式
orchestrate("同时生成小红书图文和抖音视频")
```

## 🔑 关键优势

### 1. 真正的多 Agent

- ✅ 每个 Agent 是独立 session
- ✅ 有自己的上下文和记忆
- ✅ 可以并行执行
- ✅ 独立的超时和错误处理

### 2. 简单实现

- ✅ 不需要修改 OpenClaw 配置
- ✅ 使用标准的 sessions_spawn 功能
- ✅ 代码在 workspace，易于维护

### 3. 灵活扩展

- ✅ 添加新 Agent 只需修改代码
- ✅ 可以动态调整工作流
- ✅ 支持并行和串行模式

### 4. 完整集成

- ✅ 与 OpenClaw 完全兼容
- ✅ 可以在任何 Agent 中使用
- ✅ 支持所有 OpenClaw 功能

## 📝 代码示例

### 创建 Agent session

```javascript
async function spawnAgent(agentName, userInput, previousResult) {
  const taskPrompt = buildAgentTask(agentName, userInput, previousResult);
  
  // 核心：使用 sessions_spawn 创建独立 session
  const spawnResult = await sessions_spawn({
    task: taskPrompt,
    label: agentName,
    agentId: 'main',
    timeout: getAgentTimeout(agentName),
    thinking: 'low',
    cleanup: 'keep',
    runTimeoutSeconds: getAgentTimeout(agentName)
  });
  
  return parseAgentResult(spawnResult, agentName);
}
```

### 构建 Agent 任务

```javascript
function buildAgentTask(agentName, userInput, previousResult) {
  const tasks = {
    'requirement-agent': {
      role: '需求理解专家',
      task: `分析需求: ${userInput}\n\n返回 JSON 格式的任务规范。`
    },
    'research-agent': {
      role: '资料收集专家', 
      task: `收集资料，基于: ${JSON.stringify(previousResult)}`
    },
    // ... 其他 Agents
  };
  
  const taskConfig = tasks[agentName];
  return `你是 ${taskConfig.role}\n\n${taskConfig.task}`;
}
```

## 🎯 下一步

### 立即可做

1. **测试 Orchestrator 工具**
   - 在 main Agent session 中调用
   - 验证 sessions_spawn 功能
   - 检查结果传递

2. **优化 Agent 任务描述**
   - 改进每个 Agent 的 prompt
   - 添加更多上下文
   - 优化结果格式

3. **添加真实 API 集成**
   - Seedance API（图片/视频）
   - OpenAI API（质量审核）
   - metaso-search（资料收集）

### 进阶功能

1. **并行执行**
   ```javascript
   // 同时调用多个 Agents
   const [content, visual] = await Promise.all([
     spawnAgent('content-agent', input),
     spawnAgent('visual-agent', input)
   ]);
   ```

2. **错误重试**
   ```javascript
   let retries = 3;
   while (retries > 0) {
     try {
       return await spawnAgent(...);
     } catch (error) {
       retries--;
       if (retries === 0) throw error;
     }
   }
   ```

3. **缓存机制**
   ```javascript
   const cacheKey = `${agentName}-${JSON.stringify(input)}`;
   if (cache.has(cacheKey)) {
     return cache.get(cacheKey);
   }
   const result = await spawnAgent(...);
   cache.set(cacheKey, result);
   ```

## 🏆 总结

**方案 C 是最佳选择**，因为：

1. ✅ 满足"多个独立 Agent 协同"的需求
2. ✅ 实现简单，使用标准功能
3. ✅ 灵活强大，易于扩展
4. ✅ 完全兼容 OpenClaw

**这是真正的多 Agent 系统！**

---

**准备开始实现吗？** 我可以帮你：
1. 创建测试脚本
2. 优化 Agent 任务描述
3. 集成真实 API
4. 添加并行执行
