#!/bin/bash

# Seedance 图生视频脚本
# 模型: fal-ai/bytedance/seedance/v1.5/pro/image-to-video

# 配置
API_BASE_URL="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY:-}"
POLL_INTERVAL=5
MAX_POLL_ATTEMPTS=60

# 使用方法
usage() {
    echo "Seedance 图生视频工具"
    echo ""
    echo "使用方法:"
    echo "  $0 <image_url> <prompt> <duration>"
    echo ""
    echo "参数:"
    echo "  image_url  : 参考图片URL"
    echo "  prompt     : 视频风格描述"
    echo "  duration   : 视频时长（4-12秒）"
    echo ""
    echo "示例:"
    echo "  $0 \"https://example.com/image.jpg\" \"科技感，数据流动\" \"5\""
    exit 1
}

# 参数解析
if [ $# -lt 3 ]; then
    usage
fi

IMAGE_URL="$1"
PROMPT="$2"
DURATION="$3"

# 检查 API Key
if [ -z "$API_KEY" ]; then
    echo "❌ 错误: 未设置 API Key"
    echo "请设置环境变量: export XSKILL_API_KEY=\"sk-your-api-key\""
    exit 1
fi

# 创建任务
create_task() {
    echo "📤 创建 Seedance 图生视频任务..."
    echo "   图片URL: $IMAGE_URL"
    echo "   提示词: $PROMPT"
    echo "   时长: ${DURATION}秒"

    local response=$(curl -s -X POST "${API_BASE_URL}/tasks/create" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "{
            \"model\": \"fal-ai/bytedance/seedance/v1.5/pro/image-to-video\",
            \"params\": {
                \"prompt\": \"$PROMPT\",
                \"image_url\": \"$IMAGE_URL\",
                \"duration\": \"$DURATION\"
            }
        }")

    local code=$(echo "$response" | jq -r '.code // empty')

    if [ "$code" != "200" ]; then
        echo "❌ 创建任务失败"
        echo "响应: $response"
        exit 1
    fi

    local task_id=$(echo "$response" | jq -r '.data.task_id')
    local price=$(echo "$response" | jq -r '.data.price')
    local balance=$(echo "$response" | jq -r '.data.balance')

    echo "✅ 任务创建成功"
    echo "   任务ID: $task_id"
    echo "   消耗积分: $price"
    echo "   剩余积分: $balance"
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
        local status=$(echo "$response" | jq -r '.data.status // empty')

        if [ -z "$status" ]; then
            echo "❌ 查询任务失败"
            exit 1
        fi

        if [ "$status" = "completed" ] || [ "$status" = "success" ]; then
            echo "✅ 任务完成"
            
            # 提取结果（修复URL路径）
            local video_url=$(echo "$response" | jq -r '.data.result.output.video.url // .data.result.output.videos[0].url // empty')
            
            if [ -n "$video_url" ]; then
                echo ""
                echo "🔗 视频URL: $video_url"
            else
                echo "❌ 未获取到视频URL"
            fi
            
            return 0
        fi

        if [ "$status" = "failed" ] || [ "$status" = "error" ]; then
            echo "❌ 任务失败"
            local error=$(echo "$response" | jq -r '.data.error // "未知错误"')
            echo "错误信息: $error"
            exit 1
        fi

        # 任务进行中
        echo "   状态: $status ($((attempt * POLL_INTERVAL))s)"
        sleep $POLL_INTERVAL
        attempt=$((attempt + 1))
    done

    echo "❌ 超时（超过${MAX_POLL_ATTEMPTS}次查询）"
    exit 1
}

# 主流程
main() {
    task_id=$(create_task)
    poll_task "$task_id"
}

main
