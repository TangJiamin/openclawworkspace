# Refly Workflow Generator Hook - 使用指南

## 安装步骤

### 1. 确保依赖已安装

```bash
cd ~/.openclaw/hooks/refly-workflow-generator
npm install
```

### 2. 配置环境变量

编辑 `~/.openclaw/gateway.env`，添加：

```bash
# Refly API 配置
REFLY_URL=http://refly.kmos.ai
REFLY_API_KEY=your-api-key-here
REFLY_MODEL=refly-latest

# 可选配置
REFLY_TIMEOUT=30000
REFLY_CONFIDENCE_THRESHOLD=0.8
REFLY_AUTO_TEST=false
DEBUG=false
```

### 3. 编译 TypeScript

```bash
cd ~/.openclaw/hooks/refly-workflow-generator
npm run build
```

### 4. 启用 Hook

```bash
openclaw hooks enable refly-workflow-generator
```

### 5. 验证安装

```bash
openclaw hooks check
```

应该看到 `refly-workflow-generator` 在已启用列表中。

---

## 使用示例

### 示例 1：每日天气推送

**用户输入：**
```
创建工作流：每天早上 9 点获取北京天气并发送到 Telegram
```

**系统响应：**
```
🤖 正在分析您的需求，请稍候...

✅ 工作流已创建

📋 名称: 每日天气推送
📊 置信度: 95%

⏰ 触发时间: 0 9 * * *
📊 状态: ✅ 已启用
🎯 目标: 主会话
```

### 示例 2：多步骤工作流

**用户输入：**
```
自动化：每天早上 8 点获取天气、日程和待办事项，生成早报发送到企业微信
```

**系统响应：**
```
✅ 工作流已创建

📋 名称: 每日早报生成
📊 置信度: 88%

⏰ 触发时间: 0 8 * * *
📊 状态: ✅ 已启用

包含步骤:
  1. 获取天气
  2. 获取日程
  3. 获取待办
  4. 生成报告
  5. 发送到企业微信
```

### 示例 3：需要澄清的情况

**用户输入：**
```
创建工作流：每天获取天气
```

**系统响应：**
```
🤔 我需要更多信息来创建工作流：

❓ 请确认以下问题：
  1. 获取哪个城市的天气？
  2. 发送到哪里？（Telegram/WhatsApp/Discord/...）
  3. 什么时间获取？

💬 请回复您的选择，或说"取消"放弃创建。
```

**用户回复：**
```
北京，发送到 Telegram，早上 9 点
```

**系统响应：**
```
✅ 工作流已创建：每日天气推送（北京）→ Telegram
```

---

## 支持的工作流类型

### 1. 定时任务

```
每天早上 9 点...
每天晚上 10 点...
每周一上午...
每月 1 号...
```

### 2. 事件驱动（实验性）

```
每当收到重要邮件时...
当气温超过 30 度时...
当有新通知时...
```

### 3. 多步骤自动化

```
获取天气 → 生成报告 → 发送到 Telegram
检查网站 → 如果有更新 → 发送通知
```

---

## 支持的工具

| 工具 ID | 名称 | 说明 |
|---------|------|------|
| `message` | 发送消息 | 发送到 Telegram/WhatsApp/Discord/Feishu 等 |
| `web_search` | 网络搜索 | 使用 Brave Search 搜索信息 |
| `web_fetch` | 获取网页 | 获取并解析网页内容 |
| `browser` | 浏览器 | 控制 Chrome/Firefox 进行网页操作 |
| `exec` | 执行命令 | 在服务器上执行 shell 命令 |
| `weather` | 天气 | 获取指定城市天气 |
| `calendar` | 日历 | 管理日程和事件 |
| `tts` | 语音合成 | 将文字转换为语音 |
| `nodes` | 节点控制 | 控制配对的设备 |
| `canvas` | Canvas | 在 Canvas 上展示内容 |

---

## 调试和日志

### 启用调试模式

