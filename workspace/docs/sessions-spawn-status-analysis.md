# sessions_spawn 状态分析

**时间**: 2026-03-10 19:15
**目的**: 分析 sessions_spawn 的可用性

---

## 🔍 调查结果

### 历史状态（2026-03-05）

**证据**: 从会话 compaction 记录中发现

**成功的调用**:
- ✅ content-agent (label: test-content-multi-angle)
- ✅ visual-agent (label: test-visual-optimized)
- ✅ agents 成功完成任务
- ✅ 生成输出文件

**调用方式**（从记录推断）:
```python
sessions_spawn(
    agent_id="content-agent",
    task="生成小红书文案...",
    label="test-content-multi-angle",
    timeout=90
)
```

### 当前状态（2026-03-10）

**问题**: 参数验证失败

**错误信息**:
```
Validation failed for tool "sessions_spawn":
  - task: must have required property 'task'
```

**尝试的调用方式**:
1. ❌ `sessions_spawn(agent_id="content-agent", task="...")` - 参数格式错误
2. ❌ `sessions_spawn(task="...", agent_id="content-agent")` - 参数格式错误

---

## 🎯 问题分析

### 问题根源

**参数传递方式错误**

**我使用的方式**:
```json
{
  "task=\"生成小红书内容\"",
  "agent_id": "content-agent",
  "label": "test-content-agent",
  "timeout": "90"
}
```

**工具期望的方式**:
```json
{
  "task": "生成小红书内容",
  "agent_id": "content-agent",
  "label": "test-content-agent",
  "timeout": "90"
}
```

**关键差异**: 我使用了 `task="..."` 而不是 `"task": "..."`

---

## ✅ 下一步

### 需要做的

1. **修正参数格式**
   - 使用正确的 JSON 格式
   - 不要使用 shell 赋值语法

2. **验证功能**
   - 使用正确的格式调用
   - 确认 agent 可以成功启动

3. **更新文档**
   - 记录正确的调用方式
   - 更新 SESSIONS-SPAWN-GUIDE.md

---

## 📝 学习记录

**关键学习**:
1. ⭐ **参数格式很重要** - JSON 格式 vs shell 格式
2. ⭐ **历史记录很有价值** - compaction 记录提供了成功的调用方式
3. ⭐ **验证假设很重要** - 不能假设工具一直可用

**事故根源**:
- 我使用了错误的参数格式
- 我没有先查看工具定义
- 我没有参考历史成功案例

---

**状态**: ⏳ 待修复
**优先级**: ⭐⭐⭐⭐⭐ 最高优先级
**下一步**: 使用正确的 JSON 格式调用 sessions_spawn
