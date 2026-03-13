# visual-agent 问题分析与解决方案

**日期**: 2026-03-12
**版本**: v1.0

---

## 🔍 问题分析

### 症状

- ✅ AGENTS.md 已更新（v7.0 强制执行版）
- ✅ Gateway 已重启
- ✅ AGENTS.md 会被注入到系统提示词
- ❌ visual-agent 仍然没有调用 API
- ❌ 只返回"继续等待"，没有图片 URL
- ❌ 消耗 162.6k tokens（161.2k 输入，1.5k 输出）

### 根本原因（第一性原理）

#### 1. LLM 不遵守指令 ⭐⭐⭐⭐⭐

**问题**：
- LLM 可能没有理解"必须调用 API"的强制要求
- LLM 可能习惯了生成文字方案，而不是执行操作
- LLM 可能没有意识到它有权调用 `exec` 工具

**证据**：
- 输出只有 1.5k tokens，说明没有执行任何操作
- 只返回"继续等待"，说明在等待外部操作
- 没有调用任何工具（没有工具调用记录）

#### 2. AGENTS.md 可能没有被正确注入 ⭐⭐⭐⭐

**问题**：
- 子 Agent 使用 `promptMode=minimal`
- 可能 AGENTS.md 被截断（超过 20000 字符限制）
- 可能 AGENTS.md 没有被正确读取

**验证方法**：
```bash
# 检查 AGENTS.md 大小
wc -c /home/node/.openclaw/workspace/agents/visual-agent/AGENTS.md

# 检查注入的上下文
openclaw context list
```

#### 3. 工具调用权限问题 ⭐⭐⭐⭐⭐

**问题**：
- visual-agent 可能没有 `exec` 工具权限
- 或者 LLM 不知道它有权调用 `exec`

**验证方法**：
```bash
# 检查 visual-agent 的工具权限
cat /home/node/.openclaw/openclaw.json | jq '.agents.list[] | select(.id == "visual-agent") | .tools'
```

---

## 💡 解决方案

### 方案 1：强化 AGENTS.md 指令 ⭐⭐⭐

**方法**：更明确的指令，强调工具调用

```markdown
# visual-agent - 操作指南

## ⚠️ 立即执行（不要等待）

你现在必须执行以下操作：

1. 使用 `exec` 工具调用 bash 命令
2. 调用 xskill API 生成图片
3. 返回图片 URL

### 示例代码（直接复制执行）

\`\`\`bash
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/xskill_call.sh \
  jimeng-5.0 \
  "OpenAI blue logo vs Anthropic red logo, cyberpunk style" \
  --ratio "9:16"
\`\`\`

**警告**：不要生成文字方案，不要只返回提示词，必须执行命令！
```

**优点**：
- 不改变架构
- 可能解决 LLM 理解问题

**缺点**：
- LLM 可能仍然不执行
- 依赖 LLM 的工具调用能力

---

### 方案 2：创建脚本版本 ⭐⭐⭐⭐⭐

**方法**：创建 `agents/visual-agent/run.sh` 脚本

```bash
#!/bin/bash
# visual-agent - 脚本版本

set -e

# 读取任务规范
TASK_SPEC="$1"

# 生成提示词（使用 Main Agent）
PROMPT=$(node /home/node/.openclaw/workspace/scripts/generate-prompt.js "$TASK_SPEC")

# 调用 xskill API
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/xskill_call.sh \
  jimeng-5.0 \
  "$PROMPT" \
  --ratio "9:16"
```

**调用方式**：
```python
sessions_spawn(
    agent_id="visual-agent",
    runtime="acp",  # 使用 ACP 而不是 subagent
    task=task_spec
)
```

**优点**：
- 100% 可靠
- 不依赖 LLM 工具调用
- 性能更好

**缺点**：
- 需要重写 Agent
- 失去 LLM 的灵活性

---

### 方案 3：在 Main Agent 中实现 ⭐⭐⭐⭐⭐

**方法**：在 Main Agent 的 orchestrate 中直接调用 API

