# xskill.ai MCP 方式集成方案

**目标**: 使用 MCP 方式调用 Seedream 5.0

---

## 🎯 两种方式对比

### 方式 1: MCP Server（推荐）⭐⭐⭐⭐⭐

**调用**:
```python
mcp call xskill.seedream-5.0 "生成一张科技感的图片"
```

**优势**:
- ✅ AI Agent 自主调用
- ✅ 专家级提示词
- ✅ 跨平台兼容
- ✅ 一键安装

**要求**:
- ⚠️ 需要安装 MCP Server
- ⚠️ 需要登录 xskill.ai 获取部署命令

---

### 方式 2: 直接 API（当前使用）⭐⭐⭐

**调用**:
```bash
curl -X POST "https://api.xskill.ai/v1/images/generations" \
  -H "Authorization: Bearer $XSKILL_API_KEY" \
  -d '{"model": "jimeng-5.0", "prompt": "..."}'
```

**优势**:
- ✅ 无需安装
- ✅ 立即可用
- ✅ 完全控制参数

**劣势**:
- ❌ 需要手动编写提示词
- ❌ 需要编程

---

## 🎯 集成策略

### 短期方案（立即）

**保留直接 API 调用**:
- ✅ visual-agent 继续使用 Seedance API
- ✅ video-agent 继续使用 Seedance API
- ✅ 优化提示词模板

**优化提示词**:
```python
# 优化后的提示词模板
PROMPT_TEMPLATE = """
{subject}, {style}
High quality, 4k, professional
{additional_params}
"""
```

---

### 长期方案（部署命令获取后）

**安装 MCP Server**:
```bash
# 从 xskill.ai 获取部署命令
# 例如: npx -y @xskill/mcp-server install
```

**配置 MCP Server**:
```json
{
  "mcpServers": {
    "xskill": {
      "command": "npx",
      "args": ["-y", "@xskill/mcp-server"],
      "env": {
        "XSKILL_API_KEY": "sk-dadcbb09f73d9cfecfad43a406f81394859ae8be06cf802d"
      }
    }
  }
}
```

**更新 Agents**:
- ✅ visual-agent 添加 MCP 调用方式
- ✅ video-agent 添加 MCP 调用方式
- ✅ 双模式支持（MCP + API）

---

## 📋 需要用户提供

### 部署命令

**操作**:
1. 访问: https://www.xskill.ai/
2. 登录账号
3. 找到 "One-Click Deploy" 或 "Install MCP Server"
4. 复制部署命令

**预期格式**:
```bash
npx -y @xskill/mcp-server install
# 或
curl -sSL https://install.xskill.ai/mcp | sh
```

---

## 🎯 立即可做的

### 1. 优化当前提示词

**visual-agent 提示词优化**:
```python
# 当前
prompt = "科技感图片"

# 优化后
prompt = "Futuristic tech image with neon lights, cyberpunk style, high quality, 4k, professional photography"
```

### 2. 创建 MCP wrapper（临时方案）

**脚本**: `xskill-mcp-wrapper.sh`

```bash
#!/bin/bash
# 临时 MCP wrapper（模拟 MCP 调用）

prompt="$1"

# 调用 xskill.ai API
curl -X POST "https://api.xskill.ai/v1/images/generations" \
  -H "Authorization: Bearer $XSKILL_API_KEY" \
  -d "{
    \"model\": \"jimeng-5.0\",
    \"prompt\": \"$prompt\",
    \"quality\": \"high\"
  }"
```

### 3. 准备 MCP 集成文档

**记录**: 集成步骤、配置方法、测试用例

---

## 📊 时间线

### 今天（短期）

- ✅ 优化当前提示词
- ✅ 创建 MCP wrapper
- ✅ 准备集成文档

### 获取部署命令后（长期）

- ⏸️ 安装 MCP Server
- ⏸️ 配置 MCP Server
- ⏸️ 测试 MCP 调用
- ⏸️ 更新 visual-agent
- ⏸️ 更新 video-agent

---

## 🎯 下一步

**等待用户提供**:
1. xskill.ai 部署命令
2. 确认是否安装 MCP Server

**同时进行**:
1. 优化当前提示词
2. 创建临时 MCP wrapper
3. 准备集成文档

---

**状态**: 准备中，等待部署命令
**优先级**: ⭐⭐⭐⭐⭐（高）
**预计时间**: 获取命令后 30 分钟
