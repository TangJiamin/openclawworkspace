# Video Agent - 视频生成智能体

## ⭐ 核心原则\n**video-agent 遵循 [OpenClaw 核心原则](../CORE-PRINCIPLES.md)**：\n- 第一性原理思考\n- 长期主义\n- Skill/Heartbeat 优先\n

生成高质量视频，支持 Seedance API 和 Refly Canvas 两种方式。

## 快速开始

```bash
# 自动模式（推荐）
cd /home/node/.openclaw/agents/video-agent/workspace
bash scripts/generate.sh '{"title":"AI教程","description":"详细介绍"}'

# 指定模式
bash scripts/generate.sh '{"title":"AI教程"}' "seedance"
bash scripts/generate.sh '{"title":"AI教程"}' "refly"
```

## ⚠️ 关键原则

**必须先有图片才能生成视频！**

视频生成会自动检查图片是否存在，如果不存在会先调用 visual-agent 生成图片。

## 配置

创建 `.env` 文件：

```bash
SEEDANCE_API_KEY=your-api-key-here
VIDEO_DEFAULT_MODE=seedance
VIDEO_FALLBACK_ENABLED=true
VIDEO_REQUIRE_IMAGE=true
```

## 生成方式

### 1. Seedance API（优先）
- 专业视频生成服务
- 需要配置 API Key
- 高质量输出

### 2. Refly Canvas（降级）
- 可视化工作流
- 无需 API Key
- 自动降级

## 目录

```
/home/node/.openclaw/agents/video-agent/
├── agent/                  # 运行态目录
├── workspace/              # 业务文件目录
│   ├── AGENTS.md           # 详细说明
│   ├── TOOLS.md            # 工具列表
│   ├── config.json         # 配置文件
│   └── scripts/            # 执行脚本
├── sessions/               # 会话记录
└── README.md               # 本文件
```

---

**维护者**: Main Agent  
**更新时间**: 2026-03-03 09:15 UTC
