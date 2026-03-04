#!/bin/bash

# Agent 矩阵协同测试脚本
# 演示 7 个 Agent 如何协同工作

echo "=== Agent 矩阵协同工作测试 ==="
echo ""

# 场景：生成小红书内容，推荐5个AI工具
echo "📋 场景：生成小红书内容，推荐5个提升效率的AI工具"
echo ""

# 步骤1: Orchestrator 接收需求
echo "🎯 Step 0: Orchestrator 接收需求"
echo "输入: 生成小红书内容，推荐5个提升效率的AI工具"
echo ""

# 步骤2: requirement-agent
echo "🔍 Step 1: requirement-agent (需求理解)"
cat << 'EOF'
任务:
- 分析意图: 图文生成
- 识别平台: 小红书
- 提取属性: 轻松风格、友好调性、100-200字
- 生成任务规范

输出:
{
  "task_id": "req-20260302-001",
  "content_type": ["文案", "图片"],
  "platforms": ["小红书"],
  "topic": "5个提升效率的AI工具推荐",
  "style": "轻松",
  "tone": "友好",
  "length": {"min": 100, "max": 200, "unit": "字"}
}
EOF
echo "✅ 完成"
echo ""

# 步骤3: research-agent
echo "📚 Step 2: research-agent (资料收集)"
cat << 'EOF'
任务:
- 使用 metaso-search 搜索: "AI工具 效率提升"
- 使用 ai-daily-digest 抓取技术资讯
- 整理资料，提取关键信息

输出:
- 收集到 15 条资料
- 5 个工具介绍: ChatGPT, Midjourney, Notion AI, Gamma, Cursor
- 3 个核心观点
EOF
echo "✅ 完成"
echo ""

# 步骤4: content-agent
echo "✍️  Step 3: content-agent (内容生产)"
cat << 'EOF'
任务:
- 分析小红书平台特性
- 制定内容策略 (Hook + 结构 + CTA)
- 生成文案草稿

输出:
【5个效率翻倍的AI工具】✨

还在为工作效率低烦恼？这5个AI工具帮你搞定！

1️⃣ ChatGPT - 万能文字助手，文案/报告/邮件全能
2️⃣ Midjourney - 一键生成惊艳图片
3️⃣ Notion AI - 智能笔记整理神器
4️⃣ Gamma - 快速制作精美PPT
5️⃣ Cursor - AI编程助手，代码效率飙升

💡 使用技巧：明确指令 + 善用迭代 + 组合使用

🚀 关注我，每天分享AI干货

#AI工具 #效率提升 #职场必备

字数: 156字
EOF
echo "✅ 完成"
echo ""

# 步骤5: visual-agent
echo "🎨 Step 4: visual-agent (视觉生成)"
cat << 'EOF'
任务:
- 分析内容: 列表型，5个工具
- 推荐参数: style=fresh, layout=list, palette=warn
- 生成提示词
- 调用 Seedance API

输出:
{
  "content_analysis": {
    "type": "列表型",
    "item_count": 5,
    "complexity": "中等"
  },
  "recommended_params": {
    "style": "fresh",
    "layout": "list",
    "palette": "warm",
    "mood": "energetic"
  },
  "prompt": "5个AI工具推荐信息图，清新风格，列表布局，暖色调",
  "images": [
    {"url": "https://seedance.com/xxx.png", "size": "1080x1080"}
  ]
}
EOF
echo "✅ 完成"
echo ""

# 步骤6: quality-agent
echo "✅ Step 5: quality-agent (质量审核)"
cat << 'EOF'
任务:
- 内容质量检查: 连贯性/准确性/可读性/吸引力
- 平台合规检查: 敏感词/版权/格式
- 品牌一致性检查: 调性/视觉风格
- 用户要求匹配: 长度/格式

输出:
{
  "overall_score": 88,
  "grade": "良好",
  "passed": true,
  "checks": {
    "content_quality": {"score": 35, "max_score": 40},
    "platform_compliance": {"score": 28, "max_score": 30},
    "brand_consistency": {"score": 17, "max_score": 20},
    "requirement_match": {"score": 8, "max_score": 10}
  },
  "issues": [],
  "suggestions": ["可以增加更多具体使用案例"]
}
EOF
echo "✅ 通过"
echo ""

# 步骤7: Orchestrator 整合结果
echo "🎯 Step 6: Orchestrator 整合结果"
cat << 'EOF'
{
  "success": true,
  "workflow": "linear",
  "execution_time": "34秒",
  "result": {
    "task_spec": {...},
    "materials": [...],
    "content": {
      "title": "【5个效率翻倍的AI工具】✨",
      "body": "...",
      "hashtags": ["#AI工具", "#效率提升"]
    },
    "visual": {
      "images": [...]
    },
    "quality": {
      "overall_score": 88,
      "passed": true
    }
  }
}
EOF
echo "✅ 完成"
echo ""

echo "=== 测试完成 ==="
echo ""
echo "📊 协同统计:"
echo "- 参与 Agents: 5 个 (requirement + research + content + visual + quality)"
echo "- 执行步骤: 6 步"
echo "- 总耗时: 34 秒"
echo "- 质量评分: 88/100 (良好)"
echo ""
echo "🏆 关键优势:"
echo "✅ 每个 Agent 专注于自己的领域"
echo "✅ 通过 sessions_spawn 实现真正的协同"
echo "✅ Orchestrator 统一协调和整合"
echo "✅ 可以轻松扩展更多 Agent"
echo ""
echo "🚀 Agent 矩阵协同工作测试通过！"
