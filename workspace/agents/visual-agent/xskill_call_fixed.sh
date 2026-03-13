#!/bin/bash
# Xskill 统一 API 调用工具（修复版）

# 配置
API_BASE_URL="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY:-}"
POLL_INTERVAL="${XSKILL_POLL_INTERVAL:-2}"
MAX_POLL_ATTEMPTS="${XSKILL_MAX_POLL:-60}"

# 使用方法
usage() {
    echo "Xskill 统一 API 调用工具"
    echo ""
    echo "使用方法:"
    echo "  $0 <model> <prompt> [options]"
    echo ""
    echo "模型:"
    echo "  jimeng-5.0              即梦 5.0（图像生成）"
    echo "  fal-ai/flux-realism     Flux Realism（写实图像）"
    echo ""
    echo "选项:"
    echo "  --ratio <ratio>         图像比例"
    echo "  --resolution <res>      分辨率"
    echo ""
    exit 1
}

# 参数解析
MODEL=""
PROMPT=""
RATIO=""
RESOLUTION=""

if [ $# -lt 2 ]; then
    usage
fi

MODEL="$1"
PROMPT="$2"
shift 2

while [[ $# -gt 0 ]]; do
    case $1 in
        --ratio)
            RATIO="$2"
            shift 2
            ;;
        --resolution)
            RESOLUTION="$2"
            shift 2
            ;;
        *)
            echo "❌ 未知参数: $1"
            usage
            ;;
    esac
done

# 检查 API Key
if [ -z "$API_KEY" ]; then
    echo "❌ 错误: 未设置 API Key"
    exit 1
fi

# 构建 JSON payload
build_payload() {
    # 转义特殊字符
    local escaped_prompt=$(echo "$PROMPT" | sed 's/"/\\"/g' | sed "s/'/\\'/g")

    local payload="{\"model\": \"$MODEL\", \"params\": {\"prompt\": \"$escaped_prompt\""

    if [ -n "$RATIO" ]; then
        payload="$payload, \"ratio\": \"$RATIO\""
    fi

    if [ -n "$RESOLUTION" ]; then
        payload="$payload, \"resolution\": \"$RESOLUTION\""
    fi

    payload="$payload}}"
    echo "$payload"
}

# 创建任务
create_task() {
    local payload=$(build_payload)

    echo "📤 创建任务..."
    echo "   模型: $MODEL"
    echo "   提示词: $PROMPT"
    echo "   Payload: $payload"

    local response=$(curl -s -X POST "${API_BASE_URL}/tasks/create" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "$payload")

    local code=$(echo "$response" | jq -r '.code // empty')

    if [ "$code" != "200" ]; then
        echo "❌ 创建任务失败"
        echo "响应: $response"
        exit 1
    fi

    local task_id=$(echo "$response" | jq -r '.data.task_id')
    local price=$(echo "$response" | jq -r '.data.price')

    echo "✅ 任务创建成功"
    echo "   任务ID: $task_id"
    echo "   消耗积分: $price"
    echo ""

    echo "$task_id"
}

# 查询任务状态
query_task() {
    local task_id=$1

    local response=$(curl -s -X POST "${API_BASE_URL}/tasks/query" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "{\"task_id\": \"$task_id\"}")

    echo "$response"
}

# 轮询任务直到完成
poll_task() {
    local task_id=$1
    local attempt=0

    echo "⏳ 等待任务完成..."

    while [ $attempt -lt $MAX_POLL_ATTEMPTS ]; do
        local response=$(query_task "$task_id")
        echo "DEBUG: Response = $response"
        local status=$(echo "$response" | jq -r '.data.status // empty')

        if [ -z "$status" ]; then
            echo "❌ 查询任务失败"
            echo "DEBUG: Full response = $response"
            exit 1
        fi

        if [ "$status" = "completed" ] || [ "$status" = "success" ]; then
            echo "✅ 任务完成"
            echo "$response"
            return 0
        fi

        if [ "$status" = "failed" ] || [ "$status" = "error" ]; then
            echo "❌ 任务失败"
            local error=$(echo "$response" | jq -r '.data.error // "未知错误"')
            echo "错误信息: $error"
            exit 1
        fi

        # 任务进行中
        local elapsed=$((attempt * POLL_INTERVAL))
        echo "   状态: $status (${elapsed}s)"
        sleep $POLL_INTERVAL
        attempt=$((attempt + 1))
    done

    echo "❌ 超时"
    exit 1
}

# 主流程
main() {
    task_id=$(create_task)
    result=$(poll_task "$task_id")

    # 提取结果
    local image_url=$(echo "$result" | jq -r '.data.result.output.images[0] // empty')

    if [ -n "$image_url" ]; then
        echo ""
        echo "🔗 图片URL: $image_url"
    else
        echo "❌ 未获取到结果"
        exit 1
    fi
}

main
