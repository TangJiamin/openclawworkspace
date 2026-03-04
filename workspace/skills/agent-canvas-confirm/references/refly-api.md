# Refly API (minimal for canvas lookup + confirm + trigger)

## Auth
All requests require:
`Authorization: Bearer <API_KEY>`

**API Key 寻找（必做）**
优先从工作空间读取，不要凭空编造：
- 查找 `/workspace/.env`（如 `REFLY_API_KEY` / `API_KEY`）
- 查找 `/workspace/config/` 内的 json/yaml
- 查找 `/workspace/mcporter.json`
- 关键词全文检索：`REFLY_API_KEY`、`API_KEY`、`refly`

如果仍未找到，明确询问用户提供 API Key 或存放位置。

Base path: `/api/v1`

## 1) Search canvases/workflows (find “邮件” canvas)
**GET** `/openapi/workflows`

Optional query:
- `keyword` (string) — search by workflow title
- `page`, `pageSize`, `order`

Response (200):
```json
{
  "success": true,
  "data": [
    { "canvasId": "c-...", "title": "邮件发送" }
  ]
}
```

**判定规则**（最小版）：
- `title` 包含“邮件”或英文“email”即视为邮件相关画布。
- 若用户明确给出 canvasId，优先使用它，不再搜索。

## 2) Get workflow details (show “查看详情”)
**GET** `/openapi/workflows/{canvasId}`

Response (200) contains:
- `data.title`
- `data.tasks[]` (title, prompt, toolsets)
- `data.variables[]` (name, variableType, required, options)

Example (minimal):
```json
{
  "success": true,
  "data": {
    "title": "邮件发送",
    "tasks": [
      { "id": "t1", "title": "Send Email", "prompt": "...", "toolsets": ["mail"] }
    ],
    "variables": [
      { "name": "to", "variableType": "string", "required": true },
      { "name": "subject", "variableType": "string", "required": true },
      { "name": "body", "variableType": "string", "required": true }
    ]
  }
}
```

## 3) Trigger workflow (execute after confirmation)
**POST** `/openapi/workflow/{canvasId}/run`

Request body:
```json
{
  "variables": {
    "to": "a@b.com",
    "subject": "Hello",
    "body": "..."
  }
}
```

Response (200):
```json
{
  "success": true,
  "data": { "executionId": "e-...", "status": "init" }
}
```

## 3.5) Generate workflow via Copilot (when no canvas matches)
**POST** `/openapi/copilot/workflow/generate`

Request body:
```json
{
  "query": "生成一个客户反馈分析工作流",
  "locale": "zh-CN"
}
```

Response (200) contains:
- `data.canvasId`
- `data.workflowPlan` (title, tasks, variables)

Notes:
- If `canvasId` is provided in the request, it **overwrites** that canvas (no undo). Require an extra explicit confirmation before calling this endpoint.

## 4) (Optional) Poll status / get output
- **GET** `/openapi/workflow/{executionId}/status`
- **GET** `/openapi/workflow/{executionId}/output`

## Troubleshooting
- **TLS/证书错误（curl code 60）**：Refly 端点若遇到证书问题，可用 `curl -k` 临时绕过（仅用于受信环境）。
- **下载链接是 localhost**：输出里若出现 `http://localhost:5800/...`，需改为 `https://refly.kmos.ai/api/v1/drive/file/public/<fileId>/<filename>` 才能外部访问（基于 `api_base`）。
- **请求易超时**：`workflow/generate` 或大任务可将超时调长（例如 60–120s；必要时 10 分钟），避免误以为失败导致重复调用。
- **缺少 ripgrep（rg）**：若 `rg` 不可用，改用 `grep -Rin` 做关键词检索。
