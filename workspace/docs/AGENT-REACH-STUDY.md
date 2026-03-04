# Agent Reach 能力学习笔记

**学习时间**: 2026-03-03
**来源**: https://github.com/Panniantong/Agent-Reach

---

## 📋 核心概念

### 什么是 Agent Reach？

Agent Reach 是一个**脚手架工具**，为 AI Agent 提供互联网能力。

**关键特点**：
- ✅ 一键安装配置
- ✅ 完全免费（所有工具开源）
- ✅ 支持多平台（Twitter、YouTube、Reddit、小红书等）
- ✅ 可插拔架构（每个渠道独立）
- ✅ 兼容所有 Agent（Claude Code、OpenClaw、Cursor...）

---

## 🎯 解决的问题

### 传统方式的痛点

AI Agent 需要访问互联网时，会遇到：
- 📺 "看看 YouTube 视频" → 看不了，拿不到字幕
- 🐦 "搜一下推特评价" → 搜不了，API 要付费
- 📖 "去 Reddit 看 bug" → 403 被封
- 📕 "看看小红书口碑" → 打不开，必须登录
- 🌐 "看看网页内容" → 一堆 HTML 标签

**每个平台都要自己折腾配置**，费时费力。

### Agent Reach 的解决方案

```
复制给 Agent 一句话：
"帮我安装 Agent Reach：https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md"
```

几分钟后，Agent 就能：
- ✅ 读推特、搜 Reddit、看 YouTube
- ✅ 刷小红书、解析抖音视频
- ✅ 读任意网页、搜全网

---

## 🌐 支持的平台

### 无需配置（装好即用）

| 平台 | 能力 | 上游工具 |
|------|------|---------|
| 🌐 网页 | 阅读任意网页 | Jina Reader |
| 📺 YouTube | 字幕提取 + 视频搜索 | yt-dlp |
| 📡 RSS | 阅读任意 RSS/Atom 源 | feedparser |
| 🔍 全网搜索 | 语义搜索 | Exa (via MCP) |
| 📦 GitHub | 读公开仓库 + 搜索 | gh CLI |

### 需要配置（解锁全部功能）

| 平台 | 能力 | 配置方式 |
|------|------|---------|
| 🐦 Twitter/X | 搜索、浏览、发推 | Cookie 登录 |
| 📺 B站 | 服务器支持 | 配置代理 |
| 📖 Reddit | 读帖子和评论 | 配置代理 |
| 📕 小红书 | 阅读、搜索、发帖 | MCP 服务 + Cookie |
| 🎵 抖音 | 视频解析、下载 | MCP 服务 |
| 💼 LinkedIn | Profile、职位搜索 | MCP 服务 |
| 🏢 Boss直聘 | 搜索职位、打招呼 | MCP 服务 |

---

## 🔧 核心命令

### 安装

```bash
# 一键全自动（推荐）
pip install agent-reach
agent-reach install --env=auto

# 安全模式（不自动安装系统包）
agent-reach install --env=auto --safe

# 仅预览
agent-reach install --env=auto --dry-run
```

### 诊断

```bash
# 检查所有渠道状态
agent-reach doctor

# 快速检查 + 更新检测
agent-reach watch

# 检查更新
agent-reach check-update
```

### 配置

```bash
# Twitter Cookie
agent-reach configure twitter-cookies "PASTED_STRING"

# 代理（服务器环境）
agent-reach configure proxy http://user:pass@ip:port

# GitHub 登录
agent-reach configure github-login
```

### 卸载

```bash
# 完全卸载
agent-reach uninstall

# 保留配置
agent-reach uninstall --keep-config

# 仅预览
agent-reach uninstall --dry-run
```

---

## 💡 使用示例

### 网页阅读

```bash
# 读取任意网页（提取纯文本）
curl https://r.jina.ai/https://example.com/article

# Agent 会自动调用
"帮我看看这个链接讲了什么"
```

### Twitter/X

```bash
# 读单条推文
xreach tweet https://x.com/user/status/123456 --json

# 搜索推文
xreach search "AI 工具" --json --count 10

# 浏览时间线
xreach timeline --json
```

### YouTube

```bash
# 提取字幕（JSON 格式）
yt-dlp --dump-json "https://youtube.com/watch?v=xxx"

# 提取字幕（SRT 格式）
yt-dlp --write-subs --skip-download "URL"

# 搜索视频
yt-dlp "ytsearch10:AI 视频生成教程"
```

### GitHub

```bash
# 查看仓库
gh repo view openclaw/openclaw

# 搜索仓库
gh search repos "LLM framework" --limit 10

# 查看 Issue
gh issue view 123 --repo owner/repo
```

### Reddit

```bash
# 读取帖子（JSON API）
curl -s "https://www.reddit.com/r/Python.json"

# 通过 Exa 搜索（免费）
# (配置在 mcporter 中)
```

### 小红书

```bash
# 搜索笔记
mcporter call 'xiaohongshu.search_feeds(keyword: "AI 工具")'

# 读取笔记详情
mcporter call 'xiaohongshu.get_feed_detail(note_id: "123")'
```

### 抖音

```bash
# 解析视频信息
mcporter call 'douyin.parse_douyin_video_info(share_link: "分享链接")'

# 获取无水印下载链接
# (返回结果中包含)
```

---

## 🏗️ 架构设计

### 脚手架理念

**Agent Reach 不是框架，是脚手架**：

