# Visual Agent 工具列表

## 内置工具

### 文件操作
- `read` - 读取配置文件和输入数据
- `write` - 保存生成结果

### 执行工具
- `exec` - 执行生成脚本

### Agent 通信
- `sessions_spawn` - 调用其他 Agents（如需要调用 video-agent 时）

## 使用的 Skills

### visual-generator
- **类型**: 图片生成工具
- **用途**: 调用 Seedance API 生成图片
- **位置**: `/home/node/.openclaw/workspace/skills/visual-generator/`
- **调用方式**: `bash scripts/visual-generator.sh "$CONTENT"`

### agent-canvas-confirm
- **类型**: 确认工作流工具
- **用途**: 调用 Refly Canvas 生成图片
- **位置**: `/home/node/.openclaw/workspace/skills/agent-canvas-confirm/`
- **调用方式**: `bash scripts/canvas.sh "generate-image" "$CONTENT"`

## 外部 API

### Seedance API
- **类型**: 图片生成 API
- **用途**: 专业图片生成服务
- **认证**: API Key（从 .env 或环境变量读取）
- **优先级**: 1（优先使用）

### Refly Canvas
- **类型**: 可视化工作流
- **用途**: 备用图片生成方案
- **认证**: 无需 API Key
- **优先级**: 2（降级使用）

---

**维护者**: Main Agent  
**更新时间**: 2026-03-03 09:10 UTC
