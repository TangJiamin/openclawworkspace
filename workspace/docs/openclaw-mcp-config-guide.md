# OpenClaw MCP 配置指南

**目标**: 配置 OpenClaw 连接到 xskill.ai MCP Server

---

## 🎯 已知信息

### 1. MCP Server 已安装

**位置**: `~/.cursor/mcp.json`

**配置**:
```json
{
  "mcpServers": {
    "速推AI": {
      "url": "https://ts-api.fyshark.com/api/v3/mcp-http?api_key=sk-dadcbb09f73d9cfecfad43a406f81394859ae8be06cf802d"
    }
  }
}
```

### 2. OpenClaw 支持 MCP

**证据**: Agent Client Protocol (ACP) 支持 MCP

**工具**: mcporter skill

---

## 🔧 配置步骤

### Step 1: 安装 mcporter

```bash
npx -y @modelcontextprotocol/inspector
```

---

### Step 2: 创建 MCP 配置文件

**位置**: `~/.openclaw/config/mcp.json`

```json
{
  "mcpServers": {
    "xskill": {
      "url": "https://ts-api.fyshark.com/api/v3/mcp-http?api_key=sk-dadcbb09f73d9cfecfad43a406f81394859ae8be06cf802d"
    }
  }
}
```

---

### Step 3: 测试 MCP 连接

```bash
# 列出可用的 tools
mcporter list xskill

# 调用 seedance-video
mcporter call xskill.seedance-video prompt="生成测试视频" duration="5"
```

---

### Step 4: 集成到 video-agent

**更新**: `video-agent/TOOLS.md`

**添加**: MCP 调用方式

---

## 📊 MCP vs API 对比

### API 方式（当前）

```bash
curl -X POST "https://api.xskill.ai/..." \
  -H "Authorization: Bearer $XSKILL_API_KEY" \
  -d '{...}'
```

**问题**:
- ❌ 手动编写提示词
- ❌ 需要编程
- ❌ 不够自主

---

### MCP 方式（目标）

```json
{
  "model_id": "fal-ai/bytedance/seedance/v1.5/pro/text-to-video",
  "parameters": {
    "prompt": "{{用户提示词}}",
    "resolution": "720p",
    "duration": "5"
  }
}
```

**优势**:
- ✅ AI Agent 自主调用
- ✅ 专家级提示词
- ✅ 跨平台兼容

---

## 🎯 集成方案

### 方案 1: mcporter skill ⭐⭐⭐⭐⭐

**步骤**:
1. 安装 mcporter
2. 配置 MCP Server
3. 在 video-agent 中使用 mcporter call

**优势**:
- ✅ OpenClaw 原生支持
- ✅ 无需额外配置

---

### 方案 2: 直接 HTTP 调用 ⭐⭐⭐⭐

**步骤**:
1. 使用 curl 调用 MCP HTTP endpoint
2. 传递 API Key

**优势**:
- ✅ 简单直接
- ✅ 无需额外工具

---

## 📊 推荐方案

**推荐**: 方案 2（直接 HTTP 调用）

**原因**:
- ✅ 不需要安装额外工具
- ✅ 简单直接
- ✅ 可以立即使用

**实现**:
```bash
# 调用 xskill.ai MCP HTTP endpoint
curl -X POST "https://ts-api.fyshark.com/api/v3/mcp-http?api_key=$XSKILL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "method": "tools/call",
    "params": {
      "name": "submit_task",
      "arguments": {
        "model_id": "fal-ai/bytedance/seedance/v1.5/pro/text-to-video",
        "parameters": {
          "prompt": "生成测试视频",
          "resolution": "720p",
          "duration": "5"
        }
      }
    }
  }'
```

---

## ✅ 下一步

1. ✅ 创建 MCP HTTP 调用脚本
2. ✅ 测试 seedance-video MCP 调用
3. ✅ 集成到 video-agent

---

**OpenClaw MCP 配置指南完成！准备实施！** ✅
