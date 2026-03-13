#!/bin/bash
# ClawHub 批量安装脚本
# 用法: bash install-clawhub-skills.sh

set -e

SKILLS=(
  "notion"
  "pdf"
  "code"
  "email-daily-summary"
  "calendar"
)

echo "===== ClawHub 批量安装脚本 ====="
echo "待安装技能: ${SKILLS[@]}"
echo ""

for skill in "${SKILLS[@]}"; do
  echo "📦 安装 $skill..."

  if bunx clawhub@latest install "$skill" --no-input 2>&1; then
    echo "✅ $skill 安装成功"
  else
    echo "❌ $skill 安装失败（可能受 Rate Limit 限制）"
  fi

  # 等待 20 秒避免 Rate Limit
  echo "⏳ 等待 20 秒..."
  sleep 20
  echo ""
done

echo "===== 安装完成 ====="
echo "检查已安装技能:"
bunx clawhub@latest list