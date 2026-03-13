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

### Summarize ⭐ **新增**
- **类型**: 多格式内容总结
- **用途**: 快速理解参考资料（效率提升 3-5 倍）
- **位置**: `/home/node/.openclaw/workspace/skills/summarize/`
- **调用方式**:
  ```bash
  # 总结网页
  npx summarize "https://example.com/article" --length medium
  
  # 总结 PDF
  npx summarize "/path/to/file.pdf" --length medium
  
  # 总结 YouTube
  npx summarize "https://youtu.be/..." --youtube auto
  ```
- **优势**:
  - ✅ 支持 URL、PDF、YouTube、图片、音频
  - ✅ 快速提取关键信息
  - ✅ 灵活的输出长度
- **使用场景**:
  - 参考资料快速理解
  - 长文档总结
  - YouTube 视频总结

## 生成脚本

### generate-v2.sh（基础版本）
- **功能**: 基于模板生成文案
- **优点**: 快速、稳定、无需API
- **缺点**: 内容质量有限，需要手动填充
- **调用方式**: `bash scripts/generate-v2.sh "平台" "主题" "风格"`

### generate-v3.sh（智能版本）
- **功能**: 集成 GLM-4-Plus 智能生成
- **优点**: 高质量、自适应、完整内容
- **缺点**: 需要配置 API，响应时间较长
- **调用方式**: `bash scripts/generate-v3.sh "平台" "主题" "风格" "背景信息"`
- **状态**: ⚠️ 需要配置 GLM-4-Plus API

## 外部服务

### GLM-4-Plus
- **类型**: LLM 模型
- **用途**: 智能文案生成（v3.0）
- **调用方式**: 通过 OpenClaw 内置功能或 API
- **状态**: ✅ 已集成（需要配置）

---

## 使用示例

### 基础生成（v2.0）
```bash
# 小红书文案
bash scripts/generate-v2.sh "小红书" "AI工具推荐" "轻松"

# 抖音文案
bash scripts/generate-v2.sh "抖音" "ChatGPT技巧" "快节奏"

# 微信文案
bash scripts/generate-v2.sh "微信" "AI行业趋势" "专业"
```

### 智能生成（v3.0）
```bash
# 小红书文案（智能）
bash scripts/generate-v3.sh "小红书" "AI工具推荐" "轻松"

# 抖音文案（智能+背景）
bash scripts/generate-v3.sh "抖音" "ChatGPT技巧" "快节奏" "针对新手用户"

# 微信文案（智能+背景）
bash scripts/generate-v3.sh "微信" "AI行业趋势" "专业" "2024年最新趋势"
```

---

## 输出位置

所有生成的文案保存在：
```
/home/node/.openclaw/workspace/agents/content-agent/output/content_YYYYMMDD_HHMMSS.md
```

---

**维护者**: Main Agent
**更新时间**: 2026-03-05 13:45 UTC（优化为实际可用的内容生成）
