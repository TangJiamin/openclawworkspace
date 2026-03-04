#!/bin/bash
# GitHub 认证配置脚本
# 使用方式：source /home/node/.openclaw/github-env.sh

# 检查环境变量
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  未设置 GITHUB_TOKEN 环境变量"
    echo ""
    echo "请在你的终端执行："
    echo "export GITHUB_TOKEN='ghp_xxxxxxxxxxxxxxxxxxxx'"
    echo ""
    echo "获取 Token：https://github.com/settings/tokens"
    echo "权限选择：repo（完整仓库访问权限）"
    return 1
fi

# 配置 Git 使用 Token
git config --global url."https://$GITHUB_TOKEN@github.com/".insteadOf "https://github.com/"

echo "✅ Git 配置完成"
echo ""
echo "用户名: $(git config --global user.name)"
echo "邮箱: $(git config --global user.email)"
echo ""
echo "现在你可以使用 Git 操作了："
echo "  git clone https://github.com/TangJiamin/repo.git"
echo "  git push origin main"
