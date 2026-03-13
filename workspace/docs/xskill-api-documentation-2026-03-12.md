# xskill API 文档

**更新时间**: 2026-03-12 16:00

---

## 🔧 已知 API 端点

### 1. 创建任务

**端点**: `POST https://api.xskill.ai/api/v3/tasks/create`

**请求**:
```json
{
  "model": "jimeng-5.0",
  "params": {
    "prompt": "your prompt here"
  }
}
```

**响应**:
```json
{
  "code": 200,
  "message": "任务创建成功（通道: api）",
  "data": {
    "task_id": "uuid",
    "request_id": "uuid",
    "model": "jimeng-5.0",
    "channel": "api",
    "status": "pending",
    "price": 2,
    "balance": 457367
  }
}
```

### 2. 查询任务

**端点**: `POST https://api.xskill.ai/api/v3/tasks/query`

**请求**:
```json
{
  "task_id": "your-task-id"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "查询成功",
  "data": {
    "task_id": "uuid",
    "status": "completed",
    "output": {
      "images": [
        {
          "url": "https://cdn-video.51sux.com/..."
        }
      ]
    }
  }
}
```

---

## 🎯 可用模型

### 图片生成

1. **jimeng-5.0** ⭐⭐⭐⭐⭐
   - 最新旗舰模型
   - 高质量输出
   - 成本：2 积分/张

2. **fal-ai/flux-realism**
   - 写实图像
   - 高质量

### 视频生成

1. **jimeng-video-2.0**
   - 图片转视频
   - 高质量

---

## 📋 使用示例

### 创建图片任务

```bash
curl -s -X POST "https://api.xskill.ai/api/v3/tasks/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${XSKILL_API_KEY}" \
  -d '{
    "model": "jimeng-5.0",
    "params": {
      "prompt": "OpenAI vs Anthropic, cyberpunk style, 9:16"
    }
  }' | jq -r '.data.task_id'
```

### 查询任务状态

```bash
curl -s -X POST "https://api.xskill.ai/api/v3/tasks/query" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${XSKILL_API_KEY}" \
  -d "{\"task_id\": \"${TASK_ID}\"}" | jq '.data'
```

---

## 🎯 技能 ID 7289e7d7-42d2-42b8-827c-ff0ed7cdda98

**分析**：
- 这个 ID 可能是 xskill 平台上的一个技能
- 可能是一个预配置的提示词模板
- 需要登录查看详细信息

**无法直接访问的原因**：
- 需要登录 xskill 账号
- 可能是用户创建的私有技能
- 可能有访问限制

---

## 💡 建议

1. **登录查看** - 在 xskill.ai 上登录查看技能详情
2. **使用已知 API** - 直接使用 API 端点
3. **创建自定义技能** - 根据需求创建自己的提示词

---

**文档版本**: v1.0
**最后更新**: 2026-03-12 16:00
