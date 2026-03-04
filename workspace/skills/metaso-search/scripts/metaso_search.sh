#!/bin/bash
# Metaso AI Search Script
# Usage: ./metaso_search.sh "搜索关键词" [结果数量]

QUERY="$1"
SIZE="${2:-10}"
SCOPE="${3:-webpage}"

# API密钥 - 请确保环境变量中已设置 METASO_API_KEY
API_KEY="${METASO_API_KEY:-mk-B666AF87AB936668EB445F2ABDC687BF}"

if [ -z "$QUERY" ]; then
    echo "Error: 请提供搜索关键词"
    echo "用法: $0 \"搜索关键词\" [结果数量] [搜索范围]"
    echo "示例: $0 \"OPC 一人公司政策\" 10"
    exit 1
fi

# 执行搜索
curl --location 'https://metaso.cn/api/v1/search' \
  --header "Authorization: Bearer $API_KEY" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data "{
    \"q\": \"$QUERY\",
    \"scope\": \"$SCOPE\",
    \"includeSummary\": true,
    \"size\": \"$SIZE\",
    \"includeRawContent\": false,
    \"conciseSnippet\": false
  }"
