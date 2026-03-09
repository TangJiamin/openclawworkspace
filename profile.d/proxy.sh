#!/bin/bash
# 代理配置 - 持久化配置
# 此文件在容器启动时自动加载

# Clash Verge 代理配置（Mac/Windows Docker Desktop）
export PROXY_URL="http://host.docker.internal:7897"
export http_proxy=$PROXY_URL
export https_proxy=$PROXY_URL
export HTTP_PROXY=$PROXY_URL
export HTTPS_PROXY=$PROXY_URL
export ALL_PROXY=$PROXY_URL
export no_proxy="localhost,127.0.0.1,172.19.0.1"

# Git 配置
git config --global http.proxy $PROXY_URL
git config --global https.proxy $PROXY_URL

echo "✅ 代理已自动启用: $PROXY_URL (Clash Verge)" 2>/dev/null || true
