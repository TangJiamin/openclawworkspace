#!/bin/bash
# Agent Auto-Optimizer
# 自动优化检查器 - 学习新技能后自动更新相关 Agent

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
LEARNINGS_DIR="${WORKSPACE_DIR}/.learnings"
AGENTS_DIR="${WORKSPACE_DIR}/agents"

echo "🔍 Agent Auto-Optimizer"
echo "====================="
echo ""
echo "检查新学习的技能..."
echo ""

# 检查最近的学习记录
if [[ -f "${LEARNINGS_DIR}/LEARNINGS.md" ]]; then
  echo "✅ 找到学习记录"
  
  # 提取最近学习的技能
  RECENT_SKILLS=$(grep -E "^## \[LRN-" "${LEARNINGS_DIR}/LEARNINGS.md" | tail -5 | while read line; do
    echo "$line" | sed 's/^## \[LRN-[^\]]*\] //'
  done)
  
  if [[ -n "$RECENT_SKILLS" ]]; then
    echo "最近学习的技能:"
    echo "$RECENT_SKILLS"
    echo ""
  fi
fi

# 检查新创建的 Skills
echo "📁 检查新创建的 Skills..."
echo ""

NEW_SKILLS=()

# 检查 translate Skill
if [[ -d "${WORKSPACE_DIR}/skills/translate" ]]; then
  if ! grep -q "translate" "${AGENTS_DIR}/research-agent/AGENTS.md" 2>/dev/null; then
    NEW_SKILLS+=("translate:research-agent")
  fi
  if ! grep -q "translate" "${AGENTS_DIR}/content-agent/AGENTS.md" 2>/dev/null; then
    NEW_SKILLS+=("translate:content-agent")
  fi
  echo "✅ translate Skill 已创建"
fi

# 检查 xhs-series Skill
if [[ -d "${WORKSPACE_DIR}/skills/xhs-series" ]]; then
  if ! grep -q "xhs-series" "${AGENTS_DIR}/visual-agent/AGENTS.md" 2>/dev/null; then
    NEW_SKILLS+=("xhs-series:visual-agent")
  fi
  echo "✅ xhs-series Skill 已创建"
fi

echo ""

# 分析需要优化的 Agents
if [[ ${#NEW_SKILLS[@]} -gt 0 ]]; then
  echo "🎯 发现需要优化的 Agents:"
  echo ""
  
  for skill_agent in "${NEW_SKILLS[@]}"; do
    skill="${skill_agent%:*}"
    agent="${skill_agent#*:}"
    
    echo "  - ${agent}: 集成 ${skill}"
  done
  
  echo ""
  echo "📝 生成优化建议..."
  echo ""
  
  # 生成优化建议
  for skill_agent in "${NEW_SKILLS[@]}"; do
    skill="${skill_agent%:*}"
    agent="${skill_agent#*:}"
    
    case "$skill" in
      translate)
        cat << EOF
### ${agent} - 集成 translate Skill

**新增能力**:
- 三模式翻译（quick/normal/refined）
- 术语管理（全局+项目+自动提取）
- 智能分块（>4000词自动分块）

**使用场景**:
- 翻译外文资料（research-agent）
- 多语言内容生产（content-agent）

**命令**:
\`\`\`bash
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \\
  file.md \\
  --mode normal
\`\`\`

**建议优先级**: ⭐⭐⭐⭐⭐ 高

EOF
        ;;
      xhs-series)
        cat << EOF
### ${agent} - 集成 xhs-series Skill

**新增能力**:
- Style × Layout 二维系统（11×8=88种组合）
- 1-10 张系列生成
- 20+ 快速预设

**使用场景**:
- 小红书图文系列生成
- 知识卡片制作
- 种草内容创作

**命令**:
\`\`\`bash
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \\
  article.md \\
  --preset knowledge-card
\`\`\`

**建议优先级**: ⭐⭐⭐⭐⭐ 高

EOF
        ;;
      *)
        echo "### ${agent} - 集成 ${skill} Skill"
        echo ""
        echo "**建议优先级**: ⭐⭐⭐ 中"
        echo ""
        ;;
    esac
  done
  
  # 保存优化报告
  REPORT_FILE="${WORKSPACE_DIR}/docs/optimization-report-$(date +%Y%m%d-%H%M%S).md"
  
  {
    echo "# Agent 优化报告"
    echo ""
    echo "**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "**状态**: 待确认"
    echo ""
    echo "---"
    echo ""
    echo "## 📋 优化建议"
    echo ""
    
    for skill_agent in "${NEW_SKILLS[@]}"; do
      skill="${skill_agent%:*}"
      agent="${skill_agent#*:}"
      
      case "$skill" in
        translate)
          cat << 'EOF'
### 1. research-agent - 集成 translate

**新增能力**:
- ✅ 三模式翻译
- ✅ 术语管理
- ✅ 智能分块

**使用**: 翻译外文资料

**优先级**: ⭐⭐⭐⭐⭐

EOF
          ;;
        xhs-series)
          cat << 'EOF'
### 2. visual-agent - 集成 xhs-series

**新增能力**:
- ✅ Style × Layout 系统
- ✅ 系列 1-10 张图
- ✅ 20+ 快速预设

**使用**: 小红书图文系列生成

**优先级**: ⭐⭐⭐⭐⭐

EOF
          ;;
      esac
    done
    
    echo "---"
    echo ""
    echo "## ✅ 执行优化"
    echo ""
    echo "请确认是否执行上述优化？"
    echo ""
    echo "回复: '执行优化' 或 'apply'"
    
  } > "$REPORT_FILE"
  
  echo "✅ 优化报告已生成: $REPORT_FILE"
  echo ""
  echo "📊 优化建议摘要:"
  echo ""
  echo "需要优化的 Agents: ${#NEW_SKILLS[@]}"
  echo "新增 Skills: 2 (translate, xhs-series)"
  echo "预期效果: Agent 矩阵能力大幅提升"
  echo ""
  
else
  echo "✅ 所有 Agent 已是最新的，无需优化"
fi

echo ""
echo "🎉 优化检查完成！"
