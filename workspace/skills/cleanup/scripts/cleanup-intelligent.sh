#!/bin/bash
# 智能清理脚本 v3.0 - 基于内容的深度理解
# 核心原则: 真正像人一样根据文件内容决定删除还是保留

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

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

# 报告文件
REPORT_FILE="$REPORT_DIR/cleanup-report-$(date +%Y%m%d).md"

# 统计变量
TOTAL_SCANNED=0
DELETED_COUNT=0
KEPT_COUNT=0
AI_ANALYZED=0

# ============================================================================
# 核心: Main Agent 自我认知 - 我的核心文档（绝对不能删除）
# ============================================================================

# 我的本质文档 - 定义"我是谁"
MY_ESSENCE_DOCS=(
    "$CLEANUP_ROOT/workspace/SOUL.md"
    "$CLEANUP_ROOT/workspace/IDENTITY.md"
    "$CLEANUP_ROOT/workspace/USER.md"
)

# 我的记忆文档 - 我的长期记忆和智慧
MY_MEMORY_DOCS=(
    "$CLEANUP_ROOT/workspace/MEMORY.md"
)

# 我的架构文档 - 定义"如何工作"
MY_ARCHITECTURE_DOCS=(
    "$CLEANUP_ROOT/workspace/AGENTS.md"
    "$CLEANUP_ROOT/workspace/TOOLS.md"
    "$CLEANUP_ROOT/workspace/README.md"
    "$CLEANUP_ROOT/workspace/HEARTBEAT.md"
)

# 我的技术文档 - 开发指南和最佳实践
MY_TECHNICAL_DOCS=(
    "$CLEANUP_ROOT/workspace/docs/SKILL-CREATION-GUIDE.md"
    "$CLEANUP_ROOT/workspace/docs/AGENT-MATRIX-REPLAN.md"
    "$CLEANUP_ROOT/workspace/docs/ORCHESTRATION-EXAMPLES.md"
    "$CLEANUP_ROOT/workspace/docs/AGENT-REACH-STUDY.md"
)

# 我的设计历史 - 重要的架构决策
MY_DESIGN_HISTORY=(
    "$CLEANUP_ROOT/workspace/archive/agents-history/"
    "$CLEANUP_ROOT/workspace/archive/architecture-history/"
)

# 检查是否为我的核心文档
is_my_core_document() {
    local file="$1"
    local filepath=$(realpath "$file" 2>/dev/null || echo "$file")

    # 检查本质文档
    for doc in "${MY_ESSENCE_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && return 0
    done

    # 检查记忆文档
    for doc in "${MY_MEMORY_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && return 0
    done

    # 检查架构文档
    for doc in "${MY_ARCHITECTURE_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && return 0
    done

    # 检查技术文档
    for doc in "${MY_TECHNICAL_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && return 0
    done

    # 检查设计历史目录
    for dir in "${MY_DESIGN_HISTORY[@]}"; do
        [[ "$filepath" == "$dir"* ]] && return 0
    done

    return 1
}

# 获取文档类型（用于报告）
get_document_type() {
    local file="$1"
    local filepath=$(realpath "$file" 2>/dev/null || echo "$file")

    for doc in "${MY_ESSENCE_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && echo "本质文档" && return
    done

    for doc in "${MY_MEMORY_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && echo "记忆文档" && return
    done

    for doc in "${MY_ARCHITECTURE_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && echo "架构文档" && return
    done

    for doc in "${MY_TECHNICAL_DOCS[@]}"; do
        [[ "$filepath" == "$doc" ]] && echo "技术文档" && return
    done

    for dir in "${MY_DESIGN_HISTORY[@]}"; do
        [[ "$filepath" == "$dir"* ]] && echo "设计历史" && return
    done

    echo "其他"
}

# ============================================================================
# 基于内容的智能分析
# ============================================================================

