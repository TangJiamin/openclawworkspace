#!/bin/bash
# visual-agent - 脚本版本 v4.0（最终版）
# 直接调用 xskill API 生成图片

set -e

# 配置
API_BASE="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY}"

# 主流程
main() {
    local task_json="$1"

    # 解析任务规范
    local style=$(echo "$task_json" | jq -r '.style')
    local desc=$(echo "$task_json" | jq -r '.scenes[0].description')
    local prompt="${desc}, ${style} style, cinematic, high quality, 9:16"

    echo "✅ 提示词: $prompt" >&2

    # 创建任务（使用更安全的 JSON 构建）
    local prompt_escaped=$(echo "$prompt" | jq -Rs .)
    local json_payload=$(cat <<EOF
{
  "model": "jimeng-5.0",
  "params": {
    "prompt": ${prompt_escaped}
  }
}
EOF
)

    echo "🚀 创建任务..." >&2
    local response=$(curl -s -X POST "${API_BASE}/tasks/create" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_KEY}" \
        -d "$json_payload")

    echo "📋 API 响应: $response" >&2

    local task_id=$(echo "$response" | jq -r '.data.task_id')

    if [ "$task_id" = "null" ] || [ -z "$task_id" ]; then
        echo "❌ 任务创建失败" >&2
        echo "$response" >&2
        return 1
    fi

    echo "✅ 任务 ID: $task_id" >&2

    # 等待完成
    echo "⏳ 等待生成..." >&2
    local attempt=0
    local max_attempts=60

    while [ $attempt -lt $max_attempts ]; do
        local result=$(curl -s -X POST "${API_BASE}/tasks/query" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${API_KEY}" \
            -d "{\"task_id\": \"${task_id}\"}")

        local status=$(echo "$result" | jq -r '.data.status')

        if [ "$status" = "completed" ] || [ "$status" = "success" ]; then
            local url=$(echo "$result" | jq -r '.data.output.images[0].url')
            echo "✅ 图片 URL: $url" >&2
            echo "$url"
            return 0
        fi

        if [ "$status" = "failed" ]; then
            echo "❌ 任务失败" >&2
            echo "$result" >&2
            return 1
        fi

        echo "⏳ 任务状态: $status ($((attempt + 1))/$max_attempts)" >&2
        sleep 3
        attempt=$((attempt + 1))
    done

    echo "❌ 任务超时" >&2
    return 1
}

# 执行
main "$@"
