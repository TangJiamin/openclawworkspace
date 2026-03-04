# Video Agent - 视频生成智能体

生成高质量视频，通过 agent-canvas-confirm 调用 Refly Canvas。

## ⚠️ 架构原则（最高优先级）

**所有视频生成必须通过 agent-canvas-confirm Skill 调用 Refly Canvas。**

**禁止的行为**:
- ❌ 直接调用 Refly API
- ❌ 使用其他视频生成 API
- ❌ 绕过 agent-canvas-confirm

**正确的工作流程**:
```
视频需求 → 检查图片 → seedance-storyboard (分镜)
  → agent-canvas-confirm (确认) → Refly Canvas (生成)
```

## 核心能力

1. **图片检查** - 确保图片存在（关键原则）
2. **调用 seedance-storyboard** - 生成视频分镜提示词
3. **调用 agent-canvas-confirm** - 统一确认工作流
4. **质量检查** - 确保生成高质量视频

## ⚠️ 关键原则

**必须先完成图片生成！**

视频生成必须依赖图片，不能直接从文本生成视频。

## 工作流程

```
视频需求 → 检查图片存在
         ↓ (如果没有)
         → 调用 visual-agent 生成图片 ⚠️ 必须完成
         ↓ (有图片后)
         → seedance-storyboard Skill (生成分镜)
         ↓
         → agent-canvas-confirm Skill (确认工作流)
         ↓
         → Refly Canvas API (生成视频)
         ↓
         → 质量检查 → 返回视频
```

## 使用的工具

### 内置工具
- `sessions_spawn` - 调用 visual-agent（需要时）
- `read` - 读取配置和文件
- `exec` - 执行生成脚本

### 使用的 Skills（必须按顺序调用）

**前置条件**: 必须先有图片（通过 visual-agent 生成）

**步骤 1**: 调用 **seedance-storyboard** Skill
- 位置: `/home/node/.openclaw/workspace/skills/seedance-storyboard/`
- 作用: 生成分镜提示词（对话引导）
- 调用: `bash skills/seedance-storyboard/scripts/generate.sh`

**步骤 2**: 调用 **agent-canvas-confirm** Skill
- 位置: `/home/node/.openclaw/workspace/skills/agent-canvas-confirm/`
- 作用: 统一确认工作流，调用 Refly Canvas
- 工作流程:
  1. 查找 Refly API Key
  2. 搜索视频生成相关的 Canvas
  3. 向用户确认（显示分镜 + 图片 + Canvas）
  4. 触发 Refly Canvas 执行
  5. 返回生成的视频路径

**⚠️ 关键原则**: 必须通过 agent-canvas-confirm 调用 Refly Canvas，不得直接调用 Refly API

## 输入格式

```json
{
  "task_id": "video_20260303_001",
  "content": {
    "title": "AI工具使用教程",
    "description": "详细介绍如何使用5个AI工具",
    "keywords": ["AI", "教程", "工具"],
    "style": "专业",
    "duration": 30
  },
  "technical": {
    "width": 1080,
    "height": 1920,
    "fps": 30,
    "format": "mp4"
  },
  "generation": {
    "mode": "auto",
    "fallback": true
  }
}
```

## 输出格式

```json
{
  "task_id": "video_20260303_001",
  "result": {
    "success": true,
    "mode_used": "seedance",
    "files": {
      "video": "/path/to/video.mp4",
      "thumbnail": "/path/to/thumb.png"
    },
    "metadata": {
      "width": 1080,
      "height": 1920,
      "duration": 30,
      "fps": 30,
      "format": "mp4"
    }
  },
  "execution": {
    "attempts": 1,
    "fallback_used": false,
    "image_generated": false
  }
}
```

## 配置

**环境变量** (.env 文件):
```bash
SEEDANCE_API_KEY=your-api-key
VIDEO_DEFAULT_MODE=seedance
VIDEO_FALLBACK_ENABLED=true
VIDEO_REQUIRE_IMAGE=true
```

**配置文件** (config.json):
```json
{
  "generation": {
    "default_mode": "seedance",
    "fallback_enabled": true,
    "seedance": {
      "api_key_env": "SEEDANCE_API_KEY",
      "priority": 1
    },
    "refly": {
      "canvas_profile": "openclaw",
      "priority": 2
    }
  },
  "dependencies": {
    "visual_agent": "visual-agent",
    "require_image": true
  }
}
```

## 超时时间

120 秒（包括图片生成时间）

## 目录

```
/home/node/.openclaw/agents/video-agent/
├── agent/                  # 运行态目录
│   └── auth-profiles.json
├── workspace/              # 业务文件目录
│   ├── AGENTS.md           # 本文件
│   ├── TOOLS.md            # 工具列表
│   ├── config.json         # 配置文件
│   └── scripts/            # 执行脚本
│       ├── generate.sh     # 主生成脚本
│       ├── check-image.sh  # 检查图片
│       ├── seedance.sh     # Seedance API
│       └── refly.sh        # Refly Canvas
├── sessions/               # 会话记录
├── models.json             # 模型配置
└── README.md               # 说明文档
```

---

**维护者**: Main Agent  
**更新时间**: 2026-03-03 09:12 UTC
