#!/bin/bash
# 标准剧本解析脚本

parse_standard_script() {
    local script_file=$1

    echo "📖 解析标准剧本: $script_file"
    echo ""

    # 提取剧本标题
    local title=$(grep "^#" "$script_file" | head -1 | sed 's/#\s*')
    echo "📜 剧本标题: $title"
    echo ""

    # 提取人物表
    echo "👥 人物表:"
    echo "```"
    grep -A 10 "^## 人物表" "$script_file" | tail -n +2 | grep -v "^##" | sed 's/^|//g' | while read -r line; do
        [ -z "$line" ] && break
        [[ "$line" =~ ^[0-9]+\." ]] && echo "$line"
    done
    echo "```"
    echo ""

    # 提取场次信息
    echo "🎬 场次列表:"
    echo "```"
    grep "^###" "$script_file" | sed 's/### //g' | while read -r scene; do
        [ -z "$scene" ] && break
        [[ "$scene" =~ 场次[0-9]+ ]] || [[ "$scene" =~ Scene[0-9]+ ]] && echo "$scene"
    done
    echo "```"
    echo ""

    # 提取镜头动作
    echo "🎬 镜头动作（部分）:"
    echo "```"
    grep -A 5 "镜头动作" "$script_file" | grep -E "^第.*场|景|^镜头" | head -20
    echo "```"
}

parse_text_script() {
    local script_file=$1

    echo "📖 解析文字描述: $script_file"
    echo ""

    # 提取标题或第一句话
    local title=$(head -5 "$script_file" | tr '\n' ' ')
    echo "📜 标题/第一句话: $title"
    echo ""

    # 分析内容结构
    echo "🔍 分析内容结构:"
    echo "   场次数: $(grep "^###" "$script_file" | wc -l) 个"
    echo "   段落数: $(grep "^第.*场" "$script_file" | wc -l) 个"
    echo "   动作数: $(grep -c "镜头动作" "$script_file" | wc -l) 个"
    echo ""

    # 提取关键信息
    echo "🔑 主要角色:"
    grep -oE "[A-Za-z]{2,}" "$script_file" | sort | uniq -c | sort -nr | head -5
    echo ""

    echo "🎯 场景推断:"
    grep -oE "[地点|场景|环境|室内|室外|天空|地面]" "$script_file" | sort | uniq -c | head -5
    echo ""

    # 识别情感基调
    echo "💭 情感基调:"
    local sentiment="中性"
    if grep -qE "(紧张|激烈|冲突)" "$script_file"; then
        sentiment="紧张/激烈"
    elif grep -qE "(温馨|治愈|幸福|快乐)" "$script_file"; then
        sentiment="温馨/治愈"
    elif grep -qE "(忧伤|难过|痛苦|悲伤)" "$script_file"; then
        sentiment="忧伤/难过"
    fi
    echo "   $sentiment"
    echo ""
}

echo "✅ 解析完成"
