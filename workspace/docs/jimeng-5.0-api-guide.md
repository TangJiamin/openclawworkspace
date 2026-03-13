# jimeng-5.0 API 调用指南

**版本**: v1.0
**更新时间**: 2026-03-10

---

## 📋 快速开始

### 1. 前置条件

**必需的环境变量** (在 `.env` 文件中设置):
```bash
XSKILL_API_KEY=sk-your-api-key-here
```

**API Key 获取方式**:
1. 访问 https://www.xskill.ai
2. 登录账号
3. 进入 API Key 页面
4. 创建 API Key

---

## 🚀 使用方法

### 基础调用

```bash
# 最简单的调用
bash /home/node/.openclaw/workspace/scripts/jimeng-5.0-call.sh "一只可爱的猫咪"
```

### 高级选项

```bash
# 指定比例和分辨率
bash /home/node/.openclaw/workspace/scripts/jimeng-5.0-call.sh \
  "小红书封面，5个AI工具" \
  --ratio "3:4" \
  --resolution "2k"

# 生成并下载图片
bash /home/node/.openclaw/workspace/scripts/jimeng-5.0-call.sh \
  "科技感未来城市" \
  --ratio "16:9" \
  --resolution "4k" \
  --output "/path/to/save/image.jpg"
```

---

## 📊 参数说明

### 必需参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `prompt` | 图片描述（文本提示词） | "一只可爱的猫咪在草地上" |

### 可选参数

| 参数 | 说明 | 可选值 | 默认值 |
|------|------|--------|--------|
| `--ratio` | 图像比例 | 1:1, 3:4, 4:3, 16:9, 21:9 | 3:4 |
| `--resolution` | 分辨率 | 2k, 4k | 2k |
| `--output` | 保存路径 | 任意文件路径 | (不保存) |

---

## 🎨 推荐参数组合

### 小红书内容
```bash
bash /home/node/.openclaw/workspace/scripts/jimeng-5.0-call.sh \
  "小红书封面，5个提升效率的AI工具" \
  --ratio "3:4" \
  --resolution "2k"
```

### 抖音封面
```bash
bash /home/node/.openclaw/workspace/scripts/jimeng-5.0-call.sh \
  "抖音封面，ChatGPT使用技巧" \
  --ratio "16:9" \
  --resolution "2k"
```

### 微信公众号封面
```bash
bash /home/node/.openclaw/workspace/scripts/jimeng-5.0-call.sh \
  "微信公众号封面，AI行业趋势分析" \
  --ratio "16:9" \
  --resolution "2k"
```

---

## 🔧 API 调用原理

### 1. 创建任务

**端点**: `POST https://api.xskill.ai/api/v3/tasks/create`

**请求格式**:
```json
{
  "model": "jimeng-5.0",
  "params": {
    "prompt": "一只可爱的猫咪在草地上",
    "ratio": "3:4",
    "resolution": "2k"
  }
}
```

**响应格式**:
```json
{
  "code": 200,
  "data": {
    "task_id": "task_xxx",
    "price": 2
  }
}
```

### 2. 查询任务

**端点**: `POST https://api.xskill.ai/api/v3/tasks/query`

**请求格式**:
```json
{
  "task_id": "task_xxx"
}
```

**响应格式**:
```json
{
  "code": 200,
  "data": {
    "status": "completed",
    "result": {
      "output": {
        "images": ["https://cdn.xskill.ai/xxx.jpg"]
      }
    }
  }
}
```

### 3. 轮询机制

- 每 2 秒查询一次任务状态
- 最多查询 60 次（2 分钟）
- 任务完成后返回图片 URL

---

## 💡 最佳实践

### 1. 提示词优化

**好的提示词**:
- ✅ "一只金毛犬在阳光明媚的草地上奔跑，细节丰富"
- ✅ "科技感未来城市，赛博朋克风格，霓虹灯效果"

**不好的提示词**:
- ❌ "狗" (太简单)
- ❌ "好看" (太抽象)

### 2. 比例选择

| 用途 | 推荐比例 | 原因 |
|------|---------|------|
| 小红书 | 3:4 | 竖屏，适合手机浏览 |
| 抖音封面 | 16:9 | 横屏，适合视频封面 |
| 微信公众号 | 16:9 | 横屏，适合电脑浏览 |
| 头像 | 1:1 | 正方形，通用 |

### 3. 分辨率选择

| 用途 | 推荐分辨率 | 原因 |
|------|-----------|------|
| 社交媒体 | 2k | 清晰且生成快 |
| 商业用途 | 4k | 高质量 |
| 测试 | 2k | 节省积分 |

---

## 🔒 安全原则

### API Key 管理

**✅ 正确做法**:
- 在 `.env` 文件中设置 API Key
- 脚本自动读取环境变量
- 不在命令行中暴露 API Key

**❌ 错误做法**:
- 在脚本中硬编码 API Key
- 在命令行中传递 API Key
- 将 API Key 提交到 Git

### 权限控制

- ✅ 只有用户可以设置 API Key
- ✅ AI 只能读取和使用 API Key
- ❌ AI 不能修改 .env 文件

---

## 📝 示例脚本

### 批量生成

```bash
#!/bin/bash

# 批量生成小红书图片
prompts=(
  "5个提升效率的AI工具"
  "ChatGPT使用技巧"
  "AI绘画教程"
)

for prompt in "${prompts[@]}"; do
  echo "生成: $prompt"
  bash /home/node/.openclaw/workspace/scripts/jimeng-5.0-call.sh \
    "$prompt" \
    --ratio "3:4" \
    --resolution "2k" \
    --output "./output/${prompt}.jpg"
  echo ""
done
```

---

## 🐛 故障排除

### 常见错误

**1. 未设置 API Key**
```
❌ 错误: 未设置 XSKILL_API_KEY
```
**解决**: 在 `.env` 文件中设置 `XSKILL_API_KEY=sk-your-key`

**2. 任务创建失败**
```
❌ 创建任务失败
```
**解决**: 检查 API Key 是否有效，检查积分是否充足

**3. 超时**
```
❌ 超时
```
**解决**: 任务可能在队列中，稍后重试

---

## 📚 相关资源

- **Xskill 官网**: https://www.xskill.ai
- **API 文档**: https://www.xskill.ai/#/v2/models/jimeng-5.0
- **统一调用脚本**: `/home/node/.openclaw/workspace/skills/visual-generator/scripts/xskill_call.sh`
- **Visual Generator**: `/home/node/.openclaw/workspace/skills/visual-generator/`

---

**维护者**: Main Agent
**版本**: v1.0
**更新时间**: 2026-03-10
