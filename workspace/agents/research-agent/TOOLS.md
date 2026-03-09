# research-agent - 工具参考手册

**最后更新**: 2026-03-09
**版本**: v4.0

---

## 🎯 工具能力快速查询

### 搜索工具

| 工具 | 成本 | 搜索能力 | 特殊能力 | 优先级 |
|------|------|---------|---------|--------|
| **Jina AI Search** | ✅ 免费 | ✅ | - | ⭐⭐⭐⭐⭐ 首选 |
| **Metaso Search** | ✅ 免费 | ✅ | AI 驱动 | ⭐⭐⭐⭐ 备选 |
| **Tavily Search** | ⚠️ API Key | ✅ | 深度/新闻 | ⭐⭐⭐⭐⭐ 质量优先 |
| **Exa Search** | ⚠️ API Key | ✅ | 代码/公司 | ⭐⭐⭐⭐ 代码专用 |

### 内容提取

| 工具 | 成本 | 支持格式 | 特殊能力 | 优先级 |
|------|------|---------|---------|--------|
| **Jina Reader** | ✅ 免费 | URL | ✅ SPA | ⭐⭐⭐⭐⭐ 首选 |
| **Tavily Extract** | ⚠️ API Key | URL | ✅ AI 优化 | ⭐⭐⭐⭐ 备选 |
| **Summarize** | ⚠️ API Key | 多格式 | ✅ PDF/YouTube | ⭐⭐⭐⭐ 多格式 |

### 平台搜索

| 平台 | 工具 | 成本 | 命令 |
|------|------|------|------|
| **Reddit** | Agent Reach | ✅ 免费 | `curl "https://www.reddit.com/search.json?q=query"` |
| **YouTube** | Agent Reach | ✅ 免费 | `yt-dlp --dump-json "ytsearch5:query"` |
| **GitHub** | Agent Reach | ✅ 免费 | `gh search repos "query"` |

---

## 📖 详细工具说明

### 1. Jina AI Search ⭐⭐⭐⭐⭐

**类型**: 通用网页搜索
**成本**: ✅ 完全免费
**优先级**: **首选搜索工具**

**命令**:
```bash
# 基础搜索
curl -s "https://s.jina.ai/[query]" -H "Accept: text/markdown"

# 添加关键词
curl -s "https://s.jina.ai/[query] today" -H "Accept: text/markdown"
```

**优势**:
- ✅ 完全免费
- ✅ AI 优化结果
- ✅ Markdown 输出
- ✅ 无需配置

**使用场景**:
- 所有通用搜索任务
- 成本优先场景

---

### 2. Tavily Search ⭐⭐⭐⭐⭐

