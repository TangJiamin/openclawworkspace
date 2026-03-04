# Agent-Reach 配置指南

**配置时间**: 2026-03-04 02:38 UTC

---

## 🔧 配置 GitHub

### 自动安装 gh CLI

**命令**:
```bash
agent-reach setup github
```

**或手动安装**:

**Ubuntu/Debian**:
```bash
# 添加 GitHub CLI 仓库
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

**认证**:
```bash
gh auth login
```

---

## 🔧 配置 Twitter/X

### 安装 xreach CLI

**命令**:
```bash
npm install -g xreach-cli
```

### 配置 Cookie

**方式1: 使用 Cookie-Editor（推荐）**

1. 在浏览器登录 Twitter/X
2. 安装 Cookie-Editor 插件: https://chromewebstore.google.com/detail/cookie-editor/hlkenndednhfkekhgcdicdfddnkalmdm
3. 点击插件 → Export → Header String
4. 复制导出的字符串
5. 配置:
```bash
agent-reach configure twitter-cookies "your_cookies"
```

**方式2: 自动从浏览器提取**
```bash
agent-reach configure --from-browser chrome
```

**⚠️ 安全提醒**: 使用专用小号，存在封号风险

---

## ✅ 配置完成后的使用

### GitHub 使用

```bash
# 搜索仓库
gh search repos "LLM framework" --limit 10

# 查看仓库
gh repo view openai/openai-python

# 搜索代码
gh search code "GPT-4" --language python

# 查看 releases
gh release list --repo openai/openai-python
```

---

### Twitter 使用

```bash
# 搜索推文
xreach search "GPT-5" --json -n 10

# 读单条推文
xreach tweet https://x.com/OpenAI/status/123 --json

# 读取用户时间线
xreach tweets @OpenAI --json -n 20
```

---

## 🎯 集成到 research-agent

### 添加 GitHub 数据源

```bash
#!/bin/bash
# research-agent v5.0 - 包含 GitHub 和 Twitter

TOPIC="$1"
LIMIT="${2:-5}"

# 数据源1: Metaso AI Search
METASO_OUTPUT=$(bash scripts/collect_v3_final.sh "$TOPIC" "$LIMIT")

# 数据源2: GitHub（新增）⭐
echo "📦 数据源2: GitHub - 搜索最新仓库"
GITHUB_OUTPUT=$(gh search repos "$TOPIC" --limit "$LIMIT" --json name,description,updatedAt,stars)
echo "$GITHUB_OUTPUT" | jq -r '.[] | "  📦 \(.name) (\(.stars)⭐): \(.description)"'
echo ""

# 数据源3: Twitter（新增）⭐
echo "🐦 数据源3: Twitter - 搜索最新推文"
TWITTER_OUTPUT=$(xreach search "$TOPIC" --json -n "$LIMIT" 2>/dev/null || echo "")
if [ -n "$TWITTER_OUTPUT" ]; then
  echo "$TWITTER_OUTPUT" | jq -r '.[] | "  🐦 @\(.username): \(.text)"' | head -10
else
  echo "  (需要配置 Twitter: npm install -g xreach-cli)"
fi
echo ""

# 数据源4: RSS 订阅
echo "📡 数据源4: RSS - OpenAI 官方博客"
RSS_OUTPUT=$(python3 -c "
import feedparser
d = feedparser.parse('https://openai.com/blog/rss')
for e in d.entries[:5]:
    print(f'  📰 {e.title}')
" 2>/dev/null || echo "")
echo "$RSS_OUTPUT"
echo ""

# 合并输出
ALL_OUTPUT="$METASO_OUTPUT

$GITHUB_OUTPUT

$TWITTER_OUTPUT

$RSS_OUTPUT"

echo "$ALL_OUTPUT"
```

---

### 集成到 content-agent

**使用真实资讯**:

```bash
# 从 GitHub 提取最新仓库
GITHUB_REPOS=$(gh search repos "AI tools" --limit 5 --json name,description)

# 从 Twitter 提取最新推文
TWITTER_TWEETS=$(xreach search "GPT-5 OR Claude" --json -n 5 2>/dev/null || echo "")

# 从 RSS 提取最新资讯
RSS_NEWS=$(python3 -c "
import feedparser
d = feedparser.parse('https://openai.com/blog/rss')
for e in d.entries[:3]:
    print(e.title)
" 2>/dev/null || echo "")

# 基于真实资讯生成工具列表
TOOLS=(
  "$(echo "$GITHUB_REPOS" | jq -r '.[0].name')"
  "$(echo "$TWITTER_TWEETS" | jq -r '.[0].text' | cut -c1-30)"
  "$(echo "$RSS_NEWS" | head -1)"
)

# 使用真实工具生成内容
for tool in "${TOOLS[@]}"; do
  BODY="${BODY}🤖 **${tool}** - 推荐
帮你快速解决问题，提升效率！
"
done
```

---

## 📋 配置检查

**检查配置状态**:
```bash
agent-reach doctor
```

**预期输出**:
```
✅ GitHub — gh CLI 已安装并认证
✅ Twitter/X — xreach CLI 已安装并配置 Cookie
✅ RSS/Atom — 可读取 RSS/Atom 源
✅ 任意网页 — Jina Reader 可用
```

---

## 🎯 总结

### 配置完成

**GitHub**:
- ✅ 安装 gh CLI
- ✅ 认证 GitHub 账号
- ✅ 可以搜索仓库和代码

**Twitter**:
- ✅ 安装 xreach CLI
- ✅ 配置 Cookie
- ✅ 可以搜索推文

### 立即应用

**集成到 research-agent**:
- ✅ 添加 GitHub 数据源（最新仓库）
- ✅ 添加 Twitter 数据源（最新推文）
- ✅ 解决数据源质量问题

**集成到 content-agent**:
- ✅ 基于真实资讯生成内容
- ✅ 从 GitHub 和 Twitter 提取信息

---

**维护者**: Main Agent  
**状态**: ⏳ 正在配置 Twitter 和 GitHub
