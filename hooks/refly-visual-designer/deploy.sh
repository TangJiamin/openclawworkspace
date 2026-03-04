#!/bin/bash

# Refly 视觉设计师 Hook - 一键部署脚本
# 使用方法: bash deploy.sh

set -e  # 遇到错误立即退出

echo "╔════════════════════════════════════════╗"
echo "║  Refly 视觉设计师 - 快速部署工具       ║"
echo "╚════════════════════════════════════════╝"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查函数
check_step() {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ $1${NC}"
  else
    echo -e "${RED}❌ $1${NC}"
    exit 1
  fi
}

# ========== 步骤 1: 检查依赖 ==========
echo "══ 步骤 1/7: 检查依赖 ══"

# 检查 Node.js
if command -v node &> /dev/null; then
  NODE_VERSION=$(node -v)
  echo -e "${GREEN}✓ Node.js 已安装: $NODE_VERSION${NC}"
else
  echo -e "${RED}✗ Node.js 未安装${NC}"
  echo "请先安装 Node.js: https://nodejs.org/"
  exit 1
fi

# 检查 npm
if command -v npm &> /dev/null; then
  NPM_VERSION=$(npm -v)
  echo -e "${GREEN}✓ npm 已安装: $NPM_VERSION${NC}"
else
  echo -e "${RED}✗ npm 未安装${NC}"
  exit 1
fi

# 检查 OpenClaw
if command -v openclaw &> /dev/null; then
  OC_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
  echo -e "${GREEN}✓ OpenClaw 已安装: $OC_VERSION${NC}"
else
  echo -e "${RED}✗ OpenClaw 未安装${NC}"
  echo "请先安装 OpenClaw: https://docs.openclaw.ai"
  exit 1
fi

echo ""

# ========== 步骤 2: 检查配置 ==========
echo "══ 步骤 2/7: 检查配置 ══"

# 检查环境变量
if [ -f ~/.openclaw/gateway.env ]; then
  echo -e "${GREEN}✓ gateway.env 文件存在${NC}"

  if grep -q "REFLY_API_KEY" ~/.openclaw/gateway.env; then
    echo -e "${GREEN}✓ REFLY_API_KEY 已配置${NC}"
  else
    echo -e "${YELLOW}⚠ REFLY_API_KEY 未配置${NC}"
    echo ""
    echo "请输入 Refly API Key:"
    read -p "> " API_KEY

    if [ -n "$API_KEY" ]; then
      echo "" >> ~/.openclaw/gateway.env
      echo "# Refly 配置" >> ~/.openclaw/gateway.env
      echo "REFLY_URL=http://refly.kmos.ai" >> ~/.openclaw/gateway.env
      echo "REFLY_API_KEY=$API_KEY" >> ~/.openclaw/gateway.env
      echo "REFLY_VISUAL_WORKFLOW_ID=c-anlbsxecm4d201aj4zgnph8y" >> ~/.openclaw/gateway.env
      echo -e "${GREEN}✓ API Key 已保存到 gateway.env${NC}"
    else
      echo -e "${RED}✗ API Key 不能为空${NC}"
      exit 1
    fi
  fi
else
  echo -e "${RED}✗ gateway.env 文件不存在${NC}"
  echo "请先配置 OpenClaw Gateway"
  exit 1
fi

echo ""

# ========== 步骤 3: 安装依赖 ==========
echo "══ 步骤 3/7: 安装依赖 ══"

cd ~/.openclaw/hooks/refly-visual-designer
npm install
check_step "依赖安装完成"

echo ""

# ========== 步骤 4: 编译 Hook ==========
echo "══ 步骤 4/7: 编译 Hook ══"

npm run build
check_step "Hook 编译完成"

# 验证编译文件
if [ -f "dist/handler.js" ]; then
  echo -e "${GREEN}✓ dist/handler.js 已生成${NC}"
else
  echo -e "${RED}✗ dist/handler.js 未生成${NC}"
  exit 1
fi

echo ""

# ========== 步骤 5: 启用 Hook ==========
echo "══ 步骤 5/7: 启用 Hook ══"

openclaw hooks enable refly-visual-designer
check_step "Hook 启用成功"

echo ""

# ========== 步骤 6: 重启 Gateway ==========
echo "══ 步骤 6/7: 重启 Gateway ══"

openclaw gateway restart
sleep 5
check_step "Gateway 重启完成"

echo ""

# ========== 步骤 7: 验证部署 ==========
echo "══ 步骤 7/7: 验证部署 ══"

# 检查 Hook 状态
echo "检查 Hook 状态..."
openclaw hooks check | grep -A 5 "refly-visual-designer" || echo "Hook 未在列表中"

# 检查 Gateway 状态
echo ""
echo "检查 Gateway 状态..."
openclaw gateway status

echo ""
echo "╔════════════════════════════════════════╗"
echo "║       🎉 部署完成！                   ║"
echo "╚════════════════════════════════════════╝"
echo ""

echo "📋 下一步操作："
echo ""
echo "1️⃣  测试功能"
echo "   在任意平台发送："
echo "   \"生成封面图：AI时代的生产力革命\""
echo ""
echo "2️⃣  查看日志"
echo "   openclaw logs --tail 50 | grep refly"
echo ""
echo "3️⃣  配置定时任务（可选）"
echo "   openclaw cron add \\"
echo "     --name \"daily-visual-design\" \\"
echo "     --schedule \"cron\" \\"
echo "     --cron \"0 11 * * *\" \\"
echo "     --sessionTarget \"isolated\" \\"
echo "     --message \"执行今日视觉素材生成\""
echo ""
echo "4️⃣  查看设计记录"
echo "   cat ~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/designs_\$(date +%Y-%m-%d).json"
echo ""

echo "📚 更多文档："
echo "   - 集成指南: cat INTEGRATION-GUIDE.md"
echo "   - 使用说明: cat README.md"
echo ""

echo -e "${GREEN}✨ 现在你可以用自然语言让 AI 生成视觉设计了！${NC}"
