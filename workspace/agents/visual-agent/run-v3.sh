#!/bin/bash
# visual-agent - 脚本版本 v3.0
# 直接调用 xskill API 生成图片

set -e

# 配置
API_BASE="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY}"

# 主流程
main() {
    local task_spec="$1"

    echo "📝 任务规范: $task_spec" >&2

    # 直接生成提示词（不使用 Node.js）
    local style=$(echo "$task_spec" | jq -r '.style')
    local description=$(echo "$task_spec" | jq -r '.scenes[0].description')
    local prompt="${description}, ${style} style, cinematic, high quality, 9:16"

    echo "✅ 提示词: $prompt" >&2

    # 创建任务
    echo "🚀 创建任务..." >&2
    local response=$(curl -s -X POST "${API_BASE}/tasks/create" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_KEY}" \
        -d "{
            \"model\": \"jimeng-5.0\",
            \"params\": {
                \"prompt\": \"${prompt}\"
            }
        }")

    local task_id=$(echo "$response" | jq -r '.data.task_id')
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
        echo "⏳ 任务状态: $status ($((attempt + 1))/$max_attempts)" >&2

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

        sleep 3
        attempt=$((attempt + 1))
    done

    echo "❌ 任务超时" >&2
    return 1
}

# 执行
main "$@"
