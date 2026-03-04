# Refly Workflow Generator Hook

## Summary

Automatically convert natural language requests into structured workflows using Refly AI, then deploy them as OpenClaw cron jobs.

## Description

This hook intercepts user messages that appear to be workflow creation requests, sends them to Refly for intent parsing and workflow generation, and then automatically creates the corresponding OpenClaw cron jobs.

**Key Features:**

- 🤖 Natural language to workflow conversion
- 🔄 Multi-turn对话 for clarification
- ⏰ Automatic cron job creation
- 🛠️ Supports all OpenClaw tools
- ✅ Confidence-based validation

## When It Triggers

- User sends a message containing workflow creation keywords
- Default keywords: "创建工作流", "新建自动化", "帮我做一个", "每当", "每天"

## What It Does

1. Detects workflow creation intent from user messages
2. Calls Refly API to parse natural language into structured workflow
3. Validates confidence and asks for clarification if needed
4. Converts Refly workflow to OpenClaw cron job
5. Creates and enables the cron job
6. Reports success/failure back to the user

## Configuration

Add to `~/.openclaw/gateway.env`:

```bash
REFLY_URL=http://refly.kmos.ai
REFLY_API_KEY=your-api-key-here
REFLY_MODEL=refly-latest
```

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| REFLY_URL | Yes | - | Refly API base URL |
| REFLY_API_KEY | Yes | - | Refly API authentication key |
| REFLY_MODEL | No | refly-latest | Model to use for parsing |
| REFLY_TIMEOUT | No | 30000 | API request timeout (ms) |
| REFLY_CONFIDENCE_THRESHOLD | No | 0.8 | Minimum confidence for auto-approval |

## Permissions

Required gateway permissions:
- `cron:read` - List existing cron jobs
- `cron:add` - Create new cron jobs
- `message:send` - Send confirmation messages

## Usage Examples

### Example 1: Simple Daily Task

**User says:**
```
创建工作流：每天早上 9 点获取天气并发送到 Telegram
```

**Hook response:**
```
✅ 工作流已创建：每日天气推送
触发时间：每天 09:00
置信度：95%
步骤：
  1. 获取天气 (北京)
  2. 发送到 Telegram
```

### Example 2: Multi-Step Workflow

**User says:**
```
每当有重要邮件，发送提醒到企业微信
```

**Hook response:**
```
✅ 工作流已创建：邮件提醒
触发类型：事件驱动 (webhook)
置信度：88%
```

### Example 3: Clarification Needed

**User says:**
```
每天生成报告
```

**Hook response:**
```
🤔 我需要更多信息：
1. 报告包含哪些内容？（天气/日程/待办/自定义）
2. 发送到哪里？（Telegram/WhatsApp/Discord/...）
3. 什么时间生成？

请回复您的选择，或者说"取消"放弃创建。
```

## Troubleshooting

### Hook not triggering

- Check if hook is enabled: `openclaw hooks check`
- Verify message contains one of the trigger keywords
- Check gateway logs: `openclaw logs --tail 50`

### Refly API errors

- Verify REFLY_URL is accessible
- Check API key validity
- Review timeout settings

### Cron job not created

- Check gateway cron status: `openclaw cron status`
- Verify cron permissions
- Review workflow JSON structure

## Development

**Handler:** `handler.ts`
**Dependencies:**
- node-fetch (or native fetch in Node 18+)

**Testing:**
```bash
# Enable hook
openclaw hooks enable refly-workflow-generator

# Check status
openclaw hooks check

# Send test message
echo "创建工作流：每天早上 9 点说 hello" | openclaw stdin
```

## See Also

- OpenClaw Hooks Documentation
- Refly API Documentation
- Cron Jobs Guide