# 分析文件内容，判断价值
analyze_file_content() {
    local file="$1"

    # 检查文件是否可读
    if [ ! -r "$file" ]; then
        echo "unknown"
        return
    fi

    # 如果文件很小（< 100 字节），可能是空的或无意义
    local size=$(stat -c %s "$file" 2>/dev/null || stat -f %z "$file" 2>/dev/null || echo 0)
    if [ $size -lt 100 ]; then
        echo "low"
        return
    fi

    # 尝试读取文件内容（只读取前几行）
    if ! head -1 "$file" >/dev/null 2>&1; then
        echo "unknown"
        return
    fi

    # 高价值指示词（表明文件包含重要设计决策、架构思考）
    local high_indicators=(
        "核心原则"
        "第一性原理"
        "架构设计"
        "决策原因"
        "设计模式"
        "最佳实践"
        "本质"
        "智慧"
        "经验总结"
        "重要提醒"
        "关键决策"
        "为什么"
        "原理"
    )

    # 低价值指示词（表明文件是临时记录、安装日志等）
    local low_indicators=(
        "安装完成"
        "安装时间"
        "执行时间"
        "测试通过"
        "TODO"
        "待办"
        "临时文件"
        "进度"
        "安装日志"
        "执行日志"
        "运行时间"
    )

    local high_score=0
    local low_score=0

    # 统计指示词出现次数
    for indicator in "${high_indicators[@]}"; do
        local count=$(grep -c "$indicator" "$file" 2>/dev/null || true)
        high_score=$((high_score + count))
    done

    for indicator in "${low_indicators[@]}"; do
        local count=$(grep -c "$indicator" "$file" 2>/dev/null || true)
        low_score=$((low_score + count))
    done

    # 判断价值
    if [ $high_score -ge 2 ]; then
        echo "high"
    elif [ $low_score -ge 2 ]; then
        echo "low"
    elif [ $high_score -eq 1 ]; then
        echo "medium"
    else
        echo "unknown"
    fi
}

# ============================================================================
# 智能决策函数
# ============================================================================

# 智能判断是否应该删除文件
should_delete_file() {
    local file="$1"
    local decision_reason=""
    local should_delete=0

    log_debug "分析文件: $file"

    # 1️⃣ 第一优先级：检查是否为我的核心文档
    if is_my_core_document "$file"; then
        decision_reason="核心文档 - $(get_document_type "$file") - 绝对保护"
        should_delete=0
    fi

    # 2️⃣ 第二优先级：基于内容的智能分析
    if [ -z "$decision_reason" ]; then
        local content_value=$(analyze_file_content "$file")
        AI_ANALYZED=$((AI_ANALYZED + 1))

        case "$content_value" in
            high)
                decision_reason="内容分析 - 包含重要设计决策/架构思考 - 保留"
                should_delete=0
                ;;
            low)
                decision_reason="内容分析 - 临时记录/安装日志 - 可删除"
                should_delete=1
                ;;
            medium)
                decision_reason="内容分析 - 有一定参考价值 - 保留"
                should_delete=0
                ;;
            unknown)
                decision_reason="内容分析 - 无法判断（非文本文件）- 保留"
                should_delete=0
                ;;
        esac
    fi

    # 3️⃣ 第三优先级：基于时间（仅对明确低价值的文件）
    if [ $should_delete -eq 1 ]; then
        local age_days=$(get_file_age_days "$file")
        if [ $age_days -lt 1 ]; then
            decision_reason="低价值但创建不足1天 - 暂时保留"
            should_delete=0
        fi
    fi

    # 返回决策结果
    echo "$should_delete|$decision_reason"
}

