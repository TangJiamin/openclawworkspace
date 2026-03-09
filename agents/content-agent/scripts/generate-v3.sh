#!/bin/bash
# content-agent 智能文案生成脚本 v3.0
# 集成 GLM-4-Plus 进行智能内容生成

set -e

# 输入参数
PLATFORM="$1"
TOPIC="$2"
STYLE="${3:-轻松}"
CONTENT_CONTEXT="${4:-}"  # 可选：额外的背景信息

# 配置
WORKSPACE="/home/node/.openclaw/workspace/agents/content-agent"
OUTPUT_DIR="$WORKSPACE/output"
DATA_DIR="$WORKSPACE/data"
ENV_FILE="/home/node/.openclaw/.env"

# 创建目录
mkdir -p "$OUTPUT_DIR"
mkdir -p "$DATA_DIR"

# 如果没有输入，显示使用说明
if [ -z "$PLATFORM" ] || [ -z "$TOPIC" ]; then
  cat << 'EOF'
📝 Content Agent 智能文案生成工具 v3.0

使用方法: bash scripts/generate-v3.sh "平台" "主题" "风格" "背景信息"

支持的平台:
  - 小红书（默认风格: 轻松、emoji多）
  - 抖音（默认风格: 快节奏、钩子驱动）
  - 微信（默认风格: 深度、专业）
  - B站（默认风格: 年轻化、互动性强）

示例:
  bash scripts/generate-v3.sh "小红书" "AI工具推荐" "轻松"
  bash scripts/generate-v3.sh "抖音" "ChatGPT技巧" "快节奏" "针对新手用户"
  bash scripts/generate-v3.sh "微信" "AI行业趋势" "专业" "2024年最新趋势"
EOF
  exit 1
fi

# 生成任务 ID
TASK_ID="content_$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/${TASK_ID}.md"

echo "🚀 开始智能生成文案..."
echo "   平台: $PLATFORM"
echo "   主题: $TOPIC"
echo "   风格: $STYLE"
echo "   背景信息: ${CONTENT_CONTEXT:-无}"
echo ""

# 从 .env 文件读取 API 配置
if [ -f "$ENV_FILE" ]; then
  # 导入 .env 文件中的环境变量
  export $(grep "^ZHIPU_API_KEY=" "$ENV_FILE" | xargs)
  
  BASE_URL="https://open.bigmodel.cn/api/anthropic"
  MODEL="glm-4.7"
  
  # 检查 API Key 是否存在
  if [ -z "$ZHIPU_API_KEY" ]; then
    echo "⚠️  无法从 .env 文件读取 ZHIPU_API_KEY"
    echo "📝 请在 $ENV_FILE 中设置："
    echo "   ZHIPU_API_KEY=your-api-key-here"
    echo ""
    echo "🔄 使用基础生成模式..."
    bash /home/node/.openclaw/agents/content-agent/scripts/generate-v2.sh "$PLATFORM" "$TOPIC" "$STYLE"
    exit 0
  fi
  
  echo "✅ 成功读取 API 配置:"
  echo "   API Key: ${ZHIPU_API_KEY:0:10}..."
  echo "   Base URL: $BASE_URL"
  echo "   Model: $MODEL"
  echo ""
else
  echo "⚠️  配置文件不存在: $ENV_FILE"
  echo "📝 请创建 .env 文件并设置 ZHIPU_API_KEY"
  echo ""
  echo "🔄 使用基础生成模式..."
  bash /home/node/.openclaw/agents/content-agent/scripts/generate-v2.sh "$PLATFORM" "$TOPIC" "$STYLE"
  exit 0
fi

# 平台特性配置
case "$PLATFORM" in
  "小红书")
    PLATFORM_GUIDE="小红书平台特点：
- 用户群体：18-35岁女性为主
- 内容风格：真实体验、实用干货、闺蜜对闺蜜的语气
- Emoji使用：大量使用，每个段落都有
- 标题特点：emoji+短句+感叹号，制造惊喜感
- 结构：开场引入+3-5个要点+总结+话题标签
- 互动：多用问句，引导评论和收藏"
    ;;
  "抖音")
    PLATFORM_GUIDE="抖音平台特点：
- 用户群体：18-30岁，性别均衡
- 内容风格：快节奏、强感染力、3秒抓住注意力
- Emoji使用：适度使用，关键信息加emoji
- 标题特点：短平快，数字+emoji+感叹号
- 结构：3秒hook+核心内容+总结+话题标签
- 节奏：每段不超过2行，快速切换"
    ;;
  "微信")
    PLATFORM_GUIDE="微信公众号特点：
- 用户群体：25-45岁职场人群
- 内容风格：深度内容、专业见解、结构化
- Emoji使用：少量使用，标题和重点处使用
- 标题特点：专业、准确、有时用冒号结构
- 结构：引言+背景+核心分析（3-4个部分）+总结
- 深度：每个要点详细展开，提供数据和案例"
    ;;
  "B站")
    PLATFORM_GUIDE="B站平台特点：
- 用户群体：18-25岁，男性略多
- 内容风格：有趣、有料、有梗
- Emoji使用：大量使用，配合梗图
- 标题特点：年轻化、网络热词、疑问句
- 结构：开场引入+干货内容+互动引导
- 互动：多用弹幕梗，引导投币点赞"
    ;;
  *)
    PLATFORM_GUIDE="通用内容创作指南"
    ;;
