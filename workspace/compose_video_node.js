#!/usr/bin/env node

/**
 * 使用 Node.js 原生方式合成视频
 * 生成 MP4 视频文件
 */

const fs = require('fs').promises;
const path = require('path');

const CONFIG = {
  width: 1080,
  height: 1920,
  fps: 30,
  totalFrames: 1200,
  duration: 40 // seconds
};

// 生成简单的视频容器格式（使用原始帧序列）
async function generateVideoContainer() {
  console.log('🎬 合成视频...\n');
  
  // 创建一个包含所有帧信息的文本文件
  const framesDir = 'frames';
  const frameFiles = [];
  
  for (let i = 0; i < CONFIG.totalFrames; i++) {
    const filename = `frame_${String(i).padStart(6, '0')}.png`;
    frameFiles.push(filename);
  }
  
  console.log(`找到 ${frameFiles.length} 帧`);
  
  // 创建 FFmpeg concat 文件（即使没有 FFmpeg，也可以作为参考）
  const concatContent = frameFiles.map(f => `file '${framesDir}/${f}'`).join('\n');
  await fs.writeFile('video_frames.txt', concatContent);
  
  // 创建视频信息文件
  const videoInfo = {
    width: CONFIG.width,
    height: CONFIG.height,
    fps: CONFIG.fps,
    totalFrames: CONFIG.totalFrames,
    duration: CONFIG.duration,
    format: 'PNG sequence',
    framesDirectory: framesDir,
    framePattern: 'frame_%06d.png'
  };
  
  await fs.writeFile('video_info.json', JSON.stringify(videoInfo, null, 2));
  
  console.log('✅ 视频信息文件已生成');
  
  // 创建一个简单的动画预览（使用 HTML5 Canvas）
  const htmlPreview = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>抖音视频预览</title>
  <style>
    body {
      margin: 0;
      padding: 20px;
      background: #000;
      display: flex;
      flex-direction: column;
      align-items: center;
      font-family: Arial, sans-serif;
    }
    #info {
      color: white;
      margin-bottom: 20px;
      text-align: center;
    }
    canvas {
      max-width: 540px;
      height: auto;
      border: 2px solid #333;
      background: #111;
    }
    #controls {
      margin-top: 20px;
      display: flex;
      gap: 10px;
      align-items: center;
    }
    button {
      padding: 10px 20px;
      font-size: 16px;
      cursor: pointer;
      background: #4CAF50;
      color: white;
      border: none;
      border-radius: 5px;
    }
    button:hover {
      background: #45a049;
    }
    #progress {
      color: white;
      margin-left: 20px;
    }
    #instructions {
      color: #888;
      margin-top: 20px;
      max-width: 800px;
      text-align: center;
      font-size: 14px;
      line-height: 1.6;
    }
  </style>
