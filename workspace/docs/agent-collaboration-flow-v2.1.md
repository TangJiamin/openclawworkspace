# Agent 协同流程 v2.1（立即告知用户版）

**版本**: v2.1 - 串行执行 + 数据传递 + 立即告知用户
**更新时间**: 2026-03-11 10:55
**基于**: v2.0 + 用户反馈

---

## 🎯 核心原则

### 1. 协同 ≠ 并行

**错误理解**:
- ❌ 协同 = 所有 Agent 同时并行运行

**正确理解**:
- ✅ 协同 = 按顺序串行执行 + 数据在 Agent 间流动
- ✅ 协作 = 分工明确 + 结果传递

### 2. 质量优先 + 立即告知 ⭐ 新增

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
  2. [具体问题2]
行动：打回 [Agent名称] 重新执行
预期时间：约 X 分钟
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. 数据必须传递

**核心原则**:
- ✅ 前一个 Agent 的输出 = 下一个 Agent 的输入
- ✅ 使用模板字符串或文件路径传递结果
- ❌ 不得让 Agent 独立工作而不使用前置输出

### 4. 理解用户真实需求

**核心原则**:
- ✅ 用户说"生成视频" = 生成**MP4 文件**
- ✅ 用户说"调度 Agents" = **串行调度，传递数据**
- ✅ 用户说"协同" = **协作 + 数据流动 + 质量把关**

---

## 🔄 完整流程图

### 标准协同流程（含立即告知）

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
sessions_spawn(quality-agent, task="审核需求")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → **⚠️ 立即告知用户 + 打回 requirement-agent**
  ↓
【阶段 3: 资料收集】
  ↓
sessions_spawn(research-agent, task="收集资料\n${requirementResult}")
  ↓
等待完成 ✅
  ↓
【阶段 4: 资料审核】
  ↓
sessions_spawn(quality-agent, task="审核资料")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → **⚠️ 立即告知用户 + 打回 research-agent**
  ↓
【阶段 5: 内容生产】
  ↓
sessions_spawn(content-agent, task="生成文案\n${researchResult}")
  ↓
等待完成 ✅
  ↓
【阶段 6: 文案审核】
  ↓
sessions_spawn(quality-agent, task="审核文案")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 继续
  └─ 否 → **⚠️ 立即告知用户 + 打回 content-agent**
  ↓
【阶段 7: 视觉设计】
  ↓
sessions_spawn(visual-agent, task="生成视觉建议\n${contentResult}")
  ↓
等待完成 ✅
  ↓
【阶段 8: 视频生成】
  ↓
sessions_spawn(video-agent, task="生成视频文件\n${contentResult}\n${visualResult}")
  ↓
等待完成 ✅
  ↓
【阶段 9: 视频审核】
  ↓
sessions_spawn(quality-agent, task="审核视频")
  ↓
等待完成 ✅
  ↓
评分 ≥ 85分？
  ├─ 是 → 输出视频文件 ✅
  └─ 否 → **⚠️ 立即告知用户 + 打回 video-agent**
  ↓
完成！输出结果
```

---

## ⚠️ 立即告知用户示例

### 示例 1：资料审核不通过

```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：资料收集审核
评分：57/100（要求≥85分）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ 严重问题：
1. 时效性完全缺失（0/30分）
   - Seedance 2.0：27天前
   - 华为超节点：6个月前
   - AI液冷技术：7个月前
   - 要求：90%+ 内容为 24 小时内

2. 信息准确性问题
   - 报告声称"100%为24-72小时内"
   - 实际全部不达标

🔄 正在执行：
打回 research-agent 重新收集真正的今日热点

预期时间：约 2 分钟
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 示例 2：文案审核不通过

```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：文案质量审核
评分：82/100（要求≥85分）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ 未达标问题：
1. 钩子力度不足（7/10分）
   - 前3秒钩子："AI很厉害"太泛泛
   - 建议：使用数字冲击或对比

2. 技术深度不够（6/10分）
   - 只说"技术突破"，没有具体原理
   - 建议：补充技术细节和数据

🔄 正在执行：
打回 content-agent 重新生成

预期时间：约 1 分钟
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 示例 3：视频审核不通过

```
⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：视频质量审核
评分：78/100（要求≥85分）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ 未达标问题：
1. 视频清晰度不足（20/40分）
   - 关键帧模糊，文字看不清
   - 建议：提高分辨率到 2K

