#!/bin/bash
# 文件价值评估脚本 (v2.0)
# 核心原则: 根据内容价值决定保留策略，而非简单的时间规则

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $1"; }
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================================================
# 价值评估规则
# ============================================================================

# 检查是否为高价值文件（基于文件名）
is_high_value_name() {
    local file="$1"
    local filename=$(basename "$file")

    # 高价值文件名模式
    local high_value_patterns=(
        "MEMORY.md"
        "SOUL.md"
        "IDENTITY.md"
        "USER.md"
        "AGENTS.md"
        "TOOLS.md"
        "README.md"
        "HEARTBEAT.md"
        "SKILL-CREATION-GUIDE.md"
        "AGENT-MATRIX-REPLAN.md"
        "ORCHESTRATION-EXAMPLES.md"
        "AGENT-REACH-STUDY.md"
    )

    for pattern in "${high_value_patterns[@]}"; do
        if [[ "$filename" == "$pattern" ]]; then
            return 0
        fi
    done

    return 1
}

# 检查是否为低价值文件（基于文件名）
is_low_value_name() {
    local file="$1"
    local filename=$(basename "$file")

    # 低价值文件名模式
    local low_value_patterns=(
        "*.tmp"
        "*.temp"
        "temp-*.json"
        "*INSTALLATION*.md"
        "*INSTALLED*.md"
        "*SETUP*.md"
        "*MIGRATION-*.md"
        "*PROGRESS-*.md"
        "*COMPLETE.md"
        "*SUCCESS.md"
    )

    for pattern in "${low_value_patterns[@]}"; do
        if [[ "$filename" == $pattern ]]; then
            return 0
        fi
    done

    return 1
}

# 检查是否为高价值目录
is_high_value_dir() {
    local file="$1"

    # 高价值目录模式
    local high_value_dirs=(
        "*/docs/"
        "*/extensions/"
        "*/agents/*/README.md"
        "*/agents/*/SOUL.md"
        "*/agents/*/IDENTITY.md"
        "*/skills/*/SKILL.md"
        "*/archive/agents-history/"
        "*/archive/architecture-history/"
    )

    for pattern in "${high_value_dirs[@]}"; do
        if [[ "$file" == $pattern ]]; then
            return 0
        fi
    done

    return 1
}

# 检查是否为中价值目录
is_medium_value_dir() {
    local file="$1"

    # 中价值目录模式
    local medium_value_dirs=(
        "*/archive/temp/"
        "*/agents/*/data/"
        "*/browser/*/user-data/"
        "*/agents/*/logs/"
    )

    for pattern in "${medium_value_dirs[@]}"; do
        if [[ "$file" == $pattern ]]; then
            return 0
        fi
    done

    return 1
}

# 分析 Markdown 文件内容
analyze_markdown_content() {
    local file="$1"

    # 如果文件不存在或无法读取，返回 "medium"
    if [ ! -f "$file" ] || [ ! -r "$file" ]; then
        echo "medium"
        return
    fi

    # 高价值关键词
    local high_value_keywords=(
        "架构"
        "设计"
        "决策"
        "原则"
        "模式"
        "最佳实践"
        "核心"
        "本质"
        "规范"
        "指南"
    )

    # 低价值关键词
    local low_value_keywords=(
        "安装完成"
        "测试通过"
        "进度"
        "临时"
        "TODO"
        "待办"
        "安装时间"
        "执行时间"
    )

    local high_score=0
    local low_score=0

    # 统计关键词出现次数
    for keyword in "${high_value_keywords[@]}"; do
        local count=$(grep -c "$keyword" "$file" 2>/dev/null || true)
        high_score=$((high_score + count))
    done

    for keyword in "${low_value_keywords[@]}"; do
        local count=$(grep -c "$keyword" "$file" 2>/dev/null || true)
        low_score=$((low_score + count))
    done

    # 判断价值
    if [ $high_score -gt 2 ]; then
        echo "high"
    elif [ $low_score -gt 2 ]; then
        echo "low"
    else
        echo "medium"
    fi
}

