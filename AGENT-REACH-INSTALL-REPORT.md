# Agent Reach 安装报告

**安装时间**: 2026-03-04
**环境**: Docker 容器 (Ubuntu/Debian)
**状态**: ✅ 基础安装完成

---

## 📦 安装结果

### ✅ 已安装组件

| 组件 | 版本 | 用途 |
|------|------|------|
| **agent-reach** | 1.2.0 | 核心框架 |
| **mcporter** | Latest | MCP 工具管理器 |
| **xreach-cli** | Latest | Twitter/X 访问 |
| **yt-dlp** | 2026.3.3 | YouTube/Bilibili 下载 |
| **feedparser** | 6.0.12 | RSS 订阅源 |
| **undici** | Latest | HTTP 代理支持 |

---

## 🎯 可用平台（6/12）

### ✅ 完全可用

1. **Twitter/X** - 搜索和读取推文
2. **YouTube** - 视频信息、字幕下载
3. **Bilibili** - 视频信息、字幕下载
4. **Exa 搜索** - 全网语义搜索（免费）
5. **任意网页** - Jina Reader 读取
6. **RSS 订阅源** - 读取任意 RSS/Atom

### ⚠️ 部分可用

7. **GitHub** - 可搜索公开仓库（需 gh CLI）
8. **Reddit** - 需要代理配置

### ⬜ 需要额外配置

9. **小红书** - 需要 Docker + xiaohongshu-mcp
10. **抖音** - 需要 douyin-mcp-server
11. **LinkedIn** - 需要 linkedin-scraper-mcp
12. **Boss直聘** - 需要 mcp-bosszp

---

## 🔧 环境配置

### 代理地址

```bash
HTTP_PROXY=http://192.168.65.1:7897
```

**注意**: 代理连接不稳定，建议检查 Clash Verge 配置。

### PATH 配置

```bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
```

---

## 📖 使用示例

### Twitter 搜索

```bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
xreach search "AI" --json -n 10
```

### YouTube 下载

```bash
yt-dlp --dump-json "https://www.youtube.com/watch?v=xxx"
```

### 网页读取

```bash
curl -s "https://r.jina.ai/https://example.com"
```

### Exa 搜索

```bash
mcporter call 'exa.web_search_exa(query: "AI tools", numResults: 5)'
```

---

## 🚀 下一步（可选）

### 安装 GitHub CLI

```bash
# 需要宿主机操作
# 参考：https://cli.github.com
```

### 配置 Reddit 代理

```bash
# 需要住宅代理
# 推荐：https://webshare.io ($1/月)
agent-reach configure proxy http://user:pass@ip:port
```

### 配置小红书（需要 Docker）

```bash
docker run -d --name xiaohongshu-mcp -p 18060:18060 xpzouying/xiaohongshu-mcp
mcporter config add xiaohongshu http://localhost:18060/mcp
```

---

## 📊 技术细节

### 已配置工具

- **uv**: 0.10.8 - Python 包管理器
- **bun**: 1.3.10 - JavaScript 运行时
- **npm**: 全局包安装到 `~/.npm-global/`

### 配置文件

- `~/.bashrc` - 环境变量和 PATH
- `~/.agent-reach/` - Agent Reach 配置
- `/home/node/.openclaw/workspace/config/mcporter.json` - MCP 配置

---

## ✅ 安装验证

```bash
# 运行健康检查
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
agent-reach doctor
```

---

**安装完成日期**: 2026-03-04
**维护者**: Main Agent
