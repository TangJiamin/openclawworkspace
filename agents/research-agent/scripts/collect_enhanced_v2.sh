#!/bin/bash

# Research Agent Enhanced - 集成互联网能力（修复版）

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="/home/node/.openclaw/workspace"
DATA_DIR="$AGENT_DIR/data"
METASO_DIR="$WORKSPACE_DIR/skills/metaso-search"
TOOLS_DIR="$WORKSPACE_DIR/tools"

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
    echo "  Research Agent Enhanced - 互联网增强版"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    echo ""
}

# 执行增强搜索
run_enhanced_search() {
    local topic="$1"
    local count="${2:-5}"
    local current_date=$(get_current_date)
    local json_file="$DATA_DIR/enhanced-search-$$.json"

    log_info "📍 综合搜索: $topic ($current_date)"
    echo ""

    # 1. Metaso 搜索
    log_info "🔍 Metaso 搜索"
    bash "$METASO_DIR/scripts/metaso_search.sh" "$topic $current_date" "$count" 2>/dev/null | tail -1 > "$json_file" || true
    
    # 2. GitHub 搜索
    log_info "🔍 GitHub 搜索"
    cd "$TOOLS_DIR"
    local github_results=$(bash net-tools.sh github search "$topic" 2>/dev/null || echo "搜索失败")
    
    # 3. 显示整合结果
    echo ""
    echo "📊 综合搜索结果"
    echo "=" * 70
    
    # Metaso 结果
    if [ -s "$json_file" ]; then
        python3 << PYTHON
import json

try:
    with open("$json_file", 'r') as f:
        data = json.load(f)
        pages = data.get('webpages', [])[:5]
        
        print(f"\n🌐 Metaso 搜索 ({len(pages)} 条):\n")
        for i, p in enumerate(pages, 1):
            print(f"{i}. {p.get('title', '')[:70]}")
            print(f"   {p.get('snippet', '')[:80]}")
            print(f"   🔗 {p.get('link', '')}")
            print()
except:
    print("Metaso 搜索结果解析失败")
PYTHON
    fi
    
    # GitHub 结果
    if [ -n "$github_results" ]; then
        echo "📦 GitHub 搜索:"
        echo "$github_results" | head -10
        echo
    fi
    
    rm -f "$json_file"
}

main() {
    local topic="${1:-AI 工具}"
    local count="${2:-5}"
    
    show_header
    run_enhanced_search "$topic" "$count"
    log_success "✅ 增强搜索完成"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Research Agent Enhanced - 互联网增强版"
    echo ""
    echo "用法: $0 [主题] [数量]"
    echo ""
    exit 0
fi

main "$@"
