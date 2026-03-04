# Refly 视觉设计师 - 集成配置指南

## 📋 快速部署清单

### 步骤 1: 编译 Hook

```bash
cd ~/.openclaw/hooks/refly-visual-designer
npm install
npm run build
```

**预期输出：**
```
✅ 编译成功
dist/handler.js 已生成
```

---

### 步骤 2: 配置环境变量

```bash
# 编辑 Gateway 配置
nano ~/.openclaw/gateway.env
```

**添加以下配置：**

```bash
# Refly API 配置
REFLY_URL=http://refly.kmos.ai
REFLY_API_KEY=your-actual-api-key-here
REFLY_VISUAL_WORKFLOW_ID=c-anlbsxecm4d201aj4zgnph8y

# 可选配置
REFLY_TIMEOUT=60000
DESIGN_DEFAULT_STYLE=modern
DESIGN_DEFAULT_SIZE=16:9
```

**保存并退出：** `Ctrl+X`, `Y`, `Enter`

---

### 步骤 3: 验证 Refly 连接

```bash
# 测试 Refly API 连接
curl -H "Authorization: Bearer YOUR_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"workflowId":"c-anlbsxecm4d201aj4zgnph8y"}' \
     http://refly.kmos.ai/api/v1/workflows/test
```

**预期响应：**
```json
{
  "success": true,
  "message": "Workflow found"
}
```

---

### 步骤 4: 启用 Hook

```bash
# 启用 Hook
openclaw hooks enable refly-visual-designer

# 验证 Hook 状态
openclaw hooks check

# 查看 Hook 详情
openclaw hooks info refly-visual-designer
```

**预期输出：**
```
✅ Hook "refly-visual-designer" 已启用
状态: 运行中
权限: message:send, cron:add, cron:run
```

---

### 步骤 5: 重启 Gateway

```bash
# 重启 Gateway 应用配置
openclaw gateway restart

# 等待启动完成
sleep 5

# 检查 Gateway 状态
openclaw gateway status
```

**预期输出：**
```
✅ Gateway 运行中
PID: xxxxx
端口: 18789
```

---

### 步骤 6: 测试功能

在已连接的平台（Telegram/WhatsApp/企业微信等）发送：

```
生成封面图：AI时代的生产力革命
```

**预期响应：**
```
🎨 正在生成设计，请稍候...

✅ 设计完成！

📌 标题: AI时代的生产力革命
🎨 风格: modern
📐 尺寸: 16:9

[图片附件]
```

---

## 🔧 高级配置

### 配置定时任务

#### 每日自动设计（每天 11:00）

```bash
openclaw cron add \
  --name "daily-visual-design" \
  --schedule "cron" \
  --cron "0 11 * * *" \
  --sessionTarget "isolated" \
  --message "执行今日视觉素材生成。使用命令：cd /home/node/.openclaw/workspace/skills/ai-media-pipeline && node agents/visual-designer.js"
```

#### 与内容生成联动

```bash
# 内容生成后自动触发设计（每天 10:30）
openclaw cron add \
  --name "auto-design-after-content" \
  --schedule "cron" \
  --cron "30 10 * * *" \
  --sessionTarget "isolated" \
  --message "检查今日内容生成结果，自动生成配套设计素材"
```

---

### 配置数据存储

设计结果自动保存在：

```
~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/
├── designs_2026-02-27.json    # 元数据
└── images/                     # 图片文件
    ├── cover_20260227_001.png
    ├── cover_20260227_002.png
    └── ...
```

**查看设计记录：**

```bash
# 查看今日设计
cat ~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/designs_$(date +%Y-%m-%d).json | jq

# 统计本周设计数量
find ~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/ -name "designs_*.json" -exec wc -l {} \;
```

---

## 🎯 与 AI 媒体 Pipeline 集成

### 完整自动化流程

```bash
# 1. 热点监控（每天 08:00）
openclaw cron add \
  --name "daily-hotspot-monitor" \
  --schedule "cron" \
  --cron "0 8 * * *" \
  --sessionTarget "isolated" \
  --message "执行每日热点监控"

# 2. 内容生成（每天 10:00）
openclaw cron add \
  --name "daily-content-generation" \
  --schedule "cron" \
  --cron "0 10 * * *" \
  --sessionTarget "isolated" \
  --message "执行每日内容批量生成"

# 3. 视觉设计（每天 11:00）⭐
openclaw cron add \
  --name "daily-visual-design" \
  --schedule "cron" \
  --cron "0 11 * * *" \
  --sessionTarget "isolated" \
  --message "执行今日视觉素材生成"

# 4. 人工审核后发布（手动触发）
```

### 数据流转

