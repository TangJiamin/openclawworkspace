# 🎯 两个业务场景脚本使用指南

**更新时间**: 2026-03-03 10:21 UTC

---

## 📁 脚本位置（永久）

```
/home/node/.openclaw/scripts/scenarios/
├── scene1-manual-production.sh   # 场景1：按需生产
└── scene2-batch-production.sh    # 场景2：定时批量生产
```

---

## 🚀 快速使用

### 场景1：按需生产（用户触发）

**用途**: 用户提出需求，系统生成内容

**运行**:
```bash
bash /home/node/.openclaw/scripts/scenarios/scene1-manual-production.sh
```

**流程**:
```
用户需求
  ↓
requirement-agent（入口）
  ↓
research-agent（资料收集）
  ↓
content-agent（文案生成）
  ↓
visual-agent（图片生成）
  ↓
quality-agent（质量审核）⭐
  ↓
返回审核结果给用户
```

**特点**:
- ✅ 用户触发
- ✅ 单个任务
- ✅ **quality-agent 优先审核**
- ✅ 用户决定是否使用

---

### 场景2：定时批量生产（定时触发）

**用途**: 系统定时收集资讯并批量生成内容

**运行**:
```bash
bash /home/node/.openclaw/scripts/scenarios/scene2-batch-production.sh
```

**流程**:
```
定时器触发
  ↓
research-agent（入口）
  ↓
1. 收集最新资讯
2. 识别热点话题（5-10个）
3. 批量生成内容
   ├─→ 文案 × N
   ├─→ 图片 × N
   └─→ 视频 × N（可选）
4. 批量质量审核
5. 筛选高质量（≥80分）
6. 批量发布到平台
```

**特点**:
- ✅ 定时触发
- ✅ 批量任务
- ✅ **quality-agent 批量审核**
- ✅ 自动发布

---

## 🔧 配置定时任务

### 方式1: 使用 openclaw cron（推荐）

```bash
# 添加定时任务（每天早上8点执行）
openclaw cron add \
  --schedule "0 8 * * *" \
  --payload "执行每日批量生产" \
  --delivery.mode "announce" \
  --delivery.channel "feishu"
```

### 方式2: 系统 Cron

```bash
# 编辑 crontab
crontab -e

# 添加一行
0 8 * * * bash /home/node/.openclaw/scripts/scenarios/scene2-batch-production.sh
```

---

## 📊 对比总结

| 维度 | 场景1（按需） | 场景2（定时） |
|------|------------|----------|
| **入口** | requirement-agent | research-agent |
| **触发** | 用户输入 | 定时器 |
| **规模** | 单个任务 | 批量任务（N个） |
| **审核** | quality-agent ⭐ | quality-agent ⭐ |
| **审核方式** | 立即反馈 | 自动筛选 |
| **发布** | 用户决定 | 自动发布 |
| **反馈** | 立即 | 延迟 |

---

## ✅ 关键验证

1. ✅ **两个场景都支持文案、图片、视频三种内容类型**
2. ✅ **quality-agent 在两个场景中都优先使用**
3. ✅ **脚本已保存在永久目录**
4. ✅ **支持定时任务配置**

---

## 🔗 相关文件

- `/home/node/.openclaw/agents/` - 所有 Agents
- `/home/node/.openclaw/workspace/SCENES1-SCENE2-COMPLETE.md` - 完整报告

---

**维护者**: Main Agent  
**状态**: ✅ 脚本已永久保存并可正常使用
