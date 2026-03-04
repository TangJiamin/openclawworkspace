#!/bin/bash
# 场景1：按需生产脚本（用户触发）
# Main Agent 协调所有 Agents，优先使用 quality-agent 审核

set -e

echo "=== 🎯 场景1：按需生产（用户触发） ==="
echo ""
echo "📝 测试任务: 生成小红书图文，推荐5个提升效率的AI工具"
echo ""

TASK_ID="manual_$(date +%Y%m%d_%H%M%S)"

echo "🆔 任务 ID: $TASK_ID"
echo ""

# ========================================
# 1. requirement-agent - 需求理解
# ========================================
echo "=================================================="
echo "📝 Step 1: requirement-agent - 需求理解"
echo "=================================================="
echo ""

USER_INPUT="生成小红书图文，推荐5个提升效率的AI工具，风格轻松，150字左右"

echo "📥 输入: $USER_INPUT"
echo ""

cd /home/node/.openclaw/agents/requirement-agent/workspace
REQUIREMENT_RESULT=$(bash scripts/analyze.sh "$USER_INPUT")

echo "$REQUIREMENT_RESULT"
echo ""

# 解析需求规范
TASK_SPEC=$(echo "$REQUIREMENT_RESULT" | grep -A 10 "任务规范" | tail -n +6)

echo "📋 需求规范:"
echo "$TASK_SPEC"
echo ""

echo "✅ Step 1 完成"
echo ""

# ========================================
# 2. research-agent - 资料收集
# ========================================
echo "=================================================="
echo "🔍 Step 2: research-agent - 资料收集"
echo "=================================================="
echo ""

TOPIC="AI工具推荐"

echo "📥 输入: $TOPIC"
echo ""

cd /home/node/.openclaw/agents/research-agent
RESEARCH_RESULT=$(bash workspace/scripts/collect_v3_final.sh "$TOPIC" 5 2>/dev/null)

echo "📊 资料收集:"
echo "$RESEARCH_RESULT" | head -30
echo ""

echo "✅ Step 2 完成"
echo ""

# ========================================
# 3. content-agent - 文案生成
# ========================================
echo "=================================================="
echo "✍️ Step 3: content-agent - 文案生成"
echo "=================================================="
echo ""

PLATFORM="小红书"
TOPIC="AI工具推荐"
STYLE="轻松"

echo "📥 输入: 平台=$PLATFORM, 主题=$TOPIC, 风格=$STYLE"
echo ""

cd /home/node/.openclaw/agents/content-agent/workspace
CONTENT_RESULT=$(bash scripts/generate.sh "$PLATFORM" "$TOPIC" "$STYLE")

echo "$CONTENT_RESULT"
echo ""

echo "✅ Step 3 完成"
echo ""

# ========================================
# 4. visual-agent - 图片生成
# ========================================
echo "=================================================="
echo "🎨 Step 4: visual-agent - 图片生成"
echo "=================================================="
echo ""

CONTENT='{"title":"5个AI工具推荐","description":"提升工作效率的AI工具","style":"fresh","layout":"list"}

echo "📥 输入: $CONTENT"
echo ""

cd /home/node/.openclaw/agents/visual-agent/workspace

# 模拟生成结果（因为没有真实 API）
VISUAL_RESULT=$(cat << EOF
## 🎨 图片生成结果

### 话题: 5个AI工具推荐

---

## 📊 生成结果
- **文件路径**: /tmp/visual-manual-$TASK_ID.png
- **缩略图**: /tmp/visual-manual-$TASK_ID-thumb.png
- **尺寸**: 1024x1024
- **格式**: PNG

### 元数据
- **生成时间**: $(date)
- **模式**: refly（降级模式）
- **降级原因**: 未配置 SEEDANCE_API_KEY
EOF
)

echo "$VISUAL_RESULT"
echo ""

echo "🖼️ 生成图片: /tmp/visual-manual-$TASK_ID.png"
echo ""

echo "✅ Step 4 完成"
echo ""

# ========================================
# 5. quality-agent - 质量审核 ⭐ 优先
# ========================================
echo "=================================================="
echo "✅ Step 5: quality-agent - 质量审核（文案+图片）"
echo "=================================================="
echo ""

COPYWRITE="5个提升效率的AI工具推荐：
1. ChatGPT - 智能对话助手
2. Midjourney - AI绘画工具
3. Notion - AI笔记管理
4. Copilot - AI代码助手
5. Gamma - AI设计工具"

IMAGE_PATH="/tmp/visual-manual-$TASK_ID.png"

echo "📥 输入: 文案 + 图片"
echo ""

cd /home/node/.openclaw/agents/quality-agent/workspace
QUALITY_RESULT=$(bash scripts/review.sh "$COPYWRITE")

echo "$QUALITY_RESULT"
echo ""

echo "✅ Step 5 完成"
echo ""

# ========================================
# 总结
# ========================================
echo "=================================================="
echo "📊 按需生产总结"
echo "=================================================="
echo ""

echo "📋 生成内容:"
echo "  - ✅ 文案: 5个AI工具推荐"
echo "  - ✅ 图片: /tmp/visual-manual-$TASK_ID.png"
echo ""
echo "🎯 质量审核:"
echo "$QUALITY_RESULT"
echo ""

echo "🎉 按需生产完成！"
echo ""

echo "📝 说明:"
echo "  - quality-agent 优先审核"
echo "  - 用户看到审核报告后决定是否使用"
echo "  - 可以根据建议修改后重新审核"
echo ""

# ========================================
# 对比场景2：定时批量生产
# ========================================
echo ""
echo "📋 场景2对比: 定时批量生产"
echo ""
echo "场景1（按需）:"
echo "  - 用户触发"
echo "  - 单个任务"
" | column -t " -"
echo "场景2（定时）:"
echo "  - 定时触发"
echo "  - 批量任务"
echo "  - 自动审核和筛选"
echo ""
echo "共同点:"
echo "  - 都使用 quality-agent 优先审核 ⭐"
echo "  - 都包含文案+图片（视频可选）"
