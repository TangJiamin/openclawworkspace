# OpenClaw 子 Agent 工具配置指南

**更新时间**: 2026-03-12 15:40

---

## 🔧 关键发现

**子 Agent 无法调用工具** → **需要配置 `tools.subagents.tools`**

---

## ⚙️ 配置方法

### 默认行为

**默认配置**（如果未配置 `tools.subagents`）：
- ❌ 子 Agent 只有部分工具
- ❌ **不包括 exec 工具**
- ❌ 不包括 session 工具

### 显式配置

**文件**: `/home/node/.openclaw/openclaw/openclaw.json`

**配置示例 1**: 允许所有工具
```json
{
  "tools": {
    "subagents": {
      "tools": {
        "allow": ["*"],
        "exec": {
          "host": "gateway",
          "security": "full",
          " "ask": "off"
        }
      }
    }
  }
}
```

**配置示例 2**: 仅允许特定工具
```json
{
  "tools": {
    "subagents": {
      "tools": {
        "allow": ["read", "exec", "process"],
        "exec": {
          "host": "gateway",
          "security": "full"
        }
      }
    }
  }
}
```

**配置示例 3**: 禁止特定工具
```json
{
  "tools": {
    "subagents": {
      "tools": {
        "deny": ["gateway", "cron"],
        "allow": ["*"]
      }
    }
  }
}
```

---

## 🎯 执行流程

### 1. 配置

添加配置到 `/home/node/.openclaw/openclaw.json`：

```bash
cat /home/node/.openclaw/openclaw/openclaw.json | jq '.tools.subagents = {
  tools: {
    allow: ["*"],
    exec: {
      host: "gateway",
      security: "full",
      "ask": "off"
    }
  }
}' | jq '.' > /tmp/openclaw-updated.json && \
mv /tmp/openclaw-updated.json /home/node/.openclaw/openclaw/openclaw.json && \
echo "✅ 配置已更新"
```

### 2. 验证

```bash
# 检查配置
cat /home/node/.openclaw/openclaw.json | jq '.tools.subagents'

# 重启 Gateway（如果需要）
openclaw gateway restart
```

### 3. 测试

```python
sessions_spawn(
    agent_id="visual-agent",
    task="测试 exec 工具：echo 'Hello'",
    timeoutSeconds=60
)
```

---

## 📊 验证结果

**测试时间**: 2026-03-12 15:39
**结果**: ✅ 成功
**输出**: `Hello from visual-agent`
**Token 消耗**: 35.7k
**执行时间**: 26 秒

---

## 🔍 常见问题

### Q1: 配置后仍然无法调用工具？

**解决**：
1. 检查配置：`cat /home/node/.openclaw/openclaw.json | jq '.tools.subagents'`
2. 重启 Gateway：`openclaw gateway restart`
3. 检查 Agent 配置：是否有工具限制

### Q2: 如何限制子 Agent 的工具权限？

**方法**：使用 `deny` 列表

```json
{
  "tools": {
    "subagents": {
      "tools": {
        "deny": ["gateway", "cron"],
        "allow": ["read", "exec"]
      }
    }
  }
}
```

**注意**：`deny` 优先级高于 `allow`

### Q3: 如何为不同的 Agent 配置不同的工具？

**方法**：在 `agents.list` 中为每个 Agent 配置

```json
{
  "agents": {
    "list": [
      {
        "id": "visual-agent",
        "tools": {
          "allow": ["exec", "read"]
        }
      },
      {
        "id": "research-agent",
        "tools": {
          "allow": ["web_search", "web_fetch"]
        }
      }
    ]
  }
}
```

---

## 🎯 最佳实践

### 1. 安全性

**开发环境**：
```json
{
  "tools": {
    "subagents": {
      "tools": {
        "allow": ["*"],
        "exec": {
          "host": "gateway",
          "security": "full",
          "ask": "off"
        }
      }
    }
  }
}
```

**生产环境**：
```json
{
  "tools": {
    "subagents": {
      "tools": {
        "deny": ["gateway", "cron"],
        "allow": ["read", "web_search", "web_fetch"]
      }
    }
  }
}
```

### 2. 工具分层

**Main Agent**：所有工具
**Orchestrator Agent**：sessions_spawn + subagents
**Worker Agent**：特定工具（exec, read, write）

### 3. 调试

**检查工具权限**：
```bash
# 在子 Agent 中执行
echo "可用工具：" && env | grep -i tool
```

---

## 📝 总结

1. **默认配置不包含 exec** - 必须显式配置
2. **配置位置** - `tools.subagents.tools`
3. **重启生效** - 配置后需要重启 Gateway
4. **分层配置** - 可以为不同 Agent 配置不同工具

---

**文档版本**: v1.0
**最后更新**: 2026-03-12 15:40
