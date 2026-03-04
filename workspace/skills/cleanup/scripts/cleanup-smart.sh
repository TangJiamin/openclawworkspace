#!/bin/bash
# 智能内容识别清理 - 基于文件内容判断是否为临时文件

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

REPORT_FILE="$REPORT_DIR/cleanup-smart-$(date +%Y%m%d).md"

echo "# 🧠 智能内容识别清理报告" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "**扫描时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 识别临时文件的特征
TEMP_KEYWORDS=(
    "进度报告"
    "更新时间"
    "待处理"
    "已完成"
    "TODO"
    "FIXME"
    "临时"
    "测试"
    "草稿"
    "WIP"
    "Work in Progress"
    "Migration Progress"
    "Current Status"
)

IMPORTANT_KEYWORDS=(
    "MEMORY.md"
    "IDENTITY.md"
    "USER.md"
    "SOUL.md"
    "AGENT-MATRIX-REPLAN"
    "SKILL-CREATION-GUIDE"
)

# 检查文件是否为临时文件
is_temp_file() {
    local file="$1"
    
    # 检查文件名（排除重要文档）
    local filename=$(basename "$file")
    for keyword in "${IMPORTANT_KEYWORDS[@]}"; do
        if [[ "$filename" == *"$keyword"* ]]; then
            return 1  # 不是临时文件
        fi
    done
    
    # 检查文件内容
    if [ -f "$file" ]; then
        local content=$(head -20 "$file" 2>/dev/null)
        
        # 检查临时关键词
        for keyword in "${TEMP_KEYWORDS[@]}"; do
            if echo "$content" | grep -q "$keyword"; then
                return 0  # 是临时文件
            fi
        done
        
        # 检查特征模式
        # 1. 包含"更新时间"或"进度"等时间敏感词
        if echo "$content" | grep -E "(更新时间|进度报告|当前状态|待处理|已完成)" | grep -q "**"; then
            return 0  # 是临时文件
        fi
        
        # 2. 包含任务清单（✅ ❌ ⏳ 等状态符号）
        if echo "$content" | grep -E "^\- \[x\]|^\- \[ \]|✅|❌|⏳" | grep -q "."; then
            # 进一步检查：如果大量使用这些符号，可能是临时进度文档
            local status_count=$(echo "$content" | grep -cE "✅|❌|⏳|\[x\]|\[ \]")
            if [ $status_count -gt 3 ]; then
                return 0  # 是临时文件
            fi
        fi
        
        # 3. 包含"迁移"、"重构"等一次性任务关键词
        if echo "$content" | grep -E "(迁移|重构|重构完成|已删除|已废弃)" | grep -q "**"; then
            return 0  # 是临时文件
        fi
    fi
    
    return 1  # 不是临时文件
}

# 扫描 workspace 目录
echo "## 📂 扫描 workspace 目录" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

TEMP_COUNT=0
IMPORTANT_COUNT=0

find /home/node/.openclaw/workspace -type f -name "*.md" | while read file; do
    if is_temp_file "$file"; then
        local size=$(du -h "$file" | cut -f1)
        echo "- 🗑️  **临时**: \`$file\` ($size)" >> "$REPORT_FILE"
        ((TEMP_COUNT++))
    fi
done

echo "" >> "$REPORT_FILE"
echo "**统计**: 发现 $TEMP_COUNT 个临时文档" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 扫描 agents/*/data 目录
echo "## 📂 扫描 agents 数据目录" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

find /home/node/.openclaw/agents -type f -path "*/data/*.md" | while read file; do
    local filename=$(basename "$file")
    
    # 检查是否为报告类文档
    if echo "$filename" | grep -qE "(report|Report|REPORT|优化|搜索|raw|temp|tmp)"; then
        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        local size=$(du -h "$file" | cut -f1)
        echo "- 📊 **报告**: \`$file\` ($size, ${file_age}天前)" >> "$REPORT_FILE"
        ((TEMP_COUNT++))
    fi
done

echo "" >> "$REPORT_FILE"
echo "**建议**: 删除超过 7 天的报告文档" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 生成清理建议
echo "## 💡 清理建议" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "基于内容分析，建议执行以下清理：" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "1. ✅ **临时进度文档**: 删除所有识别出的临时文档" >> "$REPORT_FILE"
echo "2. ✅ **过期报告**: 删除 agents/*/data/ 中超过 7 天的报告" >> "$REPORT_FILE"
echo "3. ✅ **保留重要文档**: MEMORY.md, IDENTITY.md 等核心文档已自动保护" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "✅ 智能内容识别扫描完成！" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "📄 报告已保存到: $REPORT_FILE" >> "$REPORT_FILE"

cat "$REPORT_FILE"
