# research-agent - 工具优先级更新

**更新时间**: 2026-03-10 10:55
**更新原因**: 全面测试通过，Tavily Search 已验证可用

---

## 🛠️ 工具清单（按优先级）⭐⭐⭐⭐⭐ **已更新**

### 搜索技能（已集成，必须使用）

| 技能 | 成本 | 用途 | 优先级 | 命令 |
|------|------|------|--------|------|
| **Tavily Search** ⭐⭐⭐⭐⭐ **首选** | ⚠️ API Key | AI 优化搜索（速度提升 30-50%） | ⭐⭐⭐⭐⭐ | `node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" -n 10 --deep` |
| **Jina AI Search** | ✅ 免费 | 通用搜索 | ⭐⭐⭐⭐ 备选 | `curl -s "https://s.jina.ai/[query]" -H "Accept: text/markdown"` |
| **Metaso Search** | ✅ 免费 | AI 优化搜索 | ⭐⭐⭐ 备选 | `bash /home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh "query" 10` |
| **Exa Search** | ⚠️ API Key | 代码/公司搜索 | ⭐⭐⭐⭐ 专用 | `mcporter call 'exa.get_code_context_exa(query: "...")'` |

**⚠️ 工具使用铁律**:
- ✅ **必须按优先级尝试至少 3 个工具**
- ❌ **不要在只尝试 1-2 个工具后就放弃**
- ❌ **不要在工具失败后直接基于知识库输出**
- ✅ **必须验证搜索结果的时效性和准确性**

---

## 🎯 Tavily Search 优势

**vs Jina AI Search**:
- ✅ AI 优化搜索（更智能）
- ✅ 深度搜索支持（--deep）
- ✅ 新闻搜索支持
- ✅ 速度提升 30-50%

**vs Metaso Search**:
- ✅ 官方 API（更稳定）
- ✅ 免费额度 1000 次/月
- ✅ 支持多种搜索模式

---

## 📊 搜索策略

### 1. 优先使用 Tavily Search

```javascript
// 首选
const tavilyResult = await tavilySearch(query, {
  maxResults: 10,
  searchDepth: "advanced", // 深度搜索
  topic: "general" // 或 "news" 新闻搜索
});
```

### 2. 智能降级

```
Tavily Search（首选）
  ↓ 结果不满足
Jina AI Search（备选）
  ↓ 结果不满足
Metaso Search（备选）
```

### 3. 搜索类型选择

| 搜索类型 | 工具选择 | 参数 |
|---------|---------|------|
| 热点资讯 | Tavily Search | `--topic news --days 1` |
| 深度研究 | Tavily Search | `--deep` |
| 通用搜索 | Jina AI Search | 默认 |
| 代码搜索 | Exa Search | 专用 |

---

## ⚠️ 使用注意事项

1. **API Key 配置**
   - ✅ 已配置 TAVILY_API_KEY
   - ✅ 自动加载 .env 文件
   - ❌ 不要手动传递

2. **免费额度管理**
   - 每月 1000 次免费搜索
   - 优先使用免费工具（Jina、Metaso）
   - Tavily 用于重要搜索

3. **质量标准**
   - 只返回评分 ≥ 7.0 的内容
   - 验证时效性（24 小时内）
   - 验证准确性（多源验证）

---

**更新完成！Tavily Search 已设为首选搜索工具！** ✅
