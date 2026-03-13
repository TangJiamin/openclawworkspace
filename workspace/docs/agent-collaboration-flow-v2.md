# Agent 协同流程 v2.0（正确版）

**版本**: v2.0 - 串行执行 + 数据传递 + 分阶段质量审核
**更新时间**: 2026-03-11 10:50
**基于**: v1.0 失败教训

---

## 🎯 核心原则

### 1. 协同 ≠ 并行

**错误理解**:
- ❌ 协同 = 所有 Agent 同时并行运行

**正确理解**:
- ✅ 协同 = 按顺序串行执行 + 数据在 Agent 间流动
- ✅ 协作 = 分工明确 + 结果传递

### 2. 质量优先于速度

**核心铁律**:
- ✅ 每个阶段完成后必须质量审核
- ✅ 质量不达标（<85分）立即重新执行
- ✅ 不得在质量不达标时继续下一阶段

### 3. 数据必须传递

**核心原则**:
- ✅ 前一个 Agent 的输出 = 下一个 Agent 的输入
- ✅ 使用模板字符串或文件路径传递结果
- ❌ 不得让 Agent 独立工作而不使用前置输出

### 4. 理解用户真实需求

**核心原则**:
- ✅ 用户说"生成视频" = 生成**MP4 文件**
- ✅ 用户说"调度 Agents" = **串行调度，传递数据**
- ✅ 用户说"协同" = **协作 + 数据流动**

---

## 🔄 完整流程图

### 标准协同流程

```
用户需求
  ↓
【阶段 1: 需求分析】
  ↓
sessions_spawn(requirement-agent, task="分析需求")
  ↓
等待完成 ✅
  ↓
【阶段 2: 需求审核】
  ↓
sessions_spawn(quality-agent, task="审核需求规范\n${requirementResult}")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → **立即告知用户 + 打回 requirement-agent 重新执行**

**告知用户格式**:
```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：需求规范审核
评分：78/100（要求≥85分）
问题：
  1. 抖音技术深度要求缺失
  2. 3个视频选择逻辑不明确
行动：打回 requirement-agent 重新分析需求
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### 重新执行机制

**关键原则**:
- ✅ 立即告知用户审核未通过
- ✅ 说明具体问题和评分
- ✅ 打回到上一个 Agent 重新执行
- ✅ 传递审核反馈（帮助改进）
- ❌ 不得继续往下执行
  ↓
【阶段 3: 资料收集】
  ↓
sessions_spawn(research-agent, task="收集资料\n基于任务规范：${requirementResult}")
  ↓
等待完成 ✅
  ↓
【阶段 4: 资料审核】
  ↓
sessions_spawn(quality-agent, task="审核资料\n${researchResult}")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → **立即告知用户 + 打回 research-agent 重新收集**

**告知用户格式**:
```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：资料收集审核
评分：57/100（要求≥85分）
问题：
  1. 时效性完全缺失（0/30分）
  2. 所有热点都不是24小时内
  3. 资料为27天前、6个月前、7个月前
行动：打回 research-agent 重新收集真正的今日热点
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
  ↓
【阶段 5: 内容生产】
  ↓
sessions_spawn(content-agent, task="生成文案\n基于资料：${researchResult}")
  ↓
等待完成 ✅
  ↓
【阶段 6: 文案审核】
  ↓
sessions_spawn(quality-agent, task="审核文案\n${contentResult}")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → **立即告知用户 + 打回 content-agent 重新生成**

**告知用户格式**:
```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：文案质量审核
评分：82/100（要求≥85分）
问题：
  1. 钩子力度不足（7/10分）
  2. 技术深度不够（6/10分）
行动：打回 content-agent 重新生成，加强钩子和技术解析
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
  ↓
【阶段 7: 视觉设计】
  ↓
sessions_spawn(visual-agent, task="生成视觉建议\n基于文案：${contentResult}")
  ↓
等待完成 ✅
  ↓
【阶段 8: 视频生成】
  ↓
sessions_spawn(video-agent, task="生成视频文件\n基于文案：${contentResult}\n视觉建议：${visualResult}")
  ↓
等待完成 ✅
  ↓
【阶段 9: 视频审核】
  ↓
sessions_spawn(quality-agent, task="审核视频\n${videoResult}")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 输出视频文件 ✅
  └─ 否 → **立即告知用户 + 打回 video-agent 重新生成**

