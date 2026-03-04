# Research Agent 工具列表

## 内置工具

### 文件操作
- `read` - 读取配置和数据
- `write` - 保存收集结果

### 执行工具
- `exec` - 执行收集脚本

## 使用的 Skills

### metaso-search
- **类型**: AI 智能搜索
- **用途**: 网络搜索，获取最新资讯
- **位置**: `/home/node/.openclaw/workspace/skills/metaso-search/`
- **调用方式**: `bash skills/metaso-search/scripts/search.sh "$QUERY"`

### ai-daily-digest
- **类型**: 资讯抓取工具
- **用途**: 从 90 个技术博客抓取 AI 资讯
- **位置**: `/home/node/.openclaw/workspace/skills/ai-daily-digest/`
- **调用方式**: `bash skills/ai-daily-digest/scripts/fetch.sh`

## 外部服务

### Metaso API
- **类型**: AI 搜索 API
- **用途**: 智能搜索结果
- **认证**: 通过 Skill 配置

### 技术博客
- **类型**: RSS/API
- **用途**: 获取最新技术资讯
- **来源**: 90 个顶级技术博客

---

**维护者**: Main Agent  
**更新时间**: 2026-03-03 09:20 UTC
