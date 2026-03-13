# 测试报告查看指南

**更新时间**: 2026-03-12 10:45

---

## 📊 最新测试报告（2026-03-10）

### 小红书内容质量评估

**文件位置**: `agents/quality-agent/reports/`

#### 1. 完整报告
```
agents/quality-agent/reports/xhs_ai_tools_20260310_quality_report.md
```

#### 2. 摘要报告
```
agents/quality-agent/reports/xhs_ai_tools_20260310_summary.txt
```

### 测试结果

**综合评分**: 82/100 (⭐⭐⭐ 及格)

**评级**: ✅ 可以使用，建议优化后发布

#### 各维度评分

| 维度 | 得分 | 比例 | 状态 |
|------|------|------|------|
| **资讯质量** | 25/30 | 83% | ✅ |
| **文案质量** | 34/40 | 85% | ✅ |
| **整体效果** | 23/30 | 77% | ⚠️ |

#### 主要优点

1. ✅ 目标受众明确 - 精准定位"打工人"群体
2. ✅ 结构清晰易读 - 清单式布局，层次分明
3. ✅ 实用价值高 - 提供具体使用场景和技巧
4. ✅ 平台风格匹配 - emoji丰富，语气亲切
5. ✅ 互动设计合理 - 结尾引导评论和分享

#### 需要改进

1. ⚠️ 热点深度不足 - 缺乏AI行业趋势洞察
2. ⚠️ 视觉元素缺失 - 缺少配图、GIF、信息图表
3. ⚠️ 内容同质化 - 与同类文章差异不明显
4. ⚠️ 夸大宣传风险 - "效率提升200%"等表述需修改

#### 改进建议

**立即修复（5分钟）**:
- 修改"效率提升200%" → "效率显著提升"
- 修改"万能助手" → "多功能助手"
- 修改"秒出纪要" → "快速生成纪要"

**快速优化（15分钟）**:
- 添加1-2个真实使用案例
- 制作9宫格配图方案
- 补充"AI工具选择指南"信息图表

**深度优化（30分钟）**:
- 添加"2026年AI工具发展趋势"洞察
- 分享1-2个小众独家工具
- 设计"AI工具使用挑战"互动环节

---

## 📁 所有测试报告位置

### 按日期

**2026-03-11**:
- `agents/content-agent/output/douyin_tech_depth_20260311.md`
- `agents/research-agent/output/AI热点资料收集报告_2026-03-11.md`
- `agents/video-agent/output/storyboard_scripts_20260311.md`

**2026-03-10**:
- `agents/content-agent/output/xhs_ai_tools_20260310.md`
- `agents/quality-agent/reports/xhs_ai_tools_20260310_quality_report.md`
- `agents/quality-agent/reports/xhs_ai_tools_20260310_summary.txt`

### 按 Agent

**research-agent**:
```
agents/research-agent/output/
├── AI热点资料收集报告_2026-03-11.md
└── task-20260312-093843/
```

**content-agent**:
```
agents/content-agent/output/
├── xhs_ai_tools_20260310.md
└── douyin_tech_depth_20260311.md
```

**visual-agent**:
```
agents/visual-agent/output/
├── visual_20260309_144030.md
└── 合道文化/
```

**video-agent**:
```
agents/video-agent/output/
└── storyboard_scripts_20260311.md
```

**quality-agent**:
```
agents/quality-agent/reports/
├── xhs_ai_tools_20260310_quality_report.md
└── xhs_ai_tools_20260310_summary.txt
```

---

## 🔍 查看方法

### 方法1: 使用 cat 命令

```bash
# 查看完整报告
cat /home/node/.openclaw/workspace/agents/quality-agent/reports/xhs_ai_tools_20260310_quality_report.md

# 查看摘要报告
cat /home/node/.openclaw/workspace/agents/quality-agent/reports/xhs_ai_tools_20260310_summary.txt
```

### 方法2: 使用 less 命令（分页查看）

```bash
less /home/node/.openclaw/workspace/agents/quality-agent/reports/xhs_ai_tools_20260310_quality_report.md

# 导航：
# 空格键 - 下一页
# b 键 - 上一页
# q 键 - 退出
```

### 方法3: 列出所有报告

```bash
# 列出 quality-agent 的所有报告
ls -lah /home/node/.openclaw/workspace/agents/quality-agent/reports/

# 列出所有 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list
```

---

## 📊 Agent 优化报告

**位置**: `skills/agent-optimizer/reports/`

**最新报告**（2026-03-10）:
- `optimization-20260310-070046.md`
- `optimization-20260310-090820.md`
- `optimization-20260310-105159.md`
- `optimization-20260310-113747.md`
- `optimization-20260310-120738.md`
- `optimization-20260310-140904.md`
- `optimization-20260310-151107.md`
- `optimization-20260310-153139.md`
- `optimization-20260310-191216.md`
- `optimization-20260310-191733.md`
- `optimization-20260310-213421.md`

**2026-03-11**:
- `optimization-20260311-003038.md`

---

## 🎯 快速查看最新报告

```bash
# 查看最新的质量评估报告
cat /home/node/.openclaw/workspace/agents/quality-agent/reports/xhs_ai_tools_20260310_summary.txt

# 查看最新的 Agent 优化报告
ls -lt /home/node/.openclaw/workspace/skills/agent-optimizer/reports/ | head -5
```

---

## 📝 注意事项

1. **质量评估报告** - 位于 `agents/quality-agent/reports/`
2. **内容产出** - 位于各 Agent 的 `output/` 目录
3. **优化报告** - 位于 `skills/agent-optimizer/reports/`
4. **使用新的产出管理工具** - 未来的产出将位于 `agents/<agent>/output/task-<timestamp>/`

---

**更新时间**: 2026-03-12 10:45
**状态**: ✅ 已整理
