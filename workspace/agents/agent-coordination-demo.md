# Agent 矩阵协同工作演示

## 架构概览

```
┌─────────────────────────────────────────────┐
│         Orchestrator (编排器)               │
│  接收需求 → 制定计划 → 分发任务 → 整合结果  │
└─────────────────────────────────────────────┘
                    ↓
        ┌───────────┼───────────┐
        ↓           ↓           ↓
    输入层       生产层       优化层
        ↓           ↓           ↓
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ requirement  │ │  content     │ │   quality    │
│   -agent     │ │   -agent     │ │   -agent     │
└──────────────┘ │  visual      │ └──────────────┘
                 │   -agent     │
                 │   video      │
                 │   -agent     │
                 └──────────────┘
                        ↑
                 ┌──────────────┐
                 │  research    │
                 │   -agent     │
                 └──────────────┘
```

## 协同流程示例

### 场景: 生成小红书内容，推荐5个AI工具

#### Step 1: 用户提交需求

```
用户: "生成小红书内容，推荐5个提升效率的AI工具"
  ↓
Orchestrator 接收
```

#### Step 2: Orchestrator 制定执行计划

```json
{
  "workflow": "linear",
  "steps": [
    {
      "order": 1,
      "agent": "requirement-agent",
      "task": "分析需求，生成任务规范"
    },
    {
      "order": 2,
      "agent": "research-agent",
      "task": "收集AI工具相关资料"
    },
    {
      "order": 3,
      "agent": "content-agent",
      "task": "生成小红书文案"
    },
    {
      "order": 4,
      "agent": "visual-agent",
      "task": "生成配图"
    },
    {
      "order": 5,
      "agent": "quality-agent",
      "task": "质量审核"
    }
  ]
}
```

#### Step 3: 串行执行

```
Orchestrator
  ↓ sessions_spawn
requirement-agent
  → 返回: task_spec
  ↓ sessions_spawn
research-agent (输入: task_spec)
  → 返回: materials
  ↓ sessions_spawn
content-agent (输入: task_spec + materials)
  → 返回: content_draft
  ↓ sessions_spawn
visual-agent (输入: content_draft)
  → 返回: images
  ↓ sessions_spawn
quality-agent (输入: content_draft + images)
  → 返回: quality_report
  ↓
Orchestrator 整合结果
  ↓
返回给用户
```

## 并行执行示例

### 场景: 同步生成小红书图文 + 抖音视频

```json
{
  "workflow": "parallel",
  "branches": [
    {
      "name": "小红书图文",
      "steps": [
        {"agent": "content-agent", "platform": "小红书"},
        {"agent": "visual-agent", "type": "信息图"}
      ]
    },
    {
      "name": "抖音视频",
      "steps": [
        {"agent": "content-agent", "platform": "抖音"},
        {"agent": "video-agent", "duration": "60秒"}
      ]
    }
  ]
}
```

```
requirement-agent
  ↓
research-agent
  ↓
  ├─→ content-agent (小红书) → visual-agent ─┐
  ├─→ content-agent (抖音) → video-agent ───┤→ quality-agent → 整合
  └─────────────────────────────────────────┘
```

## 使用 sessions_spawn 调用

### 调用 requirement-agent

```javascript
// 在 Orchestrator 中
await sessions_spawn({
  task: "分析需求: 生成小红书内容，推荐5个AI工具",
  label: "requirement-agent",
  timeout: 60,
  cleanup: "keep"
});
```

### requirement-agent 完成后通知

```javascript
// 在 requirement-agent 中
await sessions_send({
  sessionKey: "orchestrator",
  message: `✅ 需求分析完成

任务规范:
${JSON.stringify(taskSpec, null, 2)}`
});
```

## Agent 间通信

### 消息格式

```json
{
  "from": "requirement-agent",
  "to": "orchestrator",
  "type": "task_complete",
  "data": {
    "task_id": "req-20260302-001",
    "result": {...}
  },
  "timestamp": "2026-03-02T01:00:00Z"
}
```

### 状态同步

```javascript
// Orchestrator 维护状态
const workflowState = {
  current_step: 2,
  completed_steps: ["requirement-agent"],
  pending_steps: ["research-agent", "content-agent", "visual-agent", "quality-agent"],
  results: {
    "requirement-agent": {...}
  }
};
```

## 实际执行示例

### 输入

```
用户: "生成小红书内容，推荐5个提升效率的AI工具"
```

### 执行过程

```
[01:00:00] Orchestrator: 接收需求
[01:00:01] Orchestrator: 调用 requirement-agent
[01:00:05] requirement-agent: ✅ 完成
           任务规范: {"content_type": ["文案", "图片"], "platforms": ["小红书"], ...}
[01:00:06] Orchestrator: 调用 research-agent
[01:00:15] research-agent: ✅ 完成
           收集到 15 条资料
[01:00:16] Orchestrator: 调用 content-agent
[01:00:22] content-agent: ✅ 完成
           文案: "【5个效率翻倍的AI工具】✨..."
[01:00:23] Orchestrator: 调用 visual-agent
[01:00:28] visual-agent: ✅ 完成
           推荐参数: style=fresh, layout=list
[01:00:29] Orchestrator: 调用 quality-agent
[01:00:32] quality-agent: ✅ 通过
           质量评分: 88分
[01:00:33] Orchestrator: 整合结果
[01:00:34] Orchestrator: 返回给用户
```

### 输出

```json
{
  "success": true,
  "workflow": "linear",
  "execution_time": "34秒",
  "result": {
    "task_spec": {...},
    "materials": [...],
    "content": {
      "title": "【5个效率翻倍的AI工具】✨",
      "body": "...",
      "hashtags": ["#AI工具", "#效率提升"]
    },
    "visual": {
      "recommended_params": {...},
      "images": [...]
    },
    "quality": {
      "overall_score": 88,
      "grade": "良好",
      "passed": true
    }
  }
}
```

## 错误处理

### Agent 失败重试

```javascript
if (agentResult.success === false) {
  // 重试
  if (retryCount < 3) {
    await sessions_spawn({...});
  } else {
    // 跳过或终止
    workflowState.failed_steps.push(agentName);
  }
}
```

### 部分成功处理

```javascript
if (workflowState.failed_steps.length > 0) {
  return {
    success: "partial",
    message: `${workflowState.failed_steps.join(', ')} 执行失败`,
    partial_result: workflowState.results
  };
}
```

## 性能优化

### 并行调用

```javascript
// content-agent 和 visual-agent 可以并行
await Promise.all([
  sessions_spawn({
    task: "生成文案",
    label: "content-agent"
  }),
  sessions_spawn({
    task: "生成配图（基于部分文案）",
    label: "visual-agent"
  })
]);
```

### 缓存结果

```javascript
// 缓存 research-agent 结果
if (cache.has(topic)) {
  return cache.get(topic);
}
```

---

**总结**: 7个独立 Agent 通过 Orchestrator 协同工作，实现完整的内容生产流程！
