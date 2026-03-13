# 子 Agent 模型配置问题分析

**时间**: 2026-03-12 16:16

---

## 🔍 发现的问题

### 模型配置

```json
{
  "id": "visual-agent",
  "model": "default/glm-3.5-turbo"  // 注意：可能是 GLM-3.5
}
```

### 关键问题

**GLM-4.7 的能力**：
- ✅ 支持工具调用
- ✅ 支持多轮对话
- ⚠️ **可能不支持复杂的工具调用**

**文件读取成功**：
- ✅ Token: 9.5k
- ✅ 时间: 9秒
- ✅ 结果: 正确

**图片生成失败**：
- ❌ Token: 0
- ❌ 时间: 3分钟超时
- ❌ 结果: 只返回文字

---

## 💡 可能的原因

### 原因 1: GLM-4.7 不适合复杂任务 ⭐⭐⭐⭐⭐

**分析**：
- 简单任务（文件读取）：成功
- 复杂任务（API 调用）：失败

**说明**：
- GLM-4.7 可能不支持多步骤工具调用
- 或者工具调用能力有限
- 或者模型本身不适合这个任务

### 原因 2: 模型配置问题 ⭐⭐⭐⭐

**问题**：
- 模型配置是空的 `{}`
- 可能需要配置工具调用能力

**验证**：
```bash
cat /home/node/.openclaw/openclaw/openclaw.json | jq '.agents.defaults.models."default/glm-4.7"'
```

### 原因 3: 模型选择不当 ⭐⭐⭐⭐⭐

**问题**：
- GLM-4.7 可能不是最佳选择
- 可能需要更强的模型（如 GPT-4）
- 或者需要 ACP Agent

---

## 🎯 验证方案

### 方案 1: 更换模型 ⭐⭐⭐⭐⭐

**测试不同的模型**：

```json
{
  "agents": {
    "list": [
      {
        "id": "visual-agent",
        "model": "anthropic/claude-sonnet-4"  // 更强的模型
      }
    ]
  }
}
```

**优势**：
- Claude 可能更适合工具调用
- 可能支持更复杂的任务

### 方案 2: 使用 ACP Agent ⭐⭐⭐⭐⭐

**测试 ACP Agent**：

```python
sessions_spawn(
    agent_id="visual-agent",
    runtime="acp",  # ACP Agent，不是 LLM Agent
    task="生成图片..."
)
```

**优势**：
- ACP Agent 是编程 Agent
- 可以直接执行代码
- 不依赖 LLM 的工具调用

### 方案 3: 检查模型工具调用支持 ⭐⭐⭐⭐

**搜索 GLM-4.7 工具调用文档**：

```bash
# 搜索文档
python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
  --query "GLM-4.7 function calling tool use OpenClaw" \
  --max-results 5 \
  --format md
```

---

## 🎯 下一步

### 立即执行

1. ✅ **搜索 GLM-4.7 工具调用文档**
2. ✅ **测试不同的模型**
3. ✅ **测试 ACP Agent**

---

**文档版本**: v1.0
**最后更新**: 2026-03-12 16:16
**状态**: 深入调试模型配置
