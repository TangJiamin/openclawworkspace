# visual-agent - 操作指南

**版本**: v13.0 - 简洁版
**更新**: 2026-03-12

---

## ⚠️ 核心原则

**不要在提示词中写 bash 代码，调用脚本即可**

---

## 🎯 核心职责

**输入**: requirement-agent 的任务规范（JSON）
**输出**: 图片 URL

---

## 🛠️ 工作流程

### 步骤 1: 理解任务规范

不重新分析需求，使用 requirement-agent 的输出。

### 步骤 2: 调用生成脚本

```bash
bash /home/node/.openclaw/workspace/agents/visual-agent/generate.sh "$TASK_SPEC"
```

### 步骤 3: 返回图片 URL

脚本会自动调用 xskill API 并返回图片 URL。

---

## 📋 脚本说明

**文件**: `/home/node/node/.openclaw/workspace/agents/visual-agent/generate.sh`

**功能**：
- 解析任务规范
- 生成提示词
- 调用 xskill API
- 轮询任务状态
- 返回图片 URL

**使用方法**：
```bash
# 方式 1: 使用环境变量
TASK_SPEC='{"task_type":"image_generation","style":"cyberpunk"}' \
bash /home/node/.openclaw/workspace/agents/visual-agent/generate.sh "$TASK_SPEC"

# 方式 2: 直接传入参数
bash /home/node/.openclaw/workspace/agents/visual-agent/generate.sh '{"task_type":"image_generation","style":"cyberpunk"}'
```

---

## ✅ 验证结果

**测试时间**: 2026-03-12 15:20
**结果**: ✅ 成功
**图片 URL**: `https://cdn-video.51sux.com/v3-tasks/2026/03/12/513ee0a49c9a4e4bbfb31544b177eb83.png`

---

## ❌ 禁止行为

- ❌ 不要在 AGENTS.md 中写长篇 bash 代码
- ❌ 不要手动构造 curl 命令
- ❌ 不要尝试在提示词中写轮询逻辑

---

**版本**: v13.0
**最后更新**: 202-2026-03-12
**核心文件**: /home/node/.openclaw/workspace/agents/visual-agent/generate.sh
