#!/bin/bash

# Skill 安全检查脚本
# 简单版本 - 检查可疑代码和依赖

SKILL_DIR="$1"

if [ -z "$SKILL_DIR" ]; then
    echo "❌ 错误: 请提供技能目录"
    echo "用法: $0 <skill-directory>"
    exit 1
fi

echo "🔍 安全检查: $SKILL_DIR"
echo "====================="
echo ""

# 检查 1: 目录是否存在
if [ ! -d "$SKILL_DIR" ]; then
    echo "❌ 错误: 目录不存在"
    exit 1
fi

# 检查 2: 查找可疑的网络请求
echo "📡 检查网络请求:"
NETWORK_REQUESTS=$(grep -r "curl\|wget\|fetch\|axios\|request" "$SKILL_DIR" --include="*.sh" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)

if [ "$NETWORK_REQUESTS" -gt 0 ]; then
    echo "  ⚠️  发现 $NETWORK_REQUESTS 处网络请求"
    echo "  建议: 检查这些请求是否安全"
else
    echo "  ✅ 未发现网络请求"
fi

echo ""

# 检查 3: 查找文件读写操作
echo "📄 检查文件操作:"
FILE_OPS=$(grep -r "rm\|write\|read\|fs\." "$SKILL_DIR" --include="*.sh" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)

if [ "$FILE_OPS" -gt 0 ]; then
    echo "  ⚠️  发现 $FILE_OPS 处文件操作"
    echo "  建议: 检查这些操作是否安全"
else
    echo "  ✅ 未发现文件操作"
fi

echo ""

# 检查 4: 查找环境变量访问
echo "🔐 检查环境变量:"
ENV_ACCESS=$(grep -r "process.env\|\$ENV\|\${" "$SKILL_DIR" --include="*.sh" --include="*.js" --include="*.ts" 2>/dev/null | wc -l)

if [ "$ENV_ACCESS" -gt 0 ]; then
    echo "  ⚠️  发现 $ENV_ACCESS 处环境变量访问"
    echo "  建议: 检查这些访问是否必要"
else
    echo "  ✅ 未发现环境变量访问"
fi

echo ""

# 检查 5: 查找 package.json（如果有）
if [ -f "$SKILL_DIR/package.json" ]; then
    echo "📦 检查依赖:"
    echo "  ✅ 发现 package.json"
    
    # 检查是否有 package-lock.json
    if [ -f "$SKILL_DIR/package-lock.json" ]; then
        echo "  ✅ 发现 package-lock.json，可以运行 npm audit"
    else
        echo "  ⚠️  未发现 package-lock.json，无法运行 npm audit"
    fi
else
    echo "📦 检查依赖:"
    echo "  ℹ️  未发现 package.json（可能是纯脚本技能）"
fi

echo ""
echo "====================="
echo "✅ 安全检查完成"
echo ""
echo "建议:"
echo "1. 仔细审查网络请求的目标"
echo "2. 确认文件操作不会删除重要文件"
echo "3. 确认环境变量访问是必要的"
echo "4. 如果有 package.json，运行 npm audit 检查依赖漏洞"
