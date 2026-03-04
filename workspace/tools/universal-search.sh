#!/bin/bash

# Universal Search - 通用搜索工具
# 整合多个平台的搜索能力

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_help() {
    echo "🔍 Universal Search - 通用搜索工具"
    echo ""
    echo "用法: $0 <平台> <查询>"
    echo ""
    echo "支持的平台:"
    echo "  web     通用网页搜索（通过 Jina Reader + Google）"
    echo "  youtube YouTube 搜索"
    echo "  github  GitHub 仓库搜索"
    echo "  bili    B站搜索"
    echo "  all     综合搜索（所有平台）"
    echo ""
    echo "示例:"
    echo '  $0 web "AI tools 2026"'
    echo '  $0 youtube "AI tutorial"'
    echo '  $0 github "video generation"'
    echo '  $0 bili "AI 视频"'
    echo '  $0 all "AI agent"'
    echo ""
}

# Web 搜索（通过 Jina Reader + Google）
search_web() {
    local query="$1"
    log_info "🔍 通用网页搜索: $query"
    
    # 使用 Jina Reader 代理 Google 搜索
    local encoded_query=$(echo "$query" | sed 's/ /+/g')
    local result=$(curl -s "https://r.jina.ai/https://www.google.com/search?q=$encoded_query" | head -100)
    
    echo "$result"
}

# YouTube 搜索
search_youtube() {
    local query="$1"
    log_info "📺 YouTube 搜索: $query"
    
    if ! command -v yt-dlp &> /dev/null; then
        log_error "yt-dlp 未安装"
        return 1
    fi
    
    yt-dlp "ytsearch5:$query" --get-title --get-id --get-duration 2>/dev/null
}

# GitHub 搜索
search_github() {
    local query="$1"
    log_info "📦 GitHub 搜索: $query"
    
    local encoded_query=$(echo "$query" | sed 's/ /%20/g')
    local result=$(curl -s "https://api.github.com/search/repositories?q=$encoded_query&per_page=5&sort=stars" 2>/dev/null)
    
    if echo "$result" | python3 -m json.tool &> /dev/null; then
        echo "$result" | python3 -c "
import json, sys
data = json.load(sys.stdin)
items = data.get('items', [])
for item in items[:5]:
    stars = item.get('stargazers_count', 0)
    full_name = item.get('full_name', '')
    description = item.get('description', 'N/A')[:80]
    print(f'⭐ {stars} - {full_name}')
    print(f'   {description}')
    print()
"
    else
        log_warning "GitHub API 暂时不可用"
    fi
}

# B站搜索
search_bili() {
    local query="$1"
    log_info "📺 B站搜索: $query"
    
    local encoded_query=$(echo "$query" | sed 's/ /+/g' | sed 's/%20/%20/g')
    local result=$(curl -s "https://r.jina.ai/https://search.bilibili.com/all?keyword=$encoded_query" | head -80)
    
    echo "$result"
}

# Twitter 搜索（需要 xreach）
search_twitter() {
    local query="$1"
    log_info "🐦 Twitter 搜索: $query"
    
    if command -v xreach &> /dev/null; then
        xreach search "$query" --json --count 5 2>/dev/null || log_warning "xreach 需要配置 Cookie"
    else
        log_warning "xreach 未安装（安装: npm install -g xreach-cli）"
        log_warning "安装后需要配置 Twitter Cookie"
    fi
}

# 综合搜索
search_all() {
    local query="$1"
    
    echo ""
    echo "=" * 70
    echo "🔍 综合搜索: $query"
    echo "=" * 70
    echo ""
    
    # Web
    echo "🌐 通用网页搜索:"
    search_web "$query"
    echo ""
    
    # YouTube
    echo "📺 YouTube:"
    search_youtube "$query"
    echo ""
    
    # GitHub
    echo "📦 GitHub:"
    search_github "$query"
    echo ""
    
    # B站
    echo "📺 B站:"
    search_bili "$query"
    echo ""
}

# 主函数
main() {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
        show_help
        exit 0
    fi
    
    local platform="$1"
    local query="$2"
    
    if [ -z "$query" ]; then
        log_error "请提供查询内容"
        show_help
        exit 1
    fi
    
    case "$platform" in
        web)
            search_web "$query"
            ;;
        youtube)
            search_youtube "$query"
            ;;
        github)
            search_github "$query"
            ;;
        bili)
            search_bili "$query"
            ;;
        twitter)
            search_twitter "$query"
            ;;
        all)
            search_all "$query"
            ;;
        *)
            log_error "未知平台: $platform"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
