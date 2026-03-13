# xskill.ai MCP 集成调试笔记

**调试时间**: 2026-03-10 12:00
**目标**: 解决 MCP HTTP 调用的 JSON 解析错误

---

## 🔍 问题分析

### 错误信息

**错误**: "缺少 Mcp-Session-Id 头，请先发送初始化请求"

**含义**: xskill.ai MCP Server 要求先建立 Session

---

## 📋 尝试的方案

### 方案 1: 初始化 Session

**请求**:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {},
    "clientInfo": {
      "name": "openclaw-main-agent",
      "version": "1.0.0"
    }
  }
}
```

**响应**:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "protocolVersion": "2025-03-26",
    "serverInfo": {
      "name": "速推AI",
      "version": "1.0.0"
    },
    "capabilities": {
      "tools": {}
    }
  }
}
```

**问题**: 响应中没有 `sessionId`

---

## 🤔 可能的原因

### 原因 1: MCP 协议版本不匹配

**我的假设**: 使用协议版本 2024-11-05
**实际**: xskill.ai 可能使用不同版本

---

### 原因 2: 初始化参数不正确

**我的假设**: params 中只需要协议版本和客户端信息
**实际**: 可能需要其他参数

---

### 原因 3: Session ID 在响应的不同位置

**我的假设**: sessionId 在 result.root.sessionId
**实际**: 可能在其他位置

---

## 🎯 下一步调试

### 方案 1: 检查完整响应

**检查**:
```bash
curl -s "${MCP_ENDPOINT}?api_key=${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{...}}' | jq '.'
```

---

### 方案 2: 查看文档

**检查**: xskill.ai 是否有 MCP 文档

---

### 方案 3: 联系支持

**检查**: 是否有技术支持可以咨询

---

## 📊 当前状态

**问题**: MCP HTTP 调用需要 Session ID
**限制**: 初始化响应中没有返回 Session ID
**影响**: 无法完成 MCP 调用

---

## 🎯 临时方案

**继续使用 API 方式**:
- ✅ 已验证可用
- ✅ 稳定可靠
- ⏸️ MCP 方式需要进一步调试

---

**状态**: ⏸️ MCP 集成暂停，等待进一步调试或文档
