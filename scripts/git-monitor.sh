#!/bin/bash

# Git 监控脚本 - 检查核心文件修改

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="/home/node/.openclaw"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_header() {
    echo ""
    echo "=================================================="
    echo "  Git 核心文件监控"
    echo "=================================================="
    log_info "检查时间: $(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')"
    echo ""
}

check_changes() {
    log_info "检查文件修改..."
    echo ""

    cd "$REPO_DIR"

    # 检查未暂存的修改
    if git diff --quiet; then
        log_success "没有未提交的修改"
    else
        log_warn "发现未提交的修改："
        echo ""
        git diff --stat
        echo ""
        
        log_info "修改的文件："
        git diff --name-only | while read file; do
            echo "  - $file"
        done
        echo ""

        log_warn "建议："
        echo "  1. 检查修改内容: git diff"
        echo "  2. 添加文件: git add <files>"
        echo "  3. 提交修改: git commit -m '描述'"
        echo ""
    fi

    # 检查未跟踪的文件
    local untracked=$(git ls-files --others --exclude-standard | grep -E "^(workspace/AGENTS.md|workspace/MEMORY.md|workspace/SOUL.md|agents/|openclaw.json)" || true)
    
    if [ -n "$untracked" ]; then
        log_warn "发现未监控的核心文件："
        echo ""
        echo "$untracked" | while read file; do
            echo "  - $file"
        done
        echo ""
        log_warn "建议添加这些文件到监控"
        echo ""
    fi
}

show_status() {
    log_info "Git 状态摘要"
    echo ""
    
    cd "$REPO_DIR"
    
    local commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    local branch=$(git branch --show-current)
    
    echo "  分支: $branch"
    echo "  提交: $commits"
    echo "  状态: $(git status --short | wc -l) 个文件有变化"
    echo ""
}

show_recent_commits() {
    log_info "最近的提交（5条）"
    echo ""
    
    cd "$REPO_DIR"
    
    git log --oneline -5 2>/dev/null || echo "  暂无提交记录"
    echo ""
}

# 主流程
main() {
    show_header
    show_status
    show_recent_commits
    check_changes
    
    log_success "检查完成！"
}

main "$@"
