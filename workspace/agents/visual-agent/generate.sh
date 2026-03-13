#!/bin/bash
# visual-agent API 调用脚本
# 由 LLM Agent 调用，执行实际的 API 请求

set -e

# 解析参数
TASK_SPEC="$1"

# 配置
API_BASE="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY}"

# 生成提示词
STYLE=$(echo "$TASK_SPEC" | jq -r '.style')
DESC=$(echo "$TASK_SPEC" | jq -r '.scenes[0].description')
PROMPT="${DESC}, ${STYLE} style, cinematic, high quality, 9:16 vertical"

echo "🎨 生成提示词: $PROMPT" >&2

# 创建任务
RESPONSE=$(curl -s -X POST "${API_BASE}/tasks/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d "{
    \"model\": \"jimeng-5.0\",
    \"params\": {
      \"prompt\": \"${PROMPT}\"
    }
  }")

TASK_ID=$(echo "$RESPONSE" | jq -r '.data.task_id')

if [ "$TASK_ID" = "null" ] || [ -z "$TASK_ID" ]; then
  echo "❌ 任务创建失败" >&2
  echo "$RESPONSE" >&2
  exit 1
fi

echo "✅ 任务 ID: $TASK_ID" >&2

# 等待完成（优化版）
echo "⏳ 等待生成..." >&2
ATTEMPT=0
MAX_ATTEMPTS=120  # 增加到 120 次（4 分钟）
SLEEP_INTERVAL=2  # 间隔 2 秒

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  RESULT=$(curl -s -X POST "${API_BASE}/tasks/query" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${API_KEY}" \
    -d "{\"task_id\": \"${TASK_ID}\"}")

  STATUS=$(echo "$RESULT" | jq -r '.data.status')

  if [ "$STATUS" = "completed" ] || [ "$STATUS" = "success" ]; then
    URL=$(echo "$RESULT" | jq -r '.data.output.images[0].url')
    echo "✅ 生成成功！图片 URL: $URL" >&2
    echo "$URL"
    exit 0
  fi

  if [ "$STATUS" = "failed" ]; then
    echo "❌ 任务失败" >&2
    echo "$RESULT" >&2
    exit 1
  fi

  echo "⏳ 状态: $STATUS ($((ATTEMPT + 1))/$MAX_ATTEMPTS)" >&2
  sleep $SLEEP_INTERVAL
  ATTEMPT=$((ATTEMPT + 1))
done

echo "❌ 任务超时（已等待 $((MAX_ATTEMPTS * SLEEP_INTERVAL)) 秒）" >&2
exit 1
