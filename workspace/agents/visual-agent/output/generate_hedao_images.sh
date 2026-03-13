#!/bin/bash
# 合道文化品牌视频图片生成脚本

# 加载环境变量（从 .env 文件读取）
set -a
source /home/node/.openclaw/.env 2>/dev/null || true

API_BASE_URL="https://api.xskill.ai/api/v3"
API_KEY="${XSKILL_API_KEY}"
OUTPUT_DIR="/home/node/.openclaw/workspace/agents/visual-agent/output/合道文化"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 7张图片的提示词
declare -A PROMPTS=(
    [1]="极简主义黑白风格，深黑背景，白色圆点逐一浮现，混沌初开，深邃神圣，东方美学，河图洛书元素，宇宙秩序，抽象艺术"
    [2]="极简主义，黑白灰色调，白色圆点有序排列，河图洛书图案，智慧之源，东方美学，对称平衡，神圣感"
    [3]="黑白风格加朱红色点缀，流动线条串联白色圆点，形成连接，动态流动，东方美学，河图洛书，生命力"
    [4]="黑白风格加黛蓝色点缀，圆点和线条形成螺旋形态，生生不息，动态平衡，东方美学，宇宙秩序，能量流动"
    [5]="黑白风格加朱红黛蓝点缀，螺旋中能量流转，视觉化宇宙秩序，深邃神圣，东方美学，智慧光芒，动态平衡"
    [6]="极简主义东方美学，合道文化品牌标识，Logo设计，黑白灰色调，对称平衡，高级感，文化传承"
    [7]="极简主义黑白风格，东方智慧视觉化表达，深邃神圣，河图洛书元素，宇宙秩序，理念展现，文化传承"
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
    local price=$(echo "$response" | jq -r '.data.price')

    echo "   任务ID: $task_id"

    # 轮询任务状态
    local max_attempts=60
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        sleep 2
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
                echo "   URL: $image_url"

                # 下载图片
                local filename="合道文化_图片${index}.jpg"
                curl -s -o "${OUTPUT_DIR}/${filename}" "$image_url"

                if [ -f "${OUTPUT_DIR}/${filename}" ]; then
                    echo "   已保存: ${filename}"
                    return 0
                else
                    echo "❌ 下载失败"
                    return 1
                fi
            fi
        elif [ "$status" = "failed" ] || [ "$status" = "error" ]; then
            echo "❌ 图片 ${index} 生成失败"
            return 1
        fi

        if [ $((attempt % 10)) -eq 0 ]; then
            echo "   等待中... ($((attempt * 2))s)"
        fi
    done

    echo "❌ 图片 ${index} 生成超时"
    return 1
}

# 主流程
main() {
    echo "🎨 合道文化品牌视频 - 图片生成"
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
