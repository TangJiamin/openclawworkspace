# Agent 协同流程原则（2026-03-11 更新）

## ⚠️ Agent 协同核心原则

### 1. 串行执行，数据传递 ⭐⭐⭐⭐⭐

**错误理解**: 协同 = 所有 Agent 并行运行
**正确理解**: 协同 = 按顺序串行执行 + 数据在 Agent 间流动

**实施**:
- ✅ 等待前一个 Agent 完成
- ✅ 将前一个 Agent 的输出传递给下一个 Agent
- ❌ 不得所有 Agent 同时并行运行

### 2. 质量优先 + 立即告知用户 ⭐⭐⭐⭐⭐

**核心铁律**:
- ✅ 每个阶段完成后必须质量审核
- ✅ 质量不达标（<85分）**立即告知用户**
- ✅ **明确说明**：阶段、评分、问题
- ✅ **打回到上一个 Agent** 重新执行
- ❌ 不得继续往下执行
- ❌ 不得隐瞒质量问题

**告知用户格式**:
```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：[阶段名称]
评分：X/100（要求≥85分）
问题：
  1. [具体问题1]
  2. [ [具体问题2]
行动：打回 [Agent名称] 重新执行
预期时间：约 X 分钟
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. 理解用户真实需求 ⭐⭐⭐⭐⭐

**核心原则**:
- ✅ 用户说"生成视频" = 生成**实际的视频文件**（如 MP4）
- ✅ 用户说"调度 Agents" = **串行调度，传递数据**
- ✅ 用户说"协同" = **协作 + 数据流动 + 质量把关**

**错误示例**:
- ❌ 用户说"生成视频" → 我理解为"生成视频方案"
- ❌ 用户说"调度 Agents" → 我理解为"并行调度"
- ❌ 用户说"协同" → 我理解为"并行协作"

**正确示例**:
- ✅ 用户说"生成视频" → 生成 MP4 文件
- ✅ 用户说"调度 Agents" → 串行调度，传递数据
- ✅ 用户说"协同" → 协作 + 数据流动 + 质量把关

### 4. 质量审核分阶段执行

**正确流程**:
```
Agent A → quality 审核
  ├─ ≥85分 → 继续
  └─ <85分 → 立即告知用户 + 打回 Agent A 重新执行
  ↓
Agent B → quality 审核
  ├─ ≥85分 → 继续
  └─ <85分 → 立即告知用户 + 打回 Agent B 重新执行
  ↓
...
```

**错误流程**（避免）:
```
所有 Agent 并行完成
  ↓
最后统一质量审核
  ↓
发现问题但无法挽回
```

---

## 📋 完整协同流程

### 标准流程（v2.1）

```
用户需求
  ↓
【阶段 1: 需求分析】
sessions_spawn(requirement-agent) → 等待完成
  ↓
【阶段 2: 需求审核】
sessions_spawn(quality-agent) → 等待完成
  ├─ ≥85分 → 继续
  └─ <85分 → 立即告知用户 + 打回 requirement-agent
  ↓
【阶段 3: 资料收集】
sessions_spawn(research-agent, task="基于需求：${requirementResult}") → 等待完成
  ↓
【阶段 4: 资料审核】
sessions_spawn(quality-agent) → 等待完成
  ├─ ≥85分 → 继续
  └─ <85分 → 立即告知用户 + 打回 research-agent
  ↓
【阶段 5: 内容生产】
sessions_spawn(content-agent, task="基于资料：${researchResult}") → 等待完成
  ↓
【阶段 6: 文案审核】
sessions_spawn(quality-agent) → 等待完成
  ├─ ≥85分 → 继续
  └─ <85分 → 立即告知用户 + 打回 content-agent
  ↓
【阶段 7: 视觉设计】
sessions_spawn(visual-agent, task="基于文案：${contentResult}") → 等待完成
  ↓
【阶段 8: 视频生成】
sessions_spawn(video-agent, task="生成视频文件：${contentResult} ${visualResult}") → 等待完成
  ↓
