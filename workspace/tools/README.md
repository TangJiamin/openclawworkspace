# 🌐 Internet Tools - 可用能力清单

**位置**: `/home/node/.openclaw/workspace/tools/`
**状态**: ✅ 已就绪

---

## ✅ 已实现的能力

### 1. 网页阅读 (Web Reader)

**工具**: `net-tools.sh web read <URL>`

**能力**:
- 读取任意网页内容
- 自动提取正文（去除 HTML 标签）
- 支持 Markdown 格式输出

**使用示例**:
```bash
./net-tools.sh web read "https://github.com/Panniantong/Agent-Reach"
```

**返回**:
```
Title: GitHub - Panniantong/Agent-Reach...
Markdown Content:
[网页正文内容...]
```

---

### 2. GitHub 仓库信息

**工具**: `net-tools.sh github info <owner/repo>`

**能力**:
- 获取仓库基本信息（名称、描述、Stars、语言等）
- 无需认证（公开仓库）

**使用示例**:
```bash
./net-tools.sh github info "openclaw/openclaw"
```

**返回**:
```
📦 GitHub 仓库: openclaw/openclaw
---
名称: openclaw
描述: Your own personal AI assistant...
Stars: 1234
URL: https://github.com/openclaw/openclaw
语言: TypeScript
```

---

### 3. GitHub 搜索

**工具**: `net-tools.sh github search <query>`

**能力**:
- 搜索 GitHub 仓库
- 显示前 5 个结果

**使用示例**:
```bash
./net-tools.sh github search "AI agent"
```

**返回**:
```
🔍 搜索 GitHub: AI agent
---
⭐ 5000 - owner/repo1
   Description...
⭐ 3000 - owner/repo2
   Description...
```

---

### 4. YouTube 视频信息

**工具**: `net-tools.sh youtube info <URL>`

**能力**:
- 获取视频元数据（标题、时长、观看数等）
- 提取字幕（需要时）

**使用示例**:
```bash
./net-tools.sh youtube info "https://youtube.com/watch?v=xxx"
```

**返回**:
```
📺 YouTube 视频: https://youtube.com/watch?v=xxx
---
标题: Video Title
时长: 600 秒
观看: 10000
上传: 20260303
频道: Channel Name
```

---

### 5. YouTube 搜索

**工具**: `net-tools.sh youtube search <query>`

**能力**:
- 搜索 YouTube 视频
- 显示前 5 个结果

**使用示例**:
```bash
./net-tools.sh youtube search "AI tutorial"
```

---

## 🔧 工具列表

| 工具 | 功能 | 依赖 |
|------|------|------|
| `net-tools.sh` | 统一接口 | curl, python3, yt-dlp |
| `web-reader.sh` | 网页阅读 | curl |
| `youtube-tool.sh` | YouTube 工具 | yt-dlp |
| `github-tool.sh` | GitHub 工具 | curl, python3 |

---

## 📊 依赖状态

| 依赖 | 版本 | 状态 |
|------|------|------|
| curl | ✅ | 已安装 |
| python3 | 3.11.2 | ✅ 已安装 |
| yt-dlp | 2026.02.21 | ✅ 已安装 |

---

## 🚀 快速开始

### 读取网页
```bash
cd /home/node/.openclaw/workspace/tools
./net-tools.sh web read "https://example.com/article"
```

### 查看仓库信息
```bash
./net-tools.sh github info "openclaw/openclaw"
```

### 搜索 GitHub
```bash
./net-tools.sh github search "LLM framework"
```

### 获取 YouTube 信息
```bash
./net-tools.sh youtube info "https://youtube.com/watch?v=xxx"
```

---

## ⚠️ 限制

1. **GitHub API** - 无认证时每小时 60 次请求限制
2. **YouTube** - 某些视频可能有地区限制
3. **网页阅读** - 依赖 Jina Reader API

---

## 🎯 与 Research Agent 集成

Research Agent 可以使用这些工具增强搜索能力：

```bash
# 在 Research Agent 脚本中
source /home/node/.openclaw/workspace/tools/net-tools.sh

# 搜索 GitHub 上的 AI 工具
./net-tools.sh github search "AI agent tools"

# 读取相关网页内容
./net-tools.sh web read "https://example.com/ai-tools"
```

---

**当前能力**: 5 个平台（Web、GitHub、YouTube）
**下一步**: Twitter、Reddit（需要额外配置）