```python
# Main Agent 直接调用
def generate_images(task_spec):
    # 生成提示词
    prompt = generate_prompt(task_spec)

    # 调用 API
    image_url = call_xskill_api(prompt)

    return image_url
```

**优点**：
- Main Agent 有完整的工具权限
- 可靠性最高
- 易于调试

**缺点**：
- Main Agent 承担更多责任
- 失去多 Agent 架构的优势

---

### 方案 4：使用 ACP Agent 而不是 LLM Agent ⭐⭐⭐⭐⭐

**方法**：使用 `runtime="acp"` 而不是 `runtime="subagent"`

```python
sessions_spawn(
    agent_id="visual-agent",
    runtime="acp",  # ACP Agent（Codex/Claude Code）
    task=task_spec
)
```

**ACP Agent 的特点**：
- 是一个编程 Agent
- 可以直接运行代码
- 有完整的工具权限

**优点**：
- ACP Agent 可以执行代码
- 可靠性高
- 符合"Agent = 编程"的理念

**缺点**：
- 需要配置 ACP Agent
- 可能需要额外成本

---

## 🎯 推荐方案

### 立即执行：方案 4（ACP Agent）⭐⭐⭐⭐⭐

**原因**：
1. **OpenClaw 支持 ACP** - 文档明确提到 `runtime="acp"`
2. **可靠性高** - ACP Agent 可以直接执行代码
3. **符合设计** - visual/video 生成本质上是编程任务

**实施步骤**：

#### 1. 检查 ACP 配置

```bash
# 检查 ACP default agent
cat /home/node/.openclaw/openclaw.json | jq '.acp'
```

#### 2. 创建 ACP Agent

```python
# agents/visual-agent/run.js
const xskill = require('/home/node/.openclaw/workspace/skills/visual-generator/scripts/xskill.js');

async function generateImages(taskSpec) {
    // 生成提示词
    const prompt = generatePrompt(taskSpec);

    // 调用 API
    const imageUrl = await xskill.call('jimeng-5.0', prompt);

    return imageUrl;
}

module.exports = { generateImages };
```

#### 3. 更新调用方式

```python
# 在 orchestrate 中
sessions_spawn(
    agent_id="visual-agent",
    runtime="acp",  # 使用 ACP
    task=f"生成图片：{task_spec}"
)
```

---

### 备选方案：方案 2（脚本版本）

**原因**：
- 简单直接
- 不依赖 LLM
- 易于维护

**实施步骤**：

#### 1. 创建 run.sh

```bash
cat > /home/node/.openclaw/workspace/agents/visual-agent/run.sh << 'EOF'
#!/bin/bash
set -e

TASK_SPEC="$1"

# 生成提示词（调用 Main Agent）
PROMPT=$(node /home/node/.openclaw/workspace/scripts/generate-prompt.js "$TASK_SPEC")

# 调用 xskill API
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/xskill_call.sh \
  jimeng-5.0 \
  "$PROMPT" \
  --ratio "9:16"
EOF

chmod +x /home/node/.openclaw/workspace/agents/visual-agent/run.sh
```

#### 2. 测试

```bash
bash /home/node/.openclaw/workspace/agents/visual-agent/run.sh "$TASK_SPEC"
```

---

## 📊 对比分析

| 方案 | 可靠性 | 复杂度 | 性能 | 推荐度 |
|------|--------|--------|------|--------|
| 方案 1: 强化指令 | ⭐⭐ | ⭐ | ⭐⭐ | ⭐⭐ |
| 方案 2: 脚本版本 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 方案 3: Main Agent | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 方案 4: ACP Agent | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 🔧 下一步行动

### 立即执行

1. ✅ **检查 ACP 配置**
2. ✅ **创建脚本版本**
3. ✅ **测试两种方案**
4. ✅ **选择最优方案**

### 验证标准

- ✅ 成功调用 xskill API
- ✅ 返回图片 URL
- ✅ Token 消耗 < 10k
- ✅ 执行时间 < 60 秒

---

**文档版本**: v1.0
**最后更新**: 2026-03-12
