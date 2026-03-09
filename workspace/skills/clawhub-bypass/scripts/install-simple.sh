#!/bin/bash
# ClawHub Bypass - 简化版安装脚本
# 使用: bash install-simple.sh <skill-name>

SKILLS_DIR="/home/node/.openclaw/workspace/skills"
SLUG="$1"

if [ -z "$SLUG" ]; then
  echo "❌ 请提供技能名称"
  echo "使用: bash $0 <skill-name>"
  exit 1
fi

echo "📦 安装 $SLUG..."

# 创建目录
mkdir -p "$SKILLS_DIR/$SLUG"/{scripts,.clawhub}

# 下载 SKILL.md
echo "  📄 SKILL.md"
npx clawhub@latest inspect "$SLUG" --file SKILL.md 2>&1 | tail -n +10 > "$SKILLS_DIR/$SLUG/SKILL.md"

# 获取文件列表
FILES=$(npx clawhub@latest inspect "$SLUG" --files 2>&1 | grep -E "^scripts/|^SKILL.md" | awk '{print $1}')

# 下载脚本文件
for file in $FILES; do
  if [[ $file == scripts/* ]]; then
    echo "  📜 $file"
    npx clawhub@latest inspect "$SLUG" --file "$file" 2>&1 | tail -n +10 > "$SKILLS_DIR/$SLUG/$file"
  fi
done

# 创建 _meta.json
echo "  📝 _meta.json"
npx clawhub@latest inspect "$SLUG" --json > /tmp/$SLUG-meta.json

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

# 创建安装记录
echo "  ✅ 安装记录"
echo "{\"installedAt\":$(date +%s)}" > "$SKILLS_DIR/$SLUG/.clawhub/install.json"

# 清理
rm -f /tmp/$SLUG-meta.json

echo "✅ $SLUG 安装完成！"
