# Orchestrator + sessions_spawn 实现指南

## 架构设计

```
┌─────────────────────────────────────────────────┐
│         OpenClaw Agents System                  │
│                                                  │
│  ✅ Orchestrator (注册为 OpenClaw Agent)         │
│     - 在 openclaw agents list 中可见             │
│     - 可以被用户直接调用                         │
│     - 作为入口点协调所有工作                     │
│                                                  │
│  ⚡ 子 Agents (通过 sessions_spawn 动态创建)      │
│     - 不在 openclaw agents list 中               │
│     - 由 Orchestrator 按需创建                   │
│     - 完成任务后自动销毁                         │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

## 工作流程

### 1. 用户调用 Orchestrator

```bash
# 用户发送消息给 Orchestrator
"生成小红书内容，推荐5个AI工具"
  ↓
Orchestrator 接收
```

### 2. Orchestrator 分析需求

```javascript
// 在 Orchestrator 中
async execute(userInput) {
  // 1. 分析需求，制定执行计划
  const plan = this.createExecutionPlan(userInput);
  
  // 2. 串行/并行执行
  const results = await this.executeWorkflow(plan);
  
  // 3. 整合结果，返回给用户
  return this.formatResults(results);
}
```

### 3. 调用子 Agents

```javascript
// 在 Orchestrator 中
async callAgent(agentName, taskInput) {
  // 真实的 sessions_spawn 调用
  const spawnResult = await sessions_spawn({
    task: JSON.stringify(taskInput),
    label: agentName,
    agentId: 'main',  // 使用 main agent 作为执行器
    timeout: this.getAgentTimeout(agentName),
    thinking: 'low',  // 子 Agent 不需要深度思考
    cleanup: 'delete'  // 完成后自动删除
  });
  
  return spawnResult;
}
```

### 4. 子 Agent 执行任务

```javascript
// 子 Agent 的实现（在 main agent 的 session 中）
async function handleTask(task) {
  const agentName = task.agent;
  const input = task.previous_result;
  
  // 根据 agentName 执行不同的逻辑
  switch(agentName) {
    case 'requirement-agent':
      return await analyzeRequirement(input);
    case 'research-agent':
      return await collectMaterials(input);
    case 'content-agent':
      return await generateContent(input);
    // ... 其他 Agents
  }
}
```

---

## 实现步骤

### Step 1: 创建 Orchestrator Agent

**位置**: `~/.openclaw/agents/orchestrator/`

```bash
# 创建 Orchestrator Agent
openclaw agents create orchestrator

# 配置 Agent
cd ~/.openclaw/agents/orchestrator/agent
```

**system.md**:
```markdown
# Orchestrator - 多 Agent 编排器

你是 Orchestrator，负责协调多个子 Agent 协同工作。

## 你的能力

1. 接收用户需求
2. 分析需求类型
3. 制定执行计划
4. 调用子 Agents（通过 sessions_spawn）
5. 整合最终结果

## 子 Agents

你有 6 个子 Agents：
- requirement-agent: 需求理解
- research-agent: 资料收集
- content-agent: 内容生产
- visual-agent: 视觉生成
- video-agent: 视频生成
- quality-agent: 质量审核

## 工作流程

1. 分析用户需求
2. 制定执行计划（串行/并行）
3. 依次调用子 Agents
4. 整合结果，返回给用户

## 重要

- 使用 sessions_spawn 调用子 Agents
- 传递前一个 Agent 的结果给下一个
- 如果某个 Agent 失败，记录但继续执行
- 最后整合所有结果并格式化输出
```

### Step 2: 实现 Orchestrator 逻辑

在 Orchestrator 的工具脚本中实现：

**orchestrator-tool.js**:
```javascript
/**
 * Orchestrator 工具脚本
 * 在 Orchestrator Agent 的 session 中运行
 */

