#!/bin/bash
# visual-generator 主生成脚本（v3.0 - 智能模型选择）

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 使用方法
usage() {
    echo "visual-generator v3.0 - 智能视觉生成器"
    echo ""
    echo "使用方法:"
    echo "  $0 \"<content>\" [options]"
    echo ""
    echo "选项:"
    echo "  --model <model>        指定模型（jimeng-5.0/flux-realism）"
    echo "  --style <style>        风格 (fresh/bold/minimal/technical/warm/elegant)"
    echo "  --layout <layout>      布局 (sparse/balanced/dense/list)"
    echo "  --palette <palette>    色彩 (vivid/pastel/monochrome)"
    echo "  --ratio <ratio>        图像比例（仅 jimeng-5.0）"
    echo "  --resolution <res>     分辨率（2k/4k）"
    echo ""
    echo "示例:"
    echo "  $0 \"小红书封面，5个AI工具\""
    echo "  $0 \"商业广告\" --model \"flux-realism\""
    echo "  $0 \"产品渲染\" --style technical --ratio \"3:4\""
    exit 1
}

# 参数解析
CONTENT=""
MODEL=""
STYLE=""
LAYOUT=""
PALETTE=""
RATIO=""
RESOLUTION=""

if [ $# -lt 1 ]; then
    usage
fi

CONTENT="$1"
shift

while [[ $# -gt 0 ]]; do
    case $1 in
        --model)
            MODEL="$2"
            shift 2
            ;;
        --style)
            STYLE="$2"
            shift 2
            ;;
        --layout)
            LAYOUT="$2"
            shift 2
            ;;
        --palette)
            PALETTE="$2"
            shift 2
            ;;
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

# 智能模型选择
select_model() {
    local content=$1
    local user_model=$2

    # 用户指定模型
    if [ -n "$user_model" ]; then
        echo "$user_model"
        return
    fi

    # 智能选择（基于关键词）
    if echo "$content" | grep -qiE "商业|广告|产品|product|commercial"; then
        echo "fal-ai/flux-realism"
    elif echo "$content" | grep -qiE "肖像|人物|portrait|headshot"; then
        echo "fal-ai/flux-realism"
    elif echo "$content" | grep -qiE "视频|video|抖音|douyin"; then
        echo "fal-ai/bytedance/seedance/v1.5/pro/text-to-video"
    else
        echo "jimeng-5.0"
    fi
}

# 智能参数推荐
recommend_params() {
    local content=$1

    # 如果没有指定参数，进行智能推荐
    if [ -z "$STYLE" ]; then
        if echo "$content" | grep -qiE "教程|指南|步骤|tutorial"; then
            STYLE="fresh"
        elif echo "$content" | grep -qiE "科技|技术|ai|人工智能"; then
            STYLE="technical"
        elif echo "$content" | grep -qiE "可爱|萌|治愈|cute"; then
            STYLE="warm"
        else
            STYLE="fresh"
        fi
    fi

    if [ -z "$LAYOUT" ]; then
        if echo "$content" | grep -qiE "推荐|排名|top|榜单"; then
            LAYOUT="list"
        elif echo "$content" | grep -qiE "教程|步骤|流程"; then
            LAYOUT="flow"
        elif echo "$content" | grep -qiE "对比|区别|vs"; then
            LAYOUT="comparison"
        else
            LAYOUT="balanced"
        fi
    fi

    if [ -z "$PALETTE" ]; then
        if echo "$content" | grep -qiE "小红书|xhs|多巴胺"; then
            PALETTE="vivid"
        elif echo "$content" | grep -qiE "治愈|温馨|柔和"; then
            PALETTE="pastel"
        else
            PALETTE="vivid"
        fi
    fi
}

# 主流程
main() {
    echo "🎨 Visual Generator v3.0"
    echo "   内容: $CONTENT"
    echo ""

    # 1. 智能参数推荐
    recommend_params "$CONTENT"
    echo "📊 推荐参数: style=$STYLE, layout=$LAYOUT, palette=$PALETTE"

    # 2. 智能模型选择
    SELECTED_MODEL=$(select_model "$CONTENT" "$MODEL")
    echo "🎯 选择模型: $SELECTED_MODEL"
    echo ""

    # 3. 生成提示词
    PROMPT=$("${SCRIPT_DIR}/params_to_prompt.sh" "$STYLE" "$LAYOUT" "$PALETTE" "$CONTENT")
    echo "✨ 生成提示词: ${PROMPT:0:100}..."
    echo ""

    # 4. 调用 API 生成
    echo "📤 调用 API 生成..."

    # 构建参数
    API_ARGS="--prompt \"$PROMPT\""

    if [[ "$SELECTED_MODEL" == *"jimeng"* ]]; then
        API_ARGS="$API_ARGS --ratio \"${RATIO:-3:4}\" --resolution \"${RESOLUTION:-2k}\""
    elif [[ "$SELECTED_MODEL" == *"flux-realism"* ]]; then
        API_ARGS="$API_ARGS --resolution \"${RESOLUTION:-square_hd}\""
    fi

    # 调用统一 API
    eval "${SCRIPT_DIR}/xskill_call.sh \"$SELECTED_MODEL\" $API_ARGS"
}

main
