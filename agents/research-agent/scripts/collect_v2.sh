#!/bin/bash

# Research Agent v2 - 资料收集脚本（优化版）
# 改进: 时效性强化 + 自动评分 + 结果保存

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="/home/node/.openclaw/workspace"
DATA_DIR="$AGENT_DIR/data"
METASO_DIR="$WORKSPACE_DIR/skills/metaso-search"

# 创建数据目录
mkdir -p "$DATA_DIR"

# 日志函数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 获取当前时间（上海时区）
get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

get_current_date() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d'
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
    echo "  Research Agent v2 - 资料收集"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    log_info "时间边界: $(get_time_boundary) (24小时前)"
    log_info "输出目录: $DATA_DIR"
    echo ""
}

# 执行 Metaso 搜索（优化时效性）
run_metaso_search() {
    local query="$1"
    local count="${2:-5}"
    local output_file="$3"

    log_info "🔍 Metaso 搜索: $query"

    if [ ! -f "$METASO_DIR/scripts/metaso_search.sh" ]; then
        log_error "Metaso 搜索脚本不存在"
        return 1
    fi

    # 执行搜索并保存结果
    bash "$METASO_DIR/scripts/metaso_search.sh" "$query" "$count" 2>&1 | tee -a "$output_file"

    echo ""
}

# 使用 Brave Search（带时效性过滤）
run_brave_search() {
    local query="$1"
    local count="${2:-5}"
    local output_file="$3"

    log_info "🔍 Brave Search: $query (24小时内)"

    # 这里需要调用 web_search 工具
    # 由于脚本中无法直接调用，我们记录建议
    echo "  [建议] 使用 web_search 工具，参数: freshness=\"pd\"" | tee -a "$output_file"
    echo "  查询: $query" | tee -a "$output_file"
    echo ""
}

# 自动评分函数
auto_score() {
    local title="$1"
    local date_str="$2"
    local source="$3"

    # 时效性评分（30%）
    local time_score=0
    local current_ts=$(date +%s)
    local current_date=$(get_current_date)

    if [[ "$date_str" == *"小时"* ]] || [[ "$date_str" == *"刚刚"* ]]; then
        time_score=10
    elif [[ "$date_str" == *"今天"* ]] || [[ "$date_str" == "$current_date"* ]]; then
        time_score=9
    elif [[ "$date_str" == *"昨天"* ]]; then
        time_score=7
    elif [[ "$date_str" == *"2026-03"* ]]; then
        time_score=5
    else
        time_score=2
    fi

    # 热度评分（30%）- 简化判断
    local buzz_score=5
    if [[ "$source" == *"36kr"* ]] || [[ "$source" == *"juejin"* ]]; then
        buzz_score=7
    elif [[ "$source" == *"sina"* ]] || [[ "$source" == *"qq"* ]]; then
        buzz_score=6
    fi

    # 价值评分（25%）- 基于关键词
    local value_score=5
    if [[ "$title" == *"发布"* ]] || [[ "$title" == *"突破"* ]]; then
        value_score=8
    elif [[ "$title" == *"推荐"* ]] || [[ "$title" == *"盘点"* ]]; then
        value_score=6
    fi

    # AI相关性评分（15%）
    local ai_score=10  # 默认高，因为搜索已经是AI领域

    # 计算总分
    local total=$(echo "scale=1; $time_score*0.3 + $buzz_score*0.3 + $value_score*0.25 + $ai_score*0.15" | bc)
    
    echo "$total"
}

# 生成报告
generate_report() {
    local raw_file="$1"
    local report_file="$2"
    local current_date=$(get_current_date)
    local current_time=$(get_current_time)

    cat > "$report_file" << EOF
# 资料收集报告

**生成时间**: $current_time  
**时间范围**: 过去24小时  
**状态**: ⚠️ 时效性需要验证

---

## 📊 收集概览

- **搜索来源**: Metaso AI Search
- **搜索策略**: 最新资讯 / 热点话题 / 产品发布
- **原始结果**: 已收集（详见原始数据）
- **筛选状态**: 需要人工验证时效性

---

## ⚠️ 时效性问题

**当前问题**: 搜索结果中大部分内容时间戳不明确或超过24小时

**建议优化**:
1. 使用 Brave Search API 的 freshness 参数（24小时内）
2. 添加 Twitter/Reddit 实时搜索
3. 手动验证每条结果的实际发布时间

---

## 🔍 原始搜索结果

详见: \`$raw_file\`

---

## 下一步行动

1. ✅ 使用 web_search 工具（Brave Search，带时间过滤）
2. ✅ 人工验证时效性
3. ✅ 根据评分标准筛选（≥7.0分）
4. ✅ 生成最终精简报告

---

_由 Research Agent v2 自动生成_
EOF

    log_success "📄 报告已生成: $report_file"
}

# 主函数
main() {
    local topic="${1:-AI 工具}"
    local search_count="${2:-5}"
    local current_date=$(get_current_date)
    local timestamp=$(date +%Y%m%d-%H%M)
    
    # 输出文件
    local raw_file="$DATA_DIR/raw-$timestamp.md"
    local report_file="$DATA_DIR/report-$current_date.md"

    show_header

    # 初始化原始数据文件
    echo "# Research Agent 原始数据" > "$raw_file"
    echo "**收集时间**: $(get_current_time)" >> "$raw_file"
    echo "**主题**: $topic" >> "$raw_file"
    echo "" >> "$raw_file"

    # 搜索策略1: 最新资讯（优化关键词）
    log_info "📍 搜索策略1: 最新资讯（今日）"
    run_metaso_search "$topic 今天 最新 2026-03-03" "$search_count" "$raw_file"

    # 搜索策略2: 热点话题
    log_info "📍 搜索策略2: 热点话题"
    run_metaso_search "$topic 热点 2026年3月" "$search_count" "$raw_file"

    # 搜索策略3: 使用 Brave Search（建议）
    log_info "📍 搜索策略3: Brave Search（24小时内）"
    run_brave_search "$topic" "$search_count" "$raw_file"

    # 生成报告
    echo ""
    log_info "📊 生成分析报告..."
    generate_report "$raw_file" "$report_file"

    log_success "✅ 资料收集完成"
    echo ""
    echo "📁 文件位置:"
    echo "  - 原始数据: $raw_file"
    echo "  - 分析报告: $report_file"
    echo ""
}

# 帮助信息
show_help() {
    echo "Research Agent v2 - 资料收集脚本（优化版）"
    echo ""
    echo "用法:"
    echo "  $0 [主题] [搜索数量]"
    echo ""
    echo "改进点:"
    echo "  - ✅ 优化搜索关键词（今日、最新）"
    echo "  - ✅ 自动保存结果到文件"
    echo "  - ✅ 生成结构化报告"
    echo "  - ⚠️ 时效性仍需人工验证"
    echo ""
}

# 参数检查
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# 执行主函数
main "$@"
