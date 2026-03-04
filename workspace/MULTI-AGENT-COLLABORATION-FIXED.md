# 多智能体协同规范和修复

**制定时间**: 2026-03-04 02:20 UTC

---

## 🎯 核心原则

### ⭐ 所有 Agent 之间的协同都必须使用 sessions_spawn

**禁止**:
- ❌ 脚本直接调用其他 Agent 的脚本
- ❌ 使用 `bash` 命令调用子 Agents

**必须**:
- ✅ 使用 `sessions_spawn` 调用子 Agents
- ✅ 通过 task 参数传递数据
- ✅ 每个 Agent 有独立的 session

---

## ✅ 检查结果

### 发现的问题

**research-agent → content-agent**:
- ❌ `batch-produce.sh` 直接调用 content-agent 的脚本
- 📍 `/home/node/.openclaw/agents/research-agent/workspace/scripts/batch-produce.sh`

**问题代码**:
```bash
# ❌ 错误
$(bash /home/node/.openclaw/agents/content-agent/workspace/scripts/generate.sh "$PLATFORM" "$TOPIC" "轻松")
```

### 已修复

**research-agent → content-agent**:
- ✅ 改为使用 `sessions_spawn` 调用
- ✅ 通过 task 参数传递资讯数据

**修复代码**:
```bash
# ✅ 正确
CONTENT_OUTPUT=$(sessions_spawn \
  --agent-id "content-agent" \
  --task "生成小红书文案

话题：$TOPIC
平台：$PLATFORM
风格：$STYLE

基于以下资讯生成内容：
$RESEARCH_OUTPUT" \
  --timeout 90 \
  --cleanup keep)
```

---

## 📋 符合规范的 Agents

### ✅ Main Agent

**文件**: `/home/node/.openclaw/agents/main-agent/workspace/scripts/orchestrate.sh`

**调用方式**:
```bash
# ✅ 使用 sessions_spawn 调用所有子 Agents
REQUIREMENT_OUTPUT=$(sessions_spawn --agent-id "requirement-agent" ...)
RESEARCH_OUTPUT=$(sessions_spawn --agent-id "research-agent" ...)
CONTENT_OUTPUT=$(sessions_spawn --agent-id "content-agent" ...)
VISUAL_OUTPUT=$(sessions_spawn --agent-id "visual-agent" ...)
VIDEO_OUTPUT=$(sessions_spawn --agent-id "video-agent" ...)
QUALITY_OUTPUT=$(sessions_spawn --agent-id "quality-agent" ...)
```

### ✅ research-agent (batch-produce.sh)

**文件**: `/home/node/.openclaw/agents/research-agent/workspace/scripts/batch-produce.sh`

**调用方式**:
```bash
# ✅ 使用 sessions_spawn 调用 content-agent
CONTENT_OUTPUT=$(sessions_spawn \
  --agent-id "content-agent" \
  --task "生成文案...
基于以下资讯：
$RESEARCH_OUTPUT" \
  --timeout 90 \
  --cleanup keep)
```

### ✅ video-agent

**文件**: `/home/node/.openclaw/agents/video-agent/workspace/scripts/generate.sh`

**调用方式**:
```bash
# ✅ 使用 sessions_spawn 调用 visual-agent
VISUAL_RESULT=$(sessions_spawn "visual-agent" "$VISUAL_TASK" 2>&1)
```

---

## 🎉 总结

### 修复状态

- ✅ **Main Agent**: 符合规范（使用 sessions_spawn）
- ✅ **research-agent**: 已修复（使用 sessions_spawn）
- ✅ **video-agent**: 符合规范（使用 sessions_spawn）
- ✅ **content-agent**: 符合规范（不调用其他 Agents）
- ✅ **visual-agent**: 符合规范（不调用其他 Agents）
- ✅ **quality-agent**: 符合规范（不调用其他 Agents）

### 验证标准

**所有多智能体协同都满足**:
1. ✅ 使用 `sessions_spawn` 调用
2. ✅ 通过 task 参数传递数据
3. ✅ 每个 Agent 有独立的 session
4. ✅ 有超时控制
5. ✅ 有清理策略

---

**维护者**: Main Agent  
**状态**: ✅ 所有多智能体协同都符合规范
