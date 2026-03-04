# 多 Agent 编排示例

## 示例 1: 完整内容生产（小红书图文）

**用户输入**:
```
生成小红书内容，推荐5个提升效率的AI工具
```

**Main Agent 的自动编排**:

```javascript
// 1. 分析需求
const requirement = await sessions_spawn({
  agentId: "requirement-agent",
  task: "分析需求：生成小红书内容，推荐5个提升效率的AI工具",
  timeoutSeconds: 60
});

// 2. 并行：需求分析 + 资料收集
const [requirementResult, researchResult] = await Promise.all([
  sessions_spawn({
    agentId: "requirement-agent",
    task: "分析用户需求，输出结构化任务规范",
    timeoutSeconds: 60
  }),
  sessions_spawn({
    agentId: "research-agent",
    task: "收集AI工具推荐的相关资料",
    timeoutSeconds: 120
  })
]);

// 3. 内容生成
const contentResult = await sessions_spawn({
  agentId: "content-agent",
  task: `根据任务规范生成小红书文案：${requirementResult.spec}`,
  timeoutSeconds: 90
});

// 4. 视觉生成
const visualResult = await sessions_spawn({
  agentId: "visual-agent",
  task: `根据文案生成配图：${contentResult.content}`,
  timeoutSeconds: 60
});

// 5. 质量审核
const qualityResult = await sessions_spawn({
  agentId: "quality-agent",
  task: `审核质量：
    - 文案: ${contentResult.content}
    - 图片: ${visualResult.images}
  `,
  timeoutSeconds: 30
});

return {
  content: contentResult.content,
  images: visualResult.images,
  quality: qualityResult
};
```

---

## 示例 2: 视频生成（必须先有图片）

**用户输入**:
```
生成抖音视频，介绍ChatGPT使用技巧
```

**Main Agent 的自动编排**:

```javascript
// 1. 需求分析
const requirement = await sessions_spawn({
  agentId: "requirement-agent",
  task: "分析需求：生成抖音视频，介绍ChatGPT使用技巧",
  timeoutSeconds: 60
});

// 2. 资料收集
const research = await sessions_spawn({
  agentId: "research-agent",
  task: "收集ChatGPT使用技巧相关资料",
  timeoutSeconds: 120
});

// 3. 内容生成
const content = await sessions_spawn({
  agentId: "content-agent",
  task: "生成抖音口播文案",
  timeoutSeconds: 90
});

// 4. ⚠️ 必须先生成图片
const visual = await sessions_spawn({
  agentId: "visual-agent",
  task: "根据文案生成视频封面和关键帧图片",
  timeoutSeconds: 60
});

// 5. ⚠️ 检查是否有图片
if (!visual.images || visual.images.length === 0) {
  throw new Error("视频生成必须先有图片，无法继续");
}

// 6. 视频生成（基于图片）
const video = await sessions_spawn({
  agentId: "video-agent",
  task: `基于图片生成视频：${visual.images}`,
  timeoutSeconds: 120
});

// 7. 质量审核
const quality = await sessions_spawn({
  agentId: "quality-agent",
  task: `审核质量：
    - 文案: ${content.content}
    - 图片: ${visual.images}
    - 视频: ${video.videos}
  `,
  timeoutSeconds: 30
});

return {
  content: content.content,
  images: visual.images,
  videos: video.videos,
  quality: quality
};
```

---

## 示例 3: 仅资料收集

**用户输入**:
```
帮我收集2026年AI行业的最新资讯
```

**Main Agent 的自动编排**:

```javascript
// 1. 需求分析
const requirement = await sessions_spawn({
  agentId: "requirement-agent",
  task: "分析需求：收集2026年AI行业最新资讯",
  timeoutSeconds: 60
});

// 2. 资料收集
const research = await sessions_spawn({
  agentId: "research-agent",
  task: "收集2026年AI行业最新资讯",
  timeoutSeconds: 120
});

return {
  requirement: requirement,
  research: research
};
```

---

## 示例 4: 仅图片生成

**用户输入**:
```
为我的文章生成封面图
```

**Main Agent 的自动编排**:

```javascript
// 直接调用 visual-agent
const visual = await sessions_spawn({
  agentId: "visual-agent",
  task: "为文章生成封面图",
  timeoutSeconds: 60
});

return {
  images: visual.images
};
```

---

## 示例 5: 并行优化（资料收集 + 内容策划）

**用户输入**:
```
快速生成一篇微信公众号文章
```

**Main Agent 的自动编排**:

```javascript
// 1. 需求分析
const requirement = await sessions_spawn({
  agentId: "requirement-agent",
  task: "分析需求：生成微信公众号文章",
  timeoutSeconds: 60
});

// 2. 并行：资料收集 + 内容大纲
const [research, contentOutline] = await Promise.all([
  sessions_spawn({
    agentId: "research-agent",
    task: "收集相关资料",
    timeoutSeconds: 120
  }),
  sessions_spawn({
    agentId: "content-agent",
    task: "生成内容大纲",
    timeoutSeconds: 90
  })
]);

// 3. 完整内容生成
const content = await sessions_spawn({
  agentId: "content-agent",
  task: `根据资料和大纲生成完整文章`,
  timeoutSeconds: 90
});

return {
  content: content.content
};
```

---

## 编排决策总结

### 串行执行场景

1. **视频生成流程**
   - visual-agent → video-agent（必须先有图片）

2. **质量审核**
   - 等待所有内容生成完成

### 并行执行场景

1. **需求分析 + 资料收集**
   - requirement-agent || research-agent

2. **多平台适配**
   - content-agent (小红书) || content-agent (抖音) || content-agent (微信)

### 智能调度

根据用户输入的关键词自动判断：

| 关键词 | 编排策略 |
|--------|---------|
| "生成"/"创作" | 完整流程：requirement → research → content → visual → video → quality |
| "收集"/"搜索" | 简化流程：requirement → research |
| "图片"/"封面" | 直接调用：visual-agent |
| "视频" | 强制流程：visual-agent → video-agent |
| "审核" | 直接调用：quality-agent |
