# 📋 脚本位置说明

**更新时间**: 2026-03-03 10:20 UTC

---

## ❌ 错误：临时文件位置

之前的脚本保存在 `/tmp/`：
- `/tmp/scene1-manual-production.sh`
- `/tmp/scene2-batch-production.sh`

**问题**:
- `/tmp/` 目录的文件会在系统重启后自动删除
- 丢失重要脚本

---

## ✅ 正确：永久位置

已移动到永久目录：

```
/home/node/.openclaw/scripts/scenarios/
├── scene1-manual-production.sh   # 场景1：按需生产（用户触发）
└── scene2-batch-production.sh    # 场景2：定时批量生产（定时触发）
```

---

## 🔧 使用方式

### 场景1：按需生产

```bash
bash /home/node/.openclaw/scripts/scenarios/scene1-manual-production.sh
```

### 场景2：定时批量生产

```bash
bash /home/node/.openclaw/scripts/scenarios/scene2-batch-production.sh
```

---

## 📋 脚本功能

### scene1-manual-production.sh

**功能**: 按需生产（用户触发）

**流程**:
1. requirement-agent - 需求理解
2. research-agent - 资料收集
3. content-agent - 文案生成
4. visual-agent - 图片生成
5. quality-agent - 质量审核 ⭐

**入口**: requirement-agent

**触发**: 用户输入需求

---

### scene2-batch-production.sh

**功能**: 定时批量生产（定时触发）

**流程**:
1. research-agent - 收集最新资讯
2. 识别热点话题
3. 批量生成内容
   - 批量文案（N篇）
   - 批量图片（N张）
   - 批量视频（N个，可选）
4. 批量质量审核
5. 筛选高质量内容（≥80分）
6. 批量发布到平台

**入口**: research-agent

**触发**: 定时器（Cron Job）

---

## 🔗 相关文件

**批量生产主脚本**（场景2调用）:
- `/home/node/.openclaw/agents/research-agent/workspace/scripts/batch-produce.sh`

**Agent 脚本**:
- `/home/node/.openclaw/agents/requirement-agent/workspace/scripts/analyze.sh`
- `/home/node/.openclaw/agents/research-agent/workspace/scripts/collect_v3_final.sh`
- `/home/node/.openclaw/agents/content-agent/workspace/scripts/generate.sh`
- `/home/node/.openclaw/agents/visual-agent/workspace/scripts/generate.sh`
- `/home/node/.openclaw/agents/video-agent/workspace/scripts/generate.sh`
- `/home/node/.openclaw/agents/quality-agent/workspace/scripts/review.sh`

---

## ✅ 总结

- ✅ 脚本已从 `/tmp/` 移动到永久目录
- ✅ 系统重启后脚本仍然可用
- ✅ 可随时调用这两个场景的脚本

---

**维护者**: Main Agent  
**状态**: ✅ 脚本已永久保存
