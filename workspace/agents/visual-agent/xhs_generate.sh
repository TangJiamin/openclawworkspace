#!/bin/bash
# 小红书9宫格配图生成脚本
# 使用方法: ./xhs_generate.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create visual-agent)

# 创建输出目录

echo "🎨 小红书9宫格配图生成器"
echo "================================"
echo "输出目录: $OUTPUT_DIR"
echo ""

# 配置
MODEL="jimeng-5.0"
RATIO="3:4"
RESOLUTION="2k"

# 提示词列表
declare -a PROMPTS=(
    "A fresh and bright infographic cover for Xiaohongshu, titled '5个提升效率的AI工具', balanced layout, 5 colorful icons representing AI tools, vivid blue-green gradient background, decorative stars and sparkles, clean modern design"
    "A fresh infographic card showing Notion AI icon, features: intelligent note management, auto-organization, notebook and folder icons, clean white background, vivid accent colors, minimalist design"
    "A fresh infographic showing ChatGPT icon, features: AI conversation assistant, quick content generation, chat bubbles and text icons, friendly robot character, bright green accent colors"
    "A fresh infographic showing Midjourney AI art tool, colorful art palette, magic AI brush, beautiful generated artworks, vivid rainbow colors, creative and artistic"
    "A fresh infographic showing Grammarly writing assistant, green checkmark icon, text editing interface, grammar check visualization, professional and clean, green accent colors"
    "A fresh infographic showing Todoist AI task manager, red checkmark icon, task list and calendar, smart scheduling visualization, organized and clean, red accent colors"
    "A fresh infographic showing AI workflow automation, Zapier or Make style, connecting different apps, automated workflow diagram, blue and purple colors"
    "A fresh infographic showing AI calendar scheduling, Clockwise or Reclaim style, smart time blocking, calendar interface optimization, clean and organized"
    "A fresh infographic summary page for Xiaohongshu, showcasing all 5 AI tools together, upward arrow and growth chart, encouraging text, vibrant and energetic, multi-colored, inspiring"
)

# 文件名列表
declare -a FILENAMES=(
    "xhs_ai_tools_01_cover.jpg"
    "xhs_ai_tools_02_notion.jpg"
    "xhs_ai_tools_03_chatgpt.jpg"
    "xhs_ai_tools_04_midjourney.jpg"
    "xhs_ai_tools_05_grammarly.jpg"
    "xhs_ai_tools_06_todoist.jpg"
    "xhs_ai_tools_07_automation.jpg"
    "xhs_ai_tools_08_calendar.jpg"
    "xhs_ai_tools_09_summary.jpg"
)

# 检查 API Key
if [ -z "$XSKILL_API_KEY" ]; then
    echo "❌ 错误: 未设置 API Key"
    echo "请设置环境变量: export XSKILL_API_KEY=\"sk-your-api-key\""
    exit 1
fi

echo "📋 生成计划"
echo "   模型: $MODEL"
echo "   比例: $RATIO"
echo "   分辨率: $RESOLUTION"
echo "   图片数量: ${#PROMPTS[@]}张"
echo ""

# 生成函数
generate_image() {
    local index=$1
    local prompt=$2
    local filename=$3

    echo "📤 生成第 $((index + 1))/${#PROMPTS[@]} 张: $filename"

    # 使用 xskill_call_fixed.sh
    bash "${SCRIPT_DIR}/xskill_call_fixed.sh" "$MODEL" "$prompt" --ratio "$RATIO" --resolution "$RESOLUTION" > "${OUTPUT_DIR}/temp_${index}.txt" 2>&1

    # 提取图片URL
    if grep -q "图片URL:" "${OUTPUT_DIR}/temp_${index}.txt"; then
        local image_url=$(grep "图片URL:" "${OUTPUT_DIR}/temp_${index}.txt" | sed 's/.*图片URL: //')

        # 下载图片
        echo "   下载图片: $image_url"
        curl -s -o "${OUTPUT_DIR}/${filename}" "$image_url"

        if [ -f "${OUTPUT_DIR}/${filename}" ]; then
            local size=$(stat -c%s "${OUTPUT_DIR}/${filename}" 2>/dev/null || stat -f%z "${OUTPUT_DIR}/${filename}" 2>/dev/null)
            echo "   ✅ 保存成功: ${filename} (${size} bytes)"
        else
            echo "   ❌ 下载失败"
        fi
    else
        echo "   ❌ 生成失败"
        cat "${OUTPUT_DIR}/temp_${index}.txt"
    fi

    echo ""
}

# 主循环
for i in "${!PROMPTS[@]}"; do
    generate_image "$i" "${PROMPTS[$i]}" "${FILENAMES[$i]}"

    # 避免API限流
    if [ $i -lt $((${#PROMPTS[@]} - 1)) ]; then
        echo "⏳ 等待 3 秒..."
        sleep 3
    fi
done

# 清理临时文件
rm -f "${OUTPUT_DIR}"/temp_*.txt

echo ""
echo "🎉 生成完成！"
echo "📁 输出目录: $OUTPUT_DIR"
echo ""
echo "📊 生成统计:"
cd "$OUTPUT_DIR"
ls -lh *.jpg 2>/dev/null || echo "未找到生成的图片"
