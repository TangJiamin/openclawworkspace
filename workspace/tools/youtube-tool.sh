#!/bin/bash

# YouTube Tool - 提取视频信息和字幕
# 依赖: yt-dlp

show_help() {
    echo "YouTube Tool - 提取视频信息和字幕"
    echo ""
    echo "用法:"
    echo "  $0 <URL/命令> [选项]"
    echo ""
    echo "命令:"
    echo "  info    获取视频信息"
    echo "  subs    提取字幕"
    echo "  search  搜索视频"
    echo ""
    echo "示例:"
    echo '  $0 info "https://youtube.com/watch?v=xxx"'
    echo '  $0 subs "https://youtube.com/watch?v=xxx"'
    echo '  $0 search "AI tutorial"'
    echo ""
}

get_info() {
    local url="$1"
    yt-dlp --dump-json "$url" 2>/dev/null | python3 -m json.tool
}

get_subs() {
    local url="$1"
    yt-dlp --write-subs --sub-lang en,zh --skip-download --quiet "$url" 2>/dev/null
    echo "字幕已保存到当前目录"
}

search_videos() {
    local query="$1"
    yt-dlp "ytsearch10:$query" --get-title --get-id 2>/dev/null
}

# 参数解析
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    show_help
    exit 0
fi

command="$1"
arg="$2"

case "$command" in
    info)
        get_info "$arg"
        ;;
    subs)
        get_subs "$arg"
        ;;
    search)
        search_videos "$arg"
        ;;
    *)
        echo "未知命令: $command"
        show_help
        exit 1
        ;;
esac
