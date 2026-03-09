#!/bin/bash
# 清理执行脚本 v2.0 - 基于价值的智能清理
# 核心原则: 根据内容价值决定保留策略，而非简单的时间规则

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/whitelist.sh"

# 引入价值评估脚本（只加载函数，不执行 main）
ASSessor_SCRIPT="$SCRIPT_DIR/value-assessor.sh"
if [ -f "$ASSessor_SCRIPT" ]; then
    # 直接加载脚本内容，避免执行 main 函数
    . <(grep -v "^main\|show_usage\|case.*in" "$ASSessor_SCRIPT" | grep -v "^\s*;;\s*$")
else
    log_error "价值评估脚本不存在: $ASSessor_SCRIPT"
    exit 1
fi

# 报告文件
REPORT_FILE="$REPORT_DIR/cleanup-report-$(date +%Y%m%d).md"

# 统计变量
TOTAL_SCANNED=0
DELETED_COUNT=0
KEPT_COUNT=0
HIGH_VALUE_COUNT=0
MEDIUM_VALUE_COUNT=0
LOW_VALUE_COUNT=0

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; }
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $1" >> "$LOG_FILE"; }

# 获取文件年龄（天数）
get_file_age_days() {
    local file="$1"
    if [ ! -e "$file" ]; then
        echo 9999
        return
    fi

    local now=$(date +%s)
    local file_time=$(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file")
    local age_seconds=$((now - file_time))
    local age_days=$((age_seconds / 86400))

    echo $age_days
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

    log_debug "删除文件: $file (原因: $reason)"

    if [ -f "$file" ]; then
        rm -f "$file"
        DELETED_COUNT=$((DELETED_COUNT + 1))
        echo "  - ✅ 删除: \`$file\` ($reason)" >> "$REPORT_FILE"
        return 0
    elif [ -d "$file" ]; then
        rm -rf "$file"
        DELETED_COUNT=$((DELETED_COUNT + 1))
        echo "  - ✅ 删除目录: \`$file\` ($reason)" >> "$REPORT_FILE"
        return 0
    else
        log_debug "文件不存在: $file"
        return 1
    fi
}

# 保留文件（带日志）
keep_file() {
    local file="$1"
    local reason="$2"

    log_debug "保留文件: $file (原因: $reason)"
    KEPT_COUNT=$((KEPT_COUNT + 1))
    echo "  - ⏸️  保留: \`$file\` ($reason)" >> "$REPORT_FILE"
}

# 处理单个文件
process_file() {
    local file="$1"

    TOTAL_SCANNED=$((TOTAL_SCANNED + 1))

    # 检查白名单
    if is_whitelisted "$file"; then
        keep_file "$file" "白名单保护"
        return 0
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

    # 根据价值和年龄决定是否删除
    if [ "$retention" = "-1" ]; then
        # 高价值文件，永不删除
        keep_file "$file" "高价值文件，永久保留"
    elif [ $age_days -gt $retention ]; then
        # 超过保留期限，删除
        local file_size=$(stat -c %s "$file" 2>/dev/null || stat -f %z "$file" 2>/dev/null || echo 0)
        local size_formatted=$(format_size $file_size)
        delete_file "$file" "${value}价值，${age_days}天前 (保留${retention}天)，大小${size_formatted}"
    else
        # 未超过保留期限，保留
        keep_file "$file" "${value}价值，${age_days}天前 (保留${retention}天)"
    fi
}

# 扫描并清理目录
cleanup_directory() {
    local dir="$1"
    local max_files=${2:-500}

    log_info "扫描目录: $dir (最多 ${max_files} 个文件)"

    if [ ! -d "$dir" ]; then
        log_debug "目录不存在: $dir"
        return 0
    fi

    local count=0
    while IFS= read -r -d '' file; do
        if [ $count -ge $max_files ]; then
            log_warn "已达到最大文件数限制 ($max_files)，停止扫描"
            break
        fi

        process_file "$file"
        count=$((count + 1))
    done < <(find "$dir" -type f -print0 2>/dev/null)

    log_info "  扫描完成: $count 个文件"
}

# 创建报告头
create_report_header() {
    cat > "$REPORT_FILE" << EOF
# 🧹 清理执行报告 (v2.0 - 基于价值)

**执行时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')
**清理策略**: 基于文件价值的智能清理
**扫描文件数**: $TOTAL_SCANNED

EOF
}

# 创建报告尾
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

---
**清理策略**: v2.0 - 基于价值的智能清理
**维护者**: Main Agent
EOF
}

