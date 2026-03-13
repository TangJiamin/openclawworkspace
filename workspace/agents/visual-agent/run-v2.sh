#!/bin/bash
# visual-agent - 脚本版本 v2.0
# 直接调用 xskill API 生成图片

set -e

# 配置
API_BASE="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY}"

# 函数：生成提示词
generate_prompt() {
    local task_spec="$1"

    # 解析任务规范并生成提示词
    echo "$task_spec" | node -e "
        const data = '';
        process.stdin.on('data', chunk => data += chunk);
        process.stdin.on('end', () => {
            const task = JSON.parse(data);
            const prompt = task.scenes.map(scene => 
                \`\${scene.description}, \${task.style} style, cinematic, high quality, 9:16\`
            ).join('; ');
            console.log(prompt);
        });
    "
}

# 函数：调用 xskill API 创建任务
create_task() {
    local prompt="$1"

    local response=$(curl -s -X POST "${API_BASE}/tasks/create" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_KEY}" \
        -d "{
            \"model\": \"jimeng-5.0\",
            \"params\": {
                \"prompt\": \"${prompt}\"
            }
        }")

    echo "$response" | jq -r '.data.task_id'
}

# 函数：查询任务状态
query_task() {
    local task_id="$1"

    local response=$(curl -s -X POST "${API_BASE}/tasks/query" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_KEY}" \
        -d "{\"task_id\": \"${task_id}\"}")

    echo "$response"
}

# 函数：等待任务完成
wait_for_completion() {
    local task_id="$1"
    local max_attempts=60
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        local result=$(query_task "$task_id")
        local status=$(echo "$result" | jq -r '.data.status')

        echo "⏳ 任务状态: $status ($((attempt + 1))/$max_attempts)" >&2

        if [ "$status" = "completed" ] || [ "$status" = "success" ]; then
            local url=$(echo "$result" | jq -r '.data.output.images[0].url')
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

# 主流程
main() {
    local task_spec="$1"

    echo "📝 任务规范: $task_spec" >&2

    # 生成提示词
    echo "🎨 生成提示词..." >&2
    local prompt=$(generate_prompt "$task_spec")
    echo "✅ 提示词: $prompt" >&2

    # 创建任务
    echo "🚀 创建任务..." >&2
    local task_id=$(create_task "$prompt")
    echo "✅ 任务 ID: $task_id" >&2

    # 等待完成
    echo "⏳ 等待生成..." >&2
    local image_url=$(wait_for_completion "$task_id")

    if [ -n "$image_url" ]; then
        echo "✅ 图片 URL: $image_url" >&2
        echo "$image_url"
    else
        echo "❌ 生成失败" >&2
        exit 1
    fi
}

# 执行
main "$@"
