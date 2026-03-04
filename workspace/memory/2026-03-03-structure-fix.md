# 2026-03-03 目录结构标准化

## ✅ 完成的工作

### 问题发现

根据 OpenClaw 官方文档（https://docs.openclaw.ai/concepts/multi-agent），发现 Agent 目录结构不符合规范。

### 官方标准

**Agent 有两个关键目录**:

1. **agentDir** (`~/.openclaw/agents/<agentId>/agent`):
   - 存放配置文件
   - `models.json` - 模型配置
   - `auth-profiles.json` - 认证配置
   - 不应该有 AGENTS.md 或 SOUL.md

2. **workspace** (每个 Agent 独立):
   - Main Agent: `~/.openclaw/workspace/`
   - 其他 Agents: `~/.openclaw/workspace/agents/<agentId>/`
   - 存放 AGENTS.md、SOUL.md 等角色定义文件

### 执行的清理

**删除了 agentDir 中的重复文件**:
- ✅ research-agent/agent/AGENTS.md
- ✅ content-agent/agent/AGENTS.md
- ✅ visual-agent/agent/AGENTS.md
- ✅ video-agent/agent/AGENTS.md
- ✅ quality-agent/agent/AGENTS.md

**创建了 quality-agent 的 AGENTS.md**:
- ✅ 在 workspace 中创建（位置正确）

### 验证结果

所有 6 个 Agents 现在都符合官方标准：

| Agent | agentDir (配置) | workspace (角色定义) | 状态 |
|-------|----------------|---------------------|------|
| requirement-agent | models.json | AGENTS.md + SOUL.md | ✅ |
| research-agent | models.json | AGENTS.md + SOUL.md | ✅ |
| content-agent | models.json | AGENTS.md + SOUL.md | ✅ |
| visual-agent | models.json | AGENTS.md + SOUL.md | ✅ |
| video-agent | models.json | AGENTS.md + SOUL.md | ✅ |
| quality-agent | models.json | AGENTS.md | ✅ |

### 标准目录结构

**Main Agent**:
```
~/.openclaw/
├── workspace/                    ← Main Agent 的 workspace
│   ├── AGENTS.md
│   ├── SOUL.md
│   └── ...
├── agents/
│   └── main/
│       ├── agent/                 ← agentDir
│       │   ├── models.json
│       │   └── auth-profiles.json
│       └── sessions/
```

**其他 Agents**:
```
~/.openclaw/
├── workspace/
│   └── agents/
│       ├── requirement-agent/
│       │   ├── AGENTS.md          ← 在这里！
│       │   └── SOUL.md
│       ├── research-agent/
│       │   ├── AGENTS.md
│       │   └── SOUL.md
│       └── ...
├── agents/
│   ├── requirement-agent/
│   │   ├── agent/                 ← agentDir
│   │   │   ├── models.json
│   │   │   └── auth-profiles.json
│   │   └── sessions/
│   └── ...
```

---

**完成时间**: 2026-03-03 01:40 UTC
**参考**: OpenClaw 官方文档 - Multi-Agent Routing
