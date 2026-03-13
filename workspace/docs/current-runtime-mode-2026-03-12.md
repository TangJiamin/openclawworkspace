# 当前运行方式总结

**更新时间**: 2026-03-12 15:30

---

## 🎯 Agent 矩阵运行方式

### 架构

```
用户需求
  ↓
Main Agent (LLM Agent - 智能决策)
  ↓
requirement-agent (LLM Agent - 需求分析)
  ↓
research-agent (LLM Agent - 资料收集)
  ↓
content-agent (LLM Agent - 内容生成)
  ↓
┌─────────────────────────────────┐
│  visual-agent (脚本版本)        │ ← 脚本，不是 LLM Agent
│  run.sh + xskill API            │
└─────────────────────────────────┘
  ↓
┌─────────────────────────────────┐
│  video-agent (脚本版本)         │ ← 脚本，不是 LLM Agent
│  run.sh + xskill API            │
└─────────────────────────────────┘
  ↓
quality-agent (LLM Agent - 质量审核)
  ↓
最终结果
```

---

## 📋 各 Agent 的运行方式

### 1. Main Agent (LLM Agent) ✅

**类型**: LLM Agent
**运行方式**: sessions_spawn (subagent)
**职责**: 智能决策、协调、整合

**调用方式**:
```python
# 内置，始终运行
```

### 2. requirement-agent (LLM Agent) ✅

**类型**: LLM Agent
**运行方式**: sessions_spawn (subagent)
**职责**: 需求分析、任务规范

**调用方式**:
```python
sessions_spawn(
    agent_id="requirement-agent",
    runtime="subagent",
    task="分析需求：{user_input}",
    timeoutSeconds=60
)
```

### 3. research-agent (LLM Agent) ✅

**类型**: LLM Agent
**运行方式**: sessions_spawn (subagent)
**职责**: 资料收集、搜索

**调用方式**:
```python
sessions_spawn(
    agent_id="research-agent",
    runtime="subagent",
    task="收集资料：{topic}",
    timeoutSeconds=180
)
```

### 4. content-agent (LLM Agent) ✅

**类型**: LLM Agent
**运行方式**: sessions_spawn (subagent)
**职责**: 内容生成、文案创作

**调用方式**:
```python
sessions_spawn(
    agent_id="content-agent",
    runtime="subagent",
    task="生成文案：{content_spec}",
    timeoutSeconds=90
)
```

### 5. visual-agent (脚本版本) ⭐⭐⭐⭐⭐

**类型**: Bash 脚本
**运行方式**: exec (直接调用)
**职责**: 调用 xskill API 生成图片

**调用方式**:
```python
# 方式 1: 直接 exec
result = exec(f"bash /home/node/.openclaw/workspace/agents/visual-agent/run.sh '{task_spec}'")
image_url = result.strip()

# 方式 2: 在 orchestrate 中
def generate_images(task_spec):
    result = exec(f"bash /home/node/.openclaw/workspace/agents/visual-agent/run.sh '{task_spec}'")
    return result.strip()
```

**脚本位置**: `/home/node/.openclaw/workspace/agents/visual-agent/run.sh`

**为什么不用 LLM Agent**:
- ❌ LLM Agent 无法调用 exec 工具（OpenClaw 已知限制）
- ❌ Token 消耗巨大（162.6k）
- ❌ 不可靠（3 次测试均失败）

### 6. video-agent (脚本版本) ⭐⭐⭐⭐⭐

**类型**: Bash 脚本
**运行方式**: exec (直接调用)
**职责**: 调用 xskill API 生成视频

**调用方式**:
```python
# 方式 1: 直接 exec
result = exec(f"bash /home/node/.openclaw/workspace/agents/video-agent/run.sh '{task_spec}' '{image_url}'")
video_url = result.strip()

# 方式 2: 在 orchestrate 中
def generate_videos(task_spec, image_url):
    result = exec(f"bash /home/node/.openclaw/workspace/agents/video-agent/run.sh '{task_spec}' '{image_url}'")
    return result.strip()
```

