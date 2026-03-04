---
name: metaso-search
description: Use Metaso AI search API (https://metaso.cn) for intelligent web search when user requests web search or needs to find current information online. Trigger for any search queries, fact-checking, or when retrieving up-to-date information from the internet is needed. Provides AI-powered search results with summaries.
---

# Metaso AI Search

秘塔AI搜索工具，用于智能网络搜索和信息检索。

## ⚠️ 时效性保证（重要）

**当前年份**: 2026年
**必须规则**: 搜索关键词必须包含当前年份或"最新"

### 正确的搜索关键词示例
```bash
# ✅ 包含当前年份
"AI工具 2026"
"内容生成 2026年最新"

# ✅ 使用"最新"
"AI视频生成 最新"
"自媒体工具 最新趋势"

# ❌ 错误：使用旧年份
"AI工具 2024"      # 会返回过时信息
"ChatGPT 2023"     # 会返回过时信息
```

### 时效性检查流程
1. **搜索前**: 检查当前日期（`date +'%Y-%m-%d'`）
2. **关键词**: 必须包含 `2026` 或 `最新` 或 `latest`
3. **结果验证**: 检查返回结果的日期是否在 **2025-2026年**
4. **过滤**: 如果结果日期早于 **2025年**，视为过时，需重新搜索

---

## 快速开始

当用户需要网络搜索时，直接执行搜索脚本：

```bash
# 获取当前日期
TZ='Asia/Shanghai' date +'%Y-%m-%d'

# 搜索（必须包含2026或"最新"）
./scripts/metaso_search.sh "AI内容生成 2026 最新"
./scripts/metaso_search.sh "AI tools 2026 latest"
```

### 搜索示例

**时效性相关搜索**：
```bash
# 搜索最新资讯（必须）
./scripts/metaso_search.sh "AI视频生成 2026 最新"
./scripts/metaso_search.sh "content creation tools 2026"
./scripts/metaso_search.sh "自媒体自动化 最新趋势"

# 搜索技术文档（可用旧年份）
./scripts/metaso_search.sh "Python 异步编程教程"
./scripts/metaso_search.sh "React 官方文档"
```

---

## 使用方法

### 基本搜索

```bash
./scripts/metaso_search.sh "搜索关键词"
```

### 指定结果数量

```bash
./scripts/metaso_search.sh "搜索查询" 20
```

### 搜索范围选项

- `webpage` - 网页搜索（默认）
- `academic` - 学术搜索
- `knowledge` - 知识库搜索

```bash
./scripts/metaso_search.sh "学术论文" 10 academic
```

---

## 时效性验证清单

在处理搜索结果时，必须检查：

### ✅ 可接受的日期范围
- **2026年**: 完全接受
- **2025年**: 可接受（去年的内容）
- **2024年及更早**: ⚠️ 过时，需重新搜索

### 验证步骤
1. **检查结果日期**: 查看每个搜索结果的 `date` 字段
2. **统计分布**:
   - 如果 >50% 的结果日期 < 2025年 → 关键词有问题
   - 如果所有结果日期都 < 2025年 → 必须重新搜索
3. **记录时效性**: 在报告中明确标注资讯的时间范围

### 示例验证
```json
// ✅ 好的结果分布
{
  "results": [
    {"date": "2026-02-19"},
    {"date": "2026-01-01"},
    {"date": "2025-12-08"}
  ],
  "评估": "时效性良好，2025-2026年资讯"
}

// ❌ 差的结果分布
{
  "results": [
    {"date": "2024-04-17"},
    {"date": "2024-01-01"},
    {"date": "2023-10-13"}
  ],
  "评估": "过时！需重新搜索，使用'2026'关键词"
}
```

---

## API配置

脚本默认使用API密钥：`mk-B666AF87AB936668EB445F2ABDC687BF`

如需更换密钥，设置环境变量：

```bash
export METASO_API_KEY="your-api-key-here"
```

---

## 输出格式

API返回JSON格式，包含：
- 搜索结果列表
- 每个结果的 **标题、日期、摘要、URL**（日期很重要！）
- AI生成的总结（当includeSummary=true时）

---

## 注意事项

1. ⚠️ **时效性优先**: 搜索关键词必须包含当前年份（2026）或"最新"
2. **验证日期**: 必须检查返回结果的日期字段
3. **过时处理**: 如果结果 < 2025年，立即重新搜索
4. **API密钥**: 已内置，无需额外配置
5. **搜索语言**: 支持中文或英文
6. **结果数量**: 默认10条，可调整

---

## 最佳实践

### 1. 时效性搜索（资讯、趋势、工具）
```bash
# ✅ 正确：包含当前年份
./scripts/metaso_search.sh "AI视频生成工具 2026"
./scripts/metaso_search.sh "content automation 2026 latest"

# ❌ 错误：缺少年份
./scripts/metaso_search.sh "AI视频生成工具"  # 可能返回旧信息
```

### 2. 技术文档搜索（ timeless 内容）
```bash
# ✅ 可以不包含年份（技术文档变化慢）
./scripts/metaso_search.sh "Python 异步编程教程"
./scripts/metaso_search.sh "Docker 官方文档"
```

### 3. 复杂查询策略
```bash
# 分多次搜索，获取更全面结果
./scripts/metaso_search.sh "AI内容生成 2026 最新" 5
./scripts/metaso_search.sh "视频生成AI 2026 工具" 5
./scripts/metaso_search.sh "自媒体自动化 最新趋势" 5
```

### 4. 结果处理
- **验证日期**: 检查每个结果的 date 字段
- **过滤过时**: 忽略 < 2025年的结果
- **标注时间**: 在报告中明确"2026年最新资讯"
- **结合其他工具**: 使用 web_fetch 深入分析具体网页

---

## 错误案例（2026-03-02 实际发生）

### ❌ 错误示范
```bash
# 第一次搜索（错误）
./scripts/metaso_search.sh "AI content generation tools 2024"
# 结果：返回2024年的资讯，过时了！
```

### ✅ 纠正
```bash
# 第二次搜索（正确）
./scripts/metaso_search.sh "AI内容生成 2026 最新"
./scripts/metaso_search.sh "AI content generation 2026 latest"
# 结果：返回2026年最新资讯 ✅
```

**教训**: 必须在搜索前确认当前年份，并在关键词中体现

---

## 相关文件

- 搜索脚本: `/home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh`
- 错误记录: `memory/2026-03-02.md`（2026-03-02 时效性错误）
- 学习报告: `memory/daily-learning/2026-03-02.md`（已纠正）
