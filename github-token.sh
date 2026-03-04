#!/bin/bash
# GitHub Token 持久化配置
# 将此文件添加到 ~/.bashrc 或 ~/.profile

# ⚠️ 请替换成你的 GitHub Personal Access Token
export GITHUB_TOKEN='ghp_xxxxxxxxxxxxxxxxxxxx'

# Git 配置
git config --global user.name "TangJiamin"
git config --global user.email "787592346@qq.com"
git config --global credential.helper store
git config --global url."https://$GITHUB_TOKEN@github.com/".insteadOf "https://github.com/"

echo "✅ GitHub 配置已加载"
