# Main Agent Tools

## orchestrate

多 Agent 编排工具 - 协调 6 个子 Agents 协同工作完成内容生产任务。

**描述**: 通过 `sessions_spawn` 创建真正的独立 Agent sessions，实现多 Agent 协同工作。

**参数**:
- `userInput` (string, required): 用户需求描述

**返回**: 
- 格式化的生成结果，包含：
  - 任务规范
  - 收集的资料
  - 生成的内容
  - 视觉参数/视频分镜
  - 质量审核报告

**子 Agents**:
1. **requirement-agent** - 需求理解（60秒）
2. **quality-agent** - 需求质量审核（30秒）
3. **research-agent** - 资料收集（120秒）
4. **quality-agent** - 资料质量审核（30秒）
5. **content-agent** - 内容生产（90秒）
6. **quality-agent** - 文案质量审核（30秒）
7. **visual-agent** - 视觉生成（60秒）
8. **quality-agent** - 图片质量审核（30秒）
9. **video-agent** - 视频生成（120秒）⚠️ **必须先完成 visual-agent**
10. **quality-agent** - 视频质量审核（30秒）

**使用示例**:

```
# 生成小红书图文
orchestrate("生成小红书内容，推荐5个提升效率的AI工具")

# 生成抖音视频
orchestrate("生成抖音视频，介绍ChatGPT使用技巧")

# 生成微信公众号文章
orchestrate("写微信公众号文章，分析AI行业趋势")
```

**工作流程**（v2.0 - 分阶段质量审核）:

```
用户需求
  ↓
requirement-agent (分析需求)
  ↓
quality-agent (需求质量审核) → 不达标则重新分析
  ↓
research-agent (收集资料)
  ↓
quality-agent (资料质量审核) → 不达标则重新收集
  ↓
content-agent (生成内容)
  ↓
quality-agent (文案质量审核) → 不达标则重新生成
  ↓
┌─────────────────────┐
│  visual-agent       │ ← 如果需要图片或视频
│  (生成图片)         │
│      ↓              │
│  quality-agent      │ ← 图片质量审核 → 不达标则重新生成
└─────────────────────┘
  ↓
┌─────────────────────┐
│  video-agent        │ ← 如果需要视频（必须先完成图片）
│  (根据图片生成视频) │
│      ↓              │
│  quality-agent      │ ← 视频质量审核 → 不达标则重新生成
└─────────────────────┘
  ↓
整合结果 → 返回用户
```

**核心改进**: 每个阶段都有质量审核，不达标立即重新生成

**输出格式**:

```markdown
🎯 生成结果

📋 任务规范: {...}
📚 收集资料: 15条
✍️  生成内容: 【标题】正文...
🎨 视觉参数: {...}
✅ 质量评分: 88/100 (良好)
```

**注意事项**:
- 每个子 Agent 都是独立的 session
- 每个阶段都有质量审核（分阶段质量控制）
- 质量不达标会重新生成（最多3次）
- 执行时间根据 Agent 数量而定（约 3-8 分钟，包含重试）
- 支持小红书、抖音、微信公众号等平台
- 可以生成图文、视频等多种内容类型

**技术实现**:
- 使用 `sessions_spawn` 创建独立 Agent sessions
- 每个有独立的上下文、记忆、超时控制
- 结果在 Agents 之间自动传递
