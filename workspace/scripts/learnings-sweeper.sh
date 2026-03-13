#!/bin/bash
# 学习记录清理和归档脚本
# 2026-03-13

set -e

WORKSPACE="$HOME/.openclaw/workspace"
LEARNINGS_DIR="$WORKSPACE/.learnings"
MEMORY_DIR="$WORKSPACE/memory"
ARCHIVE_DIR="$WORKSPACE/.learnings/archive"
REPORT="$WORKSPACE/tmp/learnings-sweeper-report.md"

# 创建目录
mkdir -p "$ARCHIVE_DIR"
mkdir -p "$(dirname "$REPORT")"

# 初始化报告
cat > "$REPORT" << 'EOF'
# 学习记录清理报告

**生成时间**: 2026-03-13 09:05
**目标**: 清理和归档学习记录

---

## 扫描结果

EOF

echo "================================"
echo "🧹 清理学习记录"
echo "================================"
echo ""

# 统计变量
total_files=0
archived_files=0
kept_files=0
error_count=0

# 扫描学习记录
if [ -d "$LEARNINGS_DIR" ]; then
  echo "扫描 .learnings 目录..."

  for file in "$LEARNINGS_DIR"/*.md; do
    if [ ! -f "$file" ]; then
      continue
    fi

    total_files=$((total_files + 1))
    filename=$(basename "$file")

    # 获取文件修改时间（天数）
    file_age=$(($(date +%s) - $(date +%s -r "$file")))
    file_age_days=$((file_age / 86400))

    echo "检查: $filename (${file_age_days} 天前)"

    # 决定是否归档
    # 30 天前的文件归档
    if [ $file_age_days -gt 30 ]; then
      echo "  📦 归档 (超过 30 天)"

      # 移动到归档目录
      mv "$file" "$ARCHIVE_DIR/$filename"
      archived_files=$((archived_files + 1))

      echo "- **$filename**: 📦 已归档 (${file_age_days} 天前)" >> "$REPORT"
    else
      echo "  ✅ 保留"

      kept_files=$((kept_files + 1))
      echo "- **$filename**: ✅ 保留 (${file_age_days} 天前)" >> "$REPORT"
    fi
  done
else
  echo "⚠️  .learnings 目录不存在"
  error_count=$((error_count + 1))
fi

# 扫描 memory 目录
if [ -d "$MEMORY_DIR" ]; then
  echo ""
  echo "扫描 memory 目录..."

  for file in "$MEMORY_DIR"/*.md; do
    if [ ! -f "$file" ] || [ "$(basename "$file")" = "MEMORY.md" ]; then
      continue
    fi

    total_files=$((total_files + 1))
    filename=$(basename "$file")

    # 获取文件修改时间（天数）
    file_age=$(($(date +%s) - $(date +%s -r "$file")))
    file_age_days=$((file_age / 86400))

    echo "检查: $filename (${file_age_days} 天前)"

    # 保留最近的日常记忆（7天内）
    if [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$ ]] && [ $file_age_days -gt 7 ]; then
      echo "  📦 归档日常记忆 (超过 7 天)"

      # 移动到归档目录
      mv "$file" "$ARCHIVE_DIR/daily-$filename"
      archived_files=$((archived_files + 1))

      echo "- **$filename**: 📦 已归档 (日常记忆)" >> "$REPORT"
    else
      echo "  ✅ 保留"

      kept_files=$((kept_files + 1))
    fi
  done
fi

# 添加统计到报告
cat >> "$REPORT" << EOF

## 统计结果

- **总计文件**: $total_files
- 📦 **已归档**: $archived_files
- ✅ **保留**: $kept_files
- ❌ **错误**: $error_count

## 归档位置

所有归档文件已移动到: \`$ARCHIVE_DIR\`

## 下一步

1. 检查归档文件是否有价值
2. 删除无用的归档文件
3. 整理重要的学习记录
EOF

# 输出结果
echo ""
echo "================================"
echo "✅ 清理完成！"
echo "================================"
echo "总计: $total_files | 已归档: $archived_files | 保留: $kept_files | 错误: $error_count"
echo ""
echo "📄 详细报告: $REPORT"
echo ""

# 显示报告
cat "$REPORT"
