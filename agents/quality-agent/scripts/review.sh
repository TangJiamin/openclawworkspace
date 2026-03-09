#!/bin/bash
# quality-agent - 质量审核脚本（v3.0 - 使用 AI 模型审核）

set -e

# 输入参数
REVIEW_TYPE="$1"  # 审核类型：requirement | research | content | visual | video
CONTENT_PATH="$2"  # 待审核内容的文件路径
CUSTOM_REQUIREMENTS="${3:-}"  # 可选：自定义质量要求

# 配置
WORKSPACE="/home/node/.openclaw/workspace/agents/quality-agent"
OUTPUT_DIR="$WORKSPACE/output"
ZHIPU_API_KEY="${ZHIPU_API_KEY:-}"
GLM_BASE_URL="https://open.bigmodel.cn/api/paas/v4/chat/completions"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 如果没有输入，显示使用说明
if [ -z "$REVIEW_TYPE" ] || [ -z "$CONTENT_PATH" ]; then
  echo "✅ quality-agent - 质量审核工具（v3.0 - AI 模型审核）"
  echo ""
  echo "使用方法: bash scripts/review.sh \"审核类型\" \"内容文件路径\" \"自定义要求（可选）\""
  echo ""
  echo "支持的审核类型:"
  echo "  requirement - 需求审核（使用 AI 分析）"
  echo "  research    - 资料审核（使用 AI 分析）"
  echo "  content     - 文案审核（使用 AI 分析）"
  echo "  visual      - 图片审核（使用 AI 分析）"
  echo "  video       - 视频审核（使用 AI 分析）"
  echo ""
  echo "示例:"
  echo "  bash scripts/review.sh \"requirement\" \"/path/to/requirement.md\""
  echo "  bash scripts/review.sh \"content\" \"/path/to/content.md\""
  echo "  bash scripts/review.sh \"visual\" \"/path/to/visual.md\""
  exit 1
fi

echo "✅ 开始质量审核..."
echo "   审核类型: $REVIEW_TYPE"
echo "   内容文件: $CONTENT_PATH"
echo "   审核方式: AI 模型（GLM-4-Plus）"
echo ""

# 检查内容文件是否存在
if [ ! -f "$CONTENT_PATH" ]; then
  echo "❌ 错误: 内容文件不存在"
  echo "   路径: $CONTENT_PATH"
  exit 1
fi

# 检查 API Key
if [ -z "$ZHIPU_API_KEY" ]; then
  echo "❌ 错误: 未配置 ZHIPU_API_KEY"
  echo "   请在 .env 文件中配置：ZHIPU_API_KEY=your-api-key"
  exit 1
fi

# 读取内容文件
CONTENT=$(cat "$CONTENT_PATH")

# ============================================
# 根据审核类型，生成不同的 Prompt
# ============================================

case "$REVIEW_TYPE" in
  requirement)
    PROMPT="你是一个专业的需求分析师。请审核以下需求文档，从以下维度进行评价（每个维度 0-100 分）：
    
1. **需求完整性**（35%）：是否包含平台信息、主题描述、风格要求
2. **需求清晰度**（35%）：需求是否明确、无歧义、可执行
3. **需求可实现性**（30%）：技术可行性、资源充足性、时间合理性

请给出：
- 各维度的评分（0-100）
- 总体评分（加权平均）
- 发现的问题
- 改进建议

待审核的需求文档：
"""
$CONTENT
"""
"
    ;;
    
  research)
    PROMPT="你是一个专业的资料评估师。请审核以下资料收集结果，从以下维度进行评价（每个维度 0-100 分）：

1. **时效性**（30%）：90% 以上内容为 24 小时内
2. **相关性**（30%）：95% 以上内容与 AI 相关
3. **价值密度**（25%）：平均综合评分 ≥ 7.5
4. **覆盖面**（15%）：至少 3 个 AI 子领域

请给出：
- 各维度的评分（0-100）
- 总体评分（加权平均）
- 发现的问题
- 改进建议

待审核的资料：
"""
$CONTENT
"""
"
    ;;
    
  content)
    PROMPT="你是一个专业的文案编辑。请审核以下文案内容，从以下维度进行评价（每个维度 0-100 分）：

