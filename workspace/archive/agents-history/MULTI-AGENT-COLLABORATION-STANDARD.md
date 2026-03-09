# 多智能体协同规范

**制定时间**: 2026-03-04 02:20 UTC

---

## 🎯 核心原则

### ⭐ 所有 Agent 之间的协同都必须使用 sessions_spawn

**禁止**:
- ❌ 脚本直接调用其他 Agent 的脚本
- ❌ 使用 `bash` 命令调用子 Agents
- ❌ 通过临时文件传递数据

**必须**:
- ✅ 使用 `sessions_spawn` 调用子 Agents
- ✅ 通过 task 参数传递数据
- ✅ 每个 Agent 有独立的 session

---

## 📋 标准调用模式

### 基本调用

```bash
OUTPUT=$(sessions_spawn \
  --agent-id "<agent-id>" \
  --task "<任务描述>" \
  --timeout <超时秒数> \
  --cleanup <keep|delete>)
```

### 数据传递

```bash
# Step 1: Agent A 生成数据
DATA_A=$(sessions_spawn \
  --agent-id "agent-a" \
  --task "生成数据" \
  --timeout 60 \
  --cleanup keep)

# Step 2: Agent B 使用 Agent A 的数据
DATA_B=$(sessions_spawn \
  --agent-id "agent-b" \
  --task "处理以下数据：
$DATA_A" \
  --timeout 60 \
  --cleanup keep)
```

---

## 🔧 需要检查的 Agents

### 1. Main Agent → 所有子 Agents

**文件**: `/home/node/.openclaw/agents/main-agent/workspace/scripts/orchestrate.sh`

**调用方式**:
```bash
# ✅ 正确
REQUIREMENT_OUTPUT=$(sessions_spawn --agent-id "requirement-agent" ...)
RESEARCH_OUTPUT=$(sessions_spawn --agent-id "research-agent" ...)
CONTENT_OUTPUT=$(sessions_spawn --agent-id "content-agent" ...)
VISUAL_OUTPUT=$(sessions_spawn --agent-id "visual-agent" ...)
VIDEO_OUTPUT=$(sessions_spawn --agent-id "video-agent" ...)
QUALITY_OUTPUT=$(sessions_spawn --agent-id "quality-agent" ...)
```

### 2. video-agent → visual-agent

**场景**: video-agent 需要先检查图片，如果不存在则调用 visual-agent

**文件**: `/home/node/.openclaw/agents/video-agent/workspace/scripts/generate.sh`

**应该**:
```bash
# ✅ 正确
if [ ! -f "$IMAGE_PATH" ]; then
  VISUAL_OUTPUT=$(sessions_spawn \
    --agent-id "visual-agent" \
    --task "生成图片：$TOPIC" \
    --timeout 60 \
    --cleanup keep)
  
  # 从输出中提取图片路径
  IMAGE_PATH=$(echo "$VISUAL_OUTPUT" | grep -o 'image_file: [^ ]*' | cut -d' ' -f2)
fi
```

**禁止**:
```bash
# ❌ 错误
VISUAL_OUTPUT=$(bash /home/node/.openclaw/agents/visual-agent/workspace/scripts/generate.sh ...)
```

### 3. content-agent → research-agent

**场景**: content-agent 需要补充信息时调用 research-agent

**文件**: `/home/node/.openclaw/agents/content-agent/workspace/scripts/generate.sh`

**应该**:
```bash
# ✅ 正确
if [ -z "$RESEARCH_OUTPUT" ]; then
  RESEARCH_OUTPUT=$(sessions_spawn \
    --agent-id "research-agent" \
    --task "搜索 $TOPIC 相关资讯" \
    --timeout 120 \
    --cleanup keep)
fi
```

### 4. quality-agent → 所有 Agents

**场景**: quality-agent 需要审核所有内容

**文件**: `/home/node/.openclaw/agents/quality-agent/workspace/scripts/review.sh`

**应该**:
```bash
# ✅ 正确
# 审核 content-agent 的输出
CONTENT_REVIEW=$(sessions_spawn \
  --agent-id "quality-agent" \
  --task "审核文案：$CONTENT_OUTPUT" \
  --timeout 30 \
  --cleanup keep)
```

---

## 📊 检查清单

### ✅ 符合规范的 Agents

- [x] Main Agent → 使用 sessions_spawn 调用所有子 Agents
- [ ] video-agent → 检查是否使用 sessions_spawn 调用 visual-agent
- [ ] content-agent → 检查是否使用 sessions_spawn 调用 research-agent
- [ ] quality-agent → 检查是否使用 sessions_spawn 进行审核

### ❌ 需要修复的 Agents

- [ ] video-agent: 如果直接调用 visual-agent 的脚本，需要修复
- [ ] content-agent: 如果直接调用 research-agent 的脚本，需要修复
- [ ] 任何其他 Agent 之间的直接脚本调用

---

## 🔍 检查命令

```bash
# 检查所有 Agents 是否有直接脚本调用
grep -r "bash.*agents/.*scripts/" /home/node/.openclaw/agents/*/workspace/scripts/

# 检查是否有临时文件传递
grep -r "/tmp/.*\.txt" /home/node/.openclaw/agents/*/workspace/scripts/
```

---

## 🎯 修复优先级

### 🔴 P0 - 立即修复

**video-agent → visual-agent**:
- 如果 video-agent 直接调用 visual-agent 的脚本
- 必须改为使用 sessions_spawn

### 🟡 P1 - 尽快修复

**content-agent → research-agent**:
- 如果 content-agent 直接调用 research-agent 的脚本
- 必须改为使用 sessions_spawn

### 🟢 P2 - 后续优化

**quality-agent**:
- 确保审核流程使用 sessions_spawn

---

## ✅ 验证标准

**所有多智能体协同都必须满足**:
1. ✅ 使用 `sessions_spawn` 调用
2. ✅ 通过 task 参数传递数据
3. ✅ 每个Agent有独立的session
4. ✅ 有超时控制
5. ✅ 有清理策略

---

**维护者**: Main Agent  
**状态**: ⚠️ 需要全面检查和修复