```
热点监控
  ↓
内容策划
  ↓
内容生成 (文案)
  ↓
视觉设计 (配图) ⭐ 本 Hook
  ↓
[人工审核]
  ↓
多平台发布
```

---

## 🐛 故障排除

### 问题 1: Hook 无响应

**诊断：**

```bash
# 检查 Hook 是否启用
openclaw hooks check | grep refly-visual-designer

# 查看 Gateway 日志
openclaw logs --tail 100 | grep -i "refly.*visual"

# 检查编译文件是否存在
ls -la ~/.openclaw/hooks/refly-visual-designer/dist/
```

**解决方案：**

```bash
# 重新编译
cd ~/.openclaw/hooks/refly-visual-designer
npm run build

# 重启 Gateway
openclaw gateway restart
```

---

### 问题 2: API 调用失败

**诊断：**

```bash
# 检查环境变量
echo $REFLY_API_KEY
echo $REFLY_VISUAL_WORKFLOW_ID

# 测试 API 连接
curl -v http://refly.kmos.ai/health
```

**解决方案：**

1. 验证 API Key 是否正确
2. 检查 Refly 服务是否在线
3. 确认工作流 ID 有效：`c-anlbsxecm4d201aj4zgnph8y`
4. 检查网络连接

---

### 问题 3: 图片生成失败

**诊断：**

```bash
# 查看 Hook 详细日志
openclaw logs --tail 200 | grep -A 10 "Refly Visual Designer"

# 检查 Refly API 响应
curl -H "Authorization: Bearer $REFLY_API_KEY" \
     http://refly.kmos.ai/api/v1/workflows/c-anlbsxecm4d201aj4zgnph8y
```

**可能原因：**

- API 额度不足
- 工作流配置错误
- 生成请求参数不合法

**解决方案：**

1. 检查 Refly 控制台的 API 使用情况
2. 优化设计参数（简化描述、调整风格）
3. 联系 Refly 支持确认工作流状态

---

### 问题 4: 设计质量不佳

**优化建议：**

1. **提供更详细的描述**

   ❌ 差：`生成封面图：AI`

   ✅ 好：`生成封面图：AI时代的生产力革命，展示机器人和人类协作，科技蓝色调`

2. **明确指定风格**

   ❌ 差：`设计一个图`

   ✅ 好：`设计信息图：2024年AI技术发展趋势，风格：商务专业，色彩：蓝色渐变`

3. **提供参考图片**（如果工作流支持）

   ```
   生成封面图：AI革命
   参考：https://example.com/reference.jpg
   ```

---

## 📊 监控与维护

### 查看设计统计

```bash
# 今日设计数量
cat ~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/designs_$(date +%Y-%m-%d).json | jq '. | length'

# 本周设计趋势
for file in ~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/designs_*.json; do
  echo "$file: $(cat $file | jq '. | length')"
done
```

### 清理旧数据

```bash
# 删除 30 天前的设计记录
find ~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/ -name "designs_*.json" -mtime +30 -delete

# 删除旧的图片文件
find ~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/images/ -name "*.png" -mtime +30 -delete
```

---

## 🎓 进阶用法

### 批量生成设计

创建批量任务文件：

```bash
cat > /tmp/batch-designs.json << EOF
[
  {"title": "AI重构工作流", "style": "tech", "size": "16:9"},
  {"title": "自动化革命", "style": "modern", "size": "16:9"},
  {"title": "智能决策系统", "style": "business", "size": "16:9"}
]
EOF
```

循环发送请求：

```bash
for design in $(cat /tmp/batch-designs.json | jq -c '.[]'); do
  title=$(echo $design | jq -r '.title')
  echo "发送设计请求：$title"
  # 通过 OpenClaw 发送消息
  openclaw message send "生成封面图：$title"
  sleep 2
done
```

---

## ✅ 部署检查清单

- [ ] Hook 编译成功（`npm run build`）
- [ ] 环境变量配置正确（`REFLY_API_KEY`）
- [ ] Refly API 连接测试通过
- [ ] Hook 已启用（`openclaw hooks enable`）
- [ ] Gateway 已重启（`openclaw gateway restart`）
- [ ] 测试消息发送成功
- [ ] 设计结果正确保存
- [ ] 定时任务配置完成（可选）

---

## 📞 获取帮助

- **技术文档**: `~/.openclaw/hooks/refly-visual-designer/README.md`
- **OpenClaw 文档**: https://docs.openclaw.ai
- **Refly 文档**: http://refly.kmos.ai/docs
- **GitHub Issues**: https://github.com/openclaw/openclaw/issues

---

**🎉 恭喜！Refly 视觉设计师已集成完成！**

现在你可以通过自然语言让 AI 自动生成视觉设计了！
