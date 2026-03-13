# xskill.ai 技能学习决策

**学习时间**: 2026-03-10 13:47
**技能总数**: 31 个
**目标**: 筛选出真正需要学习的技能

---

## 🎯 第一性原理分析

### 问题本质

**用户**: "你可以学习https://www.xskill.ai/#/v2/skills中的技能吗"

**第一性原理**:
```
问题: 我需要学习这 31 个技能吗？
  ↓
拆解: 用户真正需要什么？
  ↓
构建: 分析 Agent 矩阵需要什么能力
  ↓
验证: 哪些技能真正有用？
  ↓
行动: 只学习真正需要的技能
```

---

## 📊 已有技能清单（31 个）

### 🎨 图片生成（4 个）

1. **seedream-image** - Seedream 4.5
2. **flux2-flash** - Flux 2 Flash
3. **gemini-image** - Gemini 3 Pro Image
4. **upload-image** - 图片上传

---

### 🎬 视频生成（9 个）

1. **seedance-video** - 即梦视频（已在用）⭐⭐⭐⭐⭐
2. **sora-2** - Sora 2 视频
3. **vidu-video** - Vidu Q3 Pro
4. **hailuo-video** - MiniMax Hailuo 2.3
5. **dreamactor-video** - Dreamactor V2
6. **grok-video** - xAI Grok
7. **omnihuman-video** - OmniHuman v1.5
8. **parse-video** - 视频解析
9. **wan-video** - Wan 2.6

---

### 🎙️ 音频生成（3 个）

1. **elevenlabs-stt** - ElevenLabs STT
2. **minimax-audio** - MiniMax Audio
3. **minimax-tts** - MiniMax TTS

---

### 📝 内容创作（4 个）

1. **novel-to-script** - 小说转剧本
2. **storyboard-generator** - 分镜生成器
3. **fashion-studio** - 时尚工作室
4. **character-creator** - 角色创建器

---

### 🔧 工具类（4 个）

1. **image-model-evaluation** - 图像模型评估
2. **points-recharge** - 积分充值
3. **coze-upload** - Coze 上传
4. **upload-image** - 图片上传

---

### 🎯 角色和场景提取（5 个）

1. **character-extractor** - 角色提取器
2. **prop-extractor** - 道具提取器
3. **scene-extractor** - 场景提取器
4. **style-extractor** - 风格提取器
5. **nano-hub** - Nano Hub

---

### 📚 小说相关（2 个）

1. **nano-banana-pro** - Nano Banana Pro
2. **nano-pro-shuihu** - Nano Pro 水浒

---

## 🎯 学习优先级评估

### ⭐⭐⭐⭐⭐ 最高优先级（立即学习）

#### 1. **storyboard-generator** - 分镜生成器 ⭐⭐⭐⭐⭐

**为什么需要**:
- ✅ content-agent 需要分镜脚本
- ✅ video-agent 需要分镜规划
- ✅ 用户经常需要生成分镜

**应用目标**:
- content-agent → 添加分镜生成能力
- video-agent → 添加分镜规划能力

---

#### 2. **novel-to-script** - 小说转剧本 ⭐⭐⭐⭐⭐

**为什么需要**:
- ✅ 小说改编成视频的热门需求
- ✅ 内容创作流程需要

**应用目标**:
- content-agent → 添加小说改编能力
- video-agent → 添加剧本生成能力

---

### ⭐⭐⭐⭐ 高优先级（近期学习）

#### 3. **parse-video** - 视频解析 ⭐⭐⭐⭐

**为什么需要**:
- ✅ 下载无水印视频
- ✅ 支持多平台（抖音、快手、小红书、B站）

**应用目标**:
- content-agent → 视频素材获取
- video-agent → 参考视频下载

---

### ⭐⭐⭐ 中优先级（按需学习）

#### 4. **upload-image** - 图片上传

**为什么需要**:
- ✅ 本地图片上传到云存储
- ✅ 获取公开 URL

**应用目标**:
- visual-agent → 图片云存储

---

## 🎯 最终学习清单

### 第 1 批（今天）⭐⭐⭐⭐⭐

1. **storyboard-generator** - 分镜生成器
2. **novel-to-script** - 小说转剧本

---

### 第 2 批（本周）⭐⭐⭐⭐

3. **parse-video** - 视频解析

---

### 第 3 批（按需）⭐⭐⭐

4. **upload-image** - 图片上传

---

## 📊 学习方式

### 学习步骤

1. ✅ 读取 SKILL.md 文档
2. ✅ 理解技能功能
3. ✅ 识别应用场景
4. ✅ 集成到相关 Agents
5. ✅ 测试验证
6. ✅ 记录学习

---

## ⚠️ 不需要学习的技能

### ❌ 已有替代方案的技能

- ❌ **seedream-image** - 已有 Seedream 5.0
- ❌ **flux2-flash** - Seedream 5.0 已够用
- ❌ **gemini-image** - Seedream 5.0 已够用

### ❌ 国外模型（网络限制）

- ❌ **sora-2** - 无法访问 OpenAI
- ❌ **grok-video** - 无法访问 xAI
- ❌ **hailuo-video** - MiniMax 备用即可

### ❌ 专用工具（暂不需要）

- ❌ **character-extractor** - 特定场景
- ❌ **prop-extractor** - 特定场景
- ❌ **scene-extractor** - 特定场景
- ❌ **style-extractor** - 特定场景
- ❌ **nano-hub** - 特定内容

### ❌ 小说相关（暂不需要）

- ❌ **nano-banana-pro** - 特定内容
- ❌ **nano-pro-shuihu** - 特定内容

### ❌ 其他工具类

- ❌ **image-model-evaluation** - 非核心需求
- ❌ **points-recharge** - 非核心需求
- ❌ **coze-upload** - 非核心需求
- ❌ **elevenlabs-stt** - 国外服务
- ❌ **minimax-audio** - 已有音频生成
- ❌ **minimax-tts** - 已有音频生成

---

## 🎯 最终结论

**只需要学习**: **2 个核心技能**（第 1 批）

1. **storyboard-generator** - 分镜生成器
2. **novel-to-script** - 小说转剧本

**减少幅度**: 从 31 个 → 2 个（93.5%）

**原则**: 只学习真正需要的，不学习所有技能

---

**第一性原理分析完成！准备学习 2 个核心技能！** ✅