# ============================================================================
# 主要清理流程
# ============================================================================

main() {
    log_info "=========================================="
    log_info "开始清理 (v2.0 - 基于价值的智能清理)"
    log_info "=========================================="
    log_info ""

    # 创建报告头
    create_report_header

    # 1. 清理临时文件
    log_info "1️⃣  清理临时文件..."
    echo "## 1️⃣ 清理临时文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    cleanup_directory "$CLEANUP_ROOT/agents" 100
    cleanup_directory "$CLEANUP_ROOT/workspace" 100
    echo "" >> "$REPORT_FILE"

    # 2. 清理浏览器日志
    log_info "2️⃣  清理浏览器日志..."
    echo "## 2️⃣ 清理浏览器日志" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    cleanup_directory "$CLEANUP_ROOT/browser" 50
    echo "" >> "$REPORT_FILE"

    # 3. 清理 Agent 数据
    log_info "3️⃣  清理 Agent 数据..."
    echo "## 3️⃣ 清理 Agent 数据" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    cleanup_directory "$CLEANUP_ROOT/agents/research-agent/data" 50
    echo "" >> "$REPORT_FILE"

    # 4. 清理会话历史
    log_info "4️⃣  清理会话历史..."
    echo "## 4️⃣ 清理会话历史" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    for agent_dir in "$CLEANUP_ROOT/agents"/*; do
        if [ -d "$agent_dir/sessions" ]; then
            cleanup_directory "$agent_dir/sessions" 50
        fi
    done
    echo "" >> "$REPORT_FILE"

    # 5. 清理备份文件
    log_info "5️⃣  清理备份文件..."
    echo "## 5️⃣ 清理备份文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    if [ -d "$CLEANUP_ROOT/agents/.backup" ]; then
        cleanup_directory "$CLEANUP_ROOT/agents/.backup" 20
    fi
    if [ -d "$CLEANUP_ROOT/workspace/skills/.backup" ]; then
        cleanup_directory "$CLEANUP_ROOT/workspace/skills/.backup" 20
    fi
    echo "" >> "$REPORT_FILE"

    # 6. 清理 workspace archive/temp/
    log_info "6️⃣  清理归档临时文件..."
    echo "## 6️⃣ 清理归档临时文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    if [ -d "$CLEANUP_ROOT/workspace/archive/temp" ]; then
        cleanup_directory "$CLEANUP_ROOT/workspace/archive/temp" 50
    fi
    echo "" >> "$REPORT_FILE"

    # 创建报告尾
    create_report_footer

    # 输出报告
    log_info ""
    log_info "=========================================="
    log_info "清理完成！"
    log_info "=========================================="
    log_info ""
    log_info "📊 统计:"
    log_info "  - 扫描文件: $TOTAL_SCANNED"
    log_info "  - 删除文件: $DELETED_COUNT"
    log_info "  - 保留文件: $KEPT_COUNT"
    log_info ""
    log_info "📊 价值分布:"
    log_info "  - 💎 高价值: $HIGH_VALUE_COUNT (永久保留)"
    log_info "  - 📦 中价值: $MEDIUM_VALUE_COUNT (保留 90 天)"
    log_info "  - 🗑️ 低价值: $LOW_VALUE_COUNT (保留 1 天)"
    log_info ""
    log_info "📄 报告: $REPORT_FILE"
    log_info ""
}

# 执行主函数
main
