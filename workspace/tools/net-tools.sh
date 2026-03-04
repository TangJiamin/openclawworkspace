#!/bin/bash

# 简化版 Internet Tools
# 专注于核心功能

# Web 阅读工具
web_read() {
    local url="$1"
    echo "📖 读取网页: $url"
    echo "---"
    curl -s "https://r.jina.ai/$url" | head -100
}

# GitHub 信息工具
github_info() {
    local repo="$1"
    echo "📦 GitHub 仓库: $repo"
    echo "---"
    curl -s "https://api.github.com/repos/$repo" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f\"名称: {data['name']}\")
print(f\"描述: {data.get('description', 'N/A')}\")
print(f\"Stars: {data['stargazers_count']}\")
print(f\"URL: {data['html_url']}\")
print(f\"语言: {data.get('language', 'N/A')}\")
"
}

# GitHub 搜索工具
github_search() {
    local query="$1"
    echo "🔍 搜索 GitHub: $query"
    echo "---"
    curl -s "https://api.github.com/search/repositories?q=$query&per_page=5" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for item in data['items'][:5]:
    print(f\"⭐ {item['stargazers_count']} - {item['full_name']}\")
    print(f\"   {item.get('description', 'N/A')[:80]}\")
    print()
"
}

# YouTube 信息工具
youtube_info() {
    local url="$1"
    echo "📺 YouTube 视频: $url"
    echo "---"
    yt-dlp --dump-json "$url" 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f\"标题: {data['title']}\")
print(f\"时长: {data['duration']} 秒\")
print(f\"观看: {data['view_count']}\")
print(f\"上传: {data['upload_date']}\")
print(f\"频道: {data['channel']}\")
"
}

# YouTube 搜索工具
youtube_search() {
    local query="$1"
    echo "🔍 搜索 YouTube: $query"
    echo "---"
    yt-dlp "ytsearch5:$query" --get-title --get-id 2>/dev/null
}

# 帮助
show_help() {
    echo "🌐 Internet Tools - AI Agent 互联网能力"
    echo ""
    echo "用法: $0 <平台> <命令> [参数]"
    echo ""
    echo "命令示例:"
    echo "  $0 web read <URL>"
    echo "  $0 github info <owner/repo>"
    echo "  $0 github search <query>"
    echo "  $0 youtube info <URL>"
    echo "  $0 youtube search <query>"
    echo ""
}

# 主函数
main() {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
        show_help
        exit 0
    fi
    
    local platform="$1"
    local command="$2"
    local arg="$3"
    
    case "$platform" in
        web)
            if [ "$command" = "read" ]; then
                web_read "$arg"
            fi
            ;;
        github)
            case "$command" in
                info) github_info "$arg" ;;
                search) github_search "$arg" ;;
                *) echo "可用命令: info, search" ;;
            esac
            ;;
        youtube)
            case "$command" in
                info) youtube_info "$arg" ;;
                search) youtube_search "$arg" ;;
                *) echo "可用命令: info, search" ;;
            esac
            ;;
        *)
            echo "未知平台: $platform"
            show_help
            ;;
    esac
}

main "$@"
