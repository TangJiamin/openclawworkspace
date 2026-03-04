#!/bin/bash
# 容器代理配置脚本
# 使用方式：source /home/node/.openclaw/setup-proxy.sh

echo "🔧 容器代理配置"
echo "===================="
echo ""

# 检查是否设置了代理
if [ -z "$HOST_PROXY" ]; then
    echo "⚠️  未设置 HOST_PROXY 环境变量"
    echo ""
    echo "请在你的终端执行："
    echo "export HOST_PROXY='http://host.docker.internal:7890'"
    echo ""
    echo "或者指定你的代理地址："
    echo "export HOST_PROXY='http://127.0.0.1:7890'"
    echo "export HOST_PROXY='socks5://127.0.0.1:7891'"
    return 1
fi

# 设置代理环境变量
export http_proxy=$HOST_PROXY
export https_proxy=$HOST_PROXY
export HTTP_PROXY=$HOST_PROXY
export HTTPS_PROXY=$HOST_PROXY
export ALL_PROXY=$HOST_PROXY
export no_proxy=localhost,127.0.0.1

# 配置 Git 使用代理
git config --global http.proxy $HOST_PROXY
git config --global https.proxy $HOST_PROXY

# 配置 npm 使用代理
npm config set proxy $HOST_PROXY
npm config set https-proxy $HOST_PROXY

# 配置 Python pip 使用代理
mkdir -p ~/.pip
cat > ~/.pip/pip.conf << EOF
[global]
proxy = $HOST_PROXY
trusted-host = pypi.org
               pypi.python.org
               files.pythonhosted.org
EOF

echo "✅ 代理配置完成"
echo ""
echo "代理地址: $HOST_PROXY"
echo ""
echo "测试连接..."
if curl -s --connect-timeout 5 https://www.google.com > /dev/null 2>&1; then
    echo "✅ 代理连接成功"
else
    echo "⚠️  代理连接失败，请检查代理地址"
fi
echo ""
echo "现在你可以安装工具了："
echo "  source /home/node/.openclaw/install-tools.sh"
