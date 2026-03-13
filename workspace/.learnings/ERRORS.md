# Agent 协同流程严重错误记录

**日期**: 2026-03-11 10:50
**问题**: Agent 协同流程设计严重错误
**状态**: ✅ 已记录，已改进

---

## 🚨 严重问题

### 问题 1：Agent 间没有传递数据 ❌

**错误行为**:
- 所有 Agent 并行运行（sessions_spawn 同时调用）
- visual-agent 没有接收 content-agent 的文案
- video-agent 没有接收文案和视觉建议
- 每个 Agent 独立工作，没有使用前一个 Agent 的输出

**违反原则**:
- ❌ 违反"Agent 间按需通信"
- ❌ 违反"协同工作应该是串行的，数据在 Agent 间流动"

**正确做法**:
- ✅ 等待前一个 Agent 完成
- ✅ 将前一个 Agent 的输出传递给下一个 Agent
- ✅ 按顺序调度：A → B → C

**根本原因**:
- 我错误理解了"并行协作"
- 将"并行"理解为"同时运行"
- 实际应该是"按顺序串行执行，数据流动"

---

### 问题 2：质量审核流程缺失 ❌

**错误行为**:
- 没有在每个阶段后进行质量审核
- quality-agent 审核在所有 Agent 完成后才进行
- 资料质量57分（严重不通过）但仍继续执行

**违反原则**:
- ❌ 违反"分阶段质量审核"
- ❌ 违反"质量不达标立即重新执行"

**正确流程**:
```
A → quality 审核 → ≥85分 ✅
  ↓
B → quality 审核 → ≥85分 ✅
  ↓
C → quality 审核 → ≥85分 ✅
  ↓
输出
```

**实际执行**:
```
A、B、C、D、E 同时并行运行
  ↓
所有完成后 quality 审核
  ↓
发现质量问题但无法挽回
```

---

### 问题 3：输出错误 ❌

**用户要求**: 生成3个可以发布到抖音的视频文件（MP4）

**我的理解**: 生成视频方案、文案、分镜脚本

**实际输出**: 
- 文案方案（content-agent）
- 视觉建议（visual-agent）
- 分镜脚本（video-agent 第一个任务）
- 没有 MP4 文件

**违反原则**:
- ❌ 没有理解用户的真实需求
- ❌ 输出的是"方案"而不是"视频文件"

**正确理解**:
- 用户要的是**可以直接发布的视频文件**
- 不是文案、不是方案、不是脚本
- 是实际的 MP4 视频文件

---

### 问题 4：资料收集质量严重不达标 ❌

**quality-agent 审核结果**: 57/100分（严重不通过）

**问题**:
- Seedance 2.0：27天前（要求24小时内）
- 华为超节点：6个月前
- AI液冷技术：7个月前
- 时效性：0% 符合要求（要求90%+）

**违反原则**:
- ❌ 违反"时效性铁律：热点资讯 90%+ 内容为 24 小时内"
- ❌ research-agent 没有验证发布时间

**根本原因**:
- research-agent 收集的资料不是真正的"今日热点"
- 可能是历史资讯或者资料来源的标注错误

---

## 📝 根本原因分析

### 1. 对"协同"的错误理解

**错误理解**:
```
协同 = 所有 Agent 同时并行运行
```

**正确理解**:
```
协同 = 按顺序串行执行，数据在 Agent 间流动
```

**核心区别**:
- ❌ 并行 ≠ 协同
- ✅ 协同 = 协作 + 数据传递

---

### 2. 对"指挥者"的错误理解

**错误行为**:
- 我以为"指挥者"就是同时调度所有 Agents
- 然后等待它们全部完成
- 最后整合结果

**正确行为**:
- "指挥者"应该**按顺序**调度 Agents
- **等待每个 Agent 完成**后再调度下一个
- **传递前一个 Agent 的输出**给下一个 Agent
- **在每个阶段进行质量审核**

---

### 3. 对输出结果的错误理解

**错误理解**:
- 用户说"生成视频"，我以为生成"视频方案"
- 用户说"调度 Agents"，我以为"并行调度"

**正确理解**:
- 用户说"生成视频" = 生成**实际的视频文件**
- 用户说"调度 Agents" = **按顺序串行调度，传递数据**

---

## ✅ 正确的协同流程

### 完整流程（v2.0 - 串行 + 质量审核）

```
用户需求
  ↓
sessions_spawn(requirement-agent)
  ↓
等待完成 ✅
  ↓
传递输出 → sessions_spawn(quality-agent, task="审核需求")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → 重新 requirement-agent
  ↓
传递需求 + 审核反馈 → sessions_spawn(research-agent)
  ↓
等待完成 ✅
  ↓
传递输出 → sessions_spawn(quality-agent, task="审核资料")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → 重新 research-agent
  ↓
传递资料 → sessions_spawn(content-agent)
  ↓
等待完成 ✅
  ↓
传递输出 → sessions_spawn(quality-agent, task="审核文案")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → 重新 content-agent
  ↓
传递文案 → sessions_spawn(visual-agent)
  ↓
等待完成 ✅
  ↓
传递文案 + 视觉建议 → sessions_spawn(video-agent)
  ↓
等待完成 ✅
  ↓
传递输出 → sessions_spawn(quality-agent, task="审核视频")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 输出视频文件 ✅
  └─ 否 → 重新 video-agent
  ↓
完成！
```