# ============================================================================
# 主要评估函数
# ============================================================================

# 评估单个文件的价值
assess_file_value() {
    local file="$1"

    log_debug "评估文件: $file"

    # 规则 1: 文件名匹配（优先级最高）
    if is_high_value_name "$file"; then
        echo "high"
        return
    fi

    if is_low_value_name "$file"; then
        echo "low"
        return
    fi

    # 规则 2: 目录位置匹配
    if is_high_value_dir "$file"; then
        echo "high"
        return
    fi

    if is_medium_value_dir "$file"; then
        echo "medium"
        return
    fi

    # 规则 3: 内容分析（仅 markdown 文件）
    if [[ "$file" == *.md ]]; then
        local content_value=$(analyze_markdown_content "$file")
        echo "$content_value"
        return
    fi

    # 默认: 中等价值
    echo "medium"
}

# 获取保留期限（天数）
get_retention_days() {
    local value="$1"

    case "$value" in
        high)
            echo "-1"  # 永不删除
            ;;
        medium)
            echo "90"  # 保留 90 天
            ;;
        low)
            echo "1"   # 保留 1 天
            ;;
        *)
            echo "90"  # 默认 90 天
            ;;
    esac
}

# 评估目录中所有文件
assess_directory() {
    local dir="$1"
    local max_files=${2:-100}

    log_info "评估目录: $dir"

    local count=0
    local high_count=0
    local medium_count=0
    local low_count=0

    while IFS= read -r -d '' file; do
        if [ $count -ge $max_files ]; then
            log_warn "已达到最大文件数限制 ($max_files)，停止评估"
            break
        fi

        local value=$(assess_file_value "$file")
        local retention=$(get_retention_days "$value")

        case "$value" in
            high)
                log_info "✅ HIGH (永久保留): $file"
                high_count=$((high_count + 1))
                ;;
            medium)
                log_info "📦 MEDIUM (保留 ${retention} 天): $file"
                medium_count=$((medium_count + 1))
                ;;
            low)
                log_info "🗑️  LOW (保留 ${retention} 天): $file"
                low_count=$((low_count + 1))
                ;;
        esac

        count=$((count + 1))
    done < <(find "$dir" -type f -print0 2>/dev/null)

    # 输出统计
    echo ""
    log_info "评估完成！"
    log_info "  高价值: $high_count 个文件"
    log_info "  中价值: $medium_count 个文件"
    log_info "  低价值: $low_count 个文件"
    log_info "  总计: $count 个文件"
}

# ============================================================================
# 命令行接口
# ============================================================================

# 显示使用说明
show_usage() {
    cat << EOF
文件价值评估脚本 (v2.0)

使用方式:
    $0 assess <file>         评估单个文件的价值
    $0 assess-dir <dir>      评估目录中所有文件
    $0 retention <value>     获取价值等级对应的保留期限

示例:
    $0 assess /home/node/.openclaw/workspace/MEMORY.md
    $0 assess-dir /home/node/.openclaw/workspace/archive/
    $0 retention high

价值等级:
    high    - 高价值，永久保留
    medium  - 中价值，保留 90 天
    low     - 低价值，保留 1 天

EOF
}

# 主函数
main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi

    local command="$1"
    shift

    case "$command" in
        assess)
            if [ $# -lt 1 ]; then
                log_error "缺少文件路径参数"
                exit 1
            fi
            assess_file_value "$1"
            ;;
        assess-dir)
            if [ $# -lt 1 ]; then
                log_error "缺少目录路径参数"
                exit 1
            fi
            assess_directory "$1" "${2:-100}"
            ;;
        retention)
            if [ $# -lt 1 ]; then
                log_error "缺少价值等级参数"
                exit 1
            fi
            get_retention_days "$1"
            ;;
        *)
            log_error "未知命令: $command"
            show_usage
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
