#!/bin/bash
# content-agent 文案生成脚本 v2.0
# 使用示例：bash scripts/generate.sh "小红书" "AI工具推荐" "轻松"

set -e

# 输入参数
PLATFORM="$1"
TOPIC="$2"
STYLE="${3:-轻松}"

# 配置
WORKSPACE="/home/node/.openclaw/workspace/agents/content-agent"
OUTPUT_DIR="$WORKSPACE/output"
DATA_DIR="$WORKSPACE/data"

# 创建目录
mkdir -p "$OUTPUT_DIR"
mkdir -p "$DATA_DIR"

# 如果没有输入，显示使用说明
if [ -z "$PLATFORM" ] || [ -z "$TOPIC" ]; then
  echo "📝 Content Agent 文案生成工具 v2.0"
  echo ""
  echo "使用方法: bash scripts/generate.sh \"平台\" \"主题\" \"风格\""
  echo ""
  echo "支持的平台:"
  echo "  - 小红书（默认风格: 轻松、emoji多）"
  echo "  - 抖音（默认风格: 快节奏、钩子驱动）"
  echo "  - 微信（默认风格: 深度、专业）"
  echo "  - B站（默认风格: 年轻化、互动性强）"
  echo ""
  echo "示例:"
  echo "  bash scripts/generate.sh \"小红书\" \"AI工具推荐\" \"轻松\""
  echo "  bash scripts/generate.sh \"抖音\" \"ChatGPT技巧\" \"快节奏\""
  echo "  bash scripts/generate.sh \"微信\" \"AI行业趋势\" \"专业\""
  exit 1
fi

# 生成任务 ID
TASK_ID="content_$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/${TASK_ID}.md"

echo "🚀 开始生成文案..."
echo "   平台: $PLATFORM"
echo "   主题: $TOPIC"
echo "   风格: $STYLE"
echo ""

# 平台特性配置
case "$PLATFORM" in
  "小红书")
    USER_AGE="18-35岁"
    USER_GENDER="女性为主"
    USER_PREFERENCE="真实体验、实用干货"
    EMOJI_USAGE="大量使用"
    TONE="闺蜜对闺蜜"
    ;;
  "抖音")
    USER_AGE="18-30岁"
    USER_GENDER="均衡"
    USER_PREFERENCE="快节奏、强感染力"
    EMOJI_USAGE="适度使用"
    TONE="快速、有力"
    ;;
  "微信")
    USER_AGE="25-45岁"
    USER_GENDER="均衡"
    USER_PREFERENCE="深度内容、专业见解"
    EMOJI_USAGE="少量使用"
    TONE="专业但不严肃"
    ;;
  "B站")
    USER_AGE="18-25岁"
    USER_GENDER="男性略多"
    USER_PREFERENCE="有趣、有料、有梗"
    EMOJI_USAGE="大量使用"
    TONE="年轻化、互动性强"
    ;;
  *)
    echo "⚠️  未识别的平台，使用默认配置"
    USER_AGE="未知"
    USER_GENDER="未知"
    USER_PREFERENCE="通用"
    EMOJI_USAGE="适量使用"
    TONE="友好"
    ;;
esac

# 生成 Hook
case "$STYLE" in
  "轻松"|"友好")
    HOOK_TYPE="提问式"
    HOOK="姐妹们，你是否也遇到过 ${TOPIC} 的问题？🤔"
    ;;
  "快节奏"|"有力")
    HOOK_TYPE="数据式"
    HOOK="99%的人都不知道的 ${TOPIC} 技巧！💯"
    ;;
  "专业"|"深度")
    HOOK_TYPE="痛点式"
    HOOK="困扰你很久的 ${TOPIC} 问题，今天终于解决了！✅"
    ;;
  *)
    HOOK_TYPE="提问式"
    HOOK="关于 ${TOPIC}，你真的了解吗？"
    ;;
esac