【阶段 9: 视频审核】
sessions_spawn(quality-agent) → 等待完成
  ├─ ≥85分 → 输出视频文件 ✅
  └─ <85分 → 立即告知用户 + 打回 video-agent
  ↓
完成！
```

---

## 🔧 实施要点

### 1. 串行执行

**代码示例**:
```javascript
// 错误：并行调度
sessions_spawn(requirement-agent, ...)
sessions_spawn(research-agent, ...)
sessions_spawn(content-agent, ...)

// 正确：串行调度
const req = await sessions_spawn(requirement-agent, task="...")
const quality1 = await sessions_spawn(quality-agent, task=`审核：${req}`)
if (quality1.score >= 85) {
  const research = await sessions_spawn(research-agent, 
    task=`基于：${req}`)
  // ...
}
```

### 2. 数据传递

**方法 1: 模板字符串**
```javascript
const research = await sessions_spawn(research-agent,
  task=`收集资料，基于：\n${JSON.stringify(reqResult)}`)
```

**方法 2: 文件路径**
```javascript
// 第一步：输出到文件
const req = await sessions_spawn(requirement-agent,
  task="分析并保存到 /path/to/requirement.json")

// 第二步：传递路径
const research = await sessions_spawn(research-agent,
  task="读取文件 /path/to/requirement.json 并收集资料")
```

### 3. 立即告知用户

**关键代码**:
```javascript
if (qualityResult.score < 85) {
  console.log(`⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：${stageName}
评分：${qualityResult.score}/100（要求≥85分）
问题：
${qualityResult.issues.join("\n")}
行动：打回 ${agentId} 重新执行
━━━━━━━━━━━━━━━━━━━━━━━━━━━━`)
  
  // 打回重做
  const retryResult = await sessions_spawn(
    agent_id=agentId,
    task=`重新执行（已审核反馈）：\n${feedback}`
  )
}
```

---

## ⚠️ 常见错误（必须避免）

### 错误 1: 并行执行所有 Agents

**错误**:
```javascript
// ❌ 所有 Agent 同时运行
sessions_spawn(requirement-agent, task="...")
sessions_spawn(research-agent, task="...")
sessions_spawn(content-agent, task="...")
```

**正确**:
```javascript
// ✅ 按顺序执行，等待完成
const req = await sessions_spawn(requirement-agent, task="...")
const quality = await sessions_spawn(quality-agent, task=`审核：${req}`)
if (quality.score >= 85) {
  const research = await sessions_spawn(research-agent, task=`基于：${req}`)
}
```

### 错误 2: 不告知用户质量失败

**错误**:
```javascript
if (qualityResult.score < 85) {
  // ❌ 直接重新执行，不告知用户
  await sessions_spawn(agentId, task="重新执行")
}
```

**正确**:
```javascript
if (qualityResult.score < 85) {
  // ✅ 立即告知用户
  console.log(`⚠️ 质量审核未通过
阶段：${stageName}
评分：${score}/100
行动：打回 ${agentId} 重新执行`)
  
  // 然后重新执行
  await sessions_spawn(agentId, task="重新执行")
}
```

### 错误 3: 质量不达标继续往下

**错误**:
```javascript
if (qualityResult.score < 85) {
  console.log("质量不达标，但继续执行下一阶段...") // ❌
}
```

**正确**:
```javascript
if (qualityResult.score < 85) {
  console.log("⚠️ 质量不达标，打回上一 Agent，停止继续") // ✅
  return
}
```

---

## 📊 成功指标

### 质量指标

- 需求规范 ≥ 85分
- 资料收集 ≥ 85分
- 文案质量 ≥ 85分
- 视频质量 ≥ 85分

### 用户体验指标

- ✅ 每个质量失败都立即告知用户
- ✅ 明确说明问题和行动
- ✅ 用户清楚了解当前进度
- ❌ 不隐瞒质量问题

---

**来源**: 2026-03-11 10:55 用户明确要求
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已理解并记录
**版本**: v2.1
