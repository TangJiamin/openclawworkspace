# 🔌 Seedance to Refly Bridge Hook

## 📋 概述

自动桥接 Seedance Skill 到 Refly 工作流，实现完全自动化的视频生成流程。

**触发方式：** Seedance Skill 完成后自动触发

**工作流程：**
```
Seedance Skill → Hook → Refly 工作流 API → 视频生成 → 返回结果
```

---

## 🎯 功能特性

### ✅ 完全自动化

- ❌ 不需要手动复制 JSON
- ❌ 不需要手动粘贴到 Refly
- ✅ 自动触发，自动处理

### ✅ 实时处理

- ⚡ Seedance Skill 完成后立即触发
- ⚡ 实时返回视频生成结果

### ✅ 错误处理

- 🔍 验证输入数据
- 🔄 自动重试机制
- 📝 详细的错误日志

### ✅ 灵活配置

- 🔧 可通过环境变量配置
- 🔧 可启用/禁用自动生成
- 🔧 可自定义超时时间

---

## 🚀 快速开始

### 步骤 1: 安装 Hook

```bash
cd /home/node/.openclaw/hooks/seedance-to-refly-bridge
npm install
```

### 步骤 2: 配置环境变量

```bash
# 编辑 Gateway 配置
nano ~/.openclaw/gateway.env
```

添加：
```bash
# Refly 配置
REFLY_WEBHOOK_URL=https://refly.kmos.ai/api/workflows/run
REFLY_API_KEY=your-refly-api-key
REFLY_WORKFLOW_ID=wf-seedance-video-gen-001

# 自动化开关
SEEDANCE_AUTO_GENERATE_VIDEO=true
```

### 步骤 3: 部署 Hook

```bash
# 部署到 OpenClaw
openclaw hooks deploy /home/node/.openclaw/hooks/seedance-to-refly-bridge

# 验证 Hook
openclaw hooks list
openclaw hooks info seedance-to-refly-bridge
```

### 步骤 4: 测试 Hook

```bash
# 运行测试
node handler.ts
```

### 步骤 5: 使用

```
/seedance-storyboard

基于这张设计图生成视频脚本：
https://refly.kmos.ai/designs/ai-tools.png

展示 AI 工具的 5 个核心功能
```

**自动执行：**
1. ✅ Seedance Skill 生成分镜脚本
2. ✅ Hook 自动触发
3. ✅ 调用 Refly 工作流
4. ✅ 生成视频
5. ✅ 返回视频链接

---

## 📊 数据流

### 输入数据

```json
{
  "seedanceOutput": {
    "success": true,
    "input": {
      "design_image_url": "https://refly.kmos.ai/designs/ai-tools.png"
    },
    "seedance_prompt": {
      "full_prompt": "Tech style, 60 seconds..."
    }
  }
}
```

### 输出数据

```json
{
  "success": true,
  "workflow": "seedance-to-refly-bridge",
  "input": {
    "design_image_url": "https://refly.kmos.ai/designs/ai-tools.png",
    "seedance_prompt_preview": "Tech style, 60 seconds..."
  },
  "output": {
    "video_url": "https://jimeng.jianying.com/videos/abc123.mp4",
    "video_id": "abc123"
  },
  "video_url": "https://jimeng.jianying.com/videos/abc123.mp4",
  "message": "✅ 视频已自动生成！"
}
```

---

## ⚙️ 配置选项

### 环境变量

| 变量 | 必需 | 默认值 | 说明 |
|------|------|--------|------|
| `REFLY_WEBHOOK_URL` | ✅ | `https://refly.kmos.ai/api/workflows/run` | Refly 工作流 API URL |
| `REFLY_API_KEY` | ✅ | - | Refly API 密钥 |
| `REFLY_WORKFLOW_ID` | ✅ | `wf-seedance-video-gen-001` | Refly 工作流 ID |
| `SEEDANCE_AUTO_GENERATE_VIDEO` | ❌ | `true` | 是否自动生成视频 |

### Hook 配置

**触发方式：** Seedance Skill 完成事件

