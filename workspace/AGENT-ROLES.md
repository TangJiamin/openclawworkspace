# Agent 职责定义（v6.0）

**更新**: 2026-03-12

---

## 🎯 核心原则

### 1. 职责分离 ⭐⭐⭐⭐⭐

**每个 Agent 只负责一件事**：

- **requirement-agent**: 需求分析
- **research-agent**: 资料收集
- **content-agent**: 内容生产
- **visual-agent**: 图片生成
- **video-agent**: 视频生成
- **quality-agent**: 质量审核

### 2. 上下文传递 ⭐⭐⭐⭐⭐

**Main Agent 必须传递上下文**：

```javascript
// ✅ 正确
const req = await spawn(requirementAgent, { task: userInput })
const visual = await spawn(visualAgent, { 
  task: req.output,  // 传递 requirement-agent 的输出
  context: req.analysis  // 传递分析结果
})

// ❌ 错误
const visual = await spawn(visualAgent, { 
  task: userInput  // visual-agent 会重新分析需求
})
```

### 3. API 调用 ⭐⭐⭐⭐⭐

**visual-agent 和 video-agent 必须调用 API**：

- **visual-agent**: 调用 xskill API (jimeng-5.0) 生成图片
- **video-agent**: 调用 xskill API (seedance pro) 生成视频
- **不生成文字方案**

---

## 🔄 正确的流程

```
用户需求
  ↓
requirement-agent（需求分析）
  ↓
research-agent（资料收集）
  ↓
content-agent（内容生产）
  ↓
visual-agent（图片生成）← 基于前面的输出
  ↓
video-agent（视频生成）← 基于前面的输出和图片
  ↓
quality-agent（质量审核）
```

---

## ⚠️ 常见错误

### 错误 1：重新分析需求

❌ **错误**：
```javascript
const visual = await spawn(visualAgent, { task: userInput })
```

✅ **正确**：
```javascript
const req = await spawn(requirementAgent, { task: userInput })
const visual = await spawn(visualAgent, { task: req.output })
```

### 错误 2：生成文字方案

❌ **错误**：
- visual-agent 生成分镜文字方案
- video-agent 生成视频文字方案

✅ **正确**：
- visual-agent 调用 API 生成图片
- video-agent 调用 API 生成视频

### 错误 3：职责混乱

❌ **错误**：
- video-agent 自己生成图片

✅ **正确**：
- video-agent 使用 visual-agent 的图片

---

**版本**: v6.0
**最后更新**: 2026-03-12
