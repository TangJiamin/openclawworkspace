#!/bin/bash
# 清理执行脚本 v2.0 - 基于价值的智能清理
# 核心原则: 根据内容价值决定保留策略，而非简单的时间规则

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/whitelist.sh"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 日志函数
log_info() { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; }
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $1" >> "$LOG_FILE"; }

# 报告文件
REPORT_FILE="$REPORT_DIR/cleanup-report-$(date +%Y%m%d).md"

# 统计变量
TOTAL_SCANNED=0
DELETED_COUNT=0
KEPT_COUNT=0
HIGH_VALUE_COUNT=0
MEDIUM_VALUE_COUNT=0
LOW_VALUE_COUNT=0

# ============================================================================
# 文件价值评估函数
# ============================================================================

# 检查是否为高价值文件（基于文件名）
is_high_value_name() {
    local file="$1"
    local filename=$(basename "$file")

    local high_value_patterns=(
        "MEMORY.md" "SOUL.md" "IDENTITY.md" "USER.md" "AGENTS.md"
        "TOOLS.md" "README.md" "HEARTBEAT.md"
        "SKILL-CREATION-GUIDE.md" "AGENT-MATRIX-REPLAN.md"
        "ORCHESTRATION-EXAMPLES.md" "AGENT-REACH-STUDY.md"
    )

    for pattern in "${high_value_patterns[@]}"; do
        [[ "$filename" == "$pattern" ]] && return 0
    done
    return 1
}

# 检查是否为低价值文件（基于文件名）
is_low_value_name() {
    local file="$1"
    local filename=$(basename "$file")

    local low_value_patterns=(
        "*.tmp" "*.temp" "temp-*.json"
        "*INSTALLATION*.md" "*INSTALLED*.md" "*SETUP*.md"
        "*MIGRATION-*.md" "*PROGRESS-*.md" "*COMPLETE.md" "*SUCCESS.md"
    )

    for pattern in "${low_value_patterns[@]}"; do
        [[ "$filename" == $pattern ]] && return 0
    done
    return 1
}

