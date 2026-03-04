#!/bin/bash

# Hook 集成部署脚本
# 自动配置 OpenClaw Hook 调用 Refly 视频制作工作流

set -e  # 遇到错误立即退出

echo "🎬 OpenClaw Hook 集成 Refly 视频制作工作流 - 部署脚本"
echo "=================================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 配置
HOOK_DIR="/home/node/.openclaw/hooks/seedance-to-refly-bridge"
WORKFLOW_ID="c-s928vwenmmkobt5yuk32nl3u"
REFLY_URL="https://refly.kmos.ai/api/workflows/run"

# 步骤 1: 检查 Hook 目录
echo -e "${YELLOW}步骤 1: 检查 Hook 目录...${NC}"
if [ ! -d "$HOOK_DIR" ]; then
  echo -e "${RED}❌ Hook 目录不存在: $HOOK_DIR${NC}"
  exit 1
fi
echo -e "${GREEN}✅ Hook 目录存在${NC}"
cd "$HOOK_DIR"
echo ""

# 步骤 2: 检查必需文件
echo -e "${YELLOW}步骤 2: 检查必需文件...${NC}"
required_files=("handler.ts" "package.json" "README.md")
for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo -e "${RED}❌ 缺少文件: $file${NC}"
    exit 1
  fi
  echo -e "${GREEN}✅ 找到文件: $file${NC}"
done
echo ""

# 步骤 3: 安装依赖
echo -e "${YELLOW}步骤 3: 安装 NPM 依赖...${NC}"
if [ ! -d "node_modules" ]; then
  echo "正在安装依赖..."
  npm install
  echo -e "${GREEN}✅ 依赖安装完成${NC}"
else
  echo -e "${GREEN}✅ 依赖已存在${NC}"
fi
echo ""

# 步骤 4: 检查环境变量
echo -e "${YELLOW}步骤 4: 检查环境变量...${NC}"

# 检查 Gateway 配置文件
GATEWAY_ENV="$HOME/.openclaw/gateway.env"
if [ ! -f "$GATEWAY_ENV" ]; then
  echo -e "${YELLOW}⚠️  Gateway 配置文件不存在，将创建...${NC}"
  touch "$GATEWAY_ENV"
fi

# 检查 REFLY_API_KEY
if grep -q "REFLY_API_KEY=" "$GATEWAY_ENV"; then
  echo -e "${GREEN}✅ REFLY_API_KEY 已配置${NC}"
else
  echo -e "${YELLOW}⚠️  REFLY_API_KEY 未配置${NC}"
  echo ""
  echo "请输入你的 Refly API Key："
  read -p "REFLY_API_KEY: " api_key
  if [ -n "$api_key" ]; then
    echo "REFLY_API_KEY=$api_key" >> "$GATEWAY_ENV"
    echo -e "${GREEN}✅ REFLY_API_KEY 已保存${NC}"
  else
    echo -e "${RED}❌ API Key 不能为空${NC}"
    exit 1
  fi
fi

# 添加其他配置
if ! grep -q "REFLY_WEBHOOK_URL=" "$GATEWAY_ENV"; then
  echo "REFLY_WEBHOOK_URL=$REFLY_URL" >> "$GATEWAY_ENV"
  echo -e "${GREEN}✅ REFLY_WEBHOOK_URL 已配置${NC}"
fi

if ! grep -q "REFLY_WORKFLOW_ID=" "$GATEWAY_ENV"; then
  echo "REFLY_WORKFLOW_ID=$WORKFLOW_ID" >> "$GATEWAY_ENV"
  echo -e "${GREEN}✅ REFLY_WORKFLOW_ID 已配置${NC}"
fi

if ! grep -q "SEEDANCE_AUTO_GENERATE_VIDEO=" "$GATEWAY_ENV"; then
  echo "SEEDANCE_AUTO_GENERATE_VIDEO=true" >> "$GATEWAY_ENV"
  echo -e "${GREEN}✅ SEEDANCE_AUTO_GENERATE_VIDEO 已配置${NC}"
fi

echo ""

# 步骤 5: 验证配置
echo -e "${YELLOW}步骤 5: 验证配置...${NC}"
source "$GATEWAY_ENV"

echo "配置信息："
echo "  Refly URL: $REFLY_WEBHOOK_URL"
echo "  工作流 ID: $REFLY_WORKFLOW_ID"
echo "  自动生成: $SEEDANCE_AUTO_GENERATE_VIDEO"
echo ""

if [ -z "$REFLY_API_KEY" ]; then
  echo -e "${RED}❌ REFLY_API_KEY 未设置${NC}"
  exit 1
fi

echo -e "${GREEN}✅ 配置验证通过${NC}"
echo ""

# 步骤 6: 测试 Hook
echo -e "${YELLOW}步骤 6: 测试 Hook...${NC}"
echo "正在运行测试..."
node handler.ts > /tmp/hook-test.log 2>&1

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Hook 测试通过${NC}"
else
  echo -e "${RED}❌ Hook 测试失败${NC}"
  echo "查看日志: cat /tmp/hook-test.log"
  exit 1
fi
echo ""

# 步骤 7: 重启 Gateway
echo -e "${YELLOW}步骤 7: 重启 OpenClaw Gateway...${NC}"
echo "正在重启 Gateway..."
openclaw gateway restart
sleep 3
echo -e "${GREEN}✅ Gateway 已重启${NC}"
echo ""

# 完成
echo "=================================================="
echo -e "${GREEN}🎉 Hook 集成部署完成！${NC}"
echo ""
echo "📋 部署信息："
echo "  Hook 目录: $HOOK_DIR"
echo "  工作流 ID: $WORKFLOW_ID"
echo "  工作流 URL: https://refly.kmos.ai/workflow/$WORKFLOW_ID"
echo ""
echo "🚀 下一步："
echo "  1. 在 OpenClaw 中使用 /seedance-storyboard"
echo "  2. Hook 将自动调用 Refly 工作流"
echo "  3. 等待视频生成完成"
echo ""
echo "📊 监控："
echo "  查看日志: openclaw logs --follow"
echo "  检查配置: cat ~/.openclaw/gateway.env"
echo ""
echo -e "${GREEN}✨ 准备就绪！${NC}"
