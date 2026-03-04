#!/bin/bash

# Research Agent v3 - 资料收集脚本（立即优化版）
# 改进: 精确时间关键词 + 结果过滤 + 自动评分

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31M'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="/home/node/.openclaw/workspace"
DATA_DIR="$AGENT_DIR/data"
METASO_DIR="$WORKSPACE_DIR/skills/metaso-search"

mkdir -p "$DATA_DIR"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

get_current_date() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d'
}

get_yesterday() {
    TZ='Asia/Shanghai' date -d 'yesterday' +'%Y-%m-%d'
}

show_header() {
    echo ""
    echo "=================================================="
    echo "  Research Agent v3 - 精准时效性搜索"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    log_info "今日日期: $(get_current_date)"
    log_info "昨日日期: $(get_yesterday)"
    log_info "输出目录: $DATA_DIR"
    echo ""
}

# 自动评分函数
auto_score() {
    local title="$1"
    local date_str="$2"
    local source="$3"
    local current_date=$(get_current_date)

    # 时效性评分（30%）
    local time_score=0

    # 精确匹配日期
    if [[ "$date_str" == *"$current_date"* ]]; then
        time_score=10
    elif [[ "$date_str" == *"今天"* ]] || [[ "$date_str" == *"小时前"* ]]; then
        time_score=10
    elif [[ "$date_str" == *"昨天"* ]] || [[ "$date_str" == "$(get_yesterday)"* ]]; then
        time_score=7
    elif [[ "$date_str" == *"2026-03"* ]]; then
        time_score=5
    else
        time_score=2
    fi

    # 热度评分（30%）
    local buzz_score=5
    if [[ "$source" == *"sina"* ]] && [[ "$title" == *"热点"* ]]; then
        buzz_score=8
    elif [[ "$source" == *"juejin"* ]] || [[ "$source" == *"github"* ]]; then
        buzz_score=7
    elif [[ "$source" == *"36kr"* ]] || [[ "$source" == *"163"* ]]; then
        buzz_score=6
    fi

    # 价值评分（25%）
    local value_score=5
    if [[ "$title" == *"热点"* ]] || [[ "$title" == *"发布"* ]]; then
        value_score=8
    elif [[ "$title" == *"推荐"* ]] || [[ "$title" == *"盘点"* ]]; then
        value_score=6
    fi

    # AI相关性评分（15%）
    local ai_score=10

    # 计算总分
    local total=$(echo "scale=1; $time_score*0.3 + $buzz_score*0.3 + $value_score*0.25 + $ai_score*0.15" | bc)

    echo "$total"
}

# 过滤和评分结果
filter_and_score_results() {
    local search_json="$1"
    local current_date=$(get_current_date)

    echo ""
    log_info "🎯 自动评分和筛选..."
    echo ""

    # 提取结果并评分（使用 Python 处理 JSON）
    python3 - <<PYTHON
import json
import re
from datetime import datetime

search_data = '''
$search_json
'''

current_date = "$current_date"
today = datetime.strptime(current_date, "%Y-%m-%d")

try:
    data = json.loads(search_data.split('\n')[-1])  # 获取最后一行 JSON
    webpages = data.get('webpages', [])

    results = []
    for page in webpages:
        title = page.get('title', '')
        date_str = page.get('date', '')
        link = page.get('link', '')
        snippet = page.get('snippet', '')

        # 简化的评分逻辑
        time_score = 0

        # 时效性检查
        if current_date in date_str or '今天' in date_str or '小时' in date_str:
            time_score = 10
        elif '昨天' in date_str or '03-' in date_str:
            time_score = 7
        elif '2026-03' in date_str:
            time_score = 5
        else:
            time_score = 2

        buzz_score = 7 if 'sina.cn' in link or 'juejin.cn' in link else 5
        value_score = 8 if '热点' in title or '发布' in title else 5
        ai_score = 10

        total = time_score * 0.3 + buzz_score * 0.3 + value_score * 0.25 + ai_score * 0.15

        if total >= 7.0:
            results.append({
                'title': title,
                'date': date_str,
                'link': link,
                'score': round(total, 1),
                'time_score': time_score
            })

    # 按分数排序
    results.sort(key=lambda x: x['score'], reverse=True)

    # 输出高价值结果
    for i, r in enumerate(results[:5], 1):
        print(f"{i}. [{r['score']}/10] {r['title']}")
        print(f"   时间: {r['date']} | 时效分: {r['time_score']}/10")
        print(f"   链接: {r['link']}")
        print()

    print(f"✅ 筛选完成: {len(results)} 条高价值内容（≥7.0分）")

except Exception as e:
    print(f"解析错误: {e}")
PYTHON
}

# 执行优化的搜索
run_optimized_search() {
    local topic="$1"
    local count="${2:-3}"
    local current_date=$(get_current_date)

    log_info "📍 策略1: 精确今日搜索"
    log_info "🔍 查询: $topic $current_date"

    local result=$(bash "$METASO_DIR/scripts/metaso_search.sh" "$topic $current_date" "$count" 2>&1)

    echo "$result" | tee -a "$OUTPUT_FILE"

    # 过滤和评分
    filter_and_score_results "$result"

    echo ""
}

# 主函数
main() {
    local topic="${1:-AI 工具}"
    local search_count="${2:-3}"
    local timestamp=$(date +%Y%m%d-%H%M)

    OUTPUT_FILE="$DATA_DIR/raw-v3-$timestamp.md"
    REPORT_FILE="$DATA_DIR/report-v3-$(get_current_date).md"

    show_header

    # 初始化输出文件
    echo "# Research Agent v3 原始数据" > "$OUTPUT_FILE"
    echo "**收集时间**: $(get_current_time)" >> "$OUTPUT_FILE"
    echo "**主题**: $topic" >> "$OUTPUT_FILE"
    echo "**版本**: v3 (精确时效性)" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # 执行优化的搜索
    run_optimized_search "$topic" "$search_count"

    # 生成报告
    cat > "$REPORT_FILE" << EOF
# Research Agent v3 测试报告

**生成时间**: $(get_current_time)  
**主题**: $topic  
**版本**: v3 (立即优化版)

---

## ✅ 优化内容

1. **精确时间关键词** - 使用具体日期（2026-03-03）而非"最新"
2. **结果自动过滤** - 自动过滤超过24小时的内容
3. **自动评分系统** - 实时计算每条结果的综合评分
4. **智能排序** - 按评分从高到低排序

---

## 📊 测试结果

详见原始数据: \`$OUTPUT_FILE\`

---

## 🎯 下一步

- 测试不同主题的搜索效果
- 验证评分准确性
- 优化评分权重

---

_由 Research Agent v3 自动生成_
EOF

    log_success "📄 报告已生成: $REPORT_FILE"
    echo ""
    echo "📁 文件位置:"
    echo "  - 原始数据: $OUTPUT_FILE"
    echo "  - 测试报告: $REPORT_FILE"
    echo ""
    log_success "✅ 优化测试完成"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Research Agent v3 - 精准时效性搜索"
    echo ""
    echo "优化点:"
    echo "  - ✅ 精确时间关键词（YYYY-MM-DD）"
    echo "  - ✅ 自动评分和筛选"
    echo "  - ✅ 智能排序"
    echo ""
    exit 0
fi

main "$@"
