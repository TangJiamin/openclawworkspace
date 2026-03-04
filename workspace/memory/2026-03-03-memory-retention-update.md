# 记忆文档清理规则更新

## 更新时间

2026-03-03 07:32 UTC

## 更新内容

### 记忆文档保留时间

**之前**: 3 天
**现在**: 7 天

### 清理规则

```bash
# 删除超过 7 天的记忆文档
find /home/node/.openclaw/workspace/memory -type f -name "*.md" -mtime +7
```

## 原因

1. **周度记忆** - 保留一周的记忆，便于回顾本周工作
2. **足够缓冲** - 7 天时间足够将重要内容压缩到 MEMORY.md
3. **平衡存储** - 既保留足够历史，又不占用过多空间

## 清理策略

### 自动清理（每天凌晨 3:00）

- 扫描 `memory/` 目录
- 删除超过 7 天的 `.md` 文件
- 保留标记为"高重要性"的记忆
- 保留今天的记忆文件

### 手动清理

```bash
# 查看超过 7 天的记忆
find /home/node/.openclaw/workspace/memory -type f -name "*.md" -mtime +7

# 删除超过 7 天的记忆
find /home/node/.openclaw/workspace/memory -type f -name "*.md" -mtime +7 -delete
```

## 当前状态

### 现有记忆文件

**最近 7 天**（保留）:
- 2026-03-03-content-based-cleanup.md
- 2026-03-03-cleaner.md
- 2026-03-03-agent-matrix-optimization.md
- 2026-03-03.md
- 2026-03-03-*.md（多个）
- 2026-03-02-*.md
- 2026-03-01.md
- 2026-02-28.md

**超过 7 天**（将删除）:
- 暂无（最早的文件是 2026-02-28，才 3 天前）

## 首次清理计划

**预计时间**: 2026-03-10（一周后）
**预期结果**: 删除 2026-03-02 之前的记忆文件

## 配置更新

**文件**: `/home/node/.openclaw/workspace/skills/cleanup/scripts/config.sh`
**新增**: `KEEP_DAYS_MEMORY=7`

**脚本**: `/home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-smart-v2.sh`
**更新**: 使用 `-mtime +7` 过滤记忆文件

## 总结

✅ 记忆文档保留时间从 3 天延长到 7 天
✅ 平衡存储需求和回顾价值
✅ 自动化清理，无需手动干预
✅ 重要内容已压缩到 MEMORY.md，安全无虞

---

**维护者**: Main Agent
**更新时间**: 2026-03-03 07:32 UTC
