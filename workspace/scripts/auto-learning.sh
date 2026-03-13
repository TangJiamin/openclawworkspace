#!/bin/bash

# 自动学习脚本
# 定期搜索平台上的新技能，自动发现和安装

echo "📚 开始自动学习..."
echo "====================="
echo ""

# 学习目标
LEARNING_GOALS=(
    "AI content production"
    "PDF tools"
    "video editing"
    "API integration"
    "automation"
    "data analysis"
    "writing assistant"
)

# 平台列表
PLATFORMS=(
    "lobehub"
    "clawhub"
    "github"
)

# 当前时间
CURRENT_TIME=$(date +%Y%m%d-%H%M%S)
LOG_FILE="/home/node/.openclaw/workspace/.learnings/auto-learning-${CURRENT_TIME}.md"

echo "学习时间: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 遍历每个目标
for goal in "${LEARNING_GOALS[@]}"; do
    echo "🎯 学习目标: $goal" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    # 遍历每个平台
    for platform in "${PLATFORMS[@]}"; do
        echo "📍 平台: $platform" | tee -a "$LOG_FILE"
        
        case $platform in
            lobehub)
                echo "🔍 搜索 LobeHub..." | tee -a "$LOG_FILE"
                bunx -y @lobehub/market-cli skills search --q "$goal" --page-size 10 --output json 2>/dev/null | jq -r '.items[] | {name, identifier, rating: (.ratingCount // 0), installs: (.installCount // 0)} | select(.installs > 10) | . | "📦 \(.name) - \(.identifier) - ⭐ \(.rating)/5 (\(.installs) 次安装)"' | tee -a "$LOG_FILE"
                ;;
            clawhub)
                echo "🔍 搜索 ClawHub..." | tee -a "$LOG_FILE"
                # ClawHub 搜索（暂无 API，使用 Jina Reader）
                curl -s "https://r.jina.ai/https://clawhub.com" | grep -i "$goal" | head -5 | tee -a "$LOG_FILE"
                ;;
            github)
                echo "🔍 搜索 GitHub..." | tee -a "$LOG_FILE"
                curl -s "https://api.github.com/search/repositories?q=$goal+language:javascript&stars:>10" | jq -r '.items[] | {name, stars, url} | select(.stars > 50) | . | "📦 \(.name) - ⭐ \(.stars) 星 - \(.url)"' | tee -a "$LOG_FILE"
                ;;
        esac
        
        echo "" | tee -a "$LOG_FILE"
    done
    
    echo "------------------------" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
done

echo "====================="
echo "✅ 自动学习完成"
echo ""
echo "📋 学习记录: $LOG_FILE"
echo ""
echo "🎯 下一步:"
echo "1. 评估发现的技能"
echo "2. 选择高价值技能安装"
echo "3. 集成到 Agent 矩阵"
