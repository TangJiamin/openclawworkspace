#!/bin/bash

# Web Reader - 使用 Jina Reader 读取网页内容
# 无需 API Key，完全免费

show_help() {
    echo "Web Reader - 读取任意网页内容"
    echo ""
    echo "用法:"
    echo "  $0 <URL> [选项]"
    echo ""
    echo "选项:"
    echo "  --raw    输出原始格式（JSON）"
    echo "  --clean  只输出正文（默认）"
    echo "  --limit  限制输出行数（默认 100）"
    echo ""
    echo "示例:"
    echo '  $0 "https://example.com/article"'
    echo '  $0 "https://github.com/user/repo" --limit 50'
    echo ""
}

read_web() {
    local url="$1"
    local limit="${3:-100}"
    
    # 使用 Jina Reader API
    local result=$(curl -s "https://r.jina.ai/$url" | head -n "$limit")
    
    echo "$result"
}

# 参数解析
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    show_help
    exit 0
fi

# 执行
read_web "$@"
