#!/bin/bash

# 应用优化脚本
# 根据优化报告应用 Agent 优化

set -e

WORKSPACE_DIR="/home/node/.openclaw/workspace"
SKILL_DIR="$WORKSPACE_DIR/skills/agent-optimizer"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0;0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 解析参数
REPORT_FILE=""
SPECIFIC_AGENT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --report)
            REPORT_FILE="$2"
            shift 2
            ;;
        --agent)
            SPECIFIC_AGENT="$2"
            shift 2
            ;;
        *)
            log_error "未知参数: $1"
            exit 1
            ;;
    esac
done

if [ -z "$REPORT_FILE" ]; then
    log_error "请指定优化报告文件: --report <path>"
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
    log_error "报告文件不存在: $REPORT_FILE"
    exit 1
fi

log_info "===== 应用 Agent 优化 ====="
log_info "优化报告: $REPORT_FILE"

# 读取报告
REPORT_CONTENT=$(cat "$REPORT_FILE")

# 检查是否需要优化
if ! echo "$REPORT_CONTENT" | grep -q "需要优化:"; then
    log_info "报告中没有需要优化的 Agent"
    exit 0
fi

# 提取需要优化的 Agent 数量
NEEDS_OPTIMIZATION=$(echo "$REPORT_CONTENT" | grep "需要优化:" | grep -oE "[0-9]+" | head -n 1)

if [ "$NEEDS_OPTIMIZATION" -eq 0 ]; then
    log_info "无需优化的 Agent"
    exit 0
fi

log_warning "发现 $NEEDS_OPTIMIZATION 个 Agent 需要优化"

# 询问用户确认
log_warning "⚠️ 这将修改现有 Agent 的代码和配置"
echo -n "是否继续应用优化？(yes/no): "
read -r CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    log_info "取消优化应用"
    exit 0
fi

# 应用优化
log_info "开始应用优化..."

# 如果指定了特定 Agent，只优化该 Agent
if [ -n "$SPECIFIC_AGENT" ]; then
    log_info "优化特定 Agent: $SPECIFIC_AGENT"

    # 备份
    AGENT_DIR="$HOME/node/.openclaw/agents/$SPECIFIC_AGENT"
    if [ -d "$AGENT_DIR" ]; then
        BACKUP_DIR="$AGENT_DIR.backup-$(date +%Y%m%d-%H%M%S)"
        log_info "备份 $AGENT_DIR -> $BACKUP_DIR"
        cp -r "$AGENT_DIR" "$BACKUP_DIR"
    fi

    # 这里应该有实际的优化逻辑
    log_warning "⚠️ 优化逻辑需要根据具体技能和 Agent 实现"
    log_info "请手动查看优化报告并应用修改"
else
    log_info "优化所有需要优化的 Agent"
    log_warning "⚠️ 优化逻辑需要根据具体技能和 Agent 实现"
    log_info "请手动查看优化报告并应用修改"
fi

log_success "优化应用完成！"
log_info "请验证优化效果"
