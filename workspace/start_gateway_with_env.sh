#!/bin/bash
# OpenClaw Gateway 启动脚本（自动加载 .env 文件）
# 使用方法：bash /home/node/.openclaw/workspace/start_gateway_with_env.sh

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
    --bind "0.0.0.0" \
    --port 18789 \
    --token "123456" \
    --verbose
