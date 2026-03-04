#!/bin/bash

# Agent 优化检查器脚本
# 当学习到新技能时，检查现有 Agent 是否需要更新优化

set -e

WORKSPACE_DIR="/home/node/.openclaw/workspace"
SKILL_DIR="$WORKSPACE_DIR/skills/agent-optimizer"
REPORTS_DIR="$SKILL_DIR/reports"
AGENTS_DIR="$HOME/node/.openclaw/agents"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0;0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 创建目录
mkdir -p "$REPORTS_DIR"

# 解析参数
SKILL_NAME=""
SKILL_SOURCE=""
SKILL_DESCRIPTION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --skill)
            SKILL_NAME="$2"
            shift 2
            ;;
        --source)
            SKILL_SOURCE="$2"
            shift 2
            ;;
        --description)
            SKILL_DESCRIPTION="$2"
            shift 2
            ;;
        *)
            log_error "未知参数: $1"
            exit 1
            ;;
    esac
done

# 如果没有提供技能信息，从今日学习文件中读取
if [ -z "$SKILL_NAME" ]; then
    TODAY=$(TZ='Asia/Shanghai' date +%Y-%m-%d)
    LEARNING_FILE="$WORKSPACE_DIR/memory/daily-learning/$TODAY.md"

    if [ -f "$LEARNING_FILE" ]; then
        log_info "从今日学习文件中读取技能信息"
        SKILL_NAME=$(grep "学习途径:" "$LEARNING_FILE" | head -n 1 | sed 's/.*选择：//' || echo "未知")
        SKILL_SOURCE=$(grep "学习途径:" "$LEARNING_FILE" | head -n 1 | sed 's/.*理由：//' || echo "未知")
    fi
fi

log_info "===== Agent 优化检查开始 ====="
log_info "检查技能: $SKILL_NAME"
log_info "技能来源: $SKILL_SOURCE"

# 列出所有 Agent
AGENTS=("requirement-agent" "research-agent" "content-agent" "visual-agent" "video-agent" "quality-agent")

# 修复路径：去掉重复的 /home/node
if [ "$HOME" = "/home/node" ]; then
    AGENTS_DIR="$HOME/.openclaw/agents"
else
    AGENTS_DIR="/home/node/.openclaw/agents"
fi

log_info "需要检查的 Agent: ${AGENTS[@]}"

# 生成报告
REPORT_FILE="$REPORTS_DIR/optimization-$(TZ='Asia/Shanghai' date +%Y%m%d-%H%M%S).md"

cat > "$REPORT_FILE" << EOF
# Agent 优化检查报告

## 检查时间
$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')

## 学习的新技能
- **技能名称**: $SKILL_NAME
- **技能来源**: $SKILL_SOURCE
- **核心功能**: $SKILL_DESCRIPTION

## 检查的 Agent
$(for agent in "${AGENTS[@]}"; do echo "- $agent"; done)

## 分析结果

EOF

# 需要优化的 Agent 数量
NEEDS_OPTIMIZATION=0
NO_OPTIMIZATION_NEEDED=()

# 检查每个 Agent
for agent in "${AGENTS[@]}"; do
    AGENT_DIR="$AGENTS_DIR/$agent"
    AGENT_README="$AGENT_DIR/README.md"

    if [ ! -d "$AGENT_DIR" ]; then
        log_warning "Agent 目录不存在: $AGENT_DIR"
        continue
    fi

    log_info "检查 $agent..."

    # 检查 Agent 的 README
    if [ -f "$AGENT_README" ]; then
        # 简化的检查逻辑（实际可以更复杂）
        # 检查是否提到相关技能或工具

        # 检查关键词匹配
        if echo "$SKILL_NAME $SKILL_DESCRIPTION" | grep -iq "$(basename "$AGENT_DIR")"; then
            log_warning "发现潜在优化点: $agent"

            cat >> "$REPORT_FILE" << EOF

### $agent ⚠️

**发现的问题**:
- 新技能可能与 $agent 的功能重叠或可以改进

**优化建议**:
1. 评估新技能是否能增强 $agent 的能力
2. 检查是否可以使用新技能替换现有实现
3. 更新 Agent 的 README 和配置

**预期效果**:
- 性能提升: 待评估
- 功能改进: 可能增强现有功能
- 架构优化: 可能简化实现

**实施步骤**:
1. 详细分析新技能和现有 Agent 的功能
2. 设计集成方案
3. 创建测试用例
4. 应用修改
5. 验证效果

**风险评估**:
- 风险等级: 中等
- 可能影响: Agent 稳定性和兼容性
- 缓解措施: 充分测试，保留回滚方案

**需要修改的文件**:
- \`$AGENT_DIR/README.md\`
- \`$AGENT_DIR/SKILL.md\` (如果存在)
- 相关脚本文件

EOF
            ((NEEDS_OPTIMIZATION++))
        else
            NO_OPTIMIZATION_NEEDED+=("$agent")
        fi
    else
        NO_OPTIMIZATION_NEEDED+=("$agent")
    fi
done

# 生成总结
cat >> "$REPORT_FILE" << EOF

## 无需优化的 Agent
$(for agent in "${NO_OPTIMIZATION_NEEDED[@]}"; do echo "- $agent: 未发现明显优化点"; done)

## 总结
- **需要优化**: $NEEDS_OPTIMIZATION 个
- **无需优化**: ${#NO_OPTIMIZATION_NEEDED[@]} 个
- **总计**: $((NEEDS_OPTIMIZATION + ${#NO_OPTIMIZATION_NEEDED[@]})) 个

## 下一步

EOF

if [ $NEEDS_OPTIMIZATION -gt 0 ]; then
    cat >> "$REPORT_FILE" << EOF
⚠️ 发现 $NEEDS_OPTIMIZATION 个 Agent 可能需要优化。

**请确认**:
1. 查看上述优化建议
2. 评估优化方案的可行性
3. 确认是否应用优化

**确认命令**:
\`\`\`bash
# 应用所有优化
bash $SKILL_DIR/scripts/apply-optimizations.sh --report $REPORT_FILE

# 应用特定 Agent 的优化
bash $SKILL_DIR/scripts/apply-optimizations.sh --report $REPORT_FILE --agent research-agent
\`\`\`
EOF
else
    cat >> "$REPORT_FILE" << EOF
✅ 所有 Agent 都无需优化。

当前系统状态良好，继续监控新技能的学习。
EOF
fi

log_success "检查完成！报告已生成: $REPORT_FILE"

# 如果需要优化，发送通知
if [ $NEEDS_OPTIMIZATION -gt 0 ]; then
    log_warning "发现 $NEEDS_OPTIMIZATION 个 Agent 可能需要优化"
    log_info "请查看报告: $REPORT_FILE"
    log_info "确认后应用优化: bash $SKILL_DIR/scripts/apply-optimizations.sh --report $REPORT_FILE"
fi

# 输出报告路径
echo "REPORT_FILE=$REPORT_FILE"