---

## 🔧 关键改进

### 改进 1：串行执行

**旧流程**（错误）:
```javascript
// 并行调度所有 Agents
sessions_spawn(requirement-agent, ...)
sessions_spawn(research-agent, ...)
sessions_spawn(content-agent, ...)
sessions_spawn(visual-agent, ...)
sessions_spawn(video-agent, ...)
```

**新流程**（正确）:
```javascript
// 串行调度，传递数据
const req = sessions_spawn(requirement-agent, task="...")
const reqResult = await req

const quality1 = sessions_spawn(quality-agent, 
  task=`审核需求：${reqResult}`)
const quality1Result = await quality1

if (quality1Result.score >= 85) {
  const research = sessions_spawn(research-agent,
    task=`收集资料：${reqResult}`)
  // ... 继续下一个 Agent
} else {
  // 重新执行 requirement-agent
}
```

---

### 改进 2：数据传递

**关键原则**:
- 前一个 Agent 的输出 = 下一个 Agent 的输入
- 使用模板字符串传递结果

**示例**:
```javascript
// research-agent 的输出
const researchOutput = {
  hotspot1: "Seedance 2.0 资料...",
  hotspot2: "华为超节点 资料...",
  hotspot3: "液冷技术 资料..."
}

// 传递给 content-agent
const content = sessions_spawn(content-agent,
  task=`生成文案，基于以下资料：${JSON.stringify(researchOutput)}`)
```

---

### 改进 3：质量审核把关

**每个阶段后都审核**:
1. requirement-agent → quality-agent 审核
2. research-agent → quality-agent 审核
3. content-agent → quality-agent 审核
4. video-agent → quality-agent 审核

**不通过则重新执行**:
- 如果需求规范 < 85分 → 重新 requirement-agent
- 如果资料收集 < 85分 → 重新 research-agent
- 如果文案质量 < 85分 → 重新 content-agent
- 如果视频质量 < 85分 → 重新 video-agent

---

### 改进 4：理解用户真实需求

**问题**: 我理解成了"生成方案"

**解决**:
- ✅ 用户说"生成视频" = 生成**MP4 文件**
- ✅ 用户说"调度 Agents" = **串行调度，传递数据**
- ✅ 用户说"协同" = **协作 + 数据流动**

---

## 📊 失败统计

| Agent | 状态 | 质量 | 时间 |
|-------|------|------|------|
| requirement-agent | ✅ 完成 | 78/100 ❌ | 35s |
| research-agent | ✅ 完成 | 57/100 ❌ | 1m59s |
| content-agent | ✅ 完成 | 93/100 ✅ | 55s |
| visual-agent | ⚠️ 超时 | N/A | 59s |
| video-agent (分镜) | ✅ 完成 | N/A | 1m59s |
| video-agent (视频) | ⏳ 运行5分钟 | N/A | 5m+ |

**总耗时**: 约 10 分钟
**结果**: 失败（没有生成视频文件）

---

## 🎓 核心教训

### 教训 1: 协同 ≠ 并行

**错误**: 协同 = 所有 Agent 同时运行
**正确**: 协同 = 按顺序执行 + 数据传递

### 教训 2: 质量审核必须分阶段

**错误**: 所有完成后统一审核
**正确**: 每个阶段完成后立即审核

### 教训 3: 理解需求而非表面

**错误**: 用户说"生成视频" → 我理解为"生成方案"
**正确**: 用户说"生成视频" → 生成**MP4 文件**

### 教训 4: 时效性铁律不可违反

**错误**: 接受27天前、6个月前的资料
**正确**: 90%+ 内容必须为 24 小时内

---

## 🚀 下次行动计划

### 下次协同的正确步骤

1. ✅ 串行调度 Agent（等待完成）
2. ✅ 传递前一个 Agent 的输出
3. ✅ 每个阶段后质量审核
4. ✅ 质量不达标立即重新执行
5. ✅ 生成实际的视频文件（MP4）

### 时间预估

- requirement-agent: ~30s
- quality审核: ~20s
- research-agent: ~2min（收集真正的今日热点）
- quality审核: ~20s
- content-agent: ~1min
- quality审核: ~20s
- visual-agent: ~1min
- video-agent: ~3min（生成实际视频）
- quality审核: ~30s
- **总计**: 约 10 分钟

---

**记录者**: Main Agent
**记录时间**: 2026-03-11 10:50
**状态**: ✅ 已记录，已改进
