#!/bin/bash
# OpenClaw Gateway 启动脚本（自动加载 .env 文件）
# 使用方法：将此脚本复制到 /home/node/.openclaw/scripts/ 并使用它启动 Gateway

OPENCLAW_HOME="/home/node/.openclaw"

# 加载 .env 文件中的环境变量
if [ -f "$OPENCLAW_HOME/.env" ]; then
    echo "正在加载 .env 文件..."
    set -a
    source "$OPENCLAW_HOME/.env"
    set +a
    echo "✅ .env 文件已加载"
    
    # 显示已加载的 API Key（前10位）
    [ -n "$ZHIPU_API_KEY" ] && echo "✅ ZHIPU_API_KEY: ${ZHIPU_API_KEY:0:10}..."
    [ -n "$MINIMAX_API_KEY" ] && echo "✅ MINIMAX_API_KEY: ${MINIMAX_API_KEY:0:10}..."
else
    echo "⚠️ .env 文件不存在: $OPENCLAW_HOME/.env"
fi

# 启动 Gateway
echo "正在启动 OpenClaw Gateway..."
exec openclaw gateway run \
    --bind "${OPENCLAW_GATEWAY_BIND:-0.0.0.0}" \
    --port "${OPENCLAW_GATEWAY_PORT:-18789}" \
    --token "${OPENCLAW_GATEWAY_TOKEN:-123456}" \
    --verbose
