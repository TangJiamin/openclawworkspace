# Agent 协同流程 v3.0（高效通信版）

**版本**: v3.0 - 解决频繁中断问题
**更新时间**: 2026-03-11 17:40

---

## 🚨 问题诊断

### Agents 频繁中断/卡住的原因

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| **超时太短** | timeoutSeconds 设置不够 | 增加超时时间 |
| **上下文占用** | 主会话轮询占用 tokens | 使用文件传递 |
| **工具调用失败** | 外部 API 超时 | 多层备用方案 |
| **等待通知** | 轮询太频繁 | 等待 completion event |

---

## ✅ 解决方案

### 1. 超时时间设置

```bash
# 推荐超时时间
requirement-agent:  60s  # 简单分析
research-agent:   120s  # 搜索收集
content-agent:    90s  # 文案生成
visual-agent:   120s  # 图片生成（较慢）
video-agent:    300s  # 视频生成（很慢）
quality-agent:   60s  # 审核
```

### 2. 文件传递（不占上下文）

```
/output/
├── requirement.json    # 需求规范
├── research.json     # 资料收集
├── content.json      # 视频文案
├── visual.json      # 视觉建议
└── videos/          # 视频文件
```

**传递方式**:
```bash
# Agent 1: 输出到文件
task="分析需求并保存到 /output/requirement.json"

# Agent 2: 读取文件
task="读取 /output/requirement.json 并收集资料"
```

### 3. 减少轮询

```bash
# 错误：频繁轮询
while true:
    sessions_list()  # 占用上下文！
    sleep(1)

# 正确：等待 completion event
# OpenClaw 会自动通知，不需要轮询
```

---

## 🔄 正确流程

### 主智能体操作

```python
# 1. 调度子智能体
sessions_spawn(
    agent_id="requirement-agent",
    task="分析需求并保存到 /output/requirement.json",
    timeoutSeconds=60
)

# 2. 等待完成（不要轮询！）
# OpenClaw 会自动发送 completion event

# 3. 读取结果文件
content = read("/output/requirement.json")

# 4. 传递结果给下一个 Agent
sessions_spawn(
    agent_id="research-agent",
    task=f"读取 /output/requirement.json 并收集资料，保存到 /output/research.json"
)
```

### 子智能体操作

```python
# 1. 读取输入文件（如需要）
if 需要前置结果:
    content = read(input_file)

# 2. 执行任务

# 3. 保存结果到文件
write(output_file, result)

# 4. 返回简洁结果（不包含大量数据）
return "已完成，保存到 " + output_file
```

---

## 📋 超时设置参考

| Agent | 任务类型 | 建议超时 | 原因 |
|-------|---------|---------|------|
| requirement-agent | 需求分析 | 60s | 简单文本处理 |
| research-agent | 资料收集 | 120s | 搜索 API 可能慢 |
| content-agent | 文案生成 | 90s | AI 生成 |
| visual-agent | 图片生成 | 120s | API 调用 |
| video-agent | 视频生成 | 300s | 最慢 |
| quality-agent | 质量审核 | 60s | 简单判断 |

---

## ⚠️ 注意事项

1. **不要在主会话中保存大量中间结果**
2. **使用文件作为 Agent 之间的桥梁**
3. **等待 completion event，不要轮询**
4. **设置足够的超时时间**

---

**版本**: v3.0
**状态**: ✅ 已优化
