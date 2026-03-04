#!/bin/bash

# Research Agent - 资料收集（Brave Search 版本）
# 特点: 使用 Brave Search API 进行24小时时效性搜索

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$WORKSPACE_DIR/data"

mkdir -p "$DATA_DIR"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

get_current_time() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M'
}

get_current_date() {
    TZ='Asia/Shanghai' date +'%Y-%m-%d'
}

show_header() {
    echo ""
    echo "=================================================="
    echo "  Research Agent - Brave Search 版本"
    echo "=================================================="
    log_info "当前时间: $(get_current_time)"
    log_info "搜索范围: 过去24小时"
    log_info "输出目录: $DATA_DIR"
    echo ""
}

# 生成搜索结果文件
generate_results() {
    local topic="$1"
    local timestamp=$(date +%Y%m%d-%H%M)
    local results_file="$DATA_DIR/brave-search-$timestamp.md"
    local report_file="$DATA_DIR/report-$(get_current_date).md"

    cat > "$results_file" << EOF
# Brave Search 结果 - 24小时时效性

**主题**: $topic  
**搜索时间**: $(get_current_time)  
**时效性**: 过去24小时  

---

## 搜索策略

由于无法在脚本中直接调用 Brave Search API，以下是建议的搜索参数：

### 策略1: 过去24小时（推荐）
\`\`\`javascript
web_search({
  query: "$topic 最新 2026",
  freshness: "pd",  // past 24h
  count: 10
})
\`\`\`

### 策略2: 过去一周
\`\`\`javascript
web_search({
  query: "$topic 热点 2026",
  freshness: "pw",  // past week
  count: 10
})
\`\`\`

---

## 手动执行步骤

1. 在 OpenClaw 主会话中执行:
   \`\`\`
   web_search({ query: "$topic 最新", freshness: "pd", count: 10 })
   \`\`\`

2. 复制搜索结果到本文件

3. 验证每条结果的时效性（24小时内）

4. 计算综合评分（≥7.0保留）

---

_由 Research Agent 自动生成_
EOF

    log_success "📄 搜索模板已生成: $results_file"

    # 生成报告
    cat > "$report_file" << EOF
# 资料收集报告（Brave Search 版本）

**生成时间**: $(get_current_time)  
**状态**: ⚠️ 需要手动执行搜索

---

## 📋 执行步骤

### Step 1: 执行 Brave Search
在主会话中运行:
\`\`\`javascript
web_search({ 
  query: "$topic 最新 2026", 
  freshness: "pd",  // 24小时内
  count: 10 
})
\`\`\`

### Step 2: 验证时效性
对每条结果检查:
- ✅ 发布时间在 24 小时内
- ✅ 内容与主题相关
- ✅ 来源可靠

### Step 3: 评分筛选
使用以下标准计算总分:
- 时效性(30%) + 热度(30%) + 价值(25%) + AI相关性(15%)
- 筛选阈值: ≥ 7.0

### Step 4: 生成最终报告
将高价值内容整理成结构化报告

---

## 🔧 为什么使用 Brave Search？

1. **时效性强**: freshness="pd" 确保只返回过去24小时的结果
2. **质量高**: Brave Search 结果质量优于普通搜索
3. **可控性**: 可以精确控制搜索范围和数量

---

_由 Research Agent 自动生成_
EOF

    log_success "📄 报告已生成: $report_file"
    echo ""
    echo "📁 文件位置:"
    echo "  - 搜索模板: $results_file"
    echo "  - 执行报告: $report_file"
    echo ""
}

main() {
    local topic="${1:-AI 工具}"

    show_header
    log_info "📍 主题: $topic"
    log_info "📍 生成搜索模板和执行指南..."
    echo ""
    
    generate_results "$topic"
    
    log_success "✅ 准备完成"
    echo ""
    echo "下一步: 在主会话中执行 web_search"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Research Agent - Brave Search 版本"
    echo ""
    echo "用法: $0 [主题]"
    echo ""
    echo "特点: 生成 web_search 执行指南（24小时时效性）"
    exit 0
fi

main "$@"
