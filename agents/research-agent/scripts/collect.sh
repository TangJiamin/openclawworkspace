#!/bin/bash

# Research Agent - 资料收集脚本
# 功能: 24小时时效性控制 + AI领域热点筛选

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
METASO_DIR="$WORKSPACE_DIR/../metaso-search"
DIGEST_DIR="$WORKSPACE_DIR/../ai-daily-digest"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取当前时间
get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

# 计算时间边界（24小时前）
get_time_boundary() {
    TZ='Asia/Shanghai' date -d '24 hours ago' +'%Y-%m-%d %H:%M' 2>/dev/null || \
    TZ='Asia/Shanghai' date -v-24H +'%Y-%m-%d %H:%M'
}

# 显示信息头
show_header() {
    echo ""
    echo "=================================================="
    echo "  Research Agent - 资料收集"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    log_info "时间边界: $(get_time_boundary) (24小时前)"
    echo ""
}

# 执行 Metaso 搜索（多角度）
run_metaso_search() {
    local query="$1"
    local count="${2:-10}"

    log_info "🔍 Metaso 搜索: $query"

    if [ ! -f "$METASO_DIR/scripts/metaso_search.sh" ]; then
        log_error "Metaso 搜索脚本不存在: $METASO_DIR/scripts/metaso_search.sh"
        return 1
    fi

    bash "$METASO_DIR/scripts/metaso_search.sh" "$query" "$count" 2>&1 | \
        sed 's/^/  /' # 缩进输出

    echo ""
}

# 执行 AI Daily Digest
run_daily_digest() {
    log_info "📰 AI Daily Digest - 90个顶级技术博客"

    if [ ! -f "$DIGEST_DIR/scripts/digest.ts" ]; then
        log_error "AI Daily Digest 脚本不存在: $DIGEST_DIR/scripts/digest.ts"
        return 1
    fi

    cd "$DIGEST_DIR"

    # 仅抓取今日最新
    npx tsx scripts/digest.ts 1 2>&1 | \
        sed 's/^/  /' # 缩进输出

    echo ""
}

# 评估和筛选内容
evaluate_content() {
    local search_results="$1"

    log_info "🎯 评估和筛选内容..."
    log_info "评分标准:"
    echo "  - 时效性 (30%): 24小时内=10分, 48小时=8分"
    echo "  - 热度 (30%): 讨论度、来源权威度"
    echo "  - 价值 (25%): 技术突破、实用性"
    echo "  - AI相关性 (15%): 直接相关=10分"
    echo ""
    log_info "筛选阈值: 综合评分 ≥ 7.0"
    echo ""
}

# 主函数
main() {
    local topic="${1:-AI 工具}"
    local search_count="${2:-5}"

    show_header

    # 搜索策略1: 最新资讯
    log_info "📍 搜索策略1: 最新资讯"
    run_metaso_search "$topic 2026 最新" "$search_count"

    # 搜索策略2: 热点话题
    log_info "📍 搜索策略2: 热点话题"
    run_metaso_search "$topic 2026 热点" "$search_count"

    # 搜索策略3: 特定领域
    log_info "📍 搜索策略3: 产品发布"
    run_metaso_search "$topic 2026 发布" "$search_count"

    # AI Daily Digest
    run_daily_digest

    # 评估和筛选
    evaluate_content

    log_success "✅ 资料收集完成"
    log_info "下一步: 人工评估和筛选，生成最终报告"
}

# 帮助信息
show_help() {
    echo "Research Agent - 资料收集脚本"
    echo ""
    echo "用法:"
    echo "  $0 [主题] [搜索数量]"
    echo ""
    echo "示例:"
    echo "  $0 \"AI 工具\" 5        # 搜索AI工具，每次5条结果"
    echo "  $0 \"视频生成 AI\" 10   # 搜索视频生成AI，每次10条结果"
    echo ""
    echo "特点:"
    echo "  - 24小时时效性控制"
    echo "  - AI 领域热点筛选"
    echo "  - 多角度搜索（最新/热点/发布）"
    echo "  - 90个顶级技术博客"
    echo ""
}

# 参数检查
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# 执行主函数
main "$@"