# 获取文件年龄（天数）
get_file_age_days() {
    local file="$1"
    [ ! -e "$file" ] && echo 9999 && return

    local now=$(date +%s)
    local file_time=$(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file")
    echo $(( (now - file_time) / 86400 ))
}

# 删除文件
delete_file() {
    local file="$1"
    local reason="$2"

    log_debug "删除: $file ($reason)"

    if [ -f "$file" ]; then
        rm -f "$file"
        DELETED_COUNT=$((DELETED_COUNT + 1))
        echo "  - ✅ 删除: \`$file\`" >> "$REPORT_FILE"
        echo "    - 原因: $reason" >> "$REPORT_FILE"
    elif [ -d "$file" ]; then
        rm -rf "$file"
        DELETED_COUNT=$((DELETED_COUNT + 1))
        echo "  - ✅ 删除目录: \`$file\`" >> "$REPORT_FILE"
        echo "    - 原因: $reason" >> "$REPORT_FILE"
    fi
}

# 保留文件
keep_file() {
    local file="$1"
    local reason="$2"

    log_debug "保留: $file ($reason)"
    KEPT_COUNT=$((KEPT_COUNT + 1))

    # 只在报告中记录重要的保留决策
    if [[ "$reason" == *"核心文档"* ]] || [[ "$reason" == *"内容分析 - high"* ]]; then
        echo "  - 💎 保留: \`$file\`" >> "$REPORT_FILE"
        echo "    - 原因: $reason" >> "$REPORT_FILE"
    fi
}

# 处理单个文件
process_file() {
    local file="$1"
    TOTAL_SCANNED=$((TOTAL_SCANNED + 1))

    # 获取智能决策
    local decision=$(should_delete_file "$file")
    local should_delete=$(echo "$decision" | cut -d'|' -f1)
    local reason=$(echo "$decision" | cut -d'|' -f2-)

    if [ "$should_delete" = "1" ]; then
        delete_file "$file" "$reason"
    else
        keep_file "$file" "$reason"
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
# 🧹 智能清理报告 (v3.0)

**执行时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')
**清理策略**: 基于内容的深度理解 + Main Agent 自我认知

## 🧠 核心理念

这不是一个简单的脚本，而是一个智能的清理系统：

1. **自我认知**: 明确知道哪些是"我的核心文档"，绝对不删除
2. **内容理解**: 真正读取文件内容，判断其价值
3. **智能决策**: 像人一样思考，而不是机械地匹配文件名

## 📋 我的核心文档（绝对保护）

### 本质文档
- SOUL.md - "我是谁"
- IDENTITY.md - "我叫什么"
- USER.md - "用户是谁"

### 记忆文档
- MEMORY.md - 长期记忆和智慧

### 架构文档
- AGENTS.md - Agent 矩阵
- TOOLS.md - 工具参考
- README.md - 工作区说明
- HEARTBEAT.md - Heartbeat 配置

### 技术文档
- docs/SKILL-CREATION-GUIDE.md - Skill 创建指南
- docs/AGENT-MATRIX-REPLAN.md - Agent 矩阵规划
- docs/ORCHESTRATION-EXAMPLES.md - 编排示例
- docs/AGENT-REACH-STUDY.md - Agent-Reach 学习笔记

### 设计历史
- archive/agents-history/ - Agent 矩阵设计历史
- archive/architecture-history/ - 架构调整历史

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
| **AI 分析** | $AI_ANALYZED |
| **删除文件** | $DELETED_COUNT |
| **保留文件** | $KEPT_COUNT |

### 决策分布

- 💎 **核心文档保护**: 基于自我认知，绝对不删除
- 🧠 **AI 内容分析**: 基于文件内容，智能判断价值
- ⏰ **时间过滤**: 仅对明确低价值的文件应用时间规则

---

✅ 清理完成！共删除 **$DELETED_COUNT** 个文件/目录。

**清理策略**: v3.0 - 基于内容的深度理解
**维护者**: Main Agent
EOF
}

# ============================================================================
# 主流程
# ============================================================================

main() {
    log_info "=========================================="
    log_info "智能清理 (v3.0 - 基于内容理解)"
    log_info "=========================================="
    log_info ""

    create_report_header

    # 1. Workspace 核心文件
    log_info "1️⃣  Workspace 核心文件..."
    create_section "1️⃣ 清理 Workspace 核心文件"
    cleanup_directory "$CLEANUP_ROOT/workspace" 150
    echo "" >> "$REPORT_FILE"

    # 2. 临时文件
    log_info "2️⃣  临时文件..."
    create_section "2️⃣ 清理临时文件"
    cleanup_directory "$CLEANUP_ROOT/agents" 100
    echo "" >> "$REPORT_FILE"

    # 3. 浏览器日志
    log_info "3️⃣  浏览器日志..."
    create_section "3️⃣ 清理浏览器日志"
    cleanup_directory "$CLEANUP_ROOT/browser" 50
    echo "" >> "$REPORT_FILE"

    # 4. Agent 数据
    log_info "4️⃣  Agent 数据..."
    create_section "4️⃣ 清理 Agent 数据"
    cleanup_directory "$CLEANUP_ROOT/agents/research-agent/data" 50
    echo "" >> "$REPORT_FILE"

    # 5. 会话历史
    log_info "5️⃣  会话历史..."
    create_section "5️⃣ 清理会话历史"
    for agent_dir in "$CLEANUP_ROOT/agents"/*; do
        [ -d "$agent_dir/sessions" ] && cleanup_directory "$agent_dir/sessions" 30
    done
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
    log_info "📊 统计: 扫描 $TOTAL_SCANNED | AI 分析 $AI_ANALYZED | 删除 $DELETED_COUNT | 保留 $KEPT_COUNT"
    log_info ""
    log_info "📄 报告: $REPORT_FILE"
}

main
