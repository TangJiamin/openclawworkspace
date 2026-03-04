#!/bin/bash

# GitHub Tool - 仓库信息获取（使用 API，无需 gh CLI）
# 无需认证，访问公开仓库

show_help() {
    echo "GitHub Tool - 获取仓库信息"
    echo ""
    echo "用法:"
    echo "  $0 <owner/repo> [命令]"
    echo ""
    echo "命令:"
    echo "  info    仓库信息（默认）"
    echo "  readme  README 内容"
    echo "  issues  Issue 列表"
    echo "  search  搜索仓库"
    echo ""
    echo "示例:"
    echo '  $0 "Panniantong/Agent-Reach"'
    echo '  $0 "openclaw/openclaw" readme'
    echo '  $0 search "AI agent"'
    echo ""
}

get_repo_info() {
    local repo="$1"
    curl -s "https://api.github.com/repos/$repo" | python3 -m json.tool
}

get_readme() {
    local repo="$1"
    curl -s "https://api.github.com/repos/$repo/readme" \
         -H "Accept: application/vnd.github.v3.raw" \
         | head -100
}

get_issues() {
    local repo="$1"
    curl -s "https://api.github.com/repos/$repo/issues?state=open&per_page=5" | python3 -m json.tool
}

search_repos() {
    local query="$1"
    curl -s "https://api.github.com/search/repositories?q=$query&per_page=5" | python3 -m json.tool
}

# 参数解析
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    show_help
    exit 0
fi

if [ "$1" = "search" ]; then
    search_repos "$2"
    exit 0
fi

repo="$1"
command="${2:-info}"

case "$command" in
    info)
        get_repo_info "$repo"
        ;;
    readme)
        get_readme "$repo"
        ;;
    issues)
        get_issues "$repo"
        ;;
    *)
        echo "未知命令: $command"
        show_help
        exit 1
        ;;
esac