**告知用户格式**:
```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：视频质量审核
评分：78/100（要求≥85分）
问题：
  1. 视频清晰度不足
  2. 技术可视化不够清晰
  3. 节奏拖沓，不符合抖音快节奏
行动：打回 video-agent 重新生成，加强视觉冲击和节奏
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
  ↓
完成！输出结果
```

---

## 📝 数据传递方式

### 方式 1: 模板字符串传递

```javascript
// 获取 requirement-agent 的输出
const reqResult = sessions_spawn(requirement-agent, task="...")

// 等待完成（关键！）
const reqData = await reqResult

// 传递给 quality-agent
const quality1Result = sessions_spawn(quality-agent,
  task=`审核需求规范：

${reqData}

请审核：1. 需求理解 2. 技术深度 3. 受众定位 4. 结构可行性`)
```

### 方式 2: 文件路径传递

```javascript
// requirement-agent 输出到文件
const reqResult = sessions_spawn(requirement-agent,
  task="分析需求并保存到 /home/node/.openclaw/workspace/output/requirement.json")

// 传递文件路径给下一个 Agent
const researchResult = sessions_spawn(research-agent,
  task="读取需求文件 /home/node/.openclaw/workspace/output/requirement.json 并收集资料")
```

### 方式 3: sessions_send 发送到已存在的 session

```javascript
// 先创建持久 session
const req = sessions_spawn(agent_id="requirement-agent",
  task="...",
  mode="session",
  thread=true)

// 发送后续任务
sessions_send(
  sessionKey="agent:requirement-agent:subagent:xxx",
  message="请审核刚才生成的需求规范"
)
```

---

## ⚠️ 质量审核标准

### 通用审核标准

| 维度 | 权重 | 及格线 | 优秀线 |
|------|------|--------|--------|
| 准确性 | 30% | 80分 | 95分 |
| 完整性 | 25% | 85分 | 95分 |
| 质量 | 25% | 85分 | 95分 |
| 时效性 | 20% | 90分 | 98分 |

**综合及格线**: 85/100分
**综合优秀线**: 93/100分

### 阶段特定标准

#### requirement-agent 审核
- 需求理解准确性（30%）
- 技术深度符合度（25%）
- 目标受众定位（25%）
- 视频结构可行性（20%）

#### research-agent 审核
- **时效性铁律**（30%）: 90%+ 内容为 24 小时内
- 资料质量评分（25%）: ≥ 7.0
- 技术深度（25%）: 足够支撑技术深度视频
- 信息准确性（20%）: 数据、事实准确

#### content-agent 审核
- 钩子力度（20%）
- 技术深度（30%）
- 节奏感（20%）
- 金句质量（20%）
- 字数控制（10%）

#### video-agent 审核
- 视频质量（40%）
- 技术可视化（30%）
- 节奏控制（20%）
- 抖音适配（10%）

---

## 🔧 实现代码示例

### 使用串行 sessions_spawn（伪代码）

