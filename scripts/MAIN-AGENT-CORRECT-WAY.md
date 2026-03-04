# Main Agent 编排器 - 正确的实现方式

**更新时间**: 2026-03-03 10:46 UTC

---

## ✅ 正确的调用方式

### 方式1: 通过 openclaw CLI

```bash
# 场景1: 按需生产
openclaw sessions spawn \
  --agent "main" \
  --task "生成小红书图文，推荐5个AI工具" \
  --timeout 300

# Main Agent 会自动编排子 Agents
```

### 方式2: 通过 Gateway API

```bash
# 场景2: 定时批量生产
curl -X POST "http://localhost:3000/api/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "main",
    "task": "执行场景2：定时批量生产",
    "timeout": 600
  }'
```

### 方式3: 通过定时任务

```bash
# 配置 cron
0 8 * * * openclaw sessions spawn --agent "main" --task "执行场景2批量生产"
```

---

## 🔧 Main Agent 的实现

Main Agent 应该是一个**真正的 Agent**，而不是 bash 脚本：

### 位置

```
/home/node/.openclaw/agents/main-agent/
├── workspace/
│   ├── AGENTS.md
│   ├── TOOLS.md
│   └── scripts/
│       └── orchestrate.sh
```

### 实现

```bash
#!/bin/bash
# main-agent/scripts/orchestrate.sh

USER_INPUT="$1"

# 识别场景
if echo "$USER_INPUT" | grep -q "批量\|定时"; then
  # 场景2: 编排批量生产
  # 1. 调用 research-agent
  # 2. 识别热点话题
  # 3. 批量调用 content-agent
  # 4. 批量调用 visual-agent
  # 5. 批量调用 quality-agent
else
  # 场景1: 编排按需生产
  # 1. 调用 requirement-agent
  # 2. 调用 research-agent
  # 3. 调用 content-agent
  # 4. 调用 visual-agent
  # 5. 调用 quality-agent
fi
```

---

## 🎯 为什么需要真正的 main-agent？

### ✅ 优势

1. **真正的 Agent**
   - 有独立上下文
   - 可以使用 sessions_spawn 调用子 Agents
   - 符合 OpenClaw 架构

2. **智能编排**
   - 自动识别场景
   - 动态调度 Agents
   - 处理错误和重试

3. **可扩展性**
   - 易于添加新场景
   - 支持并行编排
   - 可以集成更多 Agents

---

## 📋 创建 main-agent

让我创建真正的 main-agent：