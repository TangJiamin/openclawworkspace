#!/bin/bash
# OpenClaw 容器启动脚本
# 自动配置代理和启动服务

set -e

echo "🚀 OpenClaw 容器启动中..."

# ===== 代理配置 =====
# Clash Verge 代理（Mac/Windows Docker Desktop）
PROXY_URL="http://host.docker.internal:7897"

export http_proxy=$PROXY_URL
export https_proxy=$PROXY_URL
export HTTP_PROXY=$PROXY_URL
export HTTPS_PROXY=$PROXY_URL
export ALL_PROXY=$PROXY_URL
export no_proxy="localhost,127.0.0.1,172.19.0.1"

# 配置 Git
git config --global http.proxy $PROXY_URL 2>/dev/null || true
git config --global https.proxy $PROXY_URL 2>/dev/null || true

echo "✅ 代理已启用: $PROXY_URL (Clash Verge)"

# ===== 验证代理连接 =====
if command -v curl &> /dev/null; then
    if curl -s -o /dev/null -w "GitHub: %{http_code}\n" https://github.com -m 5 | grep -q "200\|301"; then
        echo "✅ 代理连接正常"
    else
        echo "⚠️  代理连接可能有问题，但将继续启动"
    fi
fi

# ===== 启动 OpenClaw =====
echo "🎯 启动 OpenClaw Gateway..."
exec openclaw gateway start "$@"
