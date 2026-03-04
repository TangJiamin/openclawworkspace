#!/bin/bash
# Main Cleanup Script

set -eo pipefail

# 导入配置和函数
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/whitelist.sh"
source "$SCRIPT_DIR/scanners.sh"
source "$SCRIPT_DIR/cleaners.sh"

# 命令行参数
COMMAND="${1:-scan}"
DRY_RUN="${2:-false}"

# 日志函数
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# 扫描命令
scan() {
    log "🔍 开始扫描 $CLEANUP_ROOT..."

    echo "# 📊 清理扫描报告" > "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "**扫描时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    # 扫描各类文件
    scan_temp_files
    scan_browser_logs
    scan_agent_data
    scan_sessions
    scan_backups
    scan_deprecated_skills
    scan_outdated_docs

    # 生成总计
    generate_summary

    log "✅ 扫描完成，报告已保存到 $REPORT_FILE"
    cat "$REPORT_FILE"
}

# 清理命令
clean() {
    log "🧹 开始清理 $CLEANUP_ROOT..."
    log "⚠️  干跑模式: $DRY_RUN"

    # 创建清理报告
    echo "# 🧹 清理执行报告" > "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "**执行时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')" >> "$REPORT_FILE"
    echo "**干跑模式**: $DRY_RUN" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    # 执行清理
    clean_temp_files
    clean_browser_logs
    clean_agent_data
    clean_sessions
    clean_backups
    clean_deprecated_skills
    clean_outdated_docs

    # 生成总计
    generate_cleanup_summary

    log "✅ 清理完成，报告已保存到 $REPORT_FILE"
    cat "$REPORT_FILE"
}

# 主函数
main() {
    case "$COMMAND" in
        scan)
            scan
            ;;
        clean)
            clean
            ;;
        *)
            echo "用法: $0 {scan|clean} [dry-run]"
            echo "示例:"
            echo "  $0 scan          # 扫描文件系统"
            echo "  $0 clean         # 执行清理"
            echo "  $0 clean true    # 干跑模式（预览）"
            exit 1
            ;;
    esac
}

main
