#!/bin/bash
# jimeng-5.0 图片生成工具（严格遵循 Codex 测试脚本格式）
# 严格遵守 API Key 安全原则：.env 文件是唯一来源

# 加载 .env 文件（唯一来源）
set -a
source /home/node/.openclaw/.env 2>/dev/null || true

# API 配置
CREATE_URL="https://api.xskill.ai/api/v3/tasks/create"
QUERY_URL="https://api.xskill.ai/api/v3/tasks/query"
API_KEY="${XSKILL_API_KEY}"

# 成功状态
SUCCESS_STATUSES=("completed" "success")
FAIL_STATUSES=("failed" "error")

# 使用方法
usage() {
    echo "🎨 jimeng-5.0 图片生成工具（严格遵循官方格式）"
    echo ""
    echo "使用方法:"
    echo "  $0 \"<prompt>\""
    echo ""
    echo "示例:"
    echo "  $0 \"A beautiful sunset over the ocean\""
    echo "  $0 \"一只可爱的猫咪\""
    exit 1
}

# 参数解析
if [ $# -lt 1 ]; then
    usage
fi

PROMPT="$1"

# 检查 API Key（从 .env 文件读取）
if [ -z "$API_KEY" ]; then
    echo "❌ 错误: 未设置 XSKILL_API_KEY"
    echo "请在 .env 文件中设置: XSKILL_API_KEY=sk-your-api-key"
    exit 1
fi

echo "🎨 jimeng-5.0 图片生成"
echo "   提示词: $PROMPT"
echo ""

# Step 1: 创建任务（严格遵循 Codex 格式）
echo "📤 创建任务..."

# 构建请求头
headers=(
    -H "Content-Type: application/json"
    -H "Authorization: Bearer $API_KEY"
)

# 构建 payload（严格遵循 Codex 格式：只传递 prompt）
payload=$(jq -n \
    --arg model "jimeng-5.0" \
    --arg prompt "$PROMPT" \
    '{
        model: $model,
        params: {prompt: $prompt},
        channel: null
    }')

echo "Payload: $payload" | jq '.' 2>/dev/null || echo "$payload"
echo ""

# 创建任务
response=$(curl -s -X POST "$CREATE_URL" \
    "${headers[@]}" \
    -d "$payload")

# 显示完整响应
echo "Task create response:"
echo "$response" | jq '.' 2>/dev/null || echo "$response"
echo ""

# 解析响应
code=$(echo "$response" | jq -r '.code // empty')

if [ "$code" != "200" ]; then
    echo "❌ 创建任务失败"
    exit 1
fi

task_id=$(echo "$response" | jq -r '.data.task_id // empty')

if [ -z "$task_id" ] || [ "$task_id" = "null" ]; then
    echo "❌ 未获取到 task_id"
    exit 1
fi

echo "✅ 任务创建成功"
echo "   任务ID: $task_id"
echo ""

# Step 2: 轮询任务状态
echo "⏳ 轮询任务状态..."
started_at=$(date +%s)
timeout=300
interval=2
last_status=""

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - started_at))
    
    if [ $elapsed -gt $timeout ]; then
        echo "❌ 超时（${timeout}秒）"
        exit 1
    fi
    
    # 查询任务
    query_response=$(curl -s -X POST "$QUERY_URL" \
        "${headers[@]}" \
        -d "{\"task_id\": \"$task_id\"}")
    
    # 解析状态
    status=$(echo "$query_response" | jq -r '.data.status // empty')
    
    if [ -n "$status" ] && [ "$status" != "$last_status" ]; then
        echo "   状态: $status"
        last_status="$status"
    fi
    
    # 检查是否成功
    for success_status in "${SUCCESS_STATUSES[@]}"; do
        if [ "$status" = "$success_status" ]; then
            echo "✅ 任务完成"
            
            # 显示结果
            result=$(echo "$query_response" | jq -r '.data.result // .data')
            echo "任务结果:"
            echo "$result" | jq '.' 2>/dev/null || echo "$result"
            
            exit 0
        fi
    done
    
    # 检查是否失败
    for fail_status in "${FAIL_STATUSES[@]}"; do
        if [ "$status" = "$fail_status" ]; then
            echo "❌ 任务失败"
            error=$(echo "$query_response" | jq -r '.data.error // "未知错误"')
            echo "错误信息: $error"
            exit 1
        fi
    done
    
    # 等待后重试
    sleep $interval
done
