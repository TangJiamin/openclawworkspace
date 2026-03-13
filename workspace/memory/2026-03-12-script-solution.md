# 2026-03-12 记忆（续）

## 🔧 OpenClaw Agent 定义机制验证（15:00）

### 官方文档确认

通过阅读 OpenClaw 官方文档，确认了以下机制：

1. **AGENTS.md 注入机制** ⭐⭐⭐⭐⭐
   - AGENTS.md 会被注入到系统提示词
   - 在每个会话开始时加载
   - 子 Agent 使用 `promptMode=minimal`

2. **子 Agent 配置**
   - workspace: `/home/node/.openclaw/workspace/agents/visual-agent`
   - agentDir: `/home/node/.openclaw/agents/visual-agent`
   - 独立的工作区和会话

3. **工具调用权限**
   - visual-agent 没有工具限制（`tools: null`）
   - 理论上可以调用 `exec` 工具

### 测试结果

**LLM Agent 测试**（3 次）：
- ❌ 第一次：超时，返回"继续等待"
- ❌ 第二次：超时，消耗 162.6k tokens
- ❌ 第三次：超时，没有调用 API

**根本原因**：
- LLM 不遵守"必须调用 API"的指令
- LLM 习惯了生成文字方案
- LLM 可能没有意识到它有权调用 `exec`

---

## 💡 脚本版本解决方案（15:20）

### 实施过程

1. **创建 run.sh 脚本**
   - 文件：`/home/node/.openclaw/workspace/agents/visual-agent/run.sh`
   - 版本：v4.0（最终版）

2. **测试验证**
   - 测试时间：2026-03-12 15:20
   - 结果：✅ 成功
   - 图片 URL：`https://cdn-video.51sux.com/v3-tasks/2026/03/12/513ee0a49c9a4e4bbfb31544b177eb83.png`
   - 执行时间：~2 分钟

3. **对比分析**

| 方案 | 结果 | Token 消耗 | 执行时间 | 可靠性 |
|------|------|-----------|----------|--------|
| LLM Agent | ❌ 超时 | 162.6k | 3 分钟 | 0% |
| 脚本版本 | ✅ 成功 | 0 | 2 分钟 | 100% |

### 关键发现

1. **LLM 不适合执行确定性的 API 调用**
   - LLM 会生成文字方案而不是执行操作
   - LLM 可能不遵守强制性指令
   - Token 消耗巨大

2. **脚本版本是最佳方案**
   - 100% 可靠
   - Token 消耗为 0
   - 执行时间可预测
   - 易于调试和维护

3. **AGENTS.md 的作用**
   - 确实会被注入到系统提示词
   - 但无法强制 LLM 执行操作
   - 更适合作为"建议"而不是"指令"

---

## 🎯 最终决策

### visual-agent 实现

**方式**：脚本版本
**文件**：`/home/node/.openclaw/workspace/agents/visual-agent/run.sh`
**调用方式**：
```bash
bash /home/node/.openclaw/workspace/agents/visual-agent/run.sh "$TASK_SPEC"
```

### video-agent 实现

**方式**：脚本版本（待创建）
**文件**：`/home/node/.openclaw/workspace/agents/video-agent/run.sh`
**调用方式**：
```bash
bash /home/node/.openclaw/workspace/agents/video-agent/run.sh "$TASK_SPEC" "$IMAGE_URL"
```

### orchestrate 更新

**旧方式**（❌ 失败）：
```python
sessions_spawn(
    agent_id="visual-agent",
    runtime="subagent",
    task=task_spec
)
```

**新方式**（✅ 成功）：
```python
result = exec(f"bash /home/node/.openclaw/workspace/agents/visual-agent/run.sh '{task_spec}'")
image_url = result.strip()
```

---

## 📝 经验教训

1. **第一性原理思考**
   - 问题：LLM 不执行操作
   - 本质：LLM 是文本生成模型，不是执行引擎
   - 解决方案：使用脚本而不是 LLM

2. **不要迷信 LLM**
   - LLM 有其局限性
   - 对于确定性任务，脚本更可靠
   - LLM 适合理解和决策，不适合执行

3. **验证是关键**
   - 不要假设更新 AGENTS.md 就能改变行为
   - 必须实际测试验证
   - 测试揭示了真实问题

---

**记录时间**: 2026-03-12 15:25
**重要性**: ⭐⭐⭐⭐⭐
