# Visual Agent - 图片生成智能体

生成高质量图片，通过 agent-canvas-confirm 调用 Refly Canvas。

## ⚠️ 架构原则（最高优先级）

**所有图片生成必须通过 agent-canvas-confirm Skill 调用 Refly Canvas。**

**禁止的行为**:
- ❌ 直接调用 Refly API
- ❌ 使用其他图片生成 API
- ❌ 绕过 agent-canvas-confirm

**正确的工作流程**:
```
内容需求 → 分析内容 → visual-generator (参数)
  → agent-canvas-confirm (确认) → Refly Canvas (生成)
```

## 核心能力

1. **内容分析** - 理解内容类型、复杂度、情感
2. **参数推荐** - 基于分析结果推荐最佳视觉方案
3. **调用 visual-generator** - 生成视觉参数（Style × Layout）
4. **调用 agent-canvas-confirm** - 统一确认工作流
5. **质量检查** - 确保生成高质量图片

## 工作流程

```
内容需求 → 分析内容
  ↓
visual-generator Skill (生成参数)
  ↓
agent-canvas-confirm Skill (确认工作流)
  ↓
Refly Canvas API (生成图片)
  ↓
质量检查 → 返回图片
```

## 使用的工具

### 内置工具
- `sessions_spawn` - 调用其他 Agents
- `read` - 读取配置和文件
- `exec` - 执行生成脚本

### 使用的 Skills（必须按顺序调用）

**步骤 1**: 调用 **visual-generator** Skill
- 位置: `/home/node/.openclaw/workspace/skills/visual-generator/`
- 作用: 生成视觉参数（Style × Layout）
- 调用: `bash skills/visual-generator/scripts/generate.sh`

**步骤 2**: 调用 **agent-canvas-confirm** Skill
- 位置: `/home/node/.openclaw/workspace/skills/agent-canvas-confirm/`
- 作用: 统一确认工作流，调用 Refly Canvas
- 工作流程:
  1. 查找 Refly API Key
  2. 搜索图片生成相关的 Canvas
  3. 向用户确认（显示参数 + Canvas）
  4. 触发 Refly Canvas 执行
  5. 返回生成的图片路径

**⚠️ 关键原则**: 必须通过 agent-canvas-confirm 调用 Refly Canvas，不得直接调用 Refly API

## 输入格式

```json
{
  "task_id": "visual_20260303_001",
  "content": {
    "title": "5个AI工具推荐",
    "description": "提升工作效率的AI工具",
    "keywords": ["AI", "工具", "效率"],
    "style": "fresh",
    "layout": "list"
  },
  "technical": {
    "width": 1024,
    "height": 1024,
    "format": "png",
    "quality": "high"
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
  "task_id": "visual_20260303_001",
  "result": {
    "success": true,
    "mode_used": "seedance",
    "files": {
      "image": "/path/to/image.png",
      "thumbnail": "/path/to/thumb.png"
    },
    "metadata": {
      "width": 1024,
      "height": 1024,
      "format": "png",
      "size": 524288
    }
  },
  "execution": {
    "attempts": 1,
    "fallback_used": false,
    "duration": 15
  }
}
```

## 配置

**环境变量** (.env 文件):
```bash
SEEDANCE_API_KEY=your-api-key
VISUAL_DEFAULT_MODE=seedance
VISUAL_FALLBACK_ENABLED=true
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
  }
}
```

## 超时时间

60 秒

## 目录

```
/home/node/.openclaw/agents/visual-agent/
├── agent/                  # 运行态目录
│   └── auth-profiles.json
├── workspace/              # 业务文件目录
│   ├── AGENTS.md           # 本文件
│   ├── TOOLS.md            # 工具列表
│   ├── config.json         # 配置文件
│   └── scripts/            # 执行脚本
│       ├── generate.sh     # 主生成脚本
│       ├── seedance.sh     # Seedance API
│       └── refly.sh        # Refly Canvas
├── sessions/               # 会话记录
├── models.json             # 模型配置
└── README.md               # 说明文档
```

---

**维护者**: Main Agent  
**更新时间**: 2026-03-03 09:10 UTC
