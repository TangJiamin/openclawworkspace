#!/bin/bash

# Research Agent v3.2 - 最终优化版
# 改进: 稳定的 JSON 处理 + 完整的评分系统

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="/home/node/.openclaw/workspace"
DATA_DIR="$AGENT_DIR/data"
METASO_DIR="$WORKSPACE_DIR/skills/metaso-search"

mkdir -p "$DATA_DIR"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

get_current_date() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d'
}

show_header() {
    echo ""
    echo "=================================================="
    echo "  Research Agent v3.2 - 最终优化版"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    log_info "今日日期: $(get_current_date)"
    echo ""
}

# 使用文件传递数据，避免 shell 引号问题
run_search_and_analyze() {
    local topic="$1"
    local count="${2:-10}"
    local current_date=$(get_current_date)

    log_info "📍 精确搜索: $topic $current_date"
    echo ""

    # 临时文件
    local json_file="$DATA_DIR/search-result-$$.json"
    local python_script="$DATA_DIR/analyze-$$.py"

    # 执行搜索，保存到文件
    bash "$METASO_DIR/scripts/metaso_search.sh" "$topic $current_date" "$count" 2>/dev/null | tail -1 > "$json_file"

    # 检查是否有效 JSON
    if ! grep -q '"webpages"' "$json_file"; then
        echo "❌ 搜索失败，未找到有效结果"
        rm -f "$json_file" "$python_script"
        return 1
    fi

    # 创建 Python 分析脚本
    cat > "$python_script" << 'PYEOF'
import json
import sys
from datetime import datetime

# 从参数获取当前日期
current_date = sys.argv[1]
json_file = sys.argv[2]

today = datetime.strptime(current_date, "%Y-%m-%d")

try:
    with open(json_file, 'r') as f:
        data = json.load(f)

    webpages = data.get('webpages', [])

    print(f"\n📊 找到 {len(webpages)} 条结果\n")
    print("=" * 70)

    results = []
    for page in webpages:
        title = page.get('title', '')
        date_str = page.get('date', '')
        link = page.get('link', '')

        # 时效性评分（30%）
        time_score = 0
        time_label = ""

        # 标准化日期字符串用于匹配
        date_normalized = date_str.replace('年', '-').replace('月', '-').replace('日', '')

        if current_date in date_str or current_date in date_normalized or '今天' in date_str:
            time_score = 10
            time_label = "✅ 今日"
        elif '昨天' in date_str or '03-02' in date_normalized or '03-0' in date_normalized:
            time_score = 7
            time_label = "⚠️ 近2日"
        elif '2026-03' in date_str or '2026-3' in date_normalized:
            time_score = 5
            time_label = "⚠️ 本月"
        elif '2026-' in date_str or '2026' in date_normalized:
            time_score = 3
            time_label = "⚠️ 本年"
        else:
            time_score = 1
            time_label = "❌ 旧闻"

        # 热度评分（30%）
        buzz_score = 5
        if 'sina.cn' in link:
            buzz_score = 8
        elif 'juejin.cn' in link or 'github' in link.lower():
            buzz_score = 7
        elif '36kr' in link or '163' in link:
            buzz_score = 6

        # 价值评分（25%）
        value_score = 5
        if '热点' in title or '发布' in title:
            value_score = 8
        elif '推荐' in title or '指南' in title:
            value_score = 6
        elif '清单' in title:
            value_score = 5

        # AI 相关性（15%）
        ai_score = 10

        # 综合评分
        total = time_score * 0.3 + buzz_score * 0.3 + value_score * 0.25 + ai_score * 0.15

        results.append({
            'title': title,
            'date': date_str,
            'link': link,
            'score': round(total, 1),
            'time_score': time_score,
            'time_label': time_label
        })

    # 按分数排序
    results.sort(key=lambda x: x['score'], reverse=True)

    # 只显示高价值结果（≥6.0分）
    high_value = [r for r in results if r['score'] >= 6.0]

    print(f"\n🎯 高价值内容 ({len(high_value)} 条，≥6.0分):\n")

    for i, r in enumerate(high_value[:10], 1):
        print(f"{i}. [{r['score']}/10] {r['time_label']} {r['title'][:60]}")
        print(f"   📅 {r['date']}")
        print(f"   🔗 {r['link']}")
        print()

    # 统计信息
    today_count = sum(1 for r in high_value if r['time_score'] == 10)
    avg_score = sum(r['score'] for r in high_value) / len(high_value) if high_value else 0

    print("=" * 70)
    print(f"📈 统计:")
    print(f"  ✅ 今日内容: {today_count} 条")
    print(f"  📊 平均评分: {avg_score:.1f}/10")
    print(f"  🎯 高价值率: {len(high_value)}/{len(results)} ({len(high_value)*100//len(results) if results else 0}%)")
    print()

except Exception as e:
    print(f"❌ 处理错误: {e}")
    import traceback
    traceback.print_exc()
PYEOF

    # 执行分析
    python3 "$python_script" "$current_date" "$json_file"

    # 清理临时文件
    rm -f "$json_file" "$python_script"

    echo ""
}

main() {
    local topic="${1:-AI 工具}"
    local search_count="${2:-10}"

    show_header

    # 执行搜索和分析
    run_search_and_analyze "$topic" "$search_count"

    log_success "✅ v3.2 测试完成"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Research Agent v3.2 - 最终优化版"
    echo ""
    echo "特性:"
    echo "  - ✅ 精确时间关键词（YYYY-MM-DD）"
    echo "  - ✅ 稳定的 JSON 处理"
    echo "  - ✅ 完整的评分系统"
    echo "  - ✅ 详细的统计信息"
    echo ""
    exit 0
fi

main "$@"
