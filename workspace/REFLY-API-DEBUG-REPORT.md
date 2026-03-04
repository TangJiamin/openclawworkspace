# Refly API 调用失败原因分析

**调试时间**: 2026-03-03 10:33 UTC

---

## ✅ 真正的失败原因

### 问题1: URL 编码（中文参数）❌

**错误的调用**:
```bash
curl "https://refly.kmos.ai/api/v1/openapi/workflows?keyword=图片"
# 返回: 400 Bad Request
```

**原因**: 
- ❌ **中文参数"图片"没有进行 URL 编码**
- API 服务器拒绝包含未编码中文的请求

**正确的调用**:
```bash
curl "https://refly.kmos.ai/api/v1/openapi/workflows?keyword=%E5%9B%BE%E7%89%87"
# 或者使用 curl --data-urlencode
```

---

### 问题2: 缺少图片生成 Canvas

**API 返回的 Canvas 列表**:
```json
{
  "success": true,
  "data": [
    {
      "canvasId": "c-m0pvd4un4sckc49s70udb3kl",
      "title": "抖音视频生成工作流"
    },
    {
      "canvasId": "c-njxmh6yp8quedcwrb9iubuiz",
      "title": "邮件发送工作流"
    }
  ]
}
```

**关键发现**:
- ✅ API 连接正常
- ✅ API Key 有效
- ✅ 认证成功
- ❌ **没有"图片生成" Canvas**
- ✅ 有"抖音视频生成" Canvas

---

## 🔧 解决方案

### 方案1: 使用 URL 编码

```bash
# 错误
curl "?keyword=图片"

# 正确
curl "?keyword=%E5%9B%BE%E7%89%87"
# 或
curl -G \
  --data-urlencode "keyword=图片" \
  "https://refly.kmos.ai/api/v1/openapi/workflows"
```

### 方案2: 使用现有的"抖音视频生成" Canvas

**Canvas ID**: `c-m0pvd4un4sckc49s70udb3kl`

可以用于视频生成，但需要：
1. 获取 Canvas 详情
2. 查看需要的变量
3. 提供正确的参数

### 方案3: 使用 Copilot 生成新的 Canvas

```bash
curl -X POST \
  "https://refly.kmos.ai/api/v1/openapi/copilot/workflow/generate" \
  -H "Authorization: Bearer rf_1hRqAmBjfEl1PQKA2BKfASwtSEkGKgUKs" \
  -H "Content-Type: application/json" \
  -k \
  -d '{
    "query": "生成一张图片：AI工具推荐",
    "locale": "zh-CN"
  }'
```

---

## 📊 API 测试结果

| 测试 | 结果 | 说明 |
|------|------|------|
| API 连接 | ✅ 成功 | 192.168.31.10:443 |
| TLS 握手 | ✅ 成功 | TLSv1.3 |
| 证书验证 | ⚠️ 警告 | 内部 CA，使用 -k 绕过 |
| API 认证 | ✅ 成功 | Bearer token 有效 |
| 中文参数（未编码） | ❌ 400 | Bad Request |
| 中文参数（编码） | ✅ 200 | 成功 |
| 获取 Canvas 列表 | ✅ 成功 | 返回 2 个 Canvas |

---

## 🎯 总结

**真正的失败原因**:
1. ❌ **中文参数没有 URL 编码**
2. ❌ **缺少图片生成 Canvas**

**API 状态**:
- ✅ API 连接正常
- ✅ API Key 有效
- ✅ 可以调用成功

**下一步**:
1. 使用 URL 编码修复中文参数
2. 使用 Copilot 生成图片生成 Canvas
3. 或使用现有的"抖音视频生成" Canvas

---

**维护者**: Main Agent  
**调试状态**: ✅ 找到根本原因
