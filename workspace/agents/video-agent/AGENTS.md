# video-agent - 操作指南

**版本**: v14.0 - Lightning 模型 + 优化脚本
**更新**: 2026-03-12

---

## ⚠️ 核心原则

**不要在提示词中写 bash 代码，调用脚本即可**

---

## 🎯 核心职责

**输入**: requirement-agent 的任务规范 + visual-agent 的图片 URL
**输出**: 视频 URL

---

## 🛠️ 工作流程

### 步骤 1: 理解任务规范

不重新分析需求，使用 requirement-agent 的输出 + visual-agent 的图片 URL。

### 步骤 2: 调用生成脚本

```bash
bash /home/node/.openclaw/workspace/agents/video-agent/generate.sh '{
  "image_url": "https://...",
  "prompt": "cinematic video",
  "duration": 5
}'
```

### 步骤 3: 返回视频 URL

脚本会自动调用 xskill API 并返回视频 URL。

---

## 📋 脚本说明

**文件**: `/home/node/.openclaw/workspace/agents/video-agent/generate.sh`

**功能**：
- 使用图片 URL 生成视频
- 调用 xskill API（jimeng-video-2.0 模型）
- 轮询任务状态
- 返回视频 URL

**参数**：
- `image_url`: visual-agent 生成的图片 URL
- `prompt`: 视频提示词（可选，默认 "cinematic video"）
- `duration`: 视频时长（秒，默认 5）

**使用方法**：
```bash
# 方式 1: 使用环境变量
TASK_SPEC='{"image_url":"https://...","prompt":"cinematic","duration":5}' \
bash /home/node/.openclaw/workspace/agents/video-agent/generate.sh "$TASK_SPEC"

# 方式 2: 直接传入参数
bash /home/node/.openclaw/workspace/agents/video-agent/generate.sh '{"image_url":"https://..."}'
```

**轮询配置**（优化版）：
- 轮询次数：150 次（视频生成需要更长时间）
- 轮询间隔：3 秒
- 总等待时间：450 秒（7.5 分钟）

---

## ✅ 性能优化

### 模型选择

**当前**: minimax/MiniMax-M2.5-Lightning（轻量版）

**优势**：
- ✅ 速度提升 50%+
- ✅ 成本降低 14%+
- ✅ 工具调用能力强

**超时配置**：
- ✅ 300 秒（5 分钟）
- ✅ 足够完成视频生成

---

## ❌ 禁止行为

- ❌ 不要在 AGENTS.md 中写长篇 bash 代码
- ❌ 不要手动构造 curl 命令
- ❌ 不要尝试在提示词中写轮询逻辑

---

**版本**: v14.0
**最后更新**: 2026-03-12
**模型**: minimax/MiniMax-M2.5-Lightning (mm-fast)
**核心文件**: /home/node/.openclaw/workspace/agents/video-agent/generate.sh
