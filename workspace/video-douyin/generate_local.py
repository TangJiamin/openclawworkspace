#!/usr/bin/env python3
"""
抖音视频生成器 - OpenAI vs Anthropic 专题
生成 9:16 竖版视频（1080×1920），50秒
"""

import os
import json
import time
import subprocess
from pathlib import Path

# ============ 配置 ============
OUTPUT_DIR = Path("output_douyin_video")
OUTPUT_DIR.mkdir(exist_ok=True)

# 视频参数
WIDTH = 1080
HEIGHT = 1920
FPS = 30
DURATION = 50  # 秒

# 音频（BGM）- 使用说明
# 请下载 Hip-hop 音乐并放置在当前目录，命名为 bgm.mp3
# 推荐搜索: "free hip hop beat 80-90 bpm"

# ============ 分镜脚本 ============
STORYBOARD = {
    "scene1": {
        "time": "0-3秒",
        "content": "开头：快剪 - 美元符号 + 五角大楼 + 震撼标题",
        "text": "AI圈出大事了！\nOpenAI刚拿到美军14亿美元大单\nAnthropic被五角大楼'拉黑'！",
        "visuals": ["美元符号", "五角大楼", "震撼标题"]
    },
    "scene2": {
        "time": "3-16秒",
        "content": "商业角度：主播 + 数据图表 + 军备竞赛视觉",
        "text": "14亿美元 = 100亿人民币！\n这是AI军备竞赛的开始！",
        "visuals": ["数据图表", "军备竞赛", "地球地图"]
    },
    "scene3": {
        "time": "16-30秒",
        "content": "伦理角度：锁链 + 天平 + 思考画面",
        "text": "AI能不能用于战争？\nAnthropic说'NO'：我要保护人类\n五角大楼说'不行也得行'",
        "visuals": ["锁链", "天平", "思考的人"]
    },
    "scene4": {
        "time": "30-43秒",
        "content": "个人角度：上班族 + AI + 监控摄像头",
        "text": "跟你有啥关系？\n1. 工作可能被AI替代\n2. 军事AI失控谁来兜底？",
        "visuals": ["上班族", "AI机器人", "监控摄像头"]
    },
    "scene5": {
        "time": "43-50秒",
        "content": "结尾：主播微笑 + 引导评论",
        "text": "AI军事化是趋势还是灾难？\n评论区聊聊，记得点个关注！",
        "visuals": ["主播", "关注按钮", "评论图标"]
    }
}

# ============ 口播文案 ============
VOICE_OVER = """
AI圈出大事了！OpenAI刚拿到美军14亿美元大单，而它的竞争对手Anthropic，直接被五角大楼'拉黑'了！

你们知道14亿美元意味着什么吗？相当于100亿人民币！这不是普通合作，这是AI军备竞赛的开始！

但我更想聊聊另一个问题：AI到底能不能用于战争？Anthropic说'NO'，我要保护人类安全。五角大楼说'不行也得行'。

有人问了：这跟月薪3000的我有啥关系？兄弟，关系大了！第一，以后你的工作可能分分钟被AI替代；第二，军事AI一旦失控，谁来兜底？

所以你怎么看？AI军事化是趋势还是灾难？评论区聊聊，记得点个关注！
"""

# ============ 视频生成主脚本 ============
def generate_video_local():
    """生成本地视频的完整脚本（需要安装 moviepy）"""
    
    script = '''#!/usr/bin/env python3
"""
抖音视频自动生成脚本
需要安装: pip install moviepy pillow openai
"""

import os
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
from moviepy.editor import *

# 配置
WIDTH, HEIGHT = 1080, 1920
FPS = 30

OUTPUT_DIR = Path("output")
OUTPUT_DIR.mkdir(exist_ok=True)

# 颜色方案
COLORS = {
    "bg": "#0D0D0D",           # 深黑背景
    "primary": "#FFD700",      # 金色
    "accent": "#FF4500",       # 橙红
    "text": "#FFFFFF",         # 白色文字
    "subtext": "#AAAAAA",     # 灰色文字
}

def create_text_layer(text, fontsize=80, color="#FFFFFF", y_position=1600):
    """创建文字图层"""
    img = Image.new("RGB", (WIDTH, HEIGHT), COLORS["bg"])
    draw = ImageDraw.Draw(img)
    
    # 尝试加载字体
    try:
        font = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", fontsize)
    except:
        font = ImageFont.load_default()
    
    # 文字换行处理
    lines = text.split("\\n")
    y = y_position
    for line in lines:
        draw.text((WIDTH//2 - 400, y), line, font=font, fill=color)
        y += fontsize + 20
    
    return img

def create_scene(title, content, duration=3):
    """创建单个场景"""
    frames = []
    
    # 背景
    bg = Image.new("RGB", (WIDTH, HEIGHT), COLORS["bg"])
    
    # 标题
    draw = ImageDraw.Draw(bg)
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 60)
        content_font = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 40)
    except:
        title_font = ImageFont.load_default()
        content_font = ImageFont.load_default()
    
    # 绘制标题（居中）
    draw.text((WIDTH//2 - 300, HEIGHT//2 - 100), title, font=title_font, fill=COLORS["primary"])
    draw.text((WIDTH//2 - 300, HEIGHT//2), content, font=content_font, fill=COLORS["text"])
    
    # 保存帧
    frame_path = OUTPUT_DIR / f"scene_{title[:10]}.png"
    bg.save(frame_path)
    
    # 创建视频片段
    clip = ImageClip(str(frame_path)).set_duration(duration)
    
    # 添加字幕动画
    clip = clip.set_position(("center", "bottom"))
    
    return clip

def main():
    print("🎬 开始生成抖音视频...")
    
    # 场景列表
    scenes = []
    
    # Scene 1: 开头 (0-3秒)
    scenes.append(create_scene(
        "AI圈出大事了！",
        "OpenAI获美军14亿美元\\nAnthropic被封杀",
        duration=3
    ))
    
    # Scene 2: 商业角度 (3-16秒，13秒)
    scenes.append(create_scene(
        "14亿美元 = 100亿人民币",
        "AI军备竞赛开始！",
        duration=13
    ))
    
    # Scene 3: 伦理角度 (16-30秒，14秒)
    scenes.append(create_scene(
        "AI能不能用于战争？",
        "Anthropic: NO\\n五角大楼: 不行也得行",
        duration=14
    ))
    
    # Scene 4: 个人角度 (30-43秒，13秒)
    scenes.append(create_scene(
        "跟你有啥关系？",
        "1. 工作被AI替代\\n2. 军事AI失控",
        duration=13
    ))
    
    # Scene 5: 结尾 (43-50秒，7秒)
    scenes.append(create_scene(
        "评论区聊聊",
        "记得点个关注！",
        duration=7
    ))
    
    # 合并所有场景
    final_clip = concatenate_videoclips(scenes, method="compose")
    
    # 添加背景音乐
    if Path("bgm.mp3").exists():
        bgm = AudioFileClip("bgm.mp3")
        bgm = bgm.subclip(0, DURATION)
        final_clip = final_clip.set_audio(bgm)
    
    # 导出视频
    output_path = OUTPUT_DIR / "douyin_video.mp4"
    final_clip.write_videofile(str(output_path), fps=FPS, codec="libx264")
    
    print(f"✅ 视频生成完成: {output_path}")

if __name__ == "__main__":
    main()
'''
    
    with open("generate_video.py", "w", encoding="utf-8") as f:
        f.write(script)
    
    print("✅ 视频生成脚本已创建: generate_video.py")