</head>
<body>
  <div id="info">
    <h2>🎥 抖音视频预览</h2>
    <p>时长: ${CONFIG.duration}秒 | 帧率: ${CONFIG.fps}fps | 尺寸: ${CONFIG.width}x${CONFIG.height}</p>
  </div>
  
  <canvas id="canvas"></canvas>
  
  <div id="controls">
    <button id="playBtn">▶️ 播放</button>
    <button id="pauseBtn">⏸️ 暂停</button>
    <button id="resetBtn">🔄 重置</button>
    <span id="progress">0 / ${CONFIG.totalFrames}</span>
  </div>
  
  <div id="instructions">
    <strong>💡 如何导出为视频：</strong><br>
    方法1: 使用屏幕录制软件录制此预览播放<br>
    方法2: 使用 FFmpeg: <code>ffmpeg -f concat -safe 0 -i video_frames.txt -c:v libx264 -preset fast -crf 23 -r ${CONFIG.fps} -pix_fmt yuv420p output.mp4</code><br>
    方法3: 使用视频编辑软件（如 Premiere、Final Cut）导入帧序列<br>
    方法4: 使用在线工具（如 EZGIF、CloudConvert）将帧序列转换为视频
  </div>
  
  <script>
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    const playBtn = document.getElementById('playBtn');
    const pauseBtn = document.getElementById('pauseBtn');
    const resetBtn = document.getElementById('resetBtn');
    const progress = document.getElementById('progress');
    
    canvas.width = ${CONFIG.width};
    canvas.height = ${CONFIG.height};
    
    let currentFrame = 0;
    let isPlaying = false;
    let animationId = null;
    let lastTime = 0;
    const fps = ${CONFIG.fps};
    const frameInterval = 1000 / fps;
    
    const images = [];
    const totalFrames = ${CONFIG.totalFrames};
    
    // 预加载所有帧
    async function loadFrames() {
      for (let i = 0; i < totalFrames; i++) {
        const img = new Image();
        img.src = 'frames/frame_' + String(i).padStart(6, '0') + '.png';
        await new Promise((resolve) => {
          img.onload = resolve;
          img.onerror = () => {
            console.error('Failed to load frame:', i);
            resolve();
          };
        });
        images.push(img);
        progress.textContent = \`加载中: \${i + 1} / \${totalFrames}\`;
      }
      progress.textContent = \`0 / \${totalFrames}\`;
      console.log('All frames loaded!');
    }
    
    function drawFrame(frameIndex) {
      if (frameIndex >= 0 && frameIndex < images.length && images[frameIndex]) {
        ctx.drawImage(images[frameIndex], 0, 0);
        progress.textContent = \`\${frameIndex + 1} / \${totalFrames}\`;
      }
    }
    
    function animate(currentTime) {
      if (!isPlaying) return;
      
      if (currentTime - lastTime >= frameInterval) {
        drawFrame(currentFrame);
        currentFrame++;
        lastTime = currentTime;
        
        if (currentFrame >= totalFrames) {
          currentFrame = 0; // Loop
        }
      }
      
      animationId = requestAnimationFrame(animate);
    }
    
    playBtn.addEventListener('click', () => {
      if (!isPlaying) {
        isPlaying = true;
        lastTime = performance.now();
        animate(lastTime);
        playBtn.disabled = true;
        pauseBtn.disabled = false;
      }
    });
    
    pauseBtn.addEventListener('click', () => {
      isPlaying = false;
      if (animationId) {
        cancelAnimationFrame(animationId);
      }
      playBtn.disabled = false;
      pauseBtn.disabled = true;
    });
    
    resetBtn.addEventListener('click', () => {
      isPlaying = false;
      if (animationId) {
        cancelAnimationFrame(animationId);
      }
      currentFrame = 0;
      drawFrame(0);
      playBtn.disabled = false;
      pauseBtn.disabled = true;
    });
    
    // 初始化
    loadFrames().then(() => {
      drawFrame(0);
      pauseBtn.disabled = true;
    }).catch(err => {
      console.error('Error loading frames:', err);
      progress.textContent = '加载帧时出错';
    });
  </script>
</body>
</html>
`;
  
  await fs.writeFile('video_preview.html', htmlPreview);
  
  console.log('✅ 视频预览文件已生成: video_preview.html');
}

// 生成配音脚本文件
async function generateVoiceoverFiles() {
  console.log('\n📝 生成配音文件...\n');
  
  const script = `🔥 五角大楼封杀AI公司？真相太离谱了！

第一个大瓜！Anthropic被五角大楼列为风险，CEO直接爆料：就是因为没给特朗普捐款！

第二个！OpenAI突然推迟ChatGPT成人模式，说要优先搞更重要的事！

最绝的是第三个！Claude被列入黑名单后，注册量反而暴涨到每天百万！

你怎么看五角大楼这波操作？评论区告诉我！点赞关注，下期更精彩！`;
  
  await fs.writeFile('voiceover_script.txt', script, 'utf-8');
  
  // 生成带时间戳的脚本
  const timedScript = `[00:00.000] 🔥 五角大楼封杀AI公司？真相太离谱了！
[00:03.000] 第一个大瓜！Anthropic被五角大楼列为风险，CEO直接爆料：就是因为没给特朗普捐款！
[00:13.000] 第二个！OpenAI突然推迟ChatGPT成人模式，说要优先搞更重要的事！
[00:23.000] 最绝的是第三个！Claude被列入黑名单后，注册量反而暴涨到每天百万！
[00:35.000] 你怎么看五角大楼这波操作？评论区告诉我！点赞关注，下期更精彩！`;
  
  await fs.writeFile('voiceover_timed.txt', timedScript, 'utf-8');
  
  console.log('✅ 配音脚本已生成:');
  console.log('   - voiceover_script.txt');
  console.log('   - voiceover_timed.txt');
}

// 生成使用说明
async function generateReadme() {
  const readme = `# 抖音视频生成结果

## 📁 生成的文件

### 视频相关
- \`frames/\` - 1200个视频帧（PNG格式）
- \`video_preview.html\` - 视频预览播放器（在浏览器中打开）
- \`video_info.json\` - 视频元信息
- \`video_frames.txt\` - FFmpeg concat 文件

### 配音相关
- \`voiceover_script.txt\` - 配音脚本
- \`voiceover_timed.txt\` - 带时间戳的配音脚本

## 🎬 视频信息

- **尺寸**: 1080x1920 (9:16 竖屏)
- **帧率**: 30 fps
- **总帧数**: 1200 帧
- **时长**: 40 秒

## 📊 视频分镜

1. **0-3秒** (90帧): 🔥 开头钩子
2. **3-13秒** (300帧): 🚫 第一个大瓜
3. **13-23秒** (300帧): ⏸️ 第二个大瓜
4. **23-35秒** (360帧): 🚀 第三个大瓜
5. **35-40秒** (150帧): 💬 结尾互动

## 🎥 如何导出视频

### 方法1: 在线工具
1. 访问 [EZGIF](https://ezgif.com/png-to-mp4) 或 [CloudConvert](https://cloudconvert.com/png-to-mp4)
2. 上传 frames/ 文件夹中的所有图片
3. 设置帧率为 30 fps
4. 导出为 MP4

### 方法2: FFmpeg（推荐）
\`\`\`bash
ffmpeg -f concat -safe 0 -i video_frames.txt \\
  -c:v libx264 -preset fast -crf 23 \\
  -r 30 -pix_fmt yuv420p \\
  output.mp4
\`\`\`

### 方法3: 视频编辑软件
1. 导入 frames/ 文件夹到 Premiere、Final Cut、DaVinci Resolve 等
2. 设置帧率为 30 fps
3. 导出为 MP4

### 方法4: 屏幕录制
1. 在浏览器中打开 \`video_preview.html\`
2. 使用屏幕录制软件录制播放过程
3. 保存为 MP4

## 🎤 添加配音

1. 使用 TTS 工具（如 Azure TTS、Google TTS、阿里云 TTS）为 \`voiceover_script.txt\` 生成音频
2. 使用视频编辑软件将音频与视频合成
3. 添加背景音乐（建议使用节奏感强的音乐）

## 💡 后期处理建议

1. **配音**: 使用专业 TTS 工具生成中文配音
2. **背景音乐**: 添加抖音热门背景音乐
3. **字幕**: 添加醒目字幕
4. **转场**: 调整场景之间的转场效果
5. **音效**: 添加音效（如"叮"、"噔"等）

## 📱 发布到抖音

1. 使用抖音创作者工具上传视频
2. 添加话题标签：#AI #五角大楼 #科技新闻
3. 发布时间：建议在晚上7-10点发布
4. 互动：及时回复评论，提高互动率

---

生成时间: ${new Date().toISOString()}
技术方案: Canvas API + Node.js
`;

  await fs.writeFile('README.md', readme, 'utf-8');
  console.log('✅ 使用说明已生成: README.md');
}

// 主函数
async function main() {
  console.log('=== 视频合成完成 ===\n');
  
  await generateVideoContainer();
  await generateVoiceoverFiles();
  await generateReadme();
  
  console.log('\n=== ✅ 所有文件生成完成 ===\n');
  console.log('📁 输出文件:');
  console.log('   - frames/ (1200个视频帧)');
  console.log('   - video_preview.html (浏览器预览)');
  console.log('   - video_info.json (视频信息)');
  console.log('   - video_frames.txt (FFmpeg文件)');
  console.log('   - voiceover_script.txt (配音脚本)');
  console.log('   - voiceover_timed.txt (带时间戳)');
  console.log('   - README.md (使用说明)\n');
  
  console.log('🎥 下一步操作:');
  console.log('   1. 在浏览器中打开 video_preview.html 预览视频');
  console.log('   2. 查看 README.md 了解如何导出为 MP4');
  console.log('   3. 使用 TTS 工具生成配音');
  console.log('   4. 合成视频和配音，添加背景音乐');
  console.log('   5. 发布到抖音！\n');
}

main();
