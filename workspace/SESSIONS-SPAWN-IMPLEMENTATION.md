# 使用 sessions_spawn 的调用方式

**更新时间**: 2026-03-04 02:18 UTC

---

## ✅ 使用 sessions_spawn 调用子 Agents

### 编排流程

```bash
# Step 1: requirement-agent
REQUIREMENT_OUTPUT=$(sessions_spawn \
  --agent-id "requirement-agent" \
  --task "分析用户需求：$USER_INPUT" \
  --timeout 60 \
  --cleanup keep)

# Step 2: research-agent
RESEARCH_OUTPUT=$(sessions_spawn \
  --agent-id "research-agent" \
  --task "搜索 $SEARCH_KEYWORD 相关的最新资讯" \
  --timeout 120 \
  --cleanup keep)

# Step 3: content-agent（传递 research-agent 的输出）⭐
CONTENT_OUTPUT=$(sessions_spawn \
  --agent-id "content-agent" \
  --task "基于以下资讯生成小红书文案：

话题：AI技术最新突破
平台：小红书
风格：轻松

资讯内容：
$RESEARCH_OUTPUT" \
  --timeout 90 \
  --cleanup keep)
```

---

## 🎯 关键改进

### 数据传递方式

**之前（脚本调用）**:
```bash
# ❌ 脚本直接调用
RESEARCH_OUTPUT=$(bash /path/to/research-agent.sh)
CONTENT_OUTPUT=$(bash /path/to/content-agent.sh "$RESEARCH_OUTPUT")
```

**现在（sessions_spawn）**:
```bash
# ✅ 使用 sessions_spawn
RESEARCH_OUTPUT=$(sessions_spawn --agent-id "research-agent" --task "...")
CONTENT_OUTPUT=$(sessions_spawn --agent-id "content-agent" --task "基于资讯：$RESEARCH_OUTPUT")
```

---

## 📋 优势

### 1. 符合 OpenClaw 架构

- ✅ 使用官方的 `sessions_spawn` 工具
- ✅ 创建真正的独立 Agent sessions
- ✅ 每个 Agent 有独立的上下文和记忆
- ✅ 支持超时控制和清理策略

### 2. 更好的数据传递

- ✅ research-agent 的输出通过 task 参数传递
- ✅ content-agent 可以直接在 task 中引用资讯内容
- ✅ 不需要临时文件或复杂的脚本逻辑

### 3. 更清晰的编排

- ✅ Main Agent 作为协调者
- ✅ 子 Agents 真正独立运行
- ✅ 每个步骤的输出明确

---

## 🔧 content-agent 需要的修改

### 当前实现

content-agent 的 `generate.sh` 脚本接收4个参数：
```bash
generate.sh "$PLATFORM" "$TOPIC" "$STYLE" "$RESEARCH_OUTPUT"
```

### sessions_spawn 的实现

content-agent 需要能够从 task 参数中解析资讯内容：

**Agent 应该**:
1. 从 task 描述中提取参数（平台、话题、风格）
2. 从 task 描述中提取资讯内容
3. 基于资讯内容生成文案

---

## 🎯 总结

**调用方式**: ✅ **使用 sessions_spawn**

**实现方式**:
- Main Agent 通过 `sessions_spawn` 调用子 Agents
- research-agent 的输出通过 task 参数传递给 content-agent
- 不需要脚本直接调用，符合 OpenClaw 架构

**下一步**: 修改 content-agent 的实现，使其能够从 task 参数中解析资讯内容

---

**维护者**: Main Agent  
**状态**: ✅ 已切换到 sessions_spawn 调用方式
