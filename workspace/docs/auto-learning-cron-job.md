# 自动学习 Cron Job 配置

**任务名称**: auto-daily-learning
**执行时间**: 每天 06:00（在定向学习之前）
**会话类型**: isolated
**超时**: 600 秒（10 分钟）

**任务描述**:
```
执行自动学习任务

## 🎯 任务目标

定期搜索以下平台上的新技能：
1. LobeHub（100,000+ 技能）
2. ClawHub
3. GitHub

## 📚 学习目标

核心能力领域：
- AI content production
- PDF tools
- video editing
- API integration
- automation
- data analysis
- writing assistant

## 🔍 搜索策略

### LobeHub

```bash
npx -y @lobehub/market-cli skills search --q "$goal" --page-size 10 --sort installCount --order desc
```

### ClawHub

```bash
curl -s "https://r.jina.ai/https://clawhub.com" | grep -i "关键词"
```

### GitHub

```bash
curl -s "https://api.github.com/search/repositories?q=关键词+language:javascript&stars:>50"
```

## 📊 评估标准

发现技能后，评估：

1. **下载量/星标** - 100+ 下载或 50+ stars
2. **评分** - 4.0+/5.0+
3. **更新频率** -  3 个月内有过更新
4. **用户评价** - 有正面评价

## 🎯 行动

1. **记录发现** - 记录高价值技能
2. **选择性安装** - 安装最相关的技能
3. **集成测试** - 集成到 Agent 矩阵
4. **评分反馈** - 使用后评分和评论

## ⚠️ 安全检查

安装前必须：
- ✅ 检查 100/3 法则
- ✅ 运行 Skill Vetter 安全检查
- ✅ 确认 SAFE 级别

## 📝 输出

保存到: workspace/.learnings/auto-learning-YYYY-MM-DD.md

包含：
- 搜索关键词
- 发现的技能
- 评估结果
- 安装决策

现在开始执行自动学习。
```

---

**创建时间**: 2026-03-10 09:45
**执行时间**: 每天 06:00
**下次运行**: 2026-03-11 06:00
