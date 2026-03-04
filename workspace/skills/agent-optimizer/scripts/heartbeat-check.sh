#!/bin/bash

# 心跳任务：Agent 优化检查器
# 每次心跳时检查是否学习了新技能，如果有则触发优化检查

set -e

WORKSPACE_DIR="/home/node/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE_DIR/memory"
LEARNING_DIR="$MEMORY_DIR/daily-learning"
OPTIMIZER_SCRIPT="$WORKSPACE_DIR/skills/agent-optimizer/scripts/check.sh"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0;0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# 今天日期
TODAY=$(TZ='Asia/Shanghai' date +%Y-%m-%d)

# 检查今日是否学习了新技能
log_info "===== 心跳任务：Agent 优化检查 ====="
log_info "检查今天是否学习了新技能..."

NEW_SKILL_DETECTED=0
SKILL_NAME=""
SKILL_SOURCE=""

# 1. 检查今日记忆文件
TODAY_MEMORY="$MEMORY_DIR/$TODAY.md"
if [ -f "$TODAY_MEMORY" ]; then
    # 搜索学习相关的关键词
    if grep -qE "学到|学习|安装|配置|掌握|新技能|新工具|新能力" "$TODAY_MEMORY"; then
        log_info "在今日记忆中发现新技能"
        NEW_SKILL_DETECTED=1
        SKILL_NAME="今日记忆中的新技能"
        SKILL_SOURCE="今日工作"
    fi
fi

# 2. 检查今日定向学习文件
TODAY_LEARNING="$LEARNING_DIR/$TODAY.md"
if [ -f "$TODAY_LEARNING" ]; then
    # 检查是否有学习途径和学习内容
    if grep -qE "学习途径:|学习内容:" "$TODAY_LEARNING"; then
        log_info "在今日定向学习中发现新技能"
        NEW_SKILL_DETECTED=1
        SKILL_NAME=$(grep "学习途径:" "$TODAY_LEARNING" | head -n 1 | sed 's/.*选择：//' || echo "未知")
        SKILL_SOURCE="定向学习"
    fi
fi

# 3. 检查是否已经有优化检查报告（避免重复）
TODAY_REPORTS="$WORKSPACE_DIR/skills/agent-optimizer/reports/optimization-${TODAY}*.md"
if ls $TODAY_REPORTS 1> /dev/null 2>&1; then
    log_info "今天已经生成过优化报告，跳过"
    NEW_SKILL_DETECTED=0
fi

# 如果检测到新技能，触发优化检查
if [ $NEW_SKILL_DETECTED -eq 1 ]; then
    log_info "检测到新技能，触发优化检查..."
    log_info "技能名称: $SKILL_NAME"
    log_info "技能来源: $SKILL_SOURCE"

    # 调用优化检查器
    if [ -x "$OPTIMIZER_SCRIPT" ]; then
        log_info "运行优化检查器..."
        bash "$OPTIMIZER_SCRIPT" \
            --skill "$SKILL_NAME" \
            --source "$SKILL_SOURCE"

        log_success "优化检查完成！"
    else
        log_info "优化检查器脚本不存在或不可执行"
    fi
else
    log_info "未检测到新技能，无需优化检查"
fi

# 返回心跳状态
if [ $NEW_SKILL_DETECTED -eq 1 ]; then
    echo "STATUS:NEW_SKILL_DETECTED"
else
    echo "STATUS:NO_NEW_SKILL"
fi