1. **文案质量**（35%）：连贯性、准确性、吸引力
2. **平台适配性**（25%）：是否符合平台特性
3. **风格匹配度**（25%）：是否符合用户要求
4. **长度适宜性**（15%）：长度是否适中

请给出：
- 各维度的评分（0-100）
- 总体评分（加权平均）
- 发现的问题
- 改进建议

待审核的文案：
"""
$CONTENT
"""
"
    ;;
    
  visual)
    PROMPT="你是一个专业的视觉设计师。请审核以下图片生成方案，从以下维度进行评价（每个维度 0-100 分）：

1. **清晰度**（30%）：图片是否清晰
2. **风格匹配度**（30%）：是否与文案匹配
3. **平台适配性**（25%）：是否符合平台特性
4. **视觉吸引力**（15%）：是否有吸引力

请给出：
- 各维度的评分（0-100）
- 总体评分（加权平均）
- 发现的问题
- 改进建议

待审核的图片方案：
"""
$CONTENT
"""
"
    ;;
    
  video)
    PROMPT="你是一个专业的视频制作人。请审核以下视频生成方案，从以下维度进行评价（每个维度 0-100 分）：

1. **流畅度**（30%）：视频是否流畅
2. **节奏感**（30%）：节奏是否合适
3. **时长匹配度**（25%）：时长是否符合要求
4. **视觉吸引力**（15%）：是否有吸引力

请给出：
- 各维度的评分（0-100）
- 总体评分（加权平均）
- 发现的问题
- 改进建议

待审核的视频方案：
"""
$CONTENT
"""
"
    ;;
    
  *)
    echo "❌ 错误: 不支持的审核类型"
    echo "   支持的类型: requirement, research, content, visual, video"
    exit 1
    ;;
esac

# 如果有自定义要求，添加到 Prompt
if [ -n "$CUSTOM_REQUIREMENTS" ]; then
  PROMPT="$PROMPT

自定义要求：
$CUSTOM_REQUIREMENTS
"
fi

echo "📍 调用 GLM-4-Plus 进行审核..."
echo ""

# ============================================
# 调用 GLM-4-Plus API
# ============================================

REVIEW_RESULT=$(curl -s "$GLM_BASE_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ZHIPU_API_KEY" \
  -d '{
    "model": "glm-4-plus",
    "messages": [
      {
        "role": "user",
        "content": '"$PROMPT"'
      }
    ],
    "temperature": 0.3,
    "max_tokens": 2000
  }')

# 解析 API 响应（使用 Python）
REVIEW_CONTENT=$(echo "$REVIEW_RESULT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    text = data['choices'][0]['message']['content']
    print(text, end='')
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    print('API 调用失败，请检查配置', file=sys.stderr)
    sys.exit(1)
" 2>&1)

# 检查是否有错误
if [ $? -ne 0 ]; then
  echo "❌ API 调用失败"
  echo "$REVIEW_CONTENT"
  exit 1
fi

# ============================================
# 保存审核报告
# ============================================

REVIEW_OUTPUT="$OUTPUT_DIR/review_${REVIEW_TYPE}_$(date +%Y%m%d_%H%M%S).md"

cat > "$REVIEW_OUTPUT" << EOF
# ✅ 质量审核报告

**审核时间**: $(date '+%Y-%m-%d %H:%M:%S')
**审核类型**: ${REVIEW_TYPE}
**内容文件**: ${CONTENT_PATH}
**审核方式**: AI 模型（GLM-4-Plus）

---

## 📊 AI 审核结果

$REVIEW_CONTENT

---

**审核者**: quality-agent (GLM-4-Plus)
**维护者**: Main Agent
EOF

echo "✅ 质量审核完成"
echo "   审核方式: AI 模型（GLM-4-Plus）"
echo "   报告文件: $REVIEW_OUTPUT"
echo ""

# 显示审核结果（简化版）
echo "📊 审核结果（摘要）："
echo "$REVIEW_CONTENT" | head -30
echo ""
echo "💡 完整报告已保存到文件"