# 生成标题（5个备选）
case "$PLATFORM" in
  "小红书")
    TITLES=(
      "${TOPIC}｜我才发现，原来这么简单！✨"
      "关于${TOPIC}，这几个技巧太香了🔥"
      "${TOPIC}｜新手必看！避坑指南⚠️"
      "${TOPIC}｜我的真实体验分享💯"
      "${TOPIC}｜原来还能这样做？！🤯"
    )
    ;;
  "抖音")
    TITLES=(
      "${TOPIC}，3秒学会！🔥"
      "${TOPIC}，99%的人都不知道！💯"
      "${TOPIC}，这个技巧太强了！😱"
      "${TOPIC}，新手必看！⚠️"
      "${TOPIC}，一分钟搞定！⚡"
    )
    ;;
  "微信")
    TITLES=(
      "${TOPIC}：深度解析与实践指南"
      "关于${TOPIC}，你需要知道的几个关键点"
      "${TOPIC}：从入门到精通"
      "${TOPID}：专业解读与趋势分析"
      "${TOPIC}：实战经验总结"
    )
    ;;
  *)
    TITLES=(
      "${TOPIC}｜实用指南"
      "${TOPIC}｜技巧分享"
      "${TOPIC}｜新手教程"
      "${TOPIC}｜经验总结"
      "${TOPIC}｜避坑指南"
    )
    ;;
esac

# 生成正文内容
generate_content() {
  case "$PLATFORM" in
    "小红书")
      cat << EOF

## 正文

大家好！今天来聊聊 ${TOPIC}～ 👋

### 📌 第一点：基础认知
首先，我们要明白 ${TOPIC} 的本质...（根据实际内容填充）

### 📌 第二点：实用技巧
这里有几个我亲测有效的方法：
1. 技巧一：XXX（具体说明）
2. 技巧二：XXX（具体说明）
3. 技巧三：XXX（具体说明）

### 📌 第三点：注意事项
在实践过程中，要注意...

## 💡 总结
${TOPIC} 其实没那么难，关键是要掌握正确的方法！

希望今天的分享对你有帮助～ 💕

---
#${TOPIC} #实用技巧 #干货分享 #经验总结

EOF
      ;;
    "抖音")
      cat << EOF

## 正文

${HOOK}

第一，XXX（核心观点1）
第二，XXX（核心观点2）
第三，XXX（核心观点3）

记住这几个要点，你也能轻松搞定 ${TOPIC}！

---
#${TOPIC} #技巧 #教学

EOF
      ;;
    "微信")
      cat << EOF

## 引言
${HOOK}

## 一、${TOPIC} 的背景与现状
（详细描述背景信息）

## 二、核心要点分析

### 2.1 要点一
（深入分析）

### 2.2 要点二
（深入分析）

### 2.3 要点三
（深入分析）

## 三、实践建议
基于以上分析，我建议...

## 四、总结
${TOPIC} 是一个值得深入研究的领域，希望本文能为你提供有价值的参考。

---
（欢迎留言讨论）

EOF
      ;;
    *)
      cat << EOF

## 正文

${HOOK}

### 1. 第一点
（内容说明）

### 2. 第二点
（内容说明）

### 3. 第三点
（内容说明）

## 总结
${TOPIC} 的关键在于...

---
#${TOPIC} #实用技巧

EOF
      ;;
  esac
}

# 生成完整内容
cat > "$OUTPUT_FILE" << EOF
# 📝 Content Agent 生成结果

**任务 ID**: ${TASK_ID}
**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**风格**: ${STYLE}

---

## 📊 平台分析

**用户画像**:
- 年龄: ${USER_AGE}
- 性别: ${USER_GENDER}
- 偏好: ${USER_PREFERENCE}

**内容特点**:
- Emoji 使用: ${EMOJI_USAGE}
- 语气: ${TONE}

---

## 🎯 内容策略

**Hook 类型**: ${HOOK_TYPE}
**Hook 文案**: ${HOOK}

**内容结构**:
1. 开场: Hook + 主题引入
2. 正文: 核心内容（3-5个要点）
3. 结尾: CTA + 互动引导

---

## ✍️ 标题备选（5个）

$(for i in "${!TITLES[@]}"; do
  echo "$(expr $i + 1). ${TITLES[$i]}"
done)

---

## 📄 完整文案

${HOOK}
$(generate_content)

---

## 📋 质量检查清单

- [ ] 标题吸引力
- [ ] Hook 相关性
- [ ] 内容完整性
- [ ] 平台适配性
- [ ] CTA 清晰度

---

**注意**: 这是基础版本的内容生成。完整版本需要：
1. 集成 GLM-4-Plus 进行智能文案生成
2. 调用 metaso-search 补充最新信息
3. 根据平台特性动态优化

---

**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
**文件位置**: ${OUTPUT_FILE}
EOF

echo "✅ 文案生成完成！"
echo "📄 文件位置: $OUTPUT_FILE"
echo ""
echo "📊 生成结果预览:"
echo ""
cat "$OUTPUT_FILE"
echo ""
echo "💡 提示: 这是基础版本的内容生成。要获得更高质量的文案，请集成 GLM-4-Plus 模型。"
