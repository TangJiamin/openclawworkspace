# Agent-Reach 安装和使用指南

**安装时间**: 2026-03-04 02:34 UTC

---

## ✅ 可以直接安装使用

### 是的！完全兼容

**Agent-Reach 是为 AI Agent 设计的工具**，完全兼容：
- ✅ OpenClaw（我们当前使用的）
- ✅ Claude Code
- ✅ Cursor
- ✅ Windsurf
- ✅ 任何能运行命令行的 Agent

---

## 🚀 快速安装

### 方式1: 一键安装（推荐）

**告诉 Agent**:
```
帮我安装 Agent Reach：https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

**Agent 会自动**:
1. 安装 CLI 工具
2. 安装系统依赖
3. 配置搜索引擎
4. 检测环境
5. 注册 SKILL.md

---

### 方式2: 手动安装

**步骤1**: 安装 Python 包
```bash
pip install https://github.com/Panniantong/agent-reach/archive/main.zip
```

**步骤2**: 安装系统依赖
```bash
agent-reach install --env=auto
```

**步骤3**: 检查状态
```bash
agent-reach doctor
```

---

## 🎯 安装后的能力

### 立即可用的功能（无需配置）

#### 1. 网页阅读

**使用**:
```bash
curl -s "https://r.jina.ai/URL" -H "Accept: text/markdown"
```

**示例**:
```bash
# 读任意网页
curl -s "https://r.jina.ai/https://www.example.com" -H "Accept: text/markdown"
```

---

#### 2. YouTube 字幕提取

**使用**:
```bash
yt-dlp --dump-json "URL"
```

**示例**:
```bash
# 提取视频元数据
yt-dlp --dump-json "https://www.youtube.com/watch?v=xxx"

# 下载字幕
yt-dlp --write-sub --skip-download "URL"
```

---

#### 3. GitHub 访问

**使用**:
```bash
gh search repos "query"
gh repo view owner/repo
```

**示例**:
```bash
# 搜索仓库
gh search repos "LLM framework" --limit 10

# 查看仓库
gh repo view openai/openai-python
```

---

#### 4. RSS 订阅

**使用**:
```python
python3 -c "
import feedparser
d = feedparser.parse('https://example.com/feed')
for e in d.entries[:5]:
    print(f'{e.title} — {e.link}')
"
```

---

### 配置后解锁的功能

#### 5. Twitter/X 搜索

**配置**:
```bash
# 导入 Cookie（使用 Cookie-Editor 插件）
agent-reach configure twitter-cookies "auth_token=xxx; ct0=yyy"
```

**使用**:
```bash
# 搜索推文
xreach search "AI工具" --json -n 10

# 读单条推文
xreach tweet https://x.com/user/status/123 --json
```

---

#### 6. 小红书

**配置**:
```bash
# 需要 Docker
agent-reach configure xiaohongshu
```

**使用**:
```bash
# 搜索笔记
mcporter call 'xiaohongshu.search_feeds(keyword: "AI工具")'

# 读笔记详情
mcporter call 'xiaohongshu.get_feed_detail(feed_id: "xxx")'
```

---

#### 7. 抖音

**配置**:
```bash
# 需要 Docker
agent-reach configure douyin
```

**使用**:
```bash
# 解析视频
mcporter call 'douyin.parse_douyin_video_info(share_link: "https://v.douyin.com/xxx/")'

# 获取无水印下载链接
mcporter call 'douyin.get_douyin_download_link(share_link: "https://v.douyin.com/xxx/")'
```

---

## 🔧 对我们系统的价值

### 1. 解决数据源问题

**之前的问题**:
- ❌ research-agent 搜索 "AI" 返回通用新闻
- ❌ 无法获取最新的 AI 产品发布信息

**安装 Agent-Reach 后**:
- ✅ 可以搜索 Twitter（xreach search "GPT-5"）
- ✅ 可以订阅 RSS（OpenAI 官方博客）
- ✅ 可以抓取网页（Jina Reader）

---

### 2. 集成到 research-agent

**修改 research-agent**:

```bash
# 之前：只能用 Metaso 搜索
METASO_RESULTS=$(metaso_search "AI资讯")

# 现在：可以使用多个数据源
TWITTER_RESULTS=$(xreach search "GPT-5" --json -n 10)
RSS_RESULTS=$(feedparser.parse "https://openai.com/blog/rss")
WEB_RESULTS=$(curl -s "https://r.jina.ai/https://openai.com/blog" -H "Accept: text/markdown")
```

---

### 3. 集成到 content-agent

**修改 content-agent**:

```bash
# 之前：使用硬编码的示例内容
TOOLS=("GPT-5发布" "Claude 3.5升级")

# 现在：可以从 Twitter 获取真实资讯
LATEST_NEWS=$(xreach search "GPT-5 OR Claude OR Gemini" --json -n 5)
# 从 LATEST_NEWS 中提取最新的产品发布信息
```

---

## 📋 安装步骤

### 立即安装

**告诉 Agent**:
```
帮我安装 Agent Reach：https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

**或者手动执行**:
```bash
# 1. 安装
pip install https://github.com/Panniantong/agent-reach/archive/main.zip

# 2. 安装依赖
agent-reach install --env=auto

# 3. 检查状态
agent-reach doctor
```

---

## 🎯 总结

### ✅ 可以直接安装

**是的！完全可以！**
- ✅ 完全兼容 OpenClaw
- ✅ 一键安装，自动配置
- ✅ 立即可用多个数据源

### 🔧 解决我们的问题

**数据源问题**:
- ✅ Twitter 搜索（AI 公司官方账号）
- ✅ RSS 订阅（官方博客）
- ✅ 网页抓取（产品发布页面）

**集成方式**:
- ✅ research-agent 可以使用多个数据源
- ✅ content-agent 可以基于真实资讯生成内容

---

**建议**: 立即安装 Agent-Reach，解决我们的数据源问题！

---

**维护者**: Main Agent  
**状态**: ✅ 可以直接安装使用
