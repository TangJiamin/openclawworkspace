#!/bin/bash

# Research Agent v3.1 - 修复 JSON 解析

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
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

get_current_date() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d'
}

show_header() {
    echo ""
    echo "=================================================="
    echo "  Research Agent v3.1 - 精准搜索"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    log_info "今日日期: $(get_current_date)"
    echo ""
}

# 执行搜索并分析
run_search_and_analyze() {
    local topic="$1"
    local count="${2:-5}"
    local current_date=$(get_current_date)

    log_info "📍 精确搜索: $topic $current_date"
    echo ""

    # 执行搜索并保存完整输出
    local output_file="$DATA_DIR/search-temp-$$.json"
    bash "$METASO_DIR/scripts/metaso_search.sh" "$topic $current_date" "$count" > "$output_file" 2>&1

    # 提取 JSON 行（最后一行）
    local json_line=$(tail -1 "$output_file")

    if [ -z "$json_line" ]; then
        log_error "未找到搜索结果 JSON"
        return 1
    fi

    # 使用 Python 分析结果
    python3 << PYTHON
import json
import sys
from datetime import datetime

json_str = '''$json_line'''

current_date = "$current_date"
today = datetime.strptime(current_date, "%Y-%m-%d")

try:
    data = json.loads(json_str)
    webpages = data.get('webpages', [])

    print(f"\n📊 找到 {len(webpages)} 条结果\n")
    print("=" * 60)

    results = []
    for page in webpages:
        title = page.get('title', '')
        date_str = page.get('date', '')
        link = page.get('link', '')
        snippet = page.get('snippet', '')[:100]

        # 时效性评分
        time_score = 0
        if current_date in date_str or '今天' in date_str or '小时' in date_str:
            time_score = 10
            time_label = "✅ 今日"
        elif '昨天' in date_str or '03-0' in date_str:
            time_score = 7
            time_label = "⚠️ 近2日"
        elif '2026-03' in date_str:
            time_score = 5
            time_label = "⚠️ 本月"
        elif '2026-' in date_str:
            time_score = 3
            time_label = "❌ 本年"
        else:
            time_score = 1
            time_label = "❌ 未知"

        # 热度评分
        buzz_score = 7 if 'sina.cn' in link or 'juejin.cn' in link else 5

        # 价值评分
        value_score = 8 if '热点' in title or '发布' in title else 5

        # AI 相关性
        ai_score = 10

        # 综合评分
        total = time_score * 0.3 + buzz_score * 0.3 + value_score * 0.25 + ai_score * 0.15

        if total >= 6.0:  # 降低阈值，展示更多结果
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

    # 输出高价值结果
    print(f"\n🎯 高价值内容 ({len(results)} 条，≥6.0分):\n")

    for i, r in enumerate(results[:8], 1):
        print(f"{i}. [{r['score']}/10] {r['time_label']} {r['title']}")
        print(f"   📅 {r['date']}")
        print(f"   🔗 {r['link']}")
        print()

    # 统计
    today_count = sum(1 for r in results if r['time_score'] == 10)
    print(f"✅ 今日内容: {today_count} 条")
    print(f"📊 平均评分: {sum(r['score'] for r in results) / len(results):.1f}/10")

except json.JSONDecodeError as e:
    print(f"❌ JSON 解析错误: {e}")
    print(f"原始数据: {json_str[:200]}")
except Exception as e:
    print(f"❌ 处理错误: {e}")
    import traceback
    traceback.print_exc()
PYTHON

    # 清理临时文件
    rm -f "$output_file"

    echo ""
}

main() {
    local topic="${1:-AI 工具}"
    local search_count="${2:-5}"

    show_header

    # 执行搜索和分析
    run_search_and_analyze "$topic" "$search_count"

    log_success "✅ v3.1 测试完成"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Research Agent v3.1 - 修复 JSON 解析"
    echo ""
    echo "改进:"
    echo "  - 修复 JSON 提取逻辑"
    echo "  - 更准确的时效性标签"
    echo "  - 详细的统计信息"
    echo ""
    exit 0
fi

main "$@"