esac

# 生成 Prompt
PROMPT_TEXT="你是一位专业的内容创作者，擅长为不同平台创作高质量文案。

## 创作任务
请为【${PLATFORM}】平台创作一篇关于【${TOPIC}】的文案。

## 平台特性
${PLATFORM_GUIDE}

## 风格要求
- 语气：${STYLE}
- 融入平台特色，让内容看起来是"原生"的
- 避免标题党，hook要匹配实际内容
- 内容要有价值，不能空洞

## 输出格式
请按以下格式输出：

### 标题（5个备选）
1. 标题1
2. 标题2
3. 标题3
4. 标题4
5. 标题5

### Hook
（开场白，用1-2句话抓住注意力）

### 正文内容
（根据平台特性创作，小红书3-5个要点，抖音快节奏，微信深度分析）

### 结尾
（CTA + 互动引导）

### 话题标签
（3-5个相关标签）
$(if [ -n "$CONTENT_CONTEXT" ]; then
  echo ""
  echo "## 背景信息"
  echo "$CONTENT_CONTEXT"
fi)

请开始创作："

echo "🤖 正在调用 GLM-4-Plus 生成文案..."
echo ""

# 调用 GLM-4-Plus API
# 保存 Prompt 到文件
PROMPT_FILE="$DATA_DIR/prompt_${TASK_ID}.txt"
echo "$PROMPT_TEXT" > "$PROMPT_FILE"

# 构建 JSON 请求体（使用临时文件）
cat > "$DATA_DIR/request_${TASK_ID}.json" << EOF
{
  "model": "$MODEL",
  "max_tokens": 2000,
  "messages": [
    {
      "role": "user",
      "content": "$(echo "$PROMPT_TEXT" | sed 's/"/\\"/g' | tr '\n' ' ' | sed 's/\\n/\\\\n/g')"
    }
  ]
}
EOF

# 调用 API
HTTP_RESPONSE=$(curl -s -X POST "${BASE_URL}/v1/messages" \
  -H "Authorization: Bearer $ZHIPU_API_KEY" \
  -H "Content-Type: application/json" \
  -d @"$DATA_DIR/request_${TASK_ID}.json" 2>&1)

# 检查 API 调用是否成功
if echo "$HTTP_RESPONSE" | grep -q "error"; then
  echo "⚠️  API 调用失败"
  echo "📋 错误信息:"
  echo "$HTTP_RESPONSE" | head -20
  echo ""
  echo "🔄 使用基础生成模式..."
  bash /home/node/.openclaw/agents/content-agent/scripts/generate-v2.sh "$PLATFORM" "$TOPIC" "$STYLE"
  exit 0
fi

# 提取生成的内容
# GLM-4-Plus 响应格式: {"content": [{"type": "text", "text": "..."}]}
# 使用 Python 来正确处理 JSON 和换行符
GENERATED_CONTENT=$(echo "$HTTP_RESPONSE" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if 'content' in data and len(data['content']) > 0:
        text = data['content'][0]['text']
        print(text, end='')
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)
" 2>/dev/null)

if [ -z "$GENERATED_CONTENT" ]; then
  echo "⚠️  无法提取生成的内容"
  echo "📋 API 响应:"
  echo "$HTTP_RESPONSE" | head -30
  echo ""
  echo "🔄 使用基础生成模式..."
  bash /home/node/.openclaw/agents/content-agent/scripts/generate-v2.sh "$PLATFORM" "$TOPIC" "$STYLE"
  exit 0
fi

# 生成完整输出
cat > "$OUTPUT_FILE" << OUTPUTEOF
# 📝 Content Agent 智能生成结果

**任务 ID**: ${TASK_ID}
**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**风格**: ${STYLE}
**背景信息**: ${CONTENT_CONTEXT:-无}

---

## 📊 平台分析

**用户画像**:
$(case "$PLATFORM" in
  "小红书")
    echo "- 年龄: 18-35岁"
    echo "- 性别: 女性为主"
    echo "- 偏好: 真实体验、实用干货"
    ;;
  "抖音")
    echo "- 年龄: 18-30岁"
    echo "- 性别: 均衡"
    echo "- 偏好: 快节奏、强感染力"
    ;;
  "微信")
    echo "- 年龄: 25-45岁"
    echo "- 职业: 职场人群"
    echo "- 偏好: 深度内容、专业见解"
    ;;
  *)
    echo "- 年龄: 未知"
    echo "- 性别: 未知"
    echo "- 偏好: 通用"
    ;;
esac)

---

## 🤖 AI 生成内容

${GENERATED_CONTENT}

---

## 📋 质量检查清单

- [ ] 标题吸引力
- [ ] Hook 相关性
- [ ] 内容完整性
- [ ] 平台适配性
- [ ] CTA 清晰度

---

**生成方式**: GLM-4-Plus 智能生成
**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
**文件位置**: ${OUTPUT_FILE}
OUTPUTEOF

echo "✅ 文案生成完成！"
echo "📄 文件位置: $OUTPUT_FILE"
echo ""
echo "📊 生成结果预览:"
echo ""
cat "$OUTPUT_FILE"
echo ""
echo "🎉 AI 智能生成成功！"