def create_prompt_file():
    """创建分镜提示词文件，供 AI 视频生成使用"""
    
    content = """# OpenAI vs Anthropic 抖音视频分镜

## 视频信息
- 标题: OpenAI获美军14亿美元合同，Anthropic被封杀
- 时长: 50秒
- 比例: 9:16 (1080×1920)
- 风格: 新闻快剪、Hip-hop节奏

## 完整口播文案
```
AI圈出大事了！OpenAI刚拿到美军14亿美元大单，而它的竞争对手Anthropic，直接被五角大楼'拉黑'了！

你们知道14亿美元意味着什么吗？相当于100亿人民币！这不是普通合作，这是AI军备竞赛的开始！

但我更想聊聊另一个问题：AI到底能不能用于战争？Anthropic说'NO'，我要保护人类安全。五角大楼说'不行也得行'。

有人问了：这跟月薪3000的我有啥关系？兄弟，关系大了！第一，以后你的工作可能分分钟被AI替代；第二，军事AI一旦失控，谁来兜底？

所以你怎么看？AI军事化是趋势还是灾难？评论区聊聊，记得点个关注！
```

## 分镜详情

### Scene 1: 开头 (0-3秒)
- 画面: 快剪 - 美元符号 + 五角大楼 + 震撼标题
- 文字: "AI圈出大事了！"
- 风格: 快速切换，电子音效

### Scene 2: 商业角度 (3-16秒，13秒)
- 画面: 主播 + 数据图表 + 军备竞赛视觉
- 文字: "14亿美元 = 100亿人民币！这是AI军备竞赛的开始！"
- 风格: 数据可视化，地球地图，武器图标

### Scene 3: 伦理角度 (16-30秒，14秒)
- 画面: 锁链 + 天平 + 思考画面
- 文字: "AI能不能用于战争？Anthropic说'NO'，五角大楼说'不行也得行'"
- 风格: 哲学感，天平摇摆，锁链束缚

### Scene 4: 个人角度 (30-43秒，13秒)
- 画面: 上班族 + AI机器人 + 监控摄像头
- 文字: "1.工作被AI替代 2.军事AI失控谁来兜底？"
- 风格: 监控视角，AI眼睛发光

### Scene 5: 结尾 (43-50秒，7秒)
- 画面: 主播微笑 + 引导评论
- 文字: "评论区聊聊，记得点个关注！"
- 风格: 温暖结尾，关注按钮闪烁

## 技术要求
- 比例: 9:16 竖版 (1080×1920)
- 字幕: 大字清晰，同步显示
- BGM: Hip-hop 80-90 BPM
- 转场: 快速切换，电子音效
"""
    
    with open("video_storyboard.md", "w", encoding="utf-8") as f:
        f.write(content)
    
    print("✅ 分镜文档已创建: video_storyboard.md")

def main():
    print("=" * 50)
    print("🎬 抖音视频素材生成器")
    print("=" * 50)
    print()
    
    # 1. 创建分镜文档
    create_prompt_file()
    
    # 2. 创建本地生成脚本
    generate_video_local()
    
    print()
    print("=" * 50)
    print("📋 下一步操作:")
    print("=" * 50)
    print("""
方案1: 使用在线AI视频生成服务
- 访问 https://www.minimax.io 或 https:// Kling.ai
- 使用 video_storyboard.md 中的提示词
- 生成 9:16 竖版视频

方案2: 本地运行脚本
1. 安装依赖: pip install moviepy pillow
2. 下载 Hip-hop 音乐命名为 bgm.mp3
3. 运行: python3 generate_video.py

方案3: 使用剪映App
- 导入本目录下的小说图片素材
- 添加 Hip-hop 背景音乐
- 添加文字字幕
- 导出 1080×1920 视频
""")

if __name__ == "__main__":
    main()