在 `gateway.env` 中设置：

```bash
DEBUG=true
```

### 查看 Hook 日志

```bash
# 查看最近的日志
openclaw logs --tail 50

# 过滤 Hook 相关日志
openclaw logs --tail 100 | grep Refly
```

### 测试 Hook 功能

```bash
# 发送测试消息
echo "创建工作流：每天早上 9 点说 hello" | openclaw stdin
```

---

## 管理工作流

### 列出所有工作流

```bash
openclaw cron list
```

### 运行工作流

```bash
openclaw cron run <工作流名称>
```

### 删除工作流

```bash
openclaw cron remove <工作流名称>
```

### 查看工作流运行历史

```bash
openclaw cron runs <工作流名称>
```

---

## 常见问题

### Q: Hook 没有响应？

**检查清单：**
1. Hook 是否已启用：`openclaw hooks check`
2. API 密钥是否正确：检查 `gateway.env`
3. Refly 服务是否可访问：`curl $REFLY_URL/health`
4. 查看日志：`openclaw logs --tail 50`

### Q: 创建的工作流没有运行？

**检查清单：**
1. 检查 Cron 状态：`openclaw cron status`
2. 检查工作流是否启用：`openclaw cron list`
3. 手动运行测试：`openclaw cron run <工作流名称>`

### Q: 如何修改已创建的工作流？

目前需要删除后重新创建：

```bash
openclaw cron remove <旧工作流名称>
# 然后重新创建
```

### Q: 支持条件分支吗？

Refly 支持在步骤中定义 `condition`，例如：

```json
{
  "toolId": "message",
  "input": {...},
  "condition": "step1.result.temp > 30"
}
```

---

## 高级配置

### 自定义置信度阈值

```bash
# gateway.env
REFLY_CONFIDENCE_THRESHOLD=0.9  # 要求更高的置信度
```

### 自动测试工作流

```bash
# gateway.env
REFLY_AUTO_TEST=true  # 创建后自动测试运行
```

### 自定义超时时间

```bash
# gateway.env
REFLY_TIMEOUT=60000  # 60 秒超时
```

---

## 开发和扩展

### 添加新工具

编辑 `lib/tools-registry.ts`：

```typescript
{
  id: 'my-custom-tool',
  name: '我的自定义工具',
  description: '...',
  parameters: {...}
}
```

### 自定义意图检测

编辑 `lib/intent-detector.ts`，添加关键词：

```typescript
const WORKFLOW_KEYWORDS = [
  '你的关键词',
  // ...
];
```

### 修改工作流转换逻辑

编辑 `lib/workflow-converter.ts` 中的 `convertToCronJob` 函数。

---

## 性能优化

### 缓存 Refly 响应

对于重复的请求，可以添加缓存层：

```typescript
// 在 handler.ts 中
const cache = new Map();

async function cachedParse(input: string) {
  if (cache.has(input)) {
    return cache.get(input);
  }
  const result = await refly.parseWorkflow(input, context);
  cache.set(input, result);
  return result;
}
```

### 批量处理

如果短时间内有多个请求，可以考虑批量调用 Refly API。

---

## 安全建议

1. **API 密钥保护**：不要在代码中硬编码 API 密钥
2. **权限控制**：确保 Hook 只有必要权限
3. **输入验证**：验证所有 Refly 返回的数据
4. **错误处理**：优雅处理 Refly 服务不可用的情况
5. **速率限制**：避免滥用 Refly API

---

## 更新日志

### v1.0.0 (2025-02-26)

- ✅ 初始版本
- ✅ 支持自然语言转工作流
- ✅ 多轮对话澄清
- ✅ 自动创建 Cron Job
- ✅ 支持 10+ OpenClaw 工具

---

## 支持

如有问题或建议，请：

1. 查看日志：`openclaw logs --tail 50`
2. 检查 Refly API 文档
3. 提交 Issue 到 OpenClaw 仓库

---

**享受自然语言自动化！** 🚀