2. 技术可视化不够清晰（15/30分）
   - 抽象概念没有可视化
   - 建议：增加3D动画演示

3. 节奏拖沓（15/20分）
   - 10秒后节奏变慢
   - 建议：每个镜头控制在2-3秒

🔄 正在执行：
打回 video-agent 重新生成

预期时间：约 3 分钟
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🔧 重新执行机制

### 关键原则

1. **立即告知** - 质量审核完成后，如果 < 85分，立即告知用户
2. **明确说明** - 清晰列出阶段、评分、问题
3. **打回重做** - 打回到上一个 Agent 重新执行
4. **传递反馈** - 将审核反馈传递给 Agent（帮助改进）

### 重试次数限制

**原则**: 最多重试 1 次

**原因**:
- 第1次失败 → 打回 + 重新执行
- 第2次失败 → **终止流程，告知用户无法完成**

---

## 📊 代码示例（包含立即告知）

```javascript
async function generateDouyinVideos(userInput) {
  // 阶段 1-2: 需求分析和审核
  const reqResult = await sessions_spawn(
    agent_id="requirement-agent",
    task=`分析需求：${userInput}`,
    timeoutSeconds=60
  )
  
  const reqQualityResult = await sessions_spawn(
    agent_id="quality-agent",
    task=`审核需求规范：\n${JSON.stringify(reqResult)}`,
    timeoutSeconds=30
  )
  
  // 立即告知用户
  if (reqQualityResult.score < 85) {
    console.log(`⚠️ 质量审核未通过
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
阶段：需求规范审核
评分：${reqQualityResult.score}/100（要求≥85分）
问题：
${reqQualityResult.issues.join("\n")}
行动：打回 requirement-agent 重新分析需求
预期时间：约 30 秒
━━━━━━━━━━━━━━━━━━━━━━━━━━━━`)
    
    // 打回重新执行
    const reqResult2 = await sessions_spawn(
      agent_id="requirement-agent",
      task=`重新分析需求（已审核反馈）\n\n原需求：${userInput}\n\n审核反馈：${JSON.stringify(reqQualityResult)}`,
      timeoutSeconds=60
    )
    
    // 第2次审核
    const reqQualityResult2 = await sessions_spawn(
      agent_id="quality-agent",
      task=`再次审核需求规范：\n${JSON.stringify(reqResult2)}`,
      timeoutSeconds=30
    )
    
    if (reqQualityResult2.score < 85) {
      console.log(`❌ 2次审核仍未通过，终止流程`)
      return { success: false, reason: "需求规范始终不达标" }
    }
  }
  
  // 继续下一阶段...
  console.log("✅ 需求规范审核通过，继续下一阶段...")
  // ... 阶段 3-9
}
```

---

## ✅ 成功标准

### 必须满足的条件

1. ✅ **串行执行**：按顺序执行，等待前一个 Agent 完成
2. ✅ **数据传递**：前一个 Agent 的输出传递给下一个 Agent
3. ✅ **质量把关**：每个阶段后审核
4. ✅ **立即告知**：质量不达标时立即告知用户
5. ✅ **实际输出**：生成用户要求的实际文件（如 MP4），不是方案

### 质量保证

- 需求规范 ≥ 85分
- 资料收集 ≥ 85分
- 文案质量 ≥ 85分
- 视频质量 ≥ 85分

---

## 📊 时间预估（含重试）

| 阶段 | Agent | 预估时间 | 重试1次 |
|------|-------|---------|---------|
| 1 | requirement-agent | 30s | +30s |
| 2 | quality-agent（需求） | 20s | - |
| 3 | research-agent | 2min | +2min |
| 4 | quality-agent（资料） | 20s | - |
| 5 | content-agent | 1min | +1min |
| 6 | quality-agent（文案） | 20s | - |
| 7 | visual-agent | 1min | - |
| 8 | video-agent | 3min | +3min |
| 9 | quality-agent（视频）| 30s | - |

**总计（无重试）**: 约 9 分钟
**总计（含1次重试）**: 约 18 分钟

---

**设计者**: Main Agent
**版本**: v2.1
**基于**: v2.0 + 用户反馈（立即告知用户）
**状态**: ✅ 已改进，已验证
