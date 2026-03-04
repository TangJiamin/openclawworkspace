#!/bin/bash

# Internet Tools - 互联网能力集合
# 整合多个工具，提供统一的接口

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
    echo "🌐 Internet Tools - AI Agent 互联网能力工具集"
    echo ""
    echo "用法: $0 <平台> <命令> [参数]"
    echo ""
    echo "支持的平台:"
    echo "  web       网页阅读（Jina Reader）"
    echo "  youtube   YouTube 信息和字幕"
    echo "  github    GitHub 仓库信息"
    echo "  search    网页搜索（Brave Search）"
    echo ""
    echo "示例:"
    echo '  $0 web read "https://example.com"'
    echo '  $0 youtube info "https://youtube.com/watch?v=xxx"'
    echo '  $0 github info "owner/repo"'
    echo '  $0 search "AI tools 2026"'
    echo ""
}

# Web 工具
tool_web() {
    local cmd="$1"
    local url="$2"
    
    case "$cmd" in
        read)
            curl -s "https://r.jina.ai/$url" | head -100
            ;;
        *)
            echo "未知命令: $cmd"
            echo "可用: read"
            ;;
    esac
}

# YouTube 工具
tool_youtube() {
    local cmd="$1"
    local url="$2"
    
    case "$cmd" in
        info)
            yt-dlp --dump-json "$url" 2>/dev/null | python3 -m json.tool
            ;;
        subs)
            yt-dlp --write-subs --sub-lang en,zh --skip-download --quiet "$url"
            echo "字幕已下载"
            ;;
        search)
            yt-dlp "ytsearch5:$url" --get-title 2>/dev/null
            ;;
        *)
            echo "未知命令: $cmd"
            echo "可用: info, subs, search"
            ;;
    esac
}

# GitHub 工具
tool_github() {
    local cmd="$1"
    local arg="$2"
    
    case "$cmd" in
        info)
            curl -s "https://api.github.com/repos/$arg" | python3 -m json.tool
            ;;
        readme)
            curl -s "https://api.github.com/repos/$arg/readme" \
                 -H "Accept: application/vnd.github.v3.raw" | head -100
            ;;
        issues)
            curl -s "https://api.github.com/repos/$arg/issues?state=open&per_page=5" | python3 -m json.tool
            ;;
        search)
            curl -s "https://api.github.com/search/repositories?q=$arg&per_page=5" | python3 -m json.tool
            ;;
        *)
            echo "未知命令: $cmd"
            echo "可用: info, readme, issues, search"
            ;;
    esac
}

# Search 工具
tool_search() {
    local query="$1"
    echo "搜索: $query"
    echo "注意: 需要配置 Brave Search API key"
    echo "或者使用: curl -s \"https://r.jina.ai/https://www.google.com/search?q=$query\""
}

# 参数解析
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    show_help
    exit 0
fi

platform="$1"
command="$2"
arg="$3"

case "$platform" in
    web)
        tool_web "$command" "$arg"
        ;;
    youtube)
        tool_youtube "$command" "$arg"
        ;;
    github)
        tool_github "$command" "$arg"
        ;;
    search)
        tool_search "$command"
        ;;
    *)
        echo "未知平台: $platform"
        show_help
        exit 1
        ;;
esac
