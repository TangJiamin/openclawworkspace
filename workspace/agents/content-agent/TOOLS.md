# Content Agent 工具列表

## 内置工具

### 文件操作
- `read` - 读取配置和输入
- `write` - 保存生成结果

### 执行工具
- `exec` - 执行生成脚本

### Agent 通信
- `sessions_spawn` - 调用 metaso-search（可选）

## 使用的 Skills

### metaso-search
- **类型**: AI 智能搜索
- **用途**: 补充信息和资料
- **位置**: `/home/node/.openclaw/workspace/skills/metaso-search/`
- **调用方式**: `bash skills/metaso-search/scripts/search.sh "$QUERY"`

## 外部服务

### GLM-4-Plus
- **类型**: LLM 模型
- **用途**: 文案生成
- **调用方式**: 通过 OpenClaw 内置功能

---

**维护者**: Main Agent  
**更新时间**: 2026-03-03 09:20 UTC
