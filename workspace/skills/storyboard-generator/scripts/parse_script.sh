#!/bin/bash
# 剧本解析脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 使用方法
usage() {
    echo "剧本解析脚本 - 将标准剧本转换为结构化数据"
    echo ""
    echo "使用方法:"
    echo "  $0 <剧本文件>"
    echo ""
    echo "支持格式:"
    echo "  - 标准剧本（场标题、人物表、镜头动作）"
    echo "  - 文字描述（无场标题、无角色表）"
    echo "  - 大纲/概要（引导用户补充）"
    echo ""
    echo "示例:"
    echo "  $0 /path/to/script.txt"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

SCRIPT_FILE="$1"

# 检查文件是否存在
if [ ! -f "$SCRIPT_FILE" ]; then
    echo "❌ 错误: 文件不存在: $SCRIPT_FILE"
    echo ""
    echo "请检查文件路径"
    exit 1
fi

# 识别剧本类型
if grep -q "场标题" "$SCRIPT_FILE"; then
    echo "✅ 识别类型: 标准剧本"
    bash "${SCRIPT_DIR}/parse_standard_script.sh" "$SCRIPT_FILE"
elif grep -q "人物表" "$SCRIPT_FILE"; then
    echo "✅ 识别类型: 标准剧本"
    bash "${SCRIPT_DIR}/parse_standard_script.sh" "$SCRIPT_FILE"
else
    echo "⚠️  识别类型: 文字描述/大纲"
    echo ""
    echo "请提供标准格式剧本，包含："
    echo "  - 场标题"
    echo "  - 人物表"
    echo "  - 隐头动作"
    echo "  - 台词"
    echo ""
    echo "是否继续解析？(y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        bash "${SCRIPT_DIR}/parse_text_script.sh" "$SCRIPT_FILE"
    else
        echo "已取消"
    fi
fi
