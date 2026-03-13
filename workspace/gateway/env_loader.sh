#!/bin/bash
# 环境变量加载器 - 放在 Gateway 前面执行
# 使用方法：在启动 Gateway 时使用此脚本

OPENCLAW_HOME="/home/node/.openclaw"

# 加载 .env 文件
if [ -f "$OPENCLAW_HOME/.env" ]; then
    set -a
    source "$OPENCLAW_HOME/.env"
    set +a
    echo "[env_loader] 已加载 .env 文件"
    
    # 显示已加载的 API Key（前10位）
    [ -n "$ZHIPU_API_KEY" ] && echo "[env_loader] ZHIPU_API_KEY: ${ZHIPU_API_KEY:0:10}..."
    [ -n "$MINIMAX_API_KEY" ] && echo "[env_loader] MINIMAX_API_KEY: ${MINIMAX_API_KEY:0:10}..."
fi

# 执行实际的 gateway 命令
exec /usr/local/bin/openclaw gateway run "$@"
