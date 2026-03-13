#!/bin/bash
# 统一搜索接口（Brave + Tavily 备用）
# 用法: bash search.sh "<query>" [max_results]

set -e

QUERY="$1"
MAX_RESULTS="${2:-5}"

if [ -z "$QUERY" ]; then
  echo "Usage: $0 <query> [max_results]" >&2
  exit 1
fi

# 1. 优先使用 Brave Search (web_search tool)
# Note: Brave Search 通过 OpenClaw 的 web_search tool 调用
# 这里提供降级方案

# 2. 备用: Tavily Search
if [ -n "$TAVILY_API_KEY" ] && [ -f "/home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py" ]; then
  python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
    --query "$QUERY" \
    --max-results "$MAX_RESULTS" \
    --format brave
  exit $?
fi

# 3. 降级: 使用 Metaso 搜索
if [ -f "/home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh" ]; then
  bash /home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh "$QUERY" "$MAX_RESULTS"
  exit $?
fi

# 4. 最后降级: 使用 web_fetch (尝试直接获取)
echo "# 搜索结果: $QUERY" >&2
echo "⚠️  所有搜索服务不可用，请配置至少一个搜索服务:" >&2
echo "   - Brave Search (OpenClaw 内置)" >&2
echo "   - Tavily Search (设置 TAVILY_API_KEY)" >&2
echo "   - Metaso Search (已集成)" >&2
exit 1
