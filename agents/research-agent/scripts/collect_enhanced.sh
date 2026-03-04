#!/bin/bash

# Research Agent Enhanced - 集成互联网能力
# 在 Research Agent v3.2 的基础上，添加 Web、GitHub、YouTube 能力

# 引入互联网工具
source /home/node/.openclaw/workspace/tools/net-tools.sh

# 执行增强的搜索
run_enhanced_search() {
    local topic="$1"
    local count="${2:-5}"
    local current_date=$(get_current_date)

    log_info "📍 综合搜索: $topic ($current_date)"
    echo ""

    # 1. Metaso 搜索（中文优先）
    log_info "🔍 Metaso 搜索"
    bash "$METASO_DIR/scripts/metaso_search.sh" "$topic $current_date" "$count" 2>/dev/null | tail -1 > "$json_file"
    
    # 2. GitHub 搜索（技术项目）
    log_info "🔍 GitHub 搜索"
    local github_results=$(./net-tools.sh github search "$topic" 2>/dev/null | head -20)
    
    # 3. 分析和整合结果
    python3 << PYTHON
import json
import sys

current_date = sys.argv[1]
json_file = sys.argv[2]
github_data = sys.argv[3]

# Metaso 结果
metaso_results = []
with open(json_file, 'r') as f:
    data = json.load(f)
    for page in data.get('webpages', [])[:5]:
        metaso_results.append({
            'source': 'Metaso',
            'title': page.get('title', ''),
            'url': page.get('link', ''),
            'snippet': page.get('snippet', '')[:100]
        })

# 显示结果
print(f"\n📊 综合搜索结果: {topic}\n")
print("=" * 70)

print(f"\n🌐 Metaso 搜索 ({len(metaso_results)} 条):\n")
for i, r in enumerate(metaso_results, 1):
    print(f"{i}. {r['title'][:70]}")
    print(f"   {r['snippet']}")
    print(f"   🔗 {r['url']}")
    print()

# GitHub 结果（简化解析）
github_lines = github_data.strip().split('\n')
if github_lines:
    print(f"📦 GitHub 搜索:\n")
    for line in github_lines[:5]:
        if line.strip():
            print(f"  {line}")
    print()

PYTHON

    rm -f "$json_file"
}

# 主函数
main() {
    local topic="${1:-AI 工具}"
    local count="${2:-5}"
    
    # 设置变量
    METASO_DIR="/home/node/.openclaw/workspace/skills/metaso-search"
    json_file="$DATA_DIR/enhanced-search-$$.json"
    
    mkdir -p "$DATA_DIR"
    
    show_header
    run_enhanced_search "$topic" "$count"
    
    log_success "✅ 增强搜索完成"
}

# 显示头部
show_header() {
    echo ""
    echo "=================================================="
    echo "  Research Agent Enhanced - 互联网增强版"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    echo ""
}

get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

log_info() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }

main "$@"
