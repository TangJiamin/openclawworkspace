#!/bin/bash
# visual-generator 参数转提示词脚本

# 风格映射
style_to_description() {
    local style=$1
    case $style in
        cute)
            echo "cute and adorable style, soft pastel colors, kawaii elements, playful and charming"
            ;;
        fresh)
            echo "fresh and bright style, natural lighting, clean and airy, vibrant and energetic"
            ;;
        warm)
            echo "warm and cozy style, soft gentle colors, friendly and approachable, comforting atmosphere"
            ;;
        bold)
            echo "bold and striking style, high contrast, strong vibrant colors, powerful visual impact"
            ;;
        minimal)
            echo "minimalist style, clean and simple, plenty of white space, elegant and refined"
            ;;
        technical)
            echo "technical style, blueprint aesthetic, engineering diagrams, precise and structured"
            ;;
        corporate)
            echo "professional corporate style, business formal, clean and organized, trustworthy and reliable"
            ;;
        elegant)
            echo "elegant and sophisticated style, premium quality, luxurious textures, refined and classy"
            ;;
        dark)
            echo "dark tech style, mysterious atmosphere, neon accents, futuristic and cyberpunk"
            ;;
        *)
            echo "modern and clean style"
            ;;
    esac
}

# 布局映射
layout_to_description() {
    local layout=$1
    case $layout in
        sparse)
            echo "sparse layout with 1-2 key points, minimalist composition, clean and focused"
            ;;
        balanced)
            echo "balanced layout with 3-4 points, well-organized structure, harmonious arrangement"
            ;;
        dense)
            echo "dense layout with 5-8 points, information-rich design, comprehensive coverage"
            ;;
        list)
            echo "list layout with ranking, clear numbering structure, organized vertical flow, easy to scan"
            ;;
        comparison)
            echo "comparison layout with two sides, side-by-side structure, clear contrast and comparison"
            ;;
        flow)
            echo "flow chart layout, step-by-step process, directional arrows, clear progression"
            ;;
        pyramid)
            echo "pyramid layout, hierarchical structure, layered organization, clear levels"
            ;;
        mind-map)
            echo "mind map layout, radiating structure, connected ideas, brainstorming format"
            ;;
        *)
            echo "clean and organized layout"
            ;;
    esac
}

# 色彩映射
palette_to_description() {
    local palette=$1
    case $palette in
        vivid)
            echo "vivid and saturated colors, high energy, eye-catching and bold"
            ;;
        pastel)
            echo "soft pastel colors, gentle and soothing, subtle and elegant"
            ;;
        monochrome)
            echo "monochrome color scheme, single tone, clean and unified"
            ;;
        complementary)
            echo "complementary colors, strong contrast, dynamic and vibrant"
            ;;
        dopamine)
            echo "dopamine color scheme, bright happy colors, cheerful and uplifting"
            ;;
        *)
            echo "balanced and harmonious colors"
            ;;
    esac
}

# 组合生成提示词
generate_prompt() {
    local style=$1
    local layout=$2
    local palette=$3
    local content_description=$4

    local style_desc=$(style_to_description "$style")
    local layout_desc=$(layout_to_description "$layout")
    local palette_desc=$(palette_to_description "$palette")

    # 组合提示词
    local prompt="A $style_desc infographic with $layout_desc, $palette_desc. "

    if [ -n "$content_description" ]; then
        prompt="$prompt$content_description. "
    fi

    prompt="${prompt%. }"

    echo "$prompt"
}

# 主函数
main() {
    if [ $# -lt 3 ]; then
        echo "使用方法: $0 <style> <layout> <palette> [content_description]"
        echo ""
        echo "示例:"
        echo "  $0 fresh list vivid \"showcasing 5 AI tools for productivity\""
        exit 1
    fi

    local style=$1
    local layout=$2
    local palette=$3
    local content_description=${4:-""}

    local prompt=$(generate_prompt "$style" "$layout" "$palette" "$content_description")

    echo "$prompt"
}

main "$@"
