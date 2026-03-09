#!/bin/bash

# Git 自动备份脚本
# 文件: /home/node/.openclaw/git-auto-backup.sh

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
    exit 1
fi

# 检查是否有修改
if [ -n "$(git status --porcelain)" ]; then
    echo "检测到修改，正在备份..."

    # 添加所有修改
    git add -A

    # 提交修改
    git commit -m "自动备份: $(date +'%Y-%m-%d %H:%M:%S')"

    # 配置远程仓库
    git remote set-url origin https://${GITHUB_TOKEN}@github.com/TangJiamin/openclawworkspace.git

    # 推送到 GitHub
    git push origin master

    if [ $? -eq 0 ]; then
        echo "✅ 备份成功: $(date +'%Y-%m-%d %H:%M:%S')"
    else
        echo "❌ 备份失败: $(date +'%Y-%m-%d %H:%M:%S')"
        exit 1
    fi
else
    echo "✓ 无修改，跳过备份"
fi