```javascript
async function generateDouyinVideos(userInput) {
  // 阶段 1: 需求分析
  console.log("🎯 阶段 1: 需求分析...")
  const reqResult = await sessions_spawn(
    agent_id="requirement-agent",
    task=`分析用户需求：${userInput}`,
    timeoutSeconds=60
  )
  
  // 阶段 2: 需求审核
  console.log("🔍 阶段 2: 需求审核...")
  const reqQualityResult = await sessions_spawn(
    agent_id="quality-agent",
    task=`审核需求规范：\n${JSON.stringify(reqResult)}`,
    timeoutSeconds=30
  )
  
  if (reqQualityResult.score < 85) {
    console.log("❌ 需求规范不达标，重新分析...")
    return generateDouyinVideos(userInput) // 重新执行
  }
  
  // 阶段 3: 资料收集
  console.log("📚 阶段 3: 资料收集...")
  const researchResult = await sessions_spawn(
    agent_id="research-agent",
    task=`收集AI热点资料\n\n需求规范：${JSON.stringify(reqResult)}\n\n审核反馈：${JSON.stringify(reqQualityResult)}`,
    timeoutSeconds=120
  )
  
  // 阶段 4: 资料审核
  console.log("🔍 阶段 4: 资料审核...")
  const researchQualityResult = await sessions_spawn(
    agent_id="quality-agent",
    task=`审核资料收集：\n${JSON.stringify(researchResult)}`,
    timeoutSeconds=30
  )
  
  if (researchQualityResult.score < 85) {
    console.log("❌ 资料质量不达标，重新收集...")
    // 重新执行阶段 3
  }
  
  // 阶段 5: 内容生产
  console.log("✍️  阶段 5: 内容生产...")
  const contentResult = await sessions_spawn(
    agent_id="content-agent",
    task=`生成抖音文案\n\n任务规范：${JSON.stringify(reqResult)}\n\n资料：${JSON.stringify(researchResult)}`,
    timeoutSeconds=90
  )
  
  // 阶段 6: 文案审核
  console.log("🔍 阶段 6: 文案审核...")
  const contentQualityResult = await sessions_spawn(
    agent_id="quality-agent",
    task=`审核文案质量：\n${JSON.stringify(contentResult)}`,
    timeoutSeconds=30
  )
  
  if (contentQualityResult.score < 85) {
    console.log("❌ 文案质量不达标，重新生成...")
    // 重新执行阶段 5
  }
  
  // 阶段 7: 视觉设计
  console.log("🎨 阶段 7: 视觉设计...")
  const visualResult = await sessions_spawn(
    agent_id="visual-agent",
    task=`生成视觉建议\n\n文案：${JSON.stringify(contentResult)}`,
    timeoutSeconds=60
  )
  
  // 阶段 8: 视频生成
  console.log("🎬 阶段 8: 视频生成...")
  const videoResult = await sessions_spawn(
    agent_id="video-agent",
    task=`生成实际视频文件\n\n文案：${JSON.stringify(contentResult)}\n\n视觉建议：${JSON.stringify(visualResult)}\n\n要求：\n1. 使用 Seedance 图生视频\n2. 生成 MP4 文件\n3. 保存到：/home/node/.openclaw/workspace/output/douyin_videos/`,
    timeoutSeconds=300
  )
  
  // 阶段 9: 视频审核
  console.log("🔍 阶段 9: 视频审核...")
  const videoQualityResult = await sessions_spawn(
    agent_id="quality-agent",
    task=`审核视频质量：\n${JSON.stringify(videoResult)}`,
    timeoutSeconds=30
  )
  
  if (videoQualityResult.score < 85) {
    console.log("❌ 视频质量不达标，重新生成...")
    // 重新执行阶段 8
  }
  
  // 完成
  console.log("✅ 所有阶段完成！")
  return {
    requirement: reqResult,
    research: researchResult,
    content: contentResult,
    visual: visualResult,
    video: videoResult,
    qualities: {
      requirement: reqQualityResult,
      research: researchQualityResult,
      content: contentQualityResult,
      video: videoQualityResult
    }
  }
}
```

---

## 📊 时间预估

| 阶段 | Agent | 预估时间 | 累计时间 |
|------|-------|---------|---------|
| 1 | requirement-agent | 30s | 30s |
| 2 | quality-agent（需求） | 20s | 50s |
| 3 | research-agent | 2min | 2m50s |
| 4 | quality-agent（资料） | 20s | 3m10s |
| 5 | content-agent | 1min | 4m10s |
| 6 | quality-agent（文案） | 20s | 4m30s |
| 7 | visual-agent | 1min | 5m30s |
| 8 | video-agent | 3min | 8m30s |
| 9 | quality-agent（视频）| 30s | 9m0s |

**总计**: 约 9 分钟（不含重试）

**含重试（最多1次）**: 约 18 分钟

---

## ✅ 成功标准

### 必须满足的条件

1. ✅ **串行执行**：按顺序执行，等待前一个 Agent 完成
2. ✅ **数据传递**：前一个 Agent 的输出传递给下一个 Agent
3. ✅ **质量把关**：每个阶段后审核，≥85分才继续
4. **实际输出**：生成用户要求的实际文件（如 MP4），不是方案

### 质量保证

- 需求规范 ≥ 85分
- 资料收集 ≥ 85分
- 文案质量 ≥ 85分
- 视频质量 ≥ 85分

---

**设计者**: Main Agent
**版本**: v2.0
**基于**: v1.0 失败教训
**状态**: ✅ 已改进，已验证
