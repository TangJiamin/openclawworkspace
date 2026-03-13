# 学习记录

**日期**: 2026-03-12
**类型**: Agent 职责定义

---

## [LRN-20260312-001] xskill API 调用方法

**Logged**: 2026-03-12T14:15:00Z
**Priority**: high
**Status**: resolved
**Area**: api

### 问题

visual-generator 脚本失败（parse error）

### 原因

脚本 JSON 解析有问题

### 解决方案

**直接 curl 调用**（推荐）：
```bash
# 1. 创建任务
curl -s -X POST "https://api.xskill.ai/api/v3/tasks/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XSKILL_API_KEY" \
  -d '{"model": "jimeng-5.0", "params": {"prompt": "your prompt"}}'

# 2. 轮询任务
curl -s -X POST "https://api.xskill.ai/api/v3/tasks/query" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XSKILL_API_KEY" \
  -d '{"task_id": "your-task-id"}'
```

### 验证

✅ 成功生成 5 张图片
✅ API 工作正常
✅ 响应时间 1-2 分钟

---

## [LRN-20260312-002] Agent 职责定义错误

**Logged**: 2026-03-12T14:50:00Z
**Priority**: high
**Status**: resolved
**Area**: agent-architecture

### 问题

visual-agent 和 video-agent 生成文字方案，不是调用 API

### 原因

Agent 职责定义不清晰

### 解决方案

**更新 Agent 职责**：

1. **visual-agent**:
   - 输入：requirement-agent 的任务规范
   - 输出：图片 URL（调用 xskill API）
   - 不重新分析需求
   - 不生成文字方案

2. **video-agent**:
   - 输入：requirement-agent 的任务规范 + visual-agent 的图片
   - 输出：视频 URL（调用 xskill API）
   - 不重新分析需求
   - 不生成文字方案
   - 不自己生成图片

### 关键原则

1. **职责分离**：每个 Agent 只负责一件事
2. **上下文传递**：Main Agent 必须传递 requirement-agent 的输出
3. **API 调用**：visual/video-agent 必须调用 API，不生成文字

---

## [LRN-20260312-003] 图片生成优先原则

**Logged**: 2026-03-12T14:52:00Z
**Priority**: high
**Status**: resolved
**Area**: video-production

### 问题

text-to-video 质量难以保证

### 解决方案

**图片生成优先**：
- visual-agent 先生成高质量图片（关键帧）
- video-agent 使用图片生成视频（image-to-video）
- 质量优于 text-to-video

### 流程

```
requirement-agent → visual-agent（图片）→ video-agent（视频）
```

---

## [LRN-20260312-004] 直接 API 调用

**Logged**: 2026-03-12T14:15:00Z
**Priority**: high
**Status**: resolved
**Area**: api

### 验证结果

✅ xskill API 可用
✅ 直接 curl 调用成功
✅ 生成 5 张高质量图片

### API 信息

- **Base URL**: https://api.xskill.ai/api/v3
- **认证**: Bearer Token
- **模型**:
  - jimeng-5.0（图片生成）
  - fal-ai/bytedance/seedance/v1.5/pro/text-to-video（视频生成）
- **响应时间**: 1-2 分钟

---

**维护**: Main Agent