**超时时间：** 5 分钟（300 秒）

**重试机制：** 是（最多 3 次，指数退避）

---

## 🔧 工作原理

### 1. 监听事件

Hook 监听 Seedance Skill 的完成事件：

```typescript
// Seedance Skill 完成后触发
event: {
  seedanceOutput: { ... }
}
```

### 2. 验证数据

验证必需字段：
- ✅ `design_image_url` 存在且有效
- ✅ `seedance_prompt.full_prompt` 存在且足够长

### 3. 构建输入

将数据转换为 Refly 兼容的 JSON 格式：

```json
{
  "success": true,
  "workflow": "seedance-storyboard",
  "data": {
    "design_image_url": "...",
    "seedance_prompt": "..."
  }
}
```

### 4. 调用 Refly API

POST 请求到 Refly 工作流：

```javascript
POST REFLY_WEBHOOK_URL
Headers:
  Authorization: Bearer REFLY_API_KEY
Body:
  {
    workflow_id: REFLY_WORKFLOW_ID,
    input: {
      seedance_data: "<JSON string>"
    }
  }
```

### 5. 返回结果

返回视频 URL 和相关元数据：

```json
{
  "video_url": "https://jimeng.jianying.com/videos/abc123.mp4",
  "video_id": "abc123"
}
```

---

## 📝 日志示例

### 成功日志

```
[2026-02-27T09:00:00.000Z] [INFO] Seedance-to-ReflBridge: 收到 Seedance 输出，准备自动生成视频...
[2026-02-27T09:00:00.100Z] [INFO] Seedance-to-ReflBridge: 正在调用 Refly 工作流...
[2026-02-27T09:04:30.500Z] [INFO] Seedance-to-ReflBridge: ✅ Refly 工作流执行成功
```

### 错误日志

```
[2026-02-27T09:00:00.000Z] [INFO] Seedance-to-ReflBridge: 收到 Seedance 输出，准备自动生成视频...
[2026-02-27T09:00:00.050Z] [ERROR] Seedance-to-ReflBridge: ❌ 处理失败: Refly API 错误: 401 - Unauthorized
```

---

## 🧪 测试

### 手动测试

```bash
cd /home/node/.openclaw/hooks/seedance-to-refly-bridge
node handler.ts
```

### 集成测试

```bash
# 在 OpenClaw 中测试
/seedance-storyboard

基于这张设计图生成视频脚本：
https://refly.kmos.ai/designs/ai-tools.png

展示 AI 工具的 5 个核心功能
```

**预期输出：**
```
✅ 分镜脚本已生成！
✅ 正在自动调用 Refly 工作流...

📹 视频已自动生成！
链接：https://jimeng.jianying.com/videos/abc123.mp4
```

---

## 🎊 优势

### 1. 零手动操作 ✅

```
之前：生成脚本 → 复制 JSON → 粘贴到 Refly → 运行工作流
现在：生成脚本 → 自动生成视频 ✨
```

### 2. 实时处理 ✅

```
之前：等待批量处理
现在：立即生成视频
```

### 3. 错误处理 ✅

```
之前：手动检查错误
现在：自动重试和通知
```

### 4. 批量支持 ✅

```
之前：逐个手动处理
现在：自动批量处理
```

---

## 📚 相关文档

- **自动化方案：** `docs/SEEDANCE-TO-REFLY-AUTOMATION.md`
- **数据传输方案：** `docs/REFLY-DATA-TRANSMISSION-SOLUTION.md`
- **工作流配置：** `docs/REFLY-WORKFLOW-CONFIG.md`

---

## ✅ 检查清单

部署前检查：

- [ ] 已安装依赖（`npm install`）
- [ ] 已配置环境变量（`REFLY_WEBHOOK_URL`, `REFLY_API_KEY`）
- [ ] 已部署 Hook（`openclaw hooks deploy`）
- [ ] 已测试 Hook（`node handler.ts`）
- [ ] 已验证 Refly 工作流（`REFLY_WORKFLOW_ID`）

---

**🎯 Hook 准备就绪！可以开始自动化视频生成流程了！**
