#!/bin/bash
# ClawHub Bypass - 安装单个技能
# 使用: bash install-single.sh <skill-name>

set -e

SKILLS_DIR="/home/node/.openclaw/workspace/skills"
SLUG="$1"

if [ -z "$SLUG" ]; then
  echo "❌ 错误: 请提供技能名称"
  echo "使用: bash $0 <skill-name>"
  echo "示例: bash $0 tavily-search"
  exit 1
fi

echo "📦 安装技能: $SLUG"
echo ""

# Step 1: 检查技能信息
echo "📋 Step 1: 检查技能信息..."
npx clawhub@latest inspect "$SLUG" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ 错误: 技能 '$SLUG' 不存在"
  exit 1
fi
echo "  ✅ 技能存在"
echo ""

# Step 2: 获取文件列表
echo "📋 Step 2: 获取文件列表..."
FILES=$(npx clawhub@latest inspect "$SLUG" --files 2>&1 | grep -E "^scripts/|^SKILL.md" | awk '{print $1}')
if [ -z "$FILES" ]; then
  # 没有脚本文件，只有 SKILL.md
  FILES="SKILL.md"
fi
echo "  ✅ 找到文件:"
echo "$FILES" | sed 's/^/     - /'
echo ""

# Step 3: 创建目录结构
echo "📁 Step 3: 创建目录结构..."
mkdir -p "$SKILLS_DIR/$SLUG"/{scripts,.clawhub}
echo "  ✅ 目录创建完成"
echo ""

# Step 4: 下载 SKILL.md
echo "📄 Step 4: 下载 SKILL.md..."
npx clawhub@latest inspect "$SLUG" --file SKILL.md 2>&1 | tail -n +10 > "$SKILLS_DIR/$SLUG/SKILL.md"
if [ $? -eq 0 ] && [ -s "$SKILLS_DIR/$SLUG/SKILL.md" ]; then
  echo "  ✅ SKILL.md 下载完成 ($(wc -c < "$SKILLS_DIR/$SLUG/SKILL.md") bytes)"
else
  echo "  ⚠️  SKILL.md 下载失败或为空"
fi
echo ""

# Step 5: 下载脚本文件
if echo "$FILES" | grep -q "^scripts/"; then
  echo "📜 Step 5: 下载脚本文件..."
  for file in $FILES; do
    if [[ $file == scripts/* ]]; then
      echo "  📥 下载 $file..."
      npx clawhub@latest inspect "$SLUG" --file "$file" 2>&1 | tail -n +10 > "$SKILLS_DIR/$SLUG/$file"
      if [ $? -eq 0 ] && [ -s "$SKILLS_DIR/$SLUG/$file" ]; then
        echo "     ✅ $file ($(wc -c < "$SKILLS_DIR/$SLUG/$file") bytes)"
      else
        echo "     ⚠️  $file 下载失败或为空"
      fi
    fi
  done
  echo ""
fi

# Step 6: 创建 _meta.json
echo "📝 Step 6: 创建 _meta.json..."
npx clawhub@latest inspect "$SLUG" --json > /tmp/$SLUG-meta.json

# 提取字段（使用 grep/sed，避免依赖 jq）
PUBLISHED_AT=$(cat /tmp/$SLUG-meta.json | grep -o '"createdAt":[0-9]*' | head -1 | cut -d: -f2)
OWNER_ID=$(cat /tmp/$SLUG-meta.json | grep -o '"userId":"[^"]*"' | head -1 | cut -d: -f2 | tr -d '"')
VERSION=$(cat /tmp/$SLUG-meta.json | grep -o '"version":"[^"]*"' | head -1 | cut -d: -f2 | tr -d '"')

if [ -z "$VERSION" ]; then
  VERSION="latest"
fi

cat > "$SKILLS_DIR/$SLUG/_meta.json" << EOF
{
  "ownerId": $OWNER_ID,
  "slug": "$SLUG",
  "version": "$VERSION",
  "publishedAt": $PUBLISHED_AT
}
EOF

echo "  ✅ _meta.json 创建完成"
echo ""

# Step 7: 创建安装记录
echo "✅ Step 7: 创建安装记录..."
echo "{\"installedAt\":$(date +%s)}" > "$SKILLS_DIR/$SLUG/.clawhub/install.json"
echo "  ✅ 安装记录创建完成"
echo ""

# Step 8: 验证安装
echo "🔍 Step 8: 验证安装..."
if [ -f "$SKILLS_DIR/$SLUG/SKILL.md" ] && [ -f "$SKILLS_DIR/$SLUG/_meta.json" ]; then
  echo "  ✅ 技能 '$SLUG' 安装成功！"
  echo ""
  echo "📊 安装信息:"
  echo "  目录: $SKILLS_DIR/$SLUG"
  echo "  版本: $VERSION"
  echo "  文件数: $(find $SKILLS_DIR/$SLUG -type f | wc -l)"
else
  echo "  ❌ 技能 '$SLUG' 安装失败（缺少必要文件）"
  exit 1
fi

# 清理临时文件
rm -f /tmp/$SLUG-meta.json

echo ""
echo "🎉 完成！"
