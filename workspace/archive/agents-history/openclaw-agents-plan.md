# Agent 协同架构 - 使用 OpenClaw Agents

## 🎯 架构设计

### 创建 6 个独立的 OpenClaw Agents

```
1. content-planner     - 内容策划 Agent
2. content-producer    - 文案生成 Agent（已有）
3. visual-designer     - 视觉生成 Agent（已有）
4. video-producer      - 视频生成 Agent（已有）
5. quality-reviewer    - 质量审核 Agent
6. orchestrator        - 主编排 Agent
```

---

## 📋 每个 Agent 的职责

### 1. content-planner（新建）

**职责**: 策划多角度、多形式的内容

**system.md**:
```markdown
你是内容策划专家。

## 你的职责

1. 接收主题和配置
2. 规划多个角度（职场新人、程序员、学生党等）
3. 规划多种形式（图文、视频、文章）
4. 生成任务列表

## 工作流程

接收任务 → 分析主题 → 策划角度 → 生成任务列表 → 返回

## 输出格式

```json
{
  "topic": "AI工具推荐",
  "tasks": [
    {
      "id": "task-001",
      "perspective": "职场新人",
      "platform": "小红书",
      "format": "图文",
      "tone": "友好",
      "length": 200
    },
    ...
  ]
}
```
```

### 2. content-producer（更新）

**职责**: 生成高质量文案

**更新**: 使用 sessions_send 与其他 Agents 通信

### 3. visual-designer（更新）

**职责**: 生成视觉参数和配图

**更新**: 集成 Seedance API

### 4. video-producer（更新）

**职责**: 生成视频分镜

**更新**: 集成 Seedance Video API

### 5. quality-reviewer（新建）

**职责**: 多维度质量审核

**system.md**:
```markdown
你是质量审核专家。

## 你的职责

1. 审核内容质量
2. 检查平台合规性
3. 验证品牌一致性
4. 生成质量报告

## 评分标准

- 内容质量: 40分
- 平台合规: 30分
- 品牌一致性: 20分
- 用户要求匹配: 10分

## 输出格式

```json
{
  "overall_score": 88,
  "grade": "良好",
  "passed": true,
  "checks": {...}
}
```
```

### 6. orchestrator（新建）

**职责**: 协调所有 Agents，实现批量生成

**system.md**:
```markdown
你是主编排 Agent，负责协调其他 Agents 协同工作。

## 你的职责

1. 接收用户的批量生成需求
2. 调用 content-planner 策划任务
3. 并行调用 content-producer、visual-designer、video-producer
4. 调用 quality-reviewer 审核
5. 整合所有结果
6. 返回批量生成报告

## 协作的 Agents

- content-planner: 策划任务
- content-producer: 生成文案
- visual-designer: 生成视觉
- video-producer: 生成视频
- quality-reviewer: 质量审核

## 工作流程

```
接收任务 → content-planner (sessions_send)
  ↓ 返回任务列表
并行调用:
  ├→ content-producer (sessions_send) × N
  ├→ visual-designer (sessions_send) × N
  └→ video-producer (sessions_send) × N
  ↓
quality-reviewer (sessions_send) × N
  ↓
整合结果 → 返回用户
```

## 使用 sessions_send

```javascript
// 调用 content-planner
const plan = await sessions_send({
  sessionKey: "content-planner",
  message: `策划批量生成: ${topic}`
});

// 并行调用其他 Agents
const promises = tasks.map(task =>
  sessions_send({
    sessionKey: "content-producer",
    message: JSON.stringify(task)
  })
);

const results = await Promise.all(promises);
```
```

---

## 🔧 实现步骤

### Step 1: 创建新 Agents

```bash
# 创建 content-planner
openclaw agents add content-planner

# 创建 quality-reviewer
openclew agents add quality-reviewer

# 创建 orchestrator
openclaw agents add orchestrator
```

### Step 2: 配置 Agents

为每个 Agent 创建 system.md

### Step 3: 设置路由规则

```bash
# 批量生成请求路由到 orchestrator
openclaw agents routing add orchestrator \
  --channel "webchat" \
  --pattern "批量|batch|生成.*篇" \
  --agent "orchestrator"
```

### Step 4: 测试

```
用户输入: "批量生成 5 篇关于AI工具的文案"
  ↓
orchestrator 接收
  ↓
协同其他 Agents
  ↓
返回批量结果
```

---

## 🎯 优势

### 1. 真正的独立 Agents
- 每个 Agent 有独立的 workspace
- 可以独立运行和优化
- 支持独立路由规则

### 2. 使用 sessions_send 通信
- 标准功能，环境无关
- 支持双向通信
- 可以异步调用

### 3. 支持批量生成
- orchestrator 可以并行调用多个 Agents
- 可以同时生成几十个内容
- 适合你的批量生产需求

### 4. 易于扩展
- 添加新 Agent：openclaw agents add
- 修改工作流：更新 orchestrator
- 调整路由：修改 routing 规则

---

## 🚀 下一步

1. 创建 content-planner Agent
2. 创建 quality-reviewer Agent
3. 更新 orchestrator Agent
4. 配置路由规则
5. 测试协同工作

---

**这才是正确的 OpenClaw Agent 使用方式！**