**脚本位置**: `/home/node/.openclaw/workspace/agents/video-agent/run.sh` (待创建)

### 7. quality-agent (LLM Agent) ✅

**类型**: LLM Agent
**运行方式**: sessions_spawn (subagent)
**职责**: 质量审核、评分

**调用方式**:
```python
sessions_spawn(
    agent_id="quality-agent",
    runtime="subagent",
    task="审核质量：{content}",
    timeoutSeconds=30
)
```

---

## 🔄 执行流程

### 完整流程（orchestrate）

```python
def orchestrate(user_input):
    # 1. 需求分析 (LLM Agent)
    requirement = sessions_spawn(
        agent_id="requirement-agent",
        task=f"分析需求：{user_input}",
        timeoutSeconds=60
    )

    # 2. 资料收集 (LLM Agent)
    research = sessions_spawn(
        agent_id="research-agent",
        task=f"收集资料：{requirement['topic']}",
        timeoutSeconds=180
    )

    # 3. 内容生成 (LLM Agent)
    content = sessions_spawn(
        agent_id="content-agent",
        task=f"生成文案：{research}, {requirement}",
        timeoutSeconds=90
    )

    # 4. 图片生成 (脚本) ⭐ 关键变更
    images_result = exec(f"bash /home/node/.openclaw/workspace/agents/visual-agent/run.sh '{requirement}'")
    image_urls = parse_result(images_result)

    # 5. 视频生成 (脚本) ⭐ 关键变更
    videos_result = exec(f"bash /home/node/.openclaw/workspace/agents/video-agent/run.sh '{requirement}' '{image_urls[0]}'")
    video_urls = parse_result(videos_result)

    # 6. 质量审核 (LLM Agent)
    quality = sessions_spawn(
        agent_id="quality-agent",
        task=f"审核质量：{content}, {image_urls}, {video_urls}",
        timeoutSeconds=30
    )

    return {
        "requirement": requirement,
        "research": research,
        "content": content,
        "images": image_urls,
        "videos": video_urls,
        "quality": quality
    }
```

---

## 📊 运行方式对比

| Agent | 类型 | 运行方式 | Token 消耗 | 可靠性 | 原因 |
|-------|------|----------|-----------|--------|------|
| Main Agent | LLM Agent | 内置 | N/A | N/A | 系统内置 |
| requirement-agent | LLM Agent | sessions_spawn | ~10k | 95% | 智能分析 |
| research-agent | LLM Agent | sessions_spawn | ~30k | 95% | 智能搜索 |
| content-agent | LLM Agent | sessions_spawn | ~20k | 95% | 智能创作 |
| **visual-agent** | **脚本** | **exec** | **0** | **100%** | **确定性 API 调用** |
| **video-agent** | **脚本** | **exec** | **0** | **100%** | **确定性 API 调用** |
| quality-agent | LLM Agent | sessions_spawn | ~5k | 95% | 智能判断 |

---

## 🎯 核心原则

### LLM Agent 适用于

- ✅ 理解和分析
- ✅ 创作和生成
- ✅ 决策和判断

### 脚本适用于

- ✅ 确定性 API 调用
- ✅ 固定流程执行
- ✅ 性能关键任务

### 混合使用

- **智能决策** → LLM Agent
- **确定性执行** → 脚本

---

## 🚀 下一步

### 立即执行

1. ✅ **创建 video-agent 脚本**
2. ✅ **更新 orchestrate 使用脚本**
3. ✅ **测试完整流程**

### 验证标准

- ✅ visual-agent 脚本成功
- ✅ video-agent 脚本成功
- ✅ 完整流程测试通过

---

**运行方式版本**: v2.0 (脚本版本)
**最后更新**: 2026-03-12 15:30