**类型**: AI 优化搜索
**成本**: ⚠️ 需要 API Key (https://tavily.com)
**优先级**: 质量优先时的选择

**命令**:
```bash
# 基础搜索
node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" -n 10

# 深度搜索
node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" --deep

# 新闻搜索（24小时内）
node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" --topic news --days 1

# 自定义结果数
node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" -n 20
```

**优势**:
- ✅ AI 优化结果
- ✅ 深度搜索能力
- ✅ 新闻主题和日期过滤
- ✅ 内容提取功能

**使用场景**:
- 新闻搜索（日期过滤）
- 深度研究任务
- 需要最高搜索质量

---

### 3. Jina Reader ⭐⭐⭐⭐⭐

**类型**: 网页内容提取
**成本**: ✅ 完全免费
**优先级**: **首选提取工具**

**命令**:
```bash
# 基础提取
curl -s "https://r.jina.ai/[URL]"

# Markdown 格式
curl -s "https://r.jina.ai/[URL]" -H "Accept: text/markdown"
```

**优势**:
- ✅ 完全免费
- ✅ 支持单页应用（SPA）
- ✅ Markdown 输出
- ✅ 无需配置

**使用场景**:
- 所有内容提取任务
- 单页应用（SPA）

---

### 4. Summarize

**类型**: 多格式总结
**成本**: ⚠️ 需要 API Key (Gemini/OpenAI/Anthropic/xAI)
**优先级**: 多格式总结专用

**命令**:
```bash
# URL 总结
npx summarize "https://example.com/article"

# PDF 总结
npx summarize "/path/to/file.pdf"

# YouTube 总结
npx summarize "https://youtu.be/..." --youtube auto

# 指定长度
npx summarize "url" --length medium

# 指定模型
npx summarize "url" --model google/gemini-3-flash-preview
```

**优势**:
- ✅ 多格式支持（URL、PDF、YouTube、图片、音频）
- ✅ 灵活的输出长度
- ✅ 支持多种模型

**使用场景**:
- PDF 研究报告总结
- YouTube 视频总结
- 长文档快速理解

---

### 5. Exa Search (Agent Reach)

**类型**: AI 优化搜索 + 代码搜索
**成本**: ⚠️ 需要 API Key
**优先级**: 代码搜索专用

**命令**:
```bash
# Web 搜索
mcporter call 'exa.web_search_exa(query: "query", numResults: 5)'

# 代码搜索（独有能力）
mcporter call 'exa.get_code_context_exa(query: "how to parse JSON in Python", tokensNum: 3000)'

# 公司研究（独有能力）
mcporter call 'exa.company_research_exa(companyName: "OpenAI")'
```

**优势**:
- ✅ 专门的代码搜索
- ✅ 公司研究功能
- ✅ AI 优化结果

**使用场景**:
- 技术问题搜索
- 代码示例搜索
- 公司背景研究

---

### 6. 平台特定工具

#### Reddit

```bash
# 搜索
curl -s "https://www.reddit.com/search.json?q=query&limit=10" -H "User-Agent: agent-reach/1.0"

# 读取子版块
curl -s "https://www.reddit.com/r/python/hot.json?limit=10"
```

#### YouTube

```bash
# 搜索
yt-dlp --dump-json "ytsearch5:query"

# 元数据
yt-dlp --dump-json "https://www.youtube.com/watch?v=xxx"

# 字幕
yt-dlp --write-sub --write-auto-sub --sub-lang "zh-Hans,zh,en" --skip-download
```

#### GitHub

```bash
# 搜索仓库
gh search repos "query" --sort stars --limit 10

# 搜索代码
gh search code "query" --language python

# 查看仓库
gh repo view owner/repo
```

---

## 🎯 场景化工具选择

### 场景 1: 热点资讯（24小时内）

**推荐工具**:
1. Jina AI Search（免费）
   ```bash
   curl -s "https://s.jina.ai/AI news today" -H "Accept: text/markdown"
   ```
2. Tavily Search（付费，更精准）
   ```bash
   node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "AI news" --topic news --days 1
   ```

---

### 场景 2: 技术问题搜索

**推荐工具**:
1. Jina AI Search（免费）
   ```bash
   curl -s "https://s.jina.ai/[query] code examples" -H "Accept: text/markdown"
   ```
2. GitHub Code Search（免费）
   ```bash
   gh search code "[query]" --language python
   ```
3. Exa Search（付费，代码专用）
   ```bash
   mcporter call 'exa.get_code_context_exa(query: "[query]")'
   ```

---

### 场景 3: 内容提取

**推荐工具**:
1. Jina Reader（免费，首选）
   ```bash
   curl -s "https://r.jina.ai/[URL]"
   ```
2. Tavily Extract（付费，AI 优化）
   ```bash
   node /home/node/.openclaw/workspace/skills/tavily-search/scripts/extract.mjs "[URL]"
   ```

---

## 📊 成本对比

### 免费工具

- ✅ Jina AI Search
- ✅ Jina Reader
- ✅ Metaso Search
- ✅ Reddit API
- ✅ yt-dlp
- ✅ gh CLI

### 需要配置 API Key

- ⚠️ Tavily Search
- ⚠️ Summarize
- ⚠️ Exa Search

---

## ⚙️ 配置状态

### 已配置（免费）

- [x] Jina AI Search
- [x] Jina Reader
- [x] Metaso Search
- [x] Reddit API
- [x] yt-dlp (YouTube)
- [x] gh CLI (GitHub)

### 待配置（需要 API Key）

- [ ] Tavily Search - https://tavily.com
- [ ] Summarize - Gemini/OpenAI/Anthropic/xAI
- [ ] Exa Search - Exa API Key

---

## 🔄 智能降级机制

### 搜索降级

```
Jina AI Search (免费)
  ↓
结果不满足？
  ↓
Tavily Search (付费)
```

### 提取降级

```
Jina Reader (免费)
  ↓
无法提取？
  ↓
Tavily Extract (付费)
```

---

**维护者**: Main Agent  
**版本**: v4.0  
**最后更新**: 2026-03-09
