#!/bin/bash

# Research Agent Ultimate - 终极增强版
# 使用所有可用的互联网能力

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

get_current_date() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d'
}

show_header() {
    echo ""
    echo "=================================================="
    echo "  Research Agent Ultimate - 互联网全能力版"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    log_info "可用能力: Metaso + Web Reader + GitHub + YouTube"
    echo ""
}

# 综合搜索（使用所有工具）
comprehensive_search() {
    local topic="$1"
    local count="${2:-5}"
    local current_date=$(get_current_date)
    
    log_info "📍 综合搜索: $topic"
    log_info "时间范围: $current_date"
    echo ""
    
    # 1. Metaso 搜索（中文资讯）
    log_info "🔍 步骤 1/3: Metaso 搜索（中文资讯）"
    local metaso_file="$DATA_DIR/metaso-result-$$.json"
    bash "$METASO_DIR/scripts/metaso_search.sh" "$topic $current_date" "$count" 2>/dev/null | tail -1 > "$metaso_file" || true
    
    # 2. Web Reader 读取关键网页
    log_info "🌐 步骤 2/3: 提取网页详细内容"
    local web_content=""
    if [ -s "$metaso_file" ]; then
        # 提取第一条结果的链接
        local first_url=$(python3 -c "
import json
try:
    with open('$metaso_file', 'r') as f:
        data = json.load(f)
        pages = data.get('webpages', [])
        if pages:
            print(pages[0].get('link', ''))
except:
    pass
" 2>/dev/null)
        
        if [ -n "$first_url" ]; then
            log_info "   读取: $first_url"
            web_content=$(curl -s "https://r.jina.ai/$first_url" | head -50 2>/dev/null || echo "")
        fi
    fi
    
    # 3. GitHub 搜索（技术项目）
    log_info "📦 步骤 3/3: GitHub 搜索（技术项目）"
    local github_results=""
    
    # 直接使用 curl，避免 API 限制
    local github_url="https://api.github.com/search/repositories?q=$(echo "$topic" | sed 's/ /%20/g')&per_page=3&sort=stars"
    local github_json=$(curl -s "$github_url" 2>/dev/null || echo "")
    
    if [ -n "$github_json" ]; then
        github_results=$(echo "$github_json" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    items = data.get('items', [])
    for item in items[:3]:
        stars = item.get('stargazers_count', 0)
        full_name = item.get('full_name', '')
        description = item.get('description', 'N/A')[:80]
        print(f'⭐ {stars} - {full_name}')
        print(f'   {description}')
        print()
except:
    print('GitHub 搜索暂时不可用')
" 2>/dev/null)
    fi
    
    # 整合输出
    echo ""
    echo "📊 综合搜索结果"
    echo "=" * 70
    echo ""
    
    # Metaso 结果
    if [ -s "$metaso_file" ]; then
        python3 << PYTHON
import json

try:
    with open("$metaso_file", 'r') as f:
        data = json.load(f)
        pages = data.get('webpages', [])[:5]
        
        print(f"🌐 Metaso 搜索 ({len(pages)} 条):\n")
        
        for i, p in enumerate(pages, 1):
            title = p.get('title', '')
            snippet = p.get('snippet', '')[:100]
            link = p.get('link', '')
            
            # 时效性标记
            date_str = p.get('date', '')
            if '$current_date' in date_str or '今天' in date_str or '2026-03-03' in date_str:
                time_tag = "✅ 今日"
            elif '2026-03' in date_str:
                time_tag = "⚠️ 本月"
            else:
                time_tag = "❌ 旧闻"
            
            print(f"{i}. [{time_tag}] {title[:70]}")
            print(f"   {snippet}")
            print(f"   🔗 {link}")
            print()
except Exception as e:
    print(f"解析错误: {e}")
PYTHON
    fi
    
    # Web 内容
    if [ -n "$web_content" ]; then
        echo "📖 深度阅读（第一条结果）:"
        echo "$web_content"
        echo ""
    fi
    
    # GitHub 结果
    if [ -n "$github_results" ]; then
        echo "📦 GitHub 热门项目:"
        echo "$github_results"
    fi
    
    rm -f "$metaso_file"
}

# 主函数
main() {
    local topic="${1:-AI 工具}"
    local count="${2:-5}"
    
    show_header
    comprehensive_search "$topic" "$count"
    log_success "✅ 综合搜索完成"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Research Agent Ultimate - 互联网全能力版"
    echo ""
    echo "用法: $0 [主题] [数量]"
    echo ""
    echo "能力:"
    echo "  - Metaso 搜索（中文资讯）"
    echo "  - Web Reader（网页详细内容）"
    echo "  - GitHub 搜索（技术项目）"
    echo ""
    exit 0
fi

main "$@"
