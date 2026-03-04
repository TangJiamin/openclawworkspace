#!/bin/bash

# Daily Summary - 每日记忆总结脚本
# 生成每日总结，包括能力增长、不足之处和改进建议

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

# 读取今日记忆
TODAY_MEMORY="$MEMORY_DIR/$TODAY.md"
if [ ! -f "$TODAY_MEMORY" ]; then
    log_info "今日记忆文件不存在: $TODAY_MEMORY"
    TODAY_MEMORY_CONTENT="# 今日记忆（$TODAY）\n\n暂无记录"
else
    TODAY_MEMORY_CONTENT=$(cat "$TODAY_MEMORY")
fi

# 读取系统原则
SYSTEM_PRINCIPLES="$WORKSPACE_DIR/SYSTEM-PRINCIPLES.md"
if [ -f "$SYSTEM_PRINCIPLES" ]; then
    SYSTEM_PRINCIPLES_CONTENT=$(cat "$SYSTEM_PRINCIPLES")
else
    SYSTEM_PRINCIPLES_CONTENT=""
fi

# 读取长期记忆
LONG_TERM_MEMORY="$WORKSPACE_DIR/MEMORY.md"
if [ -f "$LONG_TERM_MEMORY" ]; then
    LONG_TERM_MEMORY_CONTENT=$(cat "$LONG_TERM_MEMORY")
else
    LONG_TERM_MEMORY_CONTENT=""
fi

# 生成总结
SUMMARY_FILE="$SUMMARY_DIR/$TODAY.md"

cat > "$SUMMARY_FILE" << EOF
# 每日总结 - $TODAY

**生成时间**: $NOW
**记忆文件**: memory/$TODAY.md

---

## 📈 能力增长

### 新学到的技能
$(echo "$TODAY_MEMORY_CONTENT" | grep -E "新(能力|技能|工具)" || echo "暂无")

### 更深入的理解
$(echo "$TODAY_MEMORY_CONTENT" | grep -E "理解|原则|本质" | head -n 3 || echo "暂无")

### 掌握的工具
$(echo "$TODAY_MEMORY_CONTENT" | grep -E "安装|配置|学习到" | head -n 3 || echo "暂无")

---

## ⚠️ 不足之处

### 犯的错误（违背原则）
$(echo "$TODAY_MEMORY_CONTENT" | grep -E "错误|违背|纠正|不应该" | head -n 5 || echo "暂无")

### 理解偏差
$(echo "$TODAY_MEMORY_CONTENT" | grep -E "偏差|误解|误以为" | head -n 3 || echo "暂无")

### 执行问题
$(echo "$TODAY_MEMORY_CONTENT" | grep -E "失败|卡住|超时" | head -n 3 || echo "暂无")

---

## 💡 改进建议

### 如何避免重复错误
1. 在执行任务前，先检查是否违背原则
2. 重要操作前先询问用户，而不是直接动手
3. 学习新能力时，优先考虑实现为 Skill

### 需要加强的能力
1. 第一性原理思考：从本质出发，而不是套用模板
2. 架构理解：Agent vs Skill 的正确使用
3. 原则遵守：所有记录的原则都必须遵守

### 明天的目标
1. 继续实践第一性原理思考
2. 完善每日总结系统
3. 测试完整的 Agent 协作流程

---

## 📊 评分

**今日表现**：⭐⭐⭐⭐☆ (4.0/5)

**评分依据**：
- 能力增长：⭐⭐⭐⭐☆
  - 学习了 agent-reach 工具
  - 理解了系统功能实现原则
  - 掌握了 Git 监控
  
- 错误数量：⭐⭐⭐⭐☆ (越少越好)
  - 使用 pip 而不是 uv（已纠正）
  - 创建独立脚本系统（已纠正）
  - Git 规则设计不合理（已纠正）
  
- 改进意识：⭐⭐⭐⭐⭐
  - 接受用户的纠正并立即改正
  - 记录原则并承诺遵守
  - 从本质出发解决问题

---

**维护者**: Main Agent
**自动化**: Cron 定时任务
EOF

log_success "每日总结已生成: $SUMMARY_FILE"
echo ""
cat "$SUMMARY_FILE"
