#!/bin/bash
# 安装 uv 和 bun
# 使用方式：source /home/node/.openclaw/install-tools.sh

echo "📦 安装开发工具"
echo "===================="
echo ""

# 检查代理
if [ -z "$http_proxy" ]; then
    echo "⚠️  未检测到代理设置"
    echo "请先运行: source /home/node/.openclaw/setup-proxy.sh"
    return 1
fi

echo "🔧 安装 uv (Python 包管理器)..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "🔧 安装 bun (JavaScript 运行时)..."
# 先安装 unzip
apt-get update -qq && apt-get install -y unzip

export BUN_INSTALL="$HOME/.bun"
curl -fsSL https://bun.sh/install | bash
export PATH="$BUN_INSTALL/bin:$PATH"

echo ""
echo "✅ 工具安装完成"
echo ""
echo "验证安装:"
echo "  uv --version"
echo "  bun --version"
echo ""
echo "将以下内容添加到 ~/.bashrc 以永久生效:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo "  export BUN_INSTALL=\"\$HOME/.bun\""
echo "  export PATH=\"\$BUN_INSTALL/bin:\$PATH\""
