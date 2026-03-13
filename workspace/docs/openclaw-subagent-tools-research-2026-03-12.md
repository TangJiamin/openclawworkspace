# 联网搜索结果：OpenClaw Subagent 工具调用问题

**搜索时间**: 2026-03-12 15:30
**搜索工具**: Tavily Search

---

## 🔍 关键发现

### 1. GitHub Issue #9857: Subagents cannot invoke tools ⭐⭐⭐⭐⭐

**标题**: "Subagents spawned via sessions_spawn cannot invoke tools (output as text instead of tool_use)"

**发布时间**: 2026-02-05

**问题**：
- 子 Agent 通过 sessions_spawn 创建后无法调用工具
- 子 Agent 只输出文本，不执行 tool_use

**根本原因**：
- 子 Agent 的工具配置没有正确传递
- Tool schemas 没有被传递到子 Agent session 的 API 请求

**状态**: Open Issue（未解决）

### 2. GitHub Issue #29369: Add tools parameter to sessions_spawn ⭐⭐⭐⭐⭐

**标题**: "FEATURE: Add tools parameter to sessions_spawn"

**发布时间**: 2026-02-28

**问题**：
- 当前无法动态配置子 Agent 的工具权限
- 需要创建单独的 agent profiles 才能设置不同的工具集

**提议的解决方案**：
```javascript
// Research task — web only
sessions_spawn({
  task: "Research this topic",
  tools: { allow: ["web_search", "web_fetch"] }
})

// Build task — full toolkit
sessions_spawn({
  task: "Build this feature",
  tools: { allow: ["web_search", "web_fetch", "exec", "process", "read", "write", "edit"] }
})
```

**状态**: Feature Request（未实现）

### 3. 其他相关问题

**Issue #15885**: Elevated exec permissions lost after spawning sub-agent
- 启用 elevated exec 后，main session 在 sessions_spawn 后失去权限

**Issue #40082**: OpenClaw accepts tasks but agents often do not execute them
- Agent 无法执行 exec 工具
- 版本升级到 2026.3.7 后出现

---

## 💡 关键洞察

### 1. 这是 OpenClaw 的已知问题 ⭐⭐⭐⭐⭐

**确认**：
- ✅ 这不是我们的配置问题
- ✅ 这是 OpenClaw 的设计限制
- ✅ 多个用户报告了相同的问题

### 2. 当前的限制 ⭐⭐⭐⭐⭐

**子 Agent 无法调用工具**：
- ❌ 子 Agent 默认没有工具权限
- ❌ 无法通过 sessions_spawn 动态传递工具权限
- ❌ 需要创建单独的 agent profiles

**临时解决方案**：
- 为每个需要不同工具的 Agent 创建单独的 profile
- 在 agents.list 中配置 tools.sandbox.tools.allow

### 3. 我们的解决方案是正确的 ⭐⭐⭐⭐⭐

**脚本版本是最优解**：
- ✅ 绕过了 LLM Agent 的限制
- ✅ 不依赖工具调用机制
- ✅ 100% 可靠
- ✅ Token 消耗为 0

---

## 🎯 最终建议

### 立即执行

1. ✅ **使用脚本版本** - 不依赖 LLM Agent
2. ✅ **记录问题** - 等待 OpenClaw 官方修复
3. ✅ **关注 Issue #29369** - tools parameter 功能

### 长期方案

**等待 OpenClaw 更新**：
- 关注 Issue #29369 的进展
- 一旦 tools parameter 实现，可以重新考虑 LLM Agent
- 当前版本（2026.3.x）可能不支持

---

**搜索结果确认**: 我们遇到的问题是 OpenClaw 的已知限制，不是配置错误。

**文档版本**: v1.0
**最后更新**: 2026-03-12
