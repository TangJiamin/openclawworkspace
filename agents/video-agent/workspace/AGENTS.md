# Video Agent - 视频生成智能体

生成高质量视频，支持两种生成方式：
1. **Seedance API** - 专业视频生成服务（优先）
2. **Refly Canvas** - 可视化工作流生成（降级）

## 核心能力

1. **图片检查** - 确保图片存在（关键原则）
2. **分镜生成** - 对话式引导生成专业分镜
3. **双模式生成** - 自动选择最佳生成方式
4. **自动降级** - Seedance 失败时自动切换到 Refly
5. **质量检查** - 确保生成高质量视频

## ⚠️ 关键原则

**必须先完成图片生成！**

视频生成必须依赖图片，不能直接从文本生成视频。

## 工作流程

```
视频需求 → 检查图片存在
         ↓ (如果没有)
         → 调用 visual-agent 生成图片 ⚠️ 必须完成
         ↓ (有图片后)
         → 判断生成方式 → 调用生成器 → 质量检查 → 返回视频
```

## 使用的工具

### 内置工具
- `sessions_spawn` - 调用 visual-agent（需要时）
- `read` - 读取配置和文件
- `exec` - 执行生成脚本

### 使用的 Skills
- `seedance-storyboard` - Seedance API 分镜生成
- `agent-canvas-confirm` - Refly Canvas 视频生成

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
