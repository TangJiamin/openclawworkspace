#!/bin/bash
# 合道文化品牌视频图片生成脚本（简化版）

# 加载 .env 文件
set -a
source /home/node/.openclaw/.env 2>/dev/null || true

API_BASE_URL="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY}"
OUTPUT_DIR="/home/node/.openclaw/workspace/agents/visual-agent/output/合道文化"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 7张图片的提示词（简化版，提高生成速度）
declare -A PROMPTS=(
    [1]="黑白极简，白色圆点浮现在深黑背景，东方美学"
    [2]="极简主义，白色圆点有序排列，黑白灰，东方美学"
    [3]="黑白加朱红，流动线条连接圆点，东方美学"
    [4]="黑白加黛蓝，圆点形成螺旋，生生不息"
    [5]="黑白加朱红黛蓝，螺旋能量流转，深邃神圣"
    [6]="极简东方美学，合道文化Logo，黑白灰"
    [7]="黑白极简，东方智慧视觉化，深邃神圣"
)

# 生成单张图片
generate_image() {
    local index=$1
    local prompt=$2

    echo "📸 生成图片 ${index}/7..."

    # 构建请求
    local payload=$(cat <<EOF
{
    "model": "jimeng-5.0",
    "params": {
        "prompt": "${prompt}",
        "ratio": "16:9",
        "resolution": "2k"
    }
}
EOF
)

    # 创建任务
    local response=$(curl -s -X POST "${API_BASE_URL}/tasks/create" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_KEY}" \
        -d "$payload")

    local code=$(echo "$response" | jq -r '.code // empty')

    if [ "$code" != "200" ]; then
        echo "❌ 图片 ${index} 创建任务失败: $response"
        return 1
    fi

    local task_id=$(echo "$response" | jq -r '.data.task_id')
    echo "   任务ID: $task_id"

    # 轮询任务状态（增加超时时间）
    local max_attempts=120
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        sleep 3
        attempt=$((attempt + 1))

        local query_response=$(curl -s -X POST "${API_BASE_URL}/tasks/query" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${API_KEY}" \
            -d "{\"task_id\": \"$task_id\"}")

        local status=$(echo "$query_response" | jq -r '.data.status // empty')

        if [ "$status" = "completed" ] || [ "$status" = "success" ]; then
            local image_url=$(echo "$query_response" | jq -r '.data.result.output.images[0] // empty')

            if [ -n "$image_url" ]; then
                echo "✅ 图片 ${index} 生成成功"

                # 下载图片
                local filename="合道文化_图片${index}.jpg"
                curl -s -o "${OUTPUT_DIR}/${filename}" "$image_url"

                if [ -f "${OUTPUT_DIR}/${filename}" ]; then
                    local filesize=$(stat -f%z "${OUTPUT_DIR}/${filename}" 2>/dev/null || stat -c%s "${OUTPUT_DIR}/${filename}" 2>/dev/null)
                    echo "   已保存: ${filename} (${filesize} bytes)"
                    return 0
                else
                    echo "❌ 下载失败"
                    return 1
                fi
            fi
        elif [ "$status" = "failed" ] || [ "$status" = "error" ]; then
            echo "❌ 图片 ${index} 生成失败: $query_response"
            return 1
        fi

        if [ $((attempt % 20)) -eq 0 ]; then
            echo "   等待中... ($((attempt * 3))s)"
        fi
    done

    echo "❌ 图片 ${index} 生成超时"
    return 1
}

# 主流程
main() {
    echo "🎨 合道文化品牌视频 - 图片生成（简化版）"
    echo "================================"
    echo ""

    local success_count=0
    local total=7

    for i in $(seq 1 $total); do
        if generate_image "$i" "${PROMPTS[$i]}"; then
            success_count=$((success_count + 1))
        fi
        echo ""
    done

    echo "================================"
    echo "📊 生成完成: $success_count/$total"
    echo "📁 保存位置: $OUTPUT_DIR"

    if [ $success_count -eq $total ]; then
        echo "✅ 全部图片生成成功！"
        return 0
    else
        echo "⚠️  部分图片生成失败"
        return 1
    fi
}

main
