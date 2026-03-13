#!/bin/bash

# novel-to-script 调用脚本
# 将小说/网文转换为标准漫剧剧本格式

# 使用方法
usage() {
    echo "小说转剧本工具"
    echo ""
    echo "使用方法:"
    echo "  $0 <novel_file> <output_file>"
    echo ""
    echo "参数:"
    echo "  novel_file  : 小说文件路径"
    echo "  output_file: 剧本输出文件路径"
    echo ""
    echo "示例:"
    echo "  $0 \"novel.txt\" \"script.txt\""
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

NOVEL_FILE="$1"
OUTPUT_FILE="$2"

echo "📖 小说转剧本"
echo "========================================"
echo ""
echo "📄 小说文件: $NOVEL_FILE"
echo "📝 输出文件: $OUTPUT_FILE"
echo ""

# 检查文件是否存在
if [ ! -f "$NOVEL_FILE" ]; then
    echo "❌ 错误: 小说文件不存在"
    exit 1
fi

# 读取小说内容
novel_content=$(cat "$NOVEL_FILE")

# 输出剧本格式
cat > "$OUTPUT_FILE" << 'EOF'
作品名：(请填写)
题材：(请填写)
类型：(漫剧/短剧/短视频)
简略梗概：(请填写)

主要出场人物
  - 主角：(请填写)
  - 其他角色：(请填写)

人物简要描述
  - 角色名：(简要描述)

受众：(目标受众)
情绪承诺（主）：打脸爽/逆袭爽/虐爽/恐惧爽/治愈爽（只选1）

本集一句话：主角为了【目标】在【规则/限制】下，被【对手/压力】逼到【困境】，最后【变化】并引出【续看问题】
钩子：(前10秒抓手)
增量：(每30-60秒的增量点)
反转/兑现：(情绪兑现)
续看：(悬念)

---

EOF

echo "✅ 剧本文件已创建: $OUTPUT_FILE"
echo ""
echo "📋 下一步:"
echo "1. 完善剧本头部信息（作品名、题材、角色等）"
echo "2. 按照四段式节奏规划拆分场景"
echo "3. 使用 storyboard-generator 生成分镜"
echo ""
echo "========================================"
echo "✅ 完成"