const Orchestrator = {
  async execute(userInput) {
    console.log('📌 Orchestrator 启动');
    console.log(`📌 输入: ${userInput}`);
    
    // 1. 分析需求，制定计划
    const plan = this.createExecutionPlan(userInput);
    console.log(`📌 执行计划: ${plan.workflow} 模式`);
    
    // 2. 执行工作流
    const results = await this.executeWorkflow(plan);
    
    // 3. 整合结果
    const output = this.formatResults(results);
    
    return output;
  },
  
  createExecutionPlan(userInput) {
    // 检测需求类型
    const hasVideo = userInput.includes('视频') || userInput.includes('抖音');
    
    if (hasVideo) {
      return {
        workflow: 'linear',
        steps: [
          'requirement-agent',
          'research-agent',
          'content-agent',
          'video-agent',
          'quality-agent'
        ]
      };
    } else {
      return {
        workflow: 'linear',
        steps: [
          'requirement-agent',
          'research-agent',
          'content-agent',
          'visual-agent',
          'quality-agent'
        ]
      };
    }
  },
  
  async executeWorkflow(plan) {
    const results = {};
    let previousResult = null;
    
    for (const agentName of plan.steps) {
      console.log(`📋 调用 ${agentName}...`);
      
      // 调用子 Agent
      const agentResult = await this.callSubAgent(agentName, previousResult);
      
      results[agentName] = agentResult;
      previousResult = agentResult;
      
      console.log(`✅ ${agentName} 完成`);
    }
    
    return results;
  },
  
  async callSubAgent(agentName, previousResult) {
    // 这里是关键：使用 sessions_spawn
    // 注意：这需要在实际的 Agent 环境中运行
    // 简化版本用模拟
    
    const taskInput = {
      agent: agentName,
      timestamp: new Date().toISOString(),
      previous_result: previousResult
    };
    
    // 模拟 Agent 执行
    // 真实环境中应该是：
    // const result = await sessions_spawn({...});
    
    return this.simulateAgent(agentName, taskInput);
  },
  
  simulateAgent(agentName, input) {
    // 模拟各个 Agent 的输出
    const simulations = {
      'requirement-agent': () => ({
        task_id: 'req-001',
        content_type: ['文案', '图片'],
        platforms: ['小红书'],
        topic: '5个AI工具推荐'
      }),
      
      'research-agent': () => ({
        materials: [
          { name: 'ChatGPT', relevance: 0.95 },
          { name: 'Midjourney', relevance: 0.90 }
        ]
      }),
      
      'content-agent': () => ({
        title: '【5个效率翻倍的AI工具】✨',
        body: '还在为工作效率低烦恼？...',
        hashtags: ['#AI工具']
      }),
      
      'visual-agent': () => ({
        recommended_params: {
          style: 'fresh',
          layout: 'list'
        }
      }),
      
      'video-agent': () => ({
        storyboard: '60秒视频分镜'
      }),
      
      'quality-agent': () => ({
        overall_score: 88,
        grade: '良好',
        passed: true
      })
    };
    
    return simulations[agentName]?.() || {};
  },
  
  formatResults(results) {
    let output = '🎯 生成结果\n\n';
    
    if (results['content-agent']) {
      output += '📝 文案:\n';
      output += results['content-agent'].body + '\n\n';
    }
    
    if (results['visual-agent']) {
      output += '🎨 视觉参数: ';
      output += JSON.stringify(results['visual-agent'].recommended_params) + '\n\n';
    }
    
    if (results['quality-agent']) {
      output += '✅ 质量评分: ';
      output += `${results['quality-agent'].overall_score}/100\n`;
    }
    
    return output;
  }
};

// 导出
module.exports = Orchestrator;
```

### Step 3: 注册 Orchestrator 工具

在 Orchestrator Agent 中注册这个工具：

**tools.md**:
```markdown
## 工具

### orchestrate

调用 Orchestrator 执行任务。

**参数**:
- userInput (string): 用户需求

**返回**:
- 格式化的结果字符串

**示例**:
\`\`\`
orchestrate("生成小红书内容，推荐5个AI工具")
\`\`\`
```

---

## 使用方式

### 用户直接调用 Orchestrator

```bash
# 用户发送消息给 Orchestrator Agent
"请帮我生成小红书内容，推荐5个AI工具"
  ↓
Orchestrator 接收并执行
  ↓
内部调用子 Agents
  ↓
返回整合后的结果
```

### 通过 routing 规则

**配置 routing 规则**:
```bash
# 当消息包含"生成"、"推荐"等关键词时，路由到 Orchestrator
openclaw agents routing add orchestrator \
  --channel "webchat" \
  --pattern "生成|推荐|制作" \
  --agent "orchestrator"
```

---

## 优势

### 1. 简单

- 只需要管理 1 个 OpenClaw Agent
- 子 Agents 通过代码实现，不需要配置

### 2. 灵活

- 可以动态创建子 Agents
- 不需要预注册
- 可以根据需求调整

### 3. 高效

- 子 Agents 完成后自动销毁
- 不占用系统资源
- 结果直接返回

---

## 真实 sessions_spawn 集成

### 当前状态

使用 `simulateAgent()` 模拟子 Agents。

### 真实实现

需要修改 `callSubAgent()` 方法：

```javascript
async callSubAgent(agentName, previousResult) {
  const taskInput = {
    agent: agentName,
    timestamp: new Date().toISOString(),
    previous_result: previousResult
  };
  
  // 真实的 sessions_spawn 调用
  // 这需要在 OpenClaw Agent 环境中运行
  const spawnResult = await sessions_spawn({
    task: `你是${agentName}。执行以下任务：${JSON.stringify(taskInput)}`,
    label: agentName,
    agentId: 'main',
    timeout: 60,
    thinking: 'low',
    cleanup: 'delete',
    runTimeoutSeconds: 60
  });
  
  // 等待子 Agent 完成
  // 子 Agent 会通过 sessions_send 返回结果
  return spawnResult;
}
```

---

## 下一步

### 立即可做

1. **创建 Orchestrator Agent**
   ```bash
   openclaw agents create orchestrator
   ```

2. **实现工具脚本**
   - 复制上面的 `orchestrator-tool.js`
   - 注册为 Orchestrator 的工具

3. **测试**
   - 发送消息给 Orchestrator
   - 验证工作流程

### 进阶

1. **真实 sessions_spawn 集成**
   - 替换 `simulateAgent()` 为真实调用
   - 实现子 Agents 的独立逻辑

2. **API 集成**
   - Seedance API（图片/视频）
   - OpenAI API（质量审核）

3. **优化**
   - 并行执行
   - 缓存机制
   - 错误重试

---

**总结**: 使用 Orchestrator + sessions_spawn 的方案，既简单又灵活，是最佳选择！
