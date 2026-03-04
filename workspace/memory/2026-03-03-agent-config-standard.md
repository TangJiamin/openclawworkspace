# OpenClaw Agent 配置规范（正确方式）

**更新时间**: 2026-03-03 08:55 UTC
**来源**: 官方指南 OPENCLAW_SUBAGENT_CONFIG_GUIDE.md

---

## 🎯 核心原则

### Agent ≠ Skill

**Agent（智能体）**:
- 有独立上下文和会话
- 通过 `sessions_spawn` 调用
- 位置: `/home/node/.openclaw/agents/<id>/`
- **不使用 SKILL.md** ⚠️

**Skill（工具）**:
- 可复用的功能模块
- 被 Agent 调用
- 位置: `/home/node/.openclaw/workspace/skills/<id>/`
- **使用 SKILL.md** ✅

---

## 📋 Agent 配置（正确方式）

### 1. 目录结构（官方规范）

```text
/home/node/.openclaw/agents/<agent-id>/
├── agent/              # agentDir（运行态）⭐
│   ├── auth-profiles.json
│   └── ...
├── workspace/          # workspace（业务文件）⭐
│   ├── AGENTS.md       # ✅ Agent 描述
│   ├── TOOLS.md        # ✅ 工具列表
│   └── scripts/        # ✅ 执行脚本
├── sessions/           # 会话记录
├── models.json         # 模型配置
└── README.md           # 说明文档
```

### 2. openclaw.json 配置

```json
{
  "agents": {
    "defaults": {
      "workspace": "/home/node/.openclaw/workspace"
    },
    "list": [
      {
        "id": "research-agent",
        "workspace": "/home/node/.openclaw/agents/research-agent/workspace",
        "agentDir": "/home/node/.openclaw/agents/research-agent/agent",
        "model": "default/glm-4.7",
        "subagents": {
          "allowAgents": ["main"]
        }
      }
    ]
  }
}
```

### 3. Agent 的文件

| 文件 | 用途 | 必需 |
|------|------|------|
| `agent/` | 运行态目录 | ✅ 是 |
| `workspace/` | 业务文件目录 | ✅ 是 |
| `workspace/AGENTS.md` | Agent 描述 | ✅ 是 |
| `workspace/TOOLS.md` | 工具列表 | ✅ 是 |
| `models.json` | 模型配置 | 可选 |
| `README.md` | 说明文档 | 可选 |
| `SKILL.md` | ❌ 不使用 | ❌ 禁止 |

---

## 📋 Skill 配置（正确方式）

### 1. 目录结构

```text
/home/node/.openclaw/workspace/skills/<skill-id>/
├── SKILL.md            # ✅ 规范定义
└── scripts/
    └── run.sh          # ✅ 执行脚本
```

### 2. Skill 的文件

| 文件 | 用途 | 必需 |
|------|------|------|
| `SKILL.md` | 规范定义 | ✅ 是 |
| `scripts/*.sh` | 执行脚本 | ✅ 是 |

---

## 🔑 核心区别

### 职责分离

- **`agentDir`**: 运行态（状态、认证、会话）
- **`workspace`**: 业务态（文档、脚本、产物）

### 文件命名

- ✅ `AGENTS.md`（复数）- 官方标准
- ❌ `AGENT.md`（单数）- 不标准
- ✅ `SKILL.md` - 仅用于 Skill

### 调用关系

```
Agent (调用者)
  ↓
Skill (工具)
  ↓
SKILL.md (规范)
```

---

## ⚠️ 常见错误

### 错误 1: Agent 使用 SKILL.md

❌ **错误**:
```
/agents/research-agent/SKILL.md
```

✅ **正确**:
```
/agents/research-agent/workspace/AGENTS.md
/workspace/skills/metaso-search/SKILL.md
```

### 错误 2: agentDir 路径不规范

❌ **错误**:
```json
"agentDir": "/home/node/.openclaw/agents/research-agent"
```

✅ **正确**:
```json
"agentDir": "/home/node/.openclaw/agents/research-agent/agent"
```

### 错误 3: workspace 路径不规范

❌ **错误**:
```json
"workspace": "/home/node/.openclaw/workspace/agents/research-agent"
```

✅ **正确**:
```json
"workspace": "/home/node/.openclaw/agents/research-agent/workspace"
```

---

## 📚 官方参考

- [Multi-Agent 概念](https://docs.openclaw.ai/zh-CN/concepts/multi-agent)
- [Subagents 工具](https://docs.openclaw.ai/zh-CN/tools/subagents)
- [Session 配置](https://docs.openclaw.ai/zh-CN/concepts/session)
- [Agent 配置](https://docs.openclaw.ai/zh-CN/concepts/agent)

---

## ✅ 永久记忆

**Agent 绝不使用 SKILL.md！**

- ✅ Agent 使用 `AGENTS.md` 描述自己
- ✅ Agent 使用 `TOOLS.md` 列出工具
- ✅ Agent 使用 `scripts/*.sh` 执行逻辑
- ✅ Agent 使用 `models.json` 配置模型
- ❌ Agent 不使用 `SKILL.md`

---

**维护者**: Main Agent
**更新时间**: 2026-03-03 08:55 UTC
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
