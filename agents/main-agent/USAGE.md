# Main Agent 编排器 - sessions_spawn 版本

**更新时间**: 2026-03-04 02:18 UTC

---

## ✅ 编排流程

### 调用方式

使用 **sessions_spawn** 调用子 Agents（而非脚本直接调用）

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
  --task "搜索 AI资讯 相关的最新资讯" \
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

# Step 4: visual-agent（可选）
# Step 5: video-agent（可选）
# Step 6: quality-agent
QUALITY_OUTPUT=$(sessions_spawn \
  --agent-id "quality-agent" \
  --task "审核以下文案内容：$CONTENT_OUTPUT" \
  --timeout 30 \
  --cleanup keep)
```

---

## 🎯 关键改进

### 数据传递

**research-agent → content-agent**:

```bash
# research-agent 的输出
RESEARCH_OUTPUT="资讯内容..."

# 通过 task 参数传递给 content-agent
CONTENT_OUTPUT=$(sessions_spawn \
  --agent-id "content-agent" \
  --task "基于以下资讯生成文案：
$RESEARCH_OUTPUT")
```

---

## 📋 优势

1. **符合 OpenClaw 架构** ✅
   - 使用官方的 `sessions_spawn` 工具
   - 创建真正的独立 Agent sessions

2. **更好的数据传递** ✅
   - 通过 task 参数传递数据
   - 不需要临时文件

3. **更清晰的编排** ✅
   - Main Agent 作为协调者
   - 子 Agents 真正独立运行

---

## 🔧 文件位置

**Main Agent 编排器**:
`/home/node/.openclaw/agents/main-agent/workspace/scripts/orchestrate.sh`

**使用方式**:
```bash
orchestrate "生成小红书内容，推荐5个提升效率的AI工具"
```

---

**维护者**: Main Agent  
**状态**: ✅ 已切换到 sessions_spawn 调用方式
