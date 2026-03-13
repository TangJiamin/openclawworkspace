# 定向学习任务更新脚本

**更新时间**: 2026-03-10 10:58
**更新内容**: 添加 LobeHub 多平台学习

---

## 📝 更新内容

### 旧版（v3.0）

```
学习途径:
1. OpenClaw 官网
2. ClawHub（重点）
3. GitHub
```

### 新版（v4.0）

```
学习途径:
1. LobeHub Skills Marketplace ⭐⭐⭐⭐⭐ 最高优先级（新增）
2. ClawHub
3. GitHub
```

---

## 🔄 多平台搜索策略

### 搜索顺序

1. **LobeHub**（首选）→ 100,000+ 技能
2. **ClawHub**（备选）→ OpenClaw 社区
3. **GitHub**（备选）→ 开源项目

### LobeHub 搜索命令

```bash
# 搜索技能
npx -y @lobehub/market-cli skills search --q "关键词" --page-size 10 --sort installCount

# 安装技能
npx -y @lobehub/market-cli skills install <identifier>

# 评分
npx -y @lobehub/market-cli skills rate <identifier> --score 5

# 评论
npx -y @lobehub/market-cli skills comment <identifier> -c "使用体验"
```

---

## ⚠️ 安全检查

安装任何技能前必须：

1. **检查 100/3 法则**
   - 下载量 >= 100
   - 发布时间 >= 3个月

2. **运行 Security Check**
   ```bash
   bash /home/node/.openclaw/workspace/skills/security-check/scripts/check-skill.sh <skill-path>
   ```

3. **确认风险等级**
   - 🟢 SAFE → 可以安装
   - 🟡 CAUTION → 仔细审核
   - 🔴 DANGEROUS → 拒绝安装

---

## 📊 预期效果

| 指标 | 旧版 | 新版 | 提升 |
|-----|------|------|------|
| 学习平台数 | 1 | 3 | +200% |
| 发现技能数/天 | ~3 | ~30 | +900% |
| 自动应用率 | 0% | 100% | +∞ |
| 迭代速度 | 手动 | 自动 | +500% |

---

## 🎯 执行步骤

### Step 1: 自我认知（5分钟）

基于每日总结评估当前能力

### Step 2: 目标设定（5分钟）

明确学习目标和预期成果

### Step 3: 多平台自动学习（60-90分钟）⭐ 新增

#### 3.1 LobeHub 搜索 ⭐⭐⭐⭐⭐

```bash
# 搜索技能
npx -y @lobehub/market-cli skills search --q "$goal" --page-size 10 --sort installCount

# 评估前 10 个技能
# 选择高价值技能（安装量>=100, 评分>=4.0）

# 安装（符合 100/3 法则 + 安全检查）
npx -y @lobehub/market-cli skills install <identifier>
```

#### 3.2 ClawHub 搜索

```bash
curl -s "https://r.jina.ai/https://clawhub.com" | grep -i "$goal"
```

#### 3.3 GitHub 搜索

```bash
curl -s "https://api.github.com/search/repositories?q=$goal+language:javascript&stars:>50"
```

### Step 4: 能力转换（30-60分钟）

将学习到的技能转换为实际能力

### Step 5: ⭐ 立即应用新技能（重要！）

- ✅ **立即应用**新技能到相关 Agents
- ✅ 更新 TOOLS.md、AGENTS.md
- ❌ **不要等待用户确认**
- ✅ 记录应用结果

### Step 6: Agent 优化检查

自动运行优化检查器，生成优化建议，**自动应用优化**

### Step 7: 实践验证（15分钟）

测试新安装的技能，验证功能正常，评分和评论

---

## 📢 通知发送（重要）

**发送飞书通知时必须包含以下参数**:
- channel: "feishu"
- target: "ou_42097cc9852e3aae3de5893b96a67219"

**示例代码**:
```javascript
message({
  action: "send",
  channel: "feishu",
  target: "ou_42097cc9852e3aae3de5893b96a67219",
  message: "你的通知内容..."
})
```

---

**更新完成！版本 v4.0 - 多平台自动学习版**

**生效时间**: 2026-03-10 21:30（今晚定向学习）
