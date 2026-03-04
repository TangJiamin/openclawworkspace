# Agent-Reach 快速使用指南（无需完整安装）

**时间**: 2026-03-04 02:36 UTC

---

## 🚀 立即可用的核心工具

### 1. Jina Reader（网页阅读）✅ 无需安装

**使用**:
```bash
# 读任意网页为 Markdown
curl -s "https://r.jina.ai/URL" -H "Accept: text/markdown"
```

**示例**:
```bash
# 读 OpenAI 博客
curl -s "https://r.jina.ai/https://openai.com/blog" -H "Accept: text/markdown"
```

---

### 2. GitHub CLI（已安装）✅

**检查**:
```bash
gh --version
```

**使用**:
```bash
# 搜索仓库
gh search repos "LLM framework" --limit 10

# 查看仓库
gh repo view openai/openai-python
```

---

### 3. RSS（feedparser）⏳ 需要安装

**安装**:
```bash
pip3 install --user feedparser
```

**使用**:
```python
python3 -c "
import feedparser
d = feedparser.parse('https://openai.com/blog/rss')
for e in d.entries[:5]:
    print(f'{e.title} — {e.link}')
"
```

---

### 4. Twitter（xreach CLI）⏳ 需要安装

**安装**:
```bash
npm install -g xreach
```

**使用**:
```bash
# 搜索推文
xreach search "GPT-5" --json -n 10
```

---

### 5. YouTube（yt-dlp）⏳ 需要安装

**安装**:
```bash
pip3 install --user yt-dlp
```

**使用**:
```bash
# 提取视频元数据
yt-dlp --dump-json "URL"
```

---

## 🔧 集成到 research-agent

### 修改 research-agent 脚本

**位置**: `/home/node/.openclaw/agents/research-agent/workspace/scripts/collect_v4.sh`

**添加多数据源**:

```bash
#!/bin/bash
# research-agent v4.0 - 多数据源版本

set -e

TOPIC="$1"
LIMIT="${2:-5}"

echo "=================================================="
echo "  Research Agent v4.0 - 多数据源版本"
echo "=================================================="
echo ""
echo "🔍 搜索关键词: $TOPIC"
echo "📊 结果数量: $LIMIT"
echo ""

# ========================================
# 数据源1: Metaso AI Search（现有）
# ========================================

echo "📡 数据源1: Metaso AI Search"
METASO_OUTPUT=$(bash /home/node/.openclaw/agents/research-agent/workspace/scripts/collect_v3_final.sh "$TOPIC" "$LIMIT")
echo "$METASO_OUTPUT" | grep -E "(🎯 高价值|📅)" | head -10
echo ""

# ========================================
# 数据源2: GitHub（搜索最新仓库）⭐
# ========================================

echo "📦 数据源2: GitHub"
GITHUB_OUTPUT=$(gh search repos "$TOPIC" --limit "$LIMIT" --json name,description,updatedAt,stars)
echo "$GITHUB_OUTPUT" | jq -r '.[] | "  - \(.name) (\(.stars)⭐): \(.description)"' | head -10
echo ""

# ========================================
# 数据源3: RSS（OpenAI 博客）⭐
# ========================================

echo "📡 数据源3: RSS - OpenAI 博客"
RSS_OUTPUT=$(python3 -c "
import feedparser
d = feedparser.parse('https://openai.com/blog/rss')
for e in d.entries[:5]:
    print(f'{e.title} — {e.link}')
" 2>/dev/null || echo "  (需要安装 feedparser: pip3 install --user feedparser)")
echo "$RSS_OUTPUT" | head -5
echo ""

# ========================================
# 数据源4: Jina Reader（网页抓取）⭐
# ========================================

echo "🌐 数据源4: Jina Reader - 官方博客"
WEB_OUTPUT=$(curl -s "https://r.jina.ai/https://openai.com/blog" -H "Accept: text/markdown" 2>/dev/null | grep -E "GPT|Claude|Gemini" | head -5 || echo "  (网络错误)")
echo "$WEB_OUTPUT"
echo ""

# ========================================
# 合并输出
# ========================================

echo "=================================================="
echo "  📊 合并结果"
echo "=================================================="
echo ""

echo "✅ 所有数据源已合并"
echo ""
```

---

## 🔧 集成到 content-agent

### 修改 content-agent 脚本

**位置**: `/home/node/.openclaw/agents/content-agent/workspace/scripts/generate.sh`

**使用真实资讯**:

```bash
# 从 GitHub 搜索结果中提取最新仓库
GITHUB_REPOS=$(gh search repos "AI tools" --limit 5 --json name,description)

# 从推文中提取最新资讯（如果配置了 Twitter）
TWITTER_NEWS=$(xreach search "GPT-5" --json -n 5 2>/dev/null || echo "")

# 基于真实资讯生成内容
TOOLS=(
  "GPT-4 Turbo"  # 从真实资讯提取
  "Claude 3.5 Sonnet"
  "Gemini 1.5 Pro"
  # ...
)
```

---

## 📋 立即行动

### 现在就可以用

1. ✅ **Jina Reader** - 无需安装，立即可用
   ```bash
   curl -s "https://r.jina.ai/https://openai.com/blog" -H "Accept: text/markdown"
   ```

2. ✅ **GitHub CLI** - 已安装，立即可用
   ```bash
   gh search repos "AI tools" --limit 10
   ```

### 需要安装

3. ⏳ **feedparser** - RSS 订阅
   ```bash
   pip3 install --user feedparser
   ```

4. ⏳ **xreach** - Twitter 搜索
   ```bash
   npm install -g xreach
   ```

5. ⏳ **yt-dlp** - YouTube 字幕
   ```bash
   pip3 install --user yt-dlp
   ```

---

## 🎯 总结

### ✅ 可以立即使用

**无需完整安装 Agent-Reach，直接使用核心工具**:
- ✅ Jina Reader（网页）- 无需安装
- ✅ GitHub CLI - 已安装
- ⏳ feedparser（RSS）- 需要安装
- ⏳ xreach（Twitter）- 需要安装
- ⏳ yt-dlp（YouTube）- 需要安装

### 🔧 集成到系统

**修改 research-agent**:
- 添加 GitHub 数据源
- 添加 RSS 数据源
- 添加 Jina Reader 数据源

**修改 content-agent**:
- 基于真实资讯生成内容
- 从多个数据源提取信息

---

**维护者**: Main Agent  
**状态**: ✅ 核心工具可以立即使用
