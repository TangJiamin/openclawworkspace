#!/bin/bash
# 批量检查和修复官方 Skills
# 2026-03-13

set -e

SKILLS_DIR="/usr/local/lib/node_modules/openclaw/skills"
WORKSPACE_SKILLS="$HOME/.openclaw/workspace/skills"
TEMP_DIR="$HOME/.openclaw/workspace/tmp/skills-fix"
REPORT="$HOME/.openclaw/workspace/tmp/skills-fix-report.md"

# 创建临时目录
mkdir -p "$TEMP_DIR"
mkdir -p "$(dirname "$REPORT")"

# 初始化报告
echo "# Skills 修复报告" > "$REPORT"
echo "**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT"
echo "" >> "$REPORT"
echo "## 检查统计" >> "$REPORT"
echo "" >> "$REPORT"

# 统计变量
total_count=0
fixed_count=0
already_ok_count=0
error_count=0

# 遍历所有官方 Skills
for skill_dir in "$SKILLS_DIR"/*; do
  if [ ! -d "$skill_dir" ]; then
    continue
  fi

  skill_name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"

  # 跳过没有 SKILL.md 的目录
  if [ ! -f "$skill_file" ]; then
    continue
  fi

  total_count=$((total_count + 1))
  echo "检查: $skill_name"

  # 读取 SKILL.md
  content=$(cat "$skill_file" 2>/dev/null || echo "")

  # 检查是否有 location 字段
  if ! echo "$content" | grep -q "location:"; then
    echo "  ⚠️  缺少 location 字段"
    error_count=$((error_count + 1))
    echo "- **$skill_name**: ❌ 缺少 location 字段" >> "$REPORT"
    continue
  fi

  # 提取 location
  location=$(echo "$content" | grep "location:" | sed 's/.*location: *//' | tr -d ' `"' | head -1)

  # 验证 location
  if [ ! -f "$location" ]; then
    echo "  ❌ location 无效: $location"
    error_count=$((error_count + 1))
    echo "- **$skill_name**: ❌ location 无效: \`$location\`" >> "$REPORT"
    continue
  fi

  # 检查 location 是否指向自身
  expected_location="$skill_dir/SKILL.md"
  if [ "$location" != "$expected_location" ]; then
    echo "  🔧 修复 location: $location → $expected_location"

    # 备份原文件
    cp "$skill_file" "$TEMP_DIR/${skill_name}.md.bak"

    # 修复 location
    new_content=$(echo "$content" | sed "s|location:.*|location: $expected_location|")
    echo "$new_content" > "$skill_file"

    fixed_count=$((fixed_count + 1))
    echo "- **$skill_name**: ✅ 已修复" >> "$REPORT"
  else
    echo "  ✅ 正常"
    already_ok_count=$((already_ok_count + 1))
  fi
done

# 添加统计到报告
echo "" >> "$REPORT"
echo "### 统计结果" >> "$REPORT"
echo "- **总计检查**: $total_count" >> "$REPORT"
echo "- ✅ **已正常**: $already_ok_count" >> "$REPORT"
echo "- 🔧 **已修复**: $fixed_count" >> "$REPORT"
echo "- ❌ **错误**: $error_count" >> "$REPORT"
echo "" >> "$REPORT"

# 如果有修复的文件，列出备份
if [ "$fixed_count" -gt 0 ]; then
  echo "### 备份文件" >> "$REPORT"
  echo "所有修改的文件都已备份到: \`$TEMP_DIR\`" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "\`\`\`bash" >> "$REPORT"
  ls -1 "$TEMP_DIR"/*.md.bak 2>/dev/null || echo "无备份文件" >> "$REPORT"
  echo "\`\`\`" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "**下一步**:" >> "$REPORT"
echo "1. 检查修复结果" >> "$REPORT"
echo "2. 测试 Skills 是否正常工作" >> "$REPORT"
echo "3. 如果有问题，从备份恢复" >> "$REPORT"

# 输出报告
echo ""
echo "================================"
echo "✅ 检查完成！"
echo "================================"
echo "总计: $total_count | 已正常: $already_ok_count | 已修复: $fixed_count | 错误: $error_count"
echo ""
echo "📄 详细报告: $REPORT"
echo ""

# 显示报告
cat "$REPORT"
