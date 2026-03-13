#!/bin/bash
# 验证每日报告是否生成
# 创建时间: 2026-03-13
# 用途: 验证每日总结、定向学习、深度回顾报告是否生成

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日期（昨天）
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
TODAY=$(date +%Y-%m-%d)

# 目录
MEMORY_DIR="/home/node/.openclaw/workspace/memory"
DAILY_SUMMARY_DIR="$MEMORY_DIR/daily-summary"
LEARNINGS_DIR="/home/node/.openclaw/workspace/.learnings"

# 飞书通知目标
FEISHU_TARGET="ou_42097cc9852e3aae3de5893b96a67219"

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 发送飞书告警
send_alert() {
    local title="$1"
    local message="$2"
    
    # 使用 node 发送飞书通知
    node -e "
    const https = require('https');
    const data = JSON.stringify({
        msg_type: 'text',
        content: {
            text: '${title}\\n\\n${message}'
        }
    });
    
    // 这里需要实际的飞书 webhook 或 API
    // 暂时输出到标准输出
    console.log('${title}: ${message}');
    "
    
    # 备用方案：写入日志
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERT: $title - $message" >> /tmp/verify-daily-reports.log
}

# 验证文件是否存在
verify_file() {
    local file_path="$1"
    local file_name="$2"
    
    if [ -f "$file_path" ]; then
        log_info "✅ $file_name 已生成: $file_path"
        
        # 检查文件大小
        local file_size=$(stat -c%s "$file_path" 2>/dev/null || stat -f%z "$file_path" 2>/dev/null || echo "0")
        if [ "$file_size" -lt 100 ]; then
            log_warn "⚠️  $file_name 文件过小 ($file_size bytes)，可能不完整"
            send_alert "$file_name 文件过小" "文件路径: $file_path\\n文件大小: $file_size bytes\\n\\n请检查内容是否完整！"
            return 1
        fi
        
        return 0
    else
        log_error "❌ $file_name 未生成: $file_path"
        send_alert "$file_name 未生成" "文件路径: $file_path\\n\\n请检查定时任务是否正常运行！"
        return 1
    fi
}

# 主函数
main() {
    log_info "开始验证每日报告..."
    log_info "验证日期: $YESTERDAY"
    
    local errors=0
    
    # 1. 验证每日总结
    log_info "验证每日总结..."
    if ! verify_file "$DAILY_SUMMARY_DIR/$YESTERDAY.md" "每日总结"; then
        errors=$((errors + 1))
    fi
    
    # 2. 验证深度回顾
    log_info "验证深度回顾..."
    if ! verify_file "$MEMORY_DIR/daily-deep-review-$YESTERDAY.md" "深度回顾报告"; then
        errors=$((errors + 1))
    fi
    
    # 3. 验证定向学习（可选，因为不是每天都有）
    log_info "验证定向学习..."
    if [ -f "$LEARNINGS_DIR/directed-learning-$YESTERDAY.md" ]; then
        log_info "✅ 定向学习已生成: $LEARNINGS_DIR/directed-learning-$YESTERDAY.md"
    else
        log_warn "⚠️  定向学习未生成（可能当天没有学习任务）"
    fi
    
    # 总结
    echo ""
    if [ $errors -eq 0 ]; then
        log_info "✅ 所有报告验证通过！"
        exit 0
    else
        log_error "❌ 发现 $errors 个问题，请检查！"
        exit 1
    fi
}

# 执行主函数
main "$@"
