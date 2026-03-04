# 🎨 Refly 视觉设计师 - 快速参考卡

## ⚡ 30 秒快速开始

```bash
# 1. 进入目录
cd ~/.openclaw/hooks/refly-visual-designer

# 2. 运行部署
bash deploy.sh

# 3. 测试（在任意平台发送）
生成封面图：AI时代的生产力革命
```

---

## 💬 常用命令

### 设计请求示例

```
# 文章封面
生成封面图：ChatGPT-5 发布前瞻，风格：科技感，尺寸：16:9

# 信息图
设计信息图：AI模型参数量增长趋势，形式：柱状图

# 社交配图
生成小红书配图：AI工具推荐，风格：清新可爱，尺寸：1:1

# 视频封面
生成视频封面：5分钟了解AI Agents，风格：动感，尺寸：16:9

# 海报
生成海报：AI技术创新峰会，风格：高端商务
```

---

## 🔧 管理命令

```bash
# Hook 管理
openclaw hooks enable refly-visual-designer    # 启用
openclaw hooks disable refly-visual-designer   # 禁用
openclaw hooks info refly-visual-designer      # 查看状态
openclaw hooks check                           # 检查所有 Hook

# Cron 任务
openclaw cron list                             # 查看所有任务
openclaw cron add --name "..." ...             # 添加任务
openclaw cron run <name>                       # 手动运行
openclaw cron runs <name>                      # 查看历史

# 日志
openclaw logs --tail 50 | grep refly           # 查看 Refly 日志
openclaw logs --tail 100 | grep visual         # 查看视觉设计日志

# 重启
openclaw gateway restart                       # 重启 Gateway
```

---

## 📐 尺寸速查

| 尺寸 | 用途 | 命令示例 |
|------|------|---------|
| 16:9 | 视频封面、PPT | `尺寸：16:9` |
| 1:1 | 社交媒体 | `尺寸：1:1` |
| 9:16 | 短视频 | `尺寸：9:16` |
| 4:3 | 传统演示 | `尺寸：4:3` |

---

## 🎨 风格速查

| 风格 | 适用场景 |
|------|---------|
| 科技感 | AI、技术类内容 |
| 商务专业 | 企业、商业内容 |
| 现代简约 | 通用场景 |
| 清新可爱 | 生活化内容 |
| 艺术创意 | 创意类内容 |
| 深色模式 | 技术文档、工具 |

---

## 📂 文件位置

```
~/.openclaw/hooks/refly-visual-designer/
├── HOOK.md              # Hook 配置
├── README.md            # 使用说明
├── INTEGRATION-GUIDE.md # 集成指南
├── EXAMPLES.md          # 使用示例
├── handler.ts           # 主程序
├── package.json         # NPM 配置
├── tsconfig.json        # TypeScript 配置
└── deploy.sh            # 部署脚本

~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/
├── designs_2026-02-27.json   # 元数据
└── images/                    # 图片文件
```

---

## ⚙️ 环境变量

```bash
# ~/.openclaw/gateway.env
REFLY_URL=http://refly.kmos.ai
REFLY_API_KEY=your-key-here
REFLY_VISUAL_WORKFLOW_ID=c-anlbsxecm4d201aj4zgnph8y
REFLY_TIMEOUT=60000
```

---

## 🔍 故障排除

| 问题 | 解决方案 |
|------|---------|
| 无响应 | `openclaw hooks check` + `openclaw gateway restart` |
| API 失败 | 检查 `REFLY_API_KEY` |
| 质量差 | 优化 prompt，添加详细描述 |
| 未保存 | 检查文件权限 |

---

## 📚 完整文档

- **快速开始:** `README.md`
- **集成指南:** `INTEGRATION-GUIDE.md`
- **使用示例:** `EXAMPLES.md`
- **下一步行动:** `/home/node/.openclaw/workspace/REFLY-VISUAL-DESIGN-NEXT-STEPS.md`

---

**工作流 ID:** `c-anlbsxecm4d201aj4zgnph8y`

**版本:** v1.0.0

**最后更新:** 2026-02-27
