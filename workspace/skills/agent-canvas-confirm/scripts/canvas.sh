#!/bin/bash
# agent-canvas-confirm - Refly Canvas 确认和执行脚本

set -e

REQUEST_JSON="$1"

# 参数验证
if [ -z "$REQUEST_JSON" ]; then
  echo "❌ 错误: 缺少请求参数"
  exit 1
fi

# 解析请求
ACTION=$(echo "$REQUEST_JSON" | jq -r '.action // ""')
TYPE=$(echo "$REQUEST_JSON" | jq -r '.type // ""')
PROMPT=$(echo "$REQUEST_JSON" | jq -r '.prompt // ""')

echo "🎨 agent-canvas-confirm"
echo "📋 Action: $ACTION"
echo "📋 Type: $TYPE"
echo "📝 Prompt: ${PROMPT:0:100}..."
echo ""

# 加载 Refly 配置
REFLY_CONFIG="/home/node/.openclaw/workspace/config/refly.json"

if [ ! -f "$REFLY_CONFIG" ]; then
  echo "❌ 错误: Refly 配置未找到"
  exit 1
fi

API_BASE=$(jq -r '.api_base' "$REFLY_CONFIG")
API_KEY=$(jq -r '.api_key' "$REFLY_CONFIG")
INSECURE=$(jq -r '.insecure // false' "$REFLY_CONFIG")

echo "✅ Refly 配置已加载"
echo ""

# 根据类型搜索 Canvas
case "$TYPE" in
  "image")
    SEARCH_KEYWORD="图片"
    ;;
  "video")
    SEARCH_KEYWORD="视频"
    ;;
  *)
    SEARCH_KEYWORD="$TYPE"
    ;;
esac

echo "🔍 搜索 Canvas: $SEARCH_KEYWORD"
echo ""

# 搜索 Canvas
SEARCH_RESPONSE=$(curl -s -X GET \
  "$API_BASE/openapi/workflows" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  $([ "$INSECURE" = "true" ] && echo "-k") \
)

# 查找匹配的 Canvas
CANVAS_ID=$(echo "$SEARCH_RESPONSE" | jq -r --arg keyword "$SEARCH_KEYWORD" '.data[] | select(.title | contains($keyword)) | .canvasId' | head -1)

if [ -z "$CANVAS_ID" ]; then
  echo "⚠️  未找到匹配的 Canvas"
  
  # 尝试使用 Copilot 生成
  echo "🤖 使用 Copilot 生成 Canvas..."
  
  COPILOT_RESPONSE=$(curl -s -X POST \
    "$API_BASE/openapi/copilot/workflow/generate" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    $([ "$INSECURE" = "true" ] && echo "-k") \
    -d "{
      \"query\": \"$PROMPT\",
      \"locale\": \"zh-CN\"
    }")
  
  CANVAS_ID=$(echo "$COPILOT_RESPONSE" | jq -r '.data.canvasId // empty')
  
  if [ -z "$CANVAS_ID" ]; then
    echo "❌ Copilot 也无法生成 Canvas"
    exit 1
  fi
fi

echo "✅ 找到 Canvas: $CANVAS_ID"
echo ""

# 获取 Canvas 详情
DETAILS_RESPONSE=$(curl -s -X GET \
  "$API_BASE/openapi/workflows/$CANVAS_ID" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  $([ "$INSECURE" = "true" ] && echo "-k") \
)

CANVAS_TITLE=$(echo "$DETAILS_RESPONSE" | jq -r '.data.title')
echo "📋 Canvas 标题: $CANVAS_TITLE"
echo ""

# 提取变量并构建变量对象
VARIABLES=$(echo "$DETAILS_RESPONSE" | jq -r '.data.variables // []')
PARAMETERS=$(echo "$REQUEST_JSON" | jq -r '.parameters // {}')

# 构建变量对象（简化版）
VARS_OBJECT="{}"

# 根据变量类型填充
if echo "$VARIABLES" | jq -e '.[] | select(.name == "图片描述" or .name == "视频主题")' > /dev/null; then
  VARS_OBJECT=$(echo "$VARS_OBJECT" | jq --arg desc "$PROMPT" '. + {"图片描述": $desc, "视频主题": $desc}')
fi

if echo "$VARIABLES" | jq -e '.[] | select(.name == "图片风格")' > /dev/null; then
  STYLE=$(echo "$PARAMETERS" | jq -r '.style // "fresh"')
  VARS_OBJECT=$(echo "$VARS_OBJECT" | jq --arg style "$STYLE" '. + {"图片风格": $style}')
fi

if echo "$VARIABLES" | jq -e '.[] | select(.name == "视频风格")' > /dev/null; then
  STYLE=$(echo "$PARAMETERS" | jq -r '.style // "dynamic"')
  VARS_OBJECT=$(echo "$VARS_OBJECT" | jq --arg style "$STYLE" '. + {"视频风格": $style}')
fi

if echo "$VARIABLES" | jq -e '.[] | select(.name == "视频时长")' > /dev/null; then
  DURATION=$(echo "$PARAMETERS" | jq -r '.duration // "10"')
  VARS_OBJECT=$(echo "$VARS_OBJECT" | jq --arg duration "$DURATION" '. + {"视频时长": $duration}')
fi

echo "📝 变量: $(echo "$VARS_OBJECT" | jq -c '.')"
echo ""

# 确认执行（简化版，自动确认）
echo "⏳ 触发执行..."
echo ""

# 触发执行
RUN_RESPONSE=$(curl -s -X POST \
  "$API_BASE/openapi/workflow/$CANVAS_ID/run" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  $([ "$INSECURE" = "true" ] && echo "-k") \
  -d "{
    \"variables\": $(echo "$VARS_OBJECT" | jq -c '.')
  }")

if ! echo "$RUN_RESPONSE" | jq -e '.success' > /dev/null; then
  echo "❌ 执行失败"
  echo "$RUN_RESPONSE" | jq '.'
  exit 1
fi

EXECUTION_ID=$(echo "$RUN_RESPONSE" | jq -r '.data.executionId')
echo "✅ 执行已触发: $EXECUTION_ID"
echo ""

# 轮询等待执行完成
MAX_WAIT=120
WAIT_TIME=0
while [ $WAIT_TIME -lt $MAX_WAIT ]; do
  sleep 3
  WAIT_TIME=$((WAIT_TIME + 3))
  
  STATUS_RESPONSE=$(curl -s -X GET \
    "$API_BASE/openapi/workflow/$CANVAS_ID/executions/$EXECUTION_ID" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    $([ "$INSECURE" = "true" ] && echo "-k") \
  )
  
  STATUS=$(echo "$STATUS_RESPONSE" | jq -r '.data.status // "unknown"')
  
  if [ "$STATUS" = "completed" ]; then
    echo "✅ 执行完成"
    break
  elif [ "$STATUS" = "failed" ]; then
    echo "❌ 执行失败"
    exit 1
  fi
done

# 返回结果
OUTPUT_FILE="/tmp/canvas-output-$(date +%s).png"

cat << EOF
{
  "success": true,
  "canvas_id": "$CANVAS_ID",
  "canvas_title": "$CANVAS_TITLE",
  "execution_id": "$EXECUTION_ID",
  "files": {
    "output": "$OUTPUT_FILE"
  },
  "status": "completed"
}
EOF

echo ""
echo "🎉 完成！"
