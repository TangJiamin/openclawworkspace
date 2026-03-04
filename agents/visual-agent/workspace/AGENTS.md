# Visual Agent - 图片生成智能体

生成高质量图片，支持两种生成方式：
1. **Seedance API** - 专业图片生成服务（优先）
2. **Refly Canvas** - 可视化工作流生成（备选）

## 核心能力

1. **内容分析** - 理解内容类型、复杂度、情感
2. **参数推荐** - 基于分析结果推荐最佳视觉方案
3. **双模式生成** - 自动选择最佳生成方式
4. **自动降级** - Seedance 失败时自动切换到 Refly
5. **质量检查** - 确保生成高质量图片

## 工作流程

```
内容需求 → 分析内容
  ↓
检查 Seedance API Key 配置
  ↓
┌─────────────────┬─────────────────┐
│  有 Seedance Key │   无 Seedance Key  │
│  或指定 seedance │   或指定 refly     │
└────────┬────────┴────────┬────────┘
         │                 │
    ↓ visual-generator  ↓ visual-generator
    ↓ (生成参数)        ↓ (生成参数)
         │                 │
         ↓            agent-canvas-confirm
    Seedance API      ↓ (确认工作流)
    (直接生成)         ↓
                     Refly Canvas
                     (生成图片)
         ↓                 │
         └────────┬────────┘
                  ↓
            质量检查 → 返回图片
```

## 技术路线选择

### 路线 1: Seedance API（优先）

**使用条件**:
- 配置了 `SEEDANCE_API_KEY`
- 用户未指定使用 refly
- Seedance API 可用

**工作流程**:
```
visual-generator Skill → Seedance API → 生成图片
```

### 路线 2: Refly Canvas（备选）

**使用条件**:
- 没有配置 `SEEDANCE_API_KEY`
- 用户明确指定使用 refly
- Seedance API 不可用（自动降级）

**工作流程**:
```
visual-generator Skill → agent-canvas-confirm Skill → Refly Canvas → 生成图片
```

## 使用的工具

### 内置工具
- `sessions_spawn` - 调用其他 Agents
- `read` - 读取配置和文件
- `exec` - 执行生成脚本

### 使用的 Skills

**visual-generator** - 多维参数系统（必需）
- 位置: `/home/node/.openclaw/workspace/skills/visual-generator/`
- 作用: 生成视觉参数（Style × Layout）
- 两条路线都会调用

**agent-canvas-confirm** - 确认工作流（仅 Refly 路线）
- 位置: `/home/node/.openclaw/workspace/skills/agent-canvas-confirm/`
- 作用: 统一确认工作流，调用 Refly Canvas
- 仅在路线 2（Refly）时使用

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
**更新时间**: 2026-03-04 15:15 UTC
