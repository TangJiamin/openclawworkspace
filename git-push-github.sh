#!/bin/bash

# GitHub 推送脚本（使用 .env 中的 Token）
# 文件: /home/node/.openclaw/git-push-github.sh

set -e

# 进入目录
cd /home/node/.openclaw

# 加载 .env 文件
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "错误: .env 文件不存在"
    exit 1
fi

# 检查 GITHUB_TOKEN
if [ -z "$GITHUB_TOKEN" ] || [ "$GITHUB_TOKEN" = "your-token-here" ]; then
    echo "错误: GITHUB_TOKEN 未配置"
    echo ""
    echo "请按以下步骤操作:"
    echo "1. 访问: https://github.com/settings/tokens"
    echo "2. 生成 Token（权限: repo）"
    echo "3. 编辑 .env 文件，设置 GITHUB_TOKEN=<your-token>"
    echo ""
    exit 1
fi

# 配置远程仓库（使用 Token）
git remote set-url origin https://${GITHUB_TOKEN}@github.com/TangJiamin/openclawworkspace.git

# 推送代码
echo "正在推送到 GitHub..."
git push -u origin master

# 验证推送
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 推送成功！"
    echo ""
    echo "访问: https://github.com/TangJiamin/openclawspace"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "请检查:"
    echo "1. GITHUB_TOKEN 是否正确"
    echo "2. 网络连接是否正常"
    echo "3. 远程仓库 URL 是否正确"
    echo ""
    exit 1
fi
