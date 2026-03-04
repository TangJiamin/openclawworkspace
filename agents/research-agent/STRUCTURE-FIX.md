# Research Agent 结构修复说明

**问题**: 脚本位置不符合规范

## ❌ 错误结构

```
/home/node/.openclaw/agents/research-agent/
├── scripts/              # ❌ 旧结构
│   ├── collect_v3_final.sh
│   └── ...
└── workspace/
    └── scripts/          # 空目录
```

## ✅ 正确结构（官方规范）

```
/home/node/.openclaw/agents/research-agent/
├── agent/                # agentDir（运行态）
│   └── ...
├── workspace/            # workspace（业务文件）⭐
│   ├── AGENTS.md         # Agent 描述
│   ├── TOOLS.md          # 工具列表
│   ├── config.json       # 配置
│   └── scripts/          # ✅ 脚本在这里
│       └── collect_v3_final.sh
├── sessions/             # 会话记录
├── models.json           # 模型配置
└── README.md             # 说明文档
```

## 🔧 修复行动

1. ✅ 将 `scripts/collect_v3_final.sh` 复制到 `workspace/scripts/`
2. ⚠️ 其他 Agents 也需要检查

## 📋 规范来源

- 官方文档: OPENCLAW_SUBAGENT_CONFIG_GUIDE.md
- 配置规范: `/home/node/.openclaw/workspace/memory/2026-03-03-agent-config-standard.md`

**核心原则**:
- Agent 使用 `workspace/` 存放业务文件
- Agent 使用 `AGENTS.md` 而不是 `SKILL.md`
- 脚本在 `workspace/scripts/` 而不是 `scripts/`

---

**维护者**: Main Agent  
**状态**: ⚠️ 需要全面检查所有 Agents
