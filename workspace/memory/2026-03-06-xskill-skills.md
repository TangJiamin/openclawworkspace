# 2026-03-06 学习记录 - Xskill 技能库

## 学习来源
https://www.xskill.ai/#/v2/skills

## 发现的技能（57个模型）

### 🎨 图像生成（Image Gen）

#### Flux 系列（高质量）
- `fal-ai/flux/schnell` - 快速生成
- `fal-ai/flux/dev` - 开发版
- `fal-ai/flux-lora` - LoRA 训练
- `fal-ai/flux-realism` - 写实风格
- `fal-ai/flux-2/flash` - Flux 2 快速版
- `fal-ai/flux-2/flash/edit` - Flux 2 编辑

#### 即梦系列（主力）
- `jimeng-5.0` ✅ - 最新旗舰（已集成）
- `jimeng-4.6` - 上一代旗舰
- `jimeng-4.5` - 稳定版本
- `jimeng-4.1` - 早期版本
- `jimeng-4.0` - 基础版本
- `jimeng-agent` - Agent 专用

#### Seedream 系列
- `fal-ai/bytedance/seedream/v4.5/text-to-image`
- `fal-ai/bytedance/seedream/v4.5/edit`
- `fal-ai/bytedance/seedream/v5/lite/text-to-image`
- `fal-ai/bytedance/seedream/v5/lite/edit`

#### 其他
- `fal-ai/nano-banana-pro` - 轻量级
- `fal-ai/nano-banana-2` - 轻量级 v2
- `kapon/gemini-3-pro-image-preview` - Gemini 3 Pro
- `fal-ai/qwen-image-edit-2511-multiple-angles` - Qwen 编辑

---

### 🎬 视频生成（Video Gen）

#### Seedance 系列（主力）
- `fal-ai/bytedance/seedance/v1.5/pro/image-to-video` - 专业版图生视频
- `fal-ai/bytedance/seedance/v1.5/pro/text-to-video` - 专业版文生视频
- `fal-ai/bytedance/seedance/v1/lite/image-to-video` - 轻量版图生视频
- `fal-ai/bytedance/seedance/v1/lite/text-to-video` - 轻量版文生视频
- `fal-ai/bytedance/seedance/v1/lite/reference-to-video` - 参考视频
- `fal-ai/bytedance/seedance/v1/pro/fast/image-to-video` - 快速版
- `fal-ai/bytedance/seedance/v1/pro/fast/text-to-video` - 快速版

#### 即梦视频
- `jimeng-video-3.5-pro` - 专业版
- `jimeng-video-3.5-pro-10s` - 10秒版
- `jimeng-video-3.5-pro-12s` - 12秒版

#### Wan 系列
- `wan/v2.6/text-to-video` - 文生视频
- `wan/v2.6/image-to-video` - 图生视频
- `wan/v2.6/image-to-video/flash` - 快速版
- `wan/v2.6/reference-to-video` - 参考视频

#### 海螺（Hailuo）
- `fal-ai/minimax/hailuo-2.3/pro/image-to-video` - 专业版
- `fal-ai/minimax/hailuo-2.3/pro/text-to-video` - 文生视频
- `fal-ai/minimax/hailuo-2.3/standard/image-to-video` - 标准版
- `fal-ai/minimax/hailuo-2.3/standard/text-to-video` - 文生视频
- `fal-ai/minimax/hailuo-2.3-fast/pro/image-to-video` - 快速专业版
- `fal-ai/minimax/hailuo-2.3-fast/standard/image-to-video` - 快速标准版

#### Vidu
- `fal-ai/vidu/q3/text-to-video` - 文生视频
- `fal-ai/vidu/q3/image-to-video` - 图生视频

#### 其他
- `fal-ai/veo3.1` - Veo 3.1
- `sprcra/sora-2-character` - Sora 2 角色
- `fal-ai/bytedance/dreamactor/v2` - DreamActor v2
- `fal-ai/bytedance/omnihuman/v1.5` - OmniHuman

---

### 🔊 音频生成（Audio）

#### Minimax 系列
- `minimax/t2a` - 文本转音频
- `minimax/voice-design` - 声音设计
- `minimax/voice-clone` - 声音克隆
- `minimax/music-gen` - 音乐生成

#### ElevenLabs
- `fal-ai/elevenlabs/speech-to-text/scribe-v2` - 语音转文字

---

### 👁️ 视觉理解（Vision）

- `openrouter/router/vision` - 视觉理解
- `openrouter/router/video` - 视频理解

---

## 🎯 核心洞察

### 1. 即梦 5.0 是旗舰
- ✅ 已集成 jimeng-5.0-api
- 💰 2 积分/张，性价比高
- 🎨 支持 2K/4K 高分辨率

### 2. Seedance 是视频主力
- ✅ 已有 seedance-storyboard Skill
- 📊 多版本：lite/pro/fast
- 🎬 支持图生视频、文生视频、参考视频

### 3. Flux 是高质量备选
- 🎨 flux-realism - 写实风格
- ⚡ flux/schnell - 快速生成
- 🔧 flux-lora - LoRA 训练

### 4. Wan 2.6 是新晋强手
- 📈 最新模型
- 🎬 支持图生视频、文生视频
- ⚡ flash 版本快速

---

## 📋 集成优先级

### 第一优先级（立即集成）
1. ✅ jimeng-5.0 - 已完成
2. ✅ seedance-storyboard - 已完成

### 第二优先级（按需集成）
3. flux-realism - 高质量写实风格
4. jimeng-video-3.5-pro - 视频生成
5. wan/v2.6/text-to-video - 最新视频模型

### 第三优先级（观察中）
6. hailuo-2.3 - 海螺视频
7. veo3.1 - Google Veo
8. minimax 音频系列

---

## 🔄 与现有系统的关系

### 当前系统
- `visual-generator` - 参数推荐 + 提示词生成
- `jimeng-5.0-api` - 即梦 5.0 图像生成
- `seedance-storyboard` - Seedance 分镜生成

### 可扩展方向
1. **Flux 集成** - 创建 `flux-realism-api` Skill
2. **视频生成** - 创建 `jimeng-video-api` Skill
3. **音频生成** - 创建 `minimax-audio-api` Skill

---

## 💡 关键发现

### API 端点
- **模型列表**: `https://api.xskill.ai/api/v3/models`
- **任务创建**: `https://api.xskill.ai/api/v3/tasks/create`
- **任务查询**: `https://api.xskill.ai/api/v3/tasks/query`

### 统一调用模式
所有模型使用相同的 API 格式：
```json
{
  "model": "模型名称",
  "params": {
    "prompt": "提示词",
    "其他参数": "值"
  }
}
```

### 认证方式
```bash
Authorization: Bearer $XSKILL_API_KEY
```

---

**重要性**: ⭐⭐⭐⭐⭐
**状态**: ✅ 学习完成
**日期**: 2026-03-06
**下一步**: 按需集成 Flux、视频生成模型
