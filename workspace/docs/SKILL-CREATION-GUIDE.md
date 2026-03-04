# OpenClaw Skill 创建指南

## 两种 Skill 类型

### 1️⃣ Workspace Skills (简单技能)

**适用场景**: 轻量级工具、脚本封装、简单功能

**目录结构**:
```
/home/node/.openclaw/workspace/skills/your-skill/
├── SKILL.md          # 必需：技能元数据 + 文档
└── scripts/          # 可选：脚本文件
    └── script.sh
```

**SKILL.md 格式**:
```markdown
---
name: your-skill
description: 简短描述（1-2 句话）
tags: [tag1, tag2]
category: category-name
---

# 技能标题

## 简介
详细描述...

## 快速使用
```bash
./scripts/script.sh
```

## 更多文档...
```

**特点**:
- ✅ 自动发现，无需安装
- ✅ 支持任何脚本语言
- ✅ 适合快速封装工具
- ❌ 不支持复杂的依赖管理

**示例**:
- `metaso-search` - Metaso AI 搜索封装
- `ai-daily-digest` - AI 资讯摘要生成
- `weather` - 天气查询

---

### 2️⃣ Extension Skills (扩展技能)

**适用场景**: 复杂功能、需要依赖管理、TypeScript/Node.js 项目

**目录结构**:
```
/path/to/extension/skills/your-skill/
├── package.json      # Node.js 项目配置
├── tsconfig.json     # TypeScript 配置
├── src/              # 源代码
│   └── handler.ts
├── dist/             # 编译输出
└── SKILL.md          # 技能文档（可选但推荐）
```

**package.json 配置**:
```json
{
  "name": "your-skill",
  "version": "1.0.0",
  "description": "Skill description",
  "main": "dist/handler.js",
  "openclaw": {
    "skill": true
  }
}
```

**特点**:
- ✅ 支持复杂依赖（npm/yarn）
- ✅ TypeScript 类型安全
- ✅ 可访问 OpenClaw 内部 API
- ✅ 支持长期运行的进程
- ❌ 需要手动安装/配置
- ❌ 需要编译构建

**安装位置**:
- `/home/node/.openclaw/extensions/skills/` (用户扩展)
- `/usr/local/lib/node_modules/openclaw/skills/` (内置技能)

**示例**:
- `coding-agent` - 代码生成 Agent
- `healthcheck` - 安全审计工具
- `feishu-*` - 飞书集成

---

## 📋 创建决策树

```
需要创建 Skill？
    │
    ├─ 仅需调用脚本/CLI？
    │  └─ ✅ Workspace Skill
    │     - 创建 SKILL.md
    │     - 添加脚本到 scripts/
    │     - 完成！
    │
    ├─ 需要 TypeScript/复杂逻辑？
    │  └─ ✅ Extension Skill
    │     - 初始化 Node.js 项目
    │     - 编写 handler.ts
    │     - 安装到 extensions/skills/
    │     - 配置并重启 Gateway
    │
    └─ 不确定？
       └─ 从 Workspace Skill 开始
          - 后续可升级为 Extension
```

---

## 🚀 快速创建模板

### Workspace Skill 模板

```bash
# 创建 skill 目录
mkdir -p /home/node/.openclaw/workspace/skills/my-skill/scripts

# 创建 SKILL.md
cat > /home/node/.openclaw/workspace/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: 简短描述技能功能
tags: [tag1, tag2]
category: utility
---

# My Skill

## 简介
...

## 使用方法
```bash
./scripts/my-script.sh
```
EOF

# 创建脚本
cat > /home/node/.openclaw/workspace/skills/my-skill/scripts/my-script.sh << 'EOF'
#!/bin/bash
echo "Hello from my-skill!"
EOF

chmod +x /home/node/.openclaw/workspace/skills/my-skill/scripts/my-script.sh

# 验证
openclaw skills list | grep my-skill
```

### Extension Skill 模板

```bash
# 创建项目
cd /tmp
mkdir my-extension-skill
cd my-extension-skill
npm init -y

# 创建基本结构
mkdir -p src
cat > src/handler.ts << 'EOF'
export const handler = async (input: any) => {
  return { result: "Hello from extension!" };
};
EOF

# 安装到 extensions
cp -r . /home/node/.openclaw/extensions/skills/my-extension-skill/

# 重启 Gateway
openclaw gateway restart
```

---

## ⚠️ 常见错误

### ❌ 错误 1: 在 Workspace Skill 中使用 TypeScript

```bash
/home/node/.openclaw/workspace/skills/my-skill/
├── package.json          # ❌ Workspace Skill 不需要
├── tsconfig.json         # ❌ Workspace Skill 不需要
├── src/handler.ts        # ❌ 不会被识别
└── SKILL.md
```

**修复**: 移到 Extension Skills 或简化为脚本

---

### ❌ 错误 2: Extension Skill 缺少 openclaw 配置

```json
{
  "name": "my-skill",
  "version": "1.0.0"
  // ❌ 缺少 "openclaw.skill": true
}
```

**修复**: 添加 `openclaw.skill` 字段

---

### ❌ 错误 3: SKILL.md 格式错误

```markdown
---
name: my-skill
# ❌ description 缺失

# My Skill
...
```

**修复**: 补全必需字段（name, description）

---

## 📝 最佳实践

1. **从简单开始**: 先用 Workspace Skill 验证想法
2. **渐进升级**: 复杂后再迁移到 Extension
3. **文档先行**: 清晰的 description 帮助自动触发
4. **测试验证**: 创建后立即 `openclaw skills list` 检查
5. **版本控制**: 复杂技能用 Git 管理

---

## 🔗 相关资源

- 查看 `openclaw skills list` 了解现有技能
- 阅读其他技能的 SKILL.md 学习模式
- 使用 `npx clawhub` 从 ClawHub 安装社区技能

---

**记住**: Workspace Skill = SKILL.md + scripts/，简单就是美！