- 帮你完成选型和配置
- Agent 直接调用上游工具
- 每个渠道可独立替换

### 目录结构

```
channels/
├── web.py          → Jina Reader     ← 可换成 Firecrawl
├── twitter.py      → xreach            ← 可换成 Nitter
├── youtube.py      → yt-dlp          ← 可换成 YouTube API
├── github.py       → gh CLI          ← 可换成 PyGithub
├── bilibili.py     → yt-dlp          ← 可换成 bilibili-api
├── reddit.py       → JSON API + Exa  ← 可换成 PRAW
├── xiaohongshu.py  → mcporter MCP    ← 可换成其他工具
├── douyin.py       → mcporter MCP    ← 可换成其他工具
├── linkedin.py     → linkedin-mcp    ← 可换成 LinkedIn API
├── bosszhipin.py   → mcp-bosszp      ← 可换成其他招聘工具
├── rss.py          → feedparser      ← 可换成 atoma
├── exa_search.py   → mcporter MCP    ← 可换成 Tavily
└── __init__.py     → 渠道注册（doctor 检测用）
```

### 每个渠道的工作方式

```python
class TwitterChannel(BaseChannel):
    """Twitter 渠道示例"""

    def check(self) -> ChannelStatus:
        """检测上游工具是否可用"""
        # 检查 xreach 是否安装
        # 检查 Cookie 是否配置
        pass

# Agent 直接调用上游工具
# xreach search "关键词" --json
```

---

## 🔒 安全性

### 措施

| 措施 | 说明 |
|------|------|
| 🔒 本地存储 | Cookie/Token 存在 `~/.agent-reach/config.yaml`，权限 600 |
| 🛡️ 安全模式 | `--safe` 不会自动修改系统 |
| 👀 完全开源 | 代码透明，随时可审查 |
| 🔍 Dry Run | `--dry-run` 预览操作 |
| 🧩 可插拔 | 不信任某个组件？换掉即可 |

### Cookie 安全建议

⚠️ **使用专用小号，不要用主账号**

**原因**：
1. **封号风险** - 平台可能检测到非浏览器 API 调用
2. **安全风险** - Cookie 等同于完整登录权限

**推荐流程**：
1. 浏览器登录对应平台
2. 安装 Cookie-Editor 插件
3. 导出 Cookie（Header String 格式）
4. 发给 Agent 配置

---

## 📊 当前选型

| 场景 | 工具 | 选择理由 |
|------|------|---------|
| 读网页 | Jina Reader | 9.8K Star，免费，无需 API Key |
| 读推特 | xreach | Cookie 登录，免费。官方 API $0.005/条 |
| 视频字幕 | yt-dlp | 148K Star，支持 1800+ 站点 |
| 搜全网 | Exa | AI 语义搜索，MCP 接入免 Key |
| GitHub | gh CLI | 官方工具，完整 API 能力 |
| 读 RSS | feedparser | Python 生态标准，2.3K Star |
| 小红书 | xiaohongshu-mcp | 9K+ Star，Docker 一键部署 |
| 抖音 | douyin-mcp-server | MCP 服务，无需登录 |
| LinkedIn | linkedin-scraper-mcp | 900+ Star，浏览器自动化 |
| Boss直聘 | mcp-bosszp | MCP 服务，支持搜索和打招呼 |

---

## 🚀 与 OpenClaw 集成

### 现状

由于网络限制，当前环境无法直接安装 Agent Reach：
- GitHub 连接超时
- 无法下载 Python 包

### 可行的方案

#### 方案 1: 宿主机安装后挂载

```bash
# 在宿主机安装
pip install agent-reach
agent-reach install --env=auto

# 通过 volume 挂载到容器
docker run -v ~/.agent-reach:/root/.agent-reach ...
```

#### 方案 2: 手动安装依赖

根据 Agent Reach 的依赖列表，手动安装：
- yt-dlp (视频)
- gh CLI (GitHub)
- Node.js + npm (xreach)
- mcporter (MCP 工具)

#### 方案 3: 等待网络改善

配置代理后重试安装。

---

## 📚 学习收获

### 核心思想

1. **脚手架优于框架**
   - 帮你完成选型配置
   - 不绑定你的架构
   - 可插拔、可替换

2. **上游工具优先**
   - Agent 直接调用成熟工具
   - 不重复造轮子
   - 持续追踪更新

3. **自动化配置**
   - 一键安装
   - 自动检测环境
   - 自适应配置

### 可借鉴的设计

1. **渠道化架构**
   - 每个平台一个文件
   - 独立的 check() 方法
   - 统一的 doctor 检测

2. **多模式安装**
   - 全自动模式（开发环境）
   - 安全模式（生产环境）
   - Dry run（预览）

3. **配置管理**
   - 集中配置（config.yaml）
   - 命令行配置工具
   - 安全存储（权限 600）

---

## 🎯 下一步行动

### 短期

- [ ] 解决网络问题，安装 Agent Reach
- [ ] 测试基本功能（网页、YouTube、GitHub）
- [ ] 配置 Twitter Cookie（测试社交媒体）

### 中期

- [ ] 集成到 Research Agent（增强搜索能力）
- [ ] 添加 YouTube 视频分析能力
- [ ] 实现多源信息聚合

### 长期

- [ ] 探索其他渠道（LinkedIn、小红书）
- [ ] 根据需求替换上游工具
- [ ] 贡献新渠道（如果需要）

---

_学习时间: 2026-03-03_
_文档版本: 1.0_