# 检查是否为高价值目录
is_high_value_dir() {
    local file="$1"

    [[ "$file" == */docs/* ]] && return 0
    [[ "$file" == */extensions/* ]] && return 0
    [[ "$file" == */archive/agents-history/* ]] && return 0
    [[ "$file" == */archive/architecture-history/* ]] && return 0

    return 1
}

# 检查是否为中价值目录
is_medium_value_dir() {
    local file="$1"

    [[ "$file" == */archive/temp/* ]] && return 0
    [[ "$file" == */agents/*/data/* ]] && return 0
    [[ "$file" == */browser/*/user-data/* ]] && return 0
    [[ "$file" == */agents/*/logs/* ]] && return 0

    return 1
}

# 评估文件价值
assess_file_value() {
    local file="$1"

    is_high_value_name "$file" && echo "high" && return
    is_low_value_name "$file" && echo "low" && return
    is_high_value_dir "$file" && echo "high" && return
    is_medium_value_dir "$file" && echo "medium" && return

    # 默认中等价值
    echo "medium"
}

# 获取保留期限（天数）
get_retention_days() {
    local value="$1"
    case "$value" in
        high) echo "-1" ;;   # 永不删除
        medium) echo "90" ;; # 保留 90 天
        low) echo "1" ;;     # 保留 1 天
        *) echo "90" ;;
    esac
}

# ============================================================================
# 工具函数
# ============================================================================

# 获取文件年龄（天数）
get_file_age_days() {
    local file="$1"
    [ ! -e "$file" ] && echo 9999 && return

    local now=$(date +%s)
    local file_time=$(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file")
    echo $(( (now - file_time) / 86400 ))
}

# 格式化文件大小
format_size() {
    local size=$1
    if [ $size -lt 1024 ]; then
        echo "${size}B"
    elif [ $size -lt 1048576 ]; then
        echo "$((size / 1024))K"
    elif [ $size -lt 1073741824 ]; then
        echo "$((size / 1048576))M"
    else
        echo "$((size / 1073741824))G"
    fi
}

# 删除文件（带日志）
delete_file() {
    local file="$1"
    local reason="$2"

    log_debug "删除: $file ($reason)"

    if [ -f "$file" ]; then
        rm -f "$file"
        DELETED_COUNT=$((DELETED_COUNT + 1))
        echo "  - ✅ 删除: \`$file\` ($reason)" >> "$REPORT_FILE"
    elif [ -d "$file" ]; then
        rm -rf "$file"
        DELETED_COUNT=$((DELETED_COUNT + 1))
        echo "  - ✅ 删除目录: \`$file\` ($reason)" >> "$REPORT_FILE"
    fi
}

# 保留文件（带日志）
keep_file() {
    local file="$1"
    local reason="$2"

    log_debug "保留: $file ($reason)"
    KEPT_COUNT=$((KEPT_COUNT + 1))
    # 不在报告中记录每个保留的文件（太多）
}

# 处理单个文件
process_file() {
    local file="$1"
    TOTAL_SCANNED=$((TOTAL_SCANNED + 1))

    # 检查白名单
    if is_whitelisted "$file"; then
        keep_file "$file" "白名单"
        return
    fi

    # 评估文件价值
    local value=$(assess_file_value "$file")
    local retention=$(get_retention_days "$value")
    local age_days=$(get_file_age_days "$file")

    # 更新统计
    case "$value" in
        high) HIGH_VALUE_COUNT=$((HIGH_VALUE_COUNT + 1)) ;;
        medium) MEDIUM_VALUE_COUNT=$((MEDIUM_VALUE_COUNT + 1)) ;;
        low) LOW_VALUE_COUNT=$((LOW_VALUE_COUNT + 1)) ;;
    esac

    # 根据价值和年龄决定
    if [ "$retention" = "-1" ]; then
        keep_file "$file" "高价值永久保留"
    elif [ $age_days -gt $retention ]; then
        local size=$(stat -c %s "$file" 2>/dev/null || echo 0)
        local size_formatted=$(format_size $size)
        delete_file "$file" "${value}价值，${age_days}天 (保留${retention}天)，${size_formatted}"
    else
        keep_file "$file" "${value}价值，${age_days}天 (保留${retention}天)"
    fi
}

# 扫描并清理目录
cleanup_directory() {
    local dir="$1"
    local max_files=${2:-200}

    log_info "  扫描: $dir"

    [ ! -d "$dir" ] && return

    local count=0
    while IFS= read -r -d '' file; do
        [ $count -ge $max_files ] && break
        process_file "$file"
        count=$((count + 1))
    done < <(find "$dir" -type f -print0 2>/dev/null)

    log_debug "    扫描了 $count 个文件"
}

# ============================================================================
# 报告生成
# ============================================================================

create_report_header() {
    cat > "$REPORT_FILE" << EOF
# 🧹 清理执行报告 (v2.0)

**执行时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')
**清理策略**: 基于文件价值的智能清理

EOF
}

create_section() {
    local title="$1"
    echo "## $title" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

create_report_footer() {
    cat >> "$REPORT_FILE" << EOF

## 📊 清理统计

| 指标 | 数量 |
|------|------|
| **扫描文件** | $TOTAL_SCANNED |
| **删除文件** | $DELETED_COUNT |
| **保留文件** | $KEPT_COUNT |

### 价值分布

| 价值等级 | 数量 | 保留策略 |
|----------|------|----------|
| 💎 高价值 | $HIGH_VALUE_COUNT | 永久保留 |
| 📦 中价值 | $MEDIUM_VALUE_COUNT | 保留 90 天 |
| 🗑️ 低价值 | $LOW_VALUE_COUNT | 保留 1 天 |

---

✅ 清理完成！共删除 **$DELETED_COUNT** 个文件/目录。

**清理策略**: v2.0 - 基于价值的智能清理
**维护者**: Main Agent
EOF
}

# ============================================================================
# 主流程
# ============================================================================

main() {
    log_info "=========================================="
    log_info "开始清理 (v2.0 - 基于价值)"
    log_info "=========================================="
    log_info ""

    create_report_header

    # 1. 临时文件
    log_info "1️⃣  临时文件..."
    create_section "1️⃣ 清理临时文件"
    cleanup_directory "$CLEANUP_ROOT/agents" 100
    cleanup_directory "$CLEANUP_ROOT/workspace" 100
    echo "" >> "$REPORT_FILE"

    # 2. 浏览器日志
    log_info "2️⃣  浏览器日志..."
    create_section "2️⃣ 清理浏览器日志"
    cleanup_directory "$CLEANUP_ROOT/browser" 50
    echo "" >> "$REPORT_FILE"

    # 3. Agent 数据
    log_info "3️⃣  Agent 数据..."
    create_section "3️⃣ 清理 Agent 数据"
    cleanup_directory "$CLEANUP_ROOT/agents/research-agent/data" 50
    echo "" >> "$REPORT_FILE"

    # 4. 会话历史
    log_info "4️⃣  会话历史..."
    create_section "4️⃣ 清理会话历史"
    for agent_dir in "$CLEANUP_ROOT/agents"/*; do
        [ -d "$agent_dir/sessions" ] && cleanup_directory "$agent_dir/sessions" 30
    done
    echo "" >> "$REPORT_FILE"

    # 5. 备份文件
    log_info "5️⃣  备份文件..."
    create_section "5️⃣ 清理备份文件"
    [ -d "$CLEANUP_ROOT/agents/.backup" ] && cleanup_directory "$CLEANUP_ROOT/agents/.backup" 20
    [ -d "$CLEANUP_ROOT/workspace/skills/.backup" ] && cleanup_directory "$CLEANUP_ROOT/workspace/skills/.backup" 20
    echo "" >> "$REPORT_FILE"

    # 6. 归档临时文件
    log_info "6️⃣  归档临时文件..."
    create_section "6️⃣ 清理归档临时文件"
    [ -d "$CLEANUP_ROOT/workspace/archive/temp" ] && cleanup_directory "$CLEANUP_ROOT/workspace/archive/temp" 50
    echo "" >> "$REPORT_FILE"

    create_report_footer

    log_info ""
    log_info "=========================================="
    log_info "清理完成！"
    log_info "=========================================="
    log_info ""
    log_info "📊 统计: 扫描 $TOTAL_SCANNED | 删除 $DELETED_COUNT | 保留 $KEPT_COUNT"
    log_info "📊 价值: 💎 $HIGH_VALUE_COUNT | 📦 $MEDIUM_VALUE_COUNT | 🗑️  $LOW_VALUE_COUNT"
    log_info ""
    log_info "📄 报告: $REPORT_FILE"
}

main
