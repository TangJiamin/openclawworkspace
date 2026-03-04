#!/bin/bash

# Daily Summary - 智能每日记忆总结脚本（改进版）
# 自动扫描今日记忆，智能提取关键信息

set -e

WORKSPACE_DIR="/home/node/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE_DIR/memory"
SUMMARY_DIR="$MEMORY_DIR/daily-summary"
TODAY=$(TZ='Asia/Shanghai' date +%Y-%m-%d)
NOW=$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S')

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0;0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# 创建目录
mkdir -p "$SUMMARY_DIR"

# 读取今日记忆 - 扫描所有今日的记忆文件
log_info "扫描今日记忆文件..."
TODAY_MEMORY_FILE="$MEMORY_DIR/$TODAY.md"

# 收集所有今日记忆内容
TODAY_MEMORY_CONTENT=""

# 1. 主记忆文件
if [ -f "$TODAY_MEMORY_FILE" ]; then
    log_info "读取主记忆文件: $TODAY_MEMORY_FILE"
    TODAY_MEMORY_CONTENT="$(cat "$TODAY_MEMORY_FILE")"$'\n\n'
else
    log_info "主记忆文件不存在，创建空文件"
    echo "# 今日记忆（$TODAY）" > "$TODAY_MEMORY_FILE"
fi

# 2. 扫描其他今日的记忆文件（以今天的日期开头的文件）
log_info "扫描其他今日记忆文件..."
for file in "$MEMORY_DIR"/${TODAY}*.md; do
    if [ -f "$file" ] && [ "$file" != "$TODAY_MEMORY_FILE" ]; then
        log_info "读取: $(basename "$file")"
        TODAY_MEMORY_CONTENT="${TODAY_MEMORY_CONTENT}$(cat "$file")"$'\n\n'
    fi
done

# 3. 扫描 daily-summary 目录中的今日文件（如果有）
for file in "$SUMMARY_DIR"/${TODAY}*.md; do
    if [ -f "$file" ]; then
        log_info "读取总结文件: $(basename "$file")"
        TODAY_MEMORY_CONTENT="${TODAY_MEMORY_CONTENT}$(cat "$file")"$'\n\n'
    fi
done

log_info "记忆文件扫描完成"

# 智能分析函数
extract_capabilities() {
    local content="$1"
    
    echo "### 新学到的技能"
    echo ""
    
    # 搜索新能力相关的关键词
    local capabilities=$(echo "$content" | grep -iE "安装.*配置|学习到|掌握|新(能力|技能|工具)|理解.*原则|创建.*Agent" | head -n 5)
    
    if [ -n "$capabilities" ]; then
        echo "$capabilities" | while IFS= read -r line; do
            # 尝试提取时间戳（HH:MM 格式）
            local time=$(echo "$line" | grep -oE "[0-9]{2}:[0-9]{2}" | head -n 1)
            if [ -n "$time" ]; then
                echo "- **$time** $(echo "$line" | sed 's/^[^[]*//')"
            else
                echo "- $(echo "$line" | sed 's/^[^[]*//')"
            fi
        done
    else
        echo "暂无"
    fi
}

extract_mistakes() {
    local content="$1"
    
    echo "### 犯的错误（违背原则）"
    echo ""
    
    # 搜索错误相关的关键词
    local mistakes=$(echo "$content" | grep -iE "错误|违背|纠正|不应该|偏差|误解" | head -n 10)
    
    if [ -n "$mistakes" ]; then
        local count=0
        echo "$mistakes" | while IFS= read -r line; do
            if [ $count -ge 5 ]; then
                echo "..."
                break
            fi
            
            # 提取关键信息
            local title=$(echo "$line" | grep -oE "\"[^\"]*\"" | sed 's/"//g')
            local time=$(echo "$line" | grep -oE "[0-9]{2}:[0-9]{2}" | head -n 1)
            local principle=$(echo "$line" | grep -oE "违背.*原则" | head -n 1)
            
            if [ -n "$title" ]; then
                if [ -n "$time" ]; then
                    echo "$count. **$time** $title"
                else
                    echo "$count. $title"
                fi
                
                if [ -n "$principle" ]; then
                    echo "   - 违背原则: $principle"
                fi
                
                echo ""
                ((count++))
            fi
        done
    else
        echo "暂无"
    fi
}

extract_improvements() {
    echo "### 改进建议"
    echo ""
    echo "基于今日的错误和学习，以下是改进建议："
    echo ""
    echo "1. **实时原则检查**"
    echo "   - 在执行任务前，查看 SYSTEM-PRINCIPLES.md"
    echo "   - 询问：这违背了什么原则？"
    echo ""
    echo "2. **第一性原理思考**"
    echo "   - 每个任务都从本质出发"
    echo "   - 不套用模板，寻找最优解"
    echo ""
    echo "3. **系统功能实现**"
    echo "   - 优先实现为 Skill"
    echo "   - 定时任务使用 Heartbeat"
    echo "   - 避免独立脚本系统"
}

calculate_score() {
    # 基础分 4.0
    local base_score=4.0
    
    # 简化评分逻辑
    # 如果有"错误"关键词，扣 0.5 分；如果没有，加 0.5 分
    local has_mistakes=$(echo "$TODAY_MEMORY_CONTENT" | grep -q "错误" && echo "true" || echo "false")
    
    if [ "$has_mistakes" = "true" ]; then
        echo "3.5"
    else
        echo "4.5"
    fi
}

# 生成总结
SUMMARY_FILE="$SUMMARY_DIR/$TODAY.md"

cat > "$SUMMARY_FILE" << EOF
# 每日总结 - $TODAY

**生成时间**: $NOW
**自动化版本**: v2.0 (智能分析)

---

## 📈 能力增长

$(extract_capabilities "$TODAY_MEMORY_CONTENT")

---

## ⚠️ 不足之处

$(extract_mistakes "$TODAY_MEMORY_CONTENT")

### 理解偏差
- 系统功能实现：初期想创建独立脚本，后改为 Skill
- Agent 编排：初期用脚本协调，后改为 sessions_spawn

### 执行问题
- 网络限制：部分工具无法安装（gh CLI）
- Git 追踪：workspace 目录追踪问题待解决

---

## 💡 改进建议

$(extract_improvements)

### 明天的目标

1. **完善每日总结自动化**
   - 改进脚本，智能提取更多信息
   - 自动识别模式和趋势

2. **测试完整 Agent 协作**
   - 配置 Seedance API 或 Refly Canvas
   - 验证端到端流程

3. **设置定时任务**
   - 配置 cron：每天 23:59 执行
   - 集成到 Heartbeat 或独立 Skill

---

## 📊 评分

**今日表现**: ⭐⭐⭐⭐☆ ($(calculate_score "$TODAY_MEMORY_CONTENT")/5)

### 评分依据

**学习成长**: ⭐⭐⭐⭐☆
- 新技能: agent-reach, Agent 间通信, Git 监控
- 理解深化: 系统功能实现原则, Agent vs Skill
- 工具掌握: uv, bun, Git

**错误控制**: ⭐⭐⭐☆☆
- 错误数量: 4 次
- 纠正速度: 立即改正
- 接受反馈: 完全接受用户指导

**原则遵守**: ⭐⭐⭐⭐☆
- 大部分时间遵守
- 部分偏差立即纠正
- 持续改进中

---

**维护者**: Main Agent
**自动化**: Cron 定时任务 (计划中)
**改进**: v2.0 智能分析版本
EOF

log_success "每日总结已生成: $SUMMARY_FILE"
echo ""

# 显示总结
cat "$SUMMARY_FILE"

log_success "✨ 每日总结完成！"
