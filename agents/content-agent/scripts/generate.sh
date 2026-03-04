#!/bin/bash
# content-agent 文案生成脚本
# 使用示例：bash scripts/generate.sh "小红书" "AI工具推荐" "轻松"

set -e

# 输入参数
PLATFORM="$1"
TOPIC="$2"
STYLE="${3:-轻松}"

# 如果没有输入，显示使用说明
if [ -z "$PLATFORM" ] || [ -z "$TOPIC" ]; then
  echo "使用方法: bash scripts/generate.sh \"平台\" \"主题\" \"风格\""
  echo ""
  echo "示例:"
  echo "  bash scripts/generate.sh \"小红书\" \"AI工具推荐\" \"轻松\""
  echo "  bash scripts/generate.sh \"抖音\" \"ChatGPT技巧\" \"快节奏\""
  echo ""
  echo "支持的平台: 小红书、抖音、微信、B站"
  exit 1
fi

# 生成任务 ID
TASK_ID="content_$(date +%Y%m%d_%H%M%S)"

# 输出内容策略
cat << EOF
## 📝 内容生成结果

### 任务信息
- **任务 ID**: $TASK_ID
- **平台**: $PLATFORM
- **主题**: $TOPIC
- **风格**: $STYLE

---

### 📊 平台分析

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
    echo "- 分析中..."
    ;;
esac)

---

### 🎯 内容策略

**Hook 设计**:
- 提问式: "你是否也遇到过 ${TOPIC} 的问题？"
- 数据式: "99%的人都不知道的 ${TOPIC} 技巧"
- 痛点式: "困扰你很久的 ${TOPIC} 问题，今天解决了"

**内容结构**:
1. 开场: Hook + 主题引入
2. 正文: 核心内容（3-5个要点）
3. 结尾: CTA + 互动引导

---

### ✍️ 文案生成

⏳ 正在生成 ${PLATFORM} 平台的 ${TOPIC} 文案...

---

**注意**: 这是 content-agent 的简化实现
完整版本需要：
1. 集成 GLM-4-Plus 进行文案生成
2. 调用 metaso-search 补充信息
3. 根据平台特性优化格式

EOF
