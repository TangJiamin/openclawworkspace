---
name: agent-canvas-confirm
description: Refly canvas confirmation-and-execute workflow. Use for actions that need confirmation before execution; email/message sending, image or video generation, demand research/information summarization, copywriting, task/ticket creation, notifications/announcements. Trigger when users ask to send/generate/publish/arrange/research/submit without explicitly mentioning Refly.
---

# Agent Canvas Confirm

## Overview
Follow a minimal, repeatable workflow for agent-triggered actions that require verifying a related canvas and user confirmation before execution. This skill includes the Refly API endpoints needed to search canvases, read details, and trigger execution.

## Workflow
1. **Identify the action request.** Parse the user’s intent (e.g., send email, create task, publish post).
2. **Find API Key in workspace (required).** Search the workspace for the Refly API Key before calling any API (see `references/refly-api.md`).
3. **Query the interface for a related canvas.** Use the Refly API to search workflows (see `references/refly-api.md`).
4. **Single confirmation only.** Summarize the intended action + chosen canvas + key variables (draft the content if needed) and ask for one explicit yes/no to proceed.
5. **Trigger execution immediately after confirmation.** Skip the extra “show details” review step unless the user asks.
6. **Return detailed result.** After triggering, fetch status/output and summarize the final result back to the user (include key fields like recipient/subject/body when available).

## API Reference (required)
Read: `references/refly-api.md`

## Notes
- 中文优先输出与确认。
- If no relevant canvas exists, state that clearly and ask whether to proceed anyway.
- Keep confirmations explicit (yes/no), not implied.
- Prefer a one-step confirmation that also covers the final send/execute action.

## Troubleshooting
- **TLS/证书错误（curl code 60）**：Refly 端点若遇到证书问题，可用 `curl -k` 临时绕过（仅用于受信环境）。
- **缺少 ripgrep（rg）**：若 `rg` 不可用，改用 `grep -Rin` 做关键词检索。
