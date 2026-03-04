#!/bin/bash
# 安装 uv 和 bun（无需 sudo 版本）
# 使用方式：source /home/node/.openclaw/install-tools-v2.sh

set -e

echo "📦 安装开发工具（无 sudo 版本）"
echo "===================="
echo ""

# 检查代理
if [ -z "$http_proxy" ]; then
    echo "⚠️  未检测到代理设置"
    echo "请先运行: export HOST_PROXY='你的代理地址'"
    echo "然后运行: source /home/node/.openclaw/setup-proxy.sh"
    return 1
fi

echo "🔧 安装 uv (Python 包管理器)..."
if curl -LsSf https://astral.sh/uv/install.sh | sh; then
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ uv 安装成功: $(uv --version 2>&1 || echo '未安装')"
else
    echo "❌ uv 安装失败"
fi

echo ""
echo "🔧 安装 bun (JavaScript 运行时)..."
BUN_INSTALL="$HOME/.bun"
mkdir -p "$BUN_INSTALL"

# 下载 bun
if curl -fsSL https://bun.sh/install -o /tmp/install-bun.sh; then
    # 使用 Python 解压（替代 unzip）
    export BUN_INSTALL="$BUN_INSTALL"
    bash /tmp/install-bun.sh
    export PATH="$BUN_INSTALL/bin:$PATH"

    if command -v bun &> /dev/null; then
        echo "✅ bun 安装成功: $(bun --version)"
    else
        echo "⚠️  bun 可能未正确安装"
    fi
else
    echo "❌ bun 下载失败"
fi

echo ""
echo "===================="
echo "✅ 工具安装完成"
echo ""
echo "验证安装:"
echo "  uv --version"
echo "  bun --version"
echo ""
echo "将以下内容添加到 ~/.bashrc 以永久生效:"
echo ""
echo "# uv"
echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "# bun"
echo "export BUN_INSTALL=\"\$HOME/.bun\""
echo "export PATH=\"\$BUN_INSTALL/bin:\$PATH\""
echo ""
echo "# 代理（可选）"
echo "export http_proxy=\$http_proxy"
echo "export https_proxy=\$https_proxy"
