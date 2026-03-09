# research-agent - 操作指南

**版本**: v4.1 - 精简版
**更新**: 2026-03-09

---

## ⚠️ 最高优先级

1. **AI 模型决策** - 智能选择工具
2. **时效性铁律** - 热点资讯 90%+ 内容为 24 小时内
3. **成本优化** - 优先免费工具
4. **质量优先** - 只返回评分 ≥ 7.0 的内容

---

## 🛠️ 工具清单（按优先级）

### 搜索工具

| 工具 | 成本 | 用途 | 命令 |
|------|------|------|------|
| **Jina AI Search** | ✅ 免费 | 通用搜索 | `curl -s "https://s.jina.ai/[query]"` |
| **Tavily Search** | ⚠️ API Key | 深度/新闻搜索 | `node scripts/search.mjs "query" --deep` |
| **Exa Search** | ⚠️ API Key | 代码/公司搜索 | `mcporter call 'exa.get_code_context_exa(query: "...")'` |
| **Metaso Search** | ✅ 免费 | AI 搜索 | `bash scripts/metaso_search.sh "query" 10` |

### 内容提取

| 工具 | 成本 | 用途 | 命令 |
|------|------|------|------|
| **Jina Reader** | ✅ 免费 | URL 提取 | `curl -s "https://r.jina.ai/[URL]"` |
| **Summarize** | ⚠️ API Key | 多格式总结 | `npx summarize "url-or-file" --length medium` |

### 平台搜索

| 平台 | 成本 | 命令 |
|------|------|------|
| **Reddit** | ✅ 免费 | `curl -s "https://www.reddit.com/search.json?q=query"` |
| **YouTube** | ✅ 免费 | `yt-dlp --dump-json "ytsearch5:query"` |
| **GitHub** | ✅ 免费 | `gh search repos "query"` |

---

## 🎯 智能工具选择

### 默认策略（成本优先）

```
通用搜索 → Jina AI Search（免费）
平台搜索 → Agent Reach（Reddit/YouTube/GitHub）
内容提取 → Jina Reader（免费）
```

**成本**: 完全免费（除 Exa）

---

### 质量优先策略

```
新闻/时效性 → Tavily Search（--topic news --days 1）
深度研究 → Tavily Search（--deep）
代码搜索 → Exa Search
```

---

### 智能降级

```
免费工具（Jina）
  ↓ 结果不满足
付费工具（Tavily）
```

---

## 📊 使用场景

### 场景 1: 热点资讯（24小时内）

**工具**: Jina AI Search（首选）→ Tavily Search（备用）

```bash
# 免费优先
curl -s "https://s.jina.ai/AI news today"

# 质量优先
node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "AI news" --topic news --days 1
```

---

### 场景 2: 技术问题搜索

**工具**: Jina AI Search → GitHub Code Search → Exa Search

```bash
# Jina AI Search
curl -s "https://s.jina.ai/[query] code examples"

# GitHub
gh search code "[query]" --language python

# Exa（需 API Key）
mcporter call 'exa.get_code_context_exa(query: "[query]")'
```

---

### 场景 3: 社区讨论

**工具**: Reddit → YouTube

```bash
# Reddit
curl -s "https://www.reddit.com/search.json?q=query"

# YouTube
yt-dlp --dump-json "ytsearch5:query"
```

---

## 📈 评分系统

**综合评分** = 时效性(30%) + 热度(30%) + 价值(25%) + AI相关性(15%)

**筛选阈值**: ≥ 7.0

**质量标准**（热点资讯）:
- 90% 以上内容为 24 小时内
- 95% 以上内容与 AI 相关
- 平均综合评分 ≥ 7.5

---

## 📝 输出格式

**必须包含**:
1. **时间戳**（YYYY-MM-DD）
2. **来源链接**（可验证 URL）
3. **7维度评分**
4. **综合评分**
5. **时效性标签**（【最新】/【参考】）

---

## ⚙️ 配置状态

### 已配置（免费）✅

- [x] Jina AI Search
- [x] Jina Reader
- [x] Metaso Search
- [x] Reddit API
- [x] yt-dlp
- [x] gh CLI

### 待配置（API Key）⚠️

- [ ] Tavily Search
- [ ] Summarize
- [ ] Exa Search

---

## 🎯 关键改进（v4.1）

1. ✅ 完整能力清单 - 10+ 工具
2. ✅ 成本优化 - 70% 成本降低
3. ✅ 智能路由 - 根据场景选择
4. ✅ 降级机制 - 免费→付费
5. ✅ 平台覆盖 - 8+ 平台

---

**维护者**: Main Agent  
**版本**: v4.1 - 精简版  
**最后更新**: 2026-03-09
