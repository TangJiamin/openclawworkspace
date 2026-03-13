#!/usr/bin/env node

/**
 * 抖音视频生成器 v2 - 使用免费工具
 * 技术栈：
 * - 图片生成：使用 CSS/Canvas 合成（无需 API）
 * - 配音生成：使用系统 TTS（espeak/festival）
 * - 视频合成：FFmpeg
 */

const fs = require('fs').promises;
const path = require('path');
const { exec } = require('child_process');
const { promisify } = require('util');
const execAsync = promisify(exec);

// 配置
const CONFIG = {
  width: 1080,
  height: 1920,
  fps: 30,
  totalDuration: 40,
  scenes: [
    { start: 0, duration: 3, title: "开头钩子", bg: "#FF0000" },
    { start: 3, duration: 10, title: "第一个大瓜", bg: "#1A1A2E" },
    { start: 13, duration: 10, title: "第二个大瓜", bg: "#16213E" },
    { start: 23, duration: 12, title: "第三个大瓜", bg: "#FFD700" },
    { start: 35, duration: 5, title: "结尾", bg: "#000000" }
  ]
};

// 文案
const SCRIPT = {
  hook: "🔥 五角大楼封杀AI公司？真相太离谱了！",
  part1: "第一个大瓜！Anthropic被五角大楼列为风险，CEO直接爆料：就是因为没给特朗普捐款！",
  part2: "第二个！OpenAI突然推迟ChatGPT成人模式，说要优先搞更重要的事！",
  part3: "最绝的是第三个！Claude被列入黑名单后，注册量反而暴涨到每天百万！",
  ending: "你怎么看五角大楼这波操作？评论区告诉我！点赞关注，下期更精彩！"
};

// HTML模板 - 用于生成图片
const HTML_TEMPLATES = [
  // 场景1: 开头钩子
  `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { 
        width: 1080px; 
        height: 1920px;
        background: linear-gradient(135deg, #FF0000 0%, #FF6B00 50%, #1A1A2E 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Microsoft YaHei', sans-serif;
        overflow: hidden;
      }
      .container {
        position: relative;
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
      }
      .fire-effect {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at 50% 50%, rgba(255,100,0,0.3) 0%, transparent 70%);
        animation: fire 2s infinite;
      }
      @keyframes fire {
        0%, 100% { transform: scale(1); opacity: 0.8; }
        50% { transform: scale(1.1); opacity: 1; }
      }
      .glitch {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: repeating-linear-gradient(
          0deg,
          rgba(0,0,0,0.1) 0px,
          rgba(0,0,0,0.1) 1px,
          transparent 1px,
          transparent 2px
        );
        animation: glitch 0.3s infinite;
      }
      @keyframes glitch {
        0%, 100% { transform: translate(0); }
        20% { transform: translate(-2px, 2px); }
        40% { transform: translate(2px, -2px); }
        60% { transform: translate(-2px, -2px); }
        80% { transform: translate(2px, 2px); }
      }
      .matrix {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"><text x="10" y="20" fill="%2300FF00" font-size="16">1</text><text x="30" y="40" fill="%2300FF00" font-size="16">0</text><text x="50" y="60" fill="%2300FF00" font-size="16">1</text></svg>');
        opacity: 0.1;
      }
      .title {
        position: relative;
        z-index: 10;
        font-size: 120px;
        font-weight: bold;
        color: white;
        text-align: center;
        text-shadow: 
          0 0 20px rgba(255,0,0,0.8),
          0 0 40px rgba(255,100,0,0.6),
          4px 4px 0 rgba(0,0,0,0.5);
        padding: 40px;
        animation: pulse 1s infinite;
      }
      @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.05); }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="fire-effect"></div>
      <div class="glitch"></div>
      <div class="matrix"></div>
      <div class="title">🔥 五角大楼<br/>封杀AI？</div>
    </div>
  </body>
  </html>
  `,
  
  // 场景2: 第一个大瓜
  `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { 
        width: 1080px; 
        height: 1920px;
        background: linear-gradient(135deg, #1A1A2E 0%, #0F0F1E 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Microsoft YaHei', sans-serif;
      }
      .container {
        position: relative;
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
      }
      .ban-sign {
        position: absolute;
        width: 600px;
        height: 600px;
        border: 40px solid #FF0000;
        border-radius: 50%;
        top: 200px;
        left: 50%;
        transform: translateX(-50%);
        animation: shake 0.5s infinite;
      }
      @keyframes shake {
        0%, 100% { transform: translateX(-50%) rotate(-45deg); }
        50% { transform: translateX(-50%) rotate(-45deg) scale(1.1); }
      }
      .ban-sign::after {
        content: '';
        position: absolute;
        width: 680px;
        height: 80px;
        background: #FF0000;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
      }
      .dollar {
        position: absolute;
        font-size: 200px;
        color: #FFD700;
        top: 400px;
        left: 50%;
        transform: translateX(-50%);
        animation: break 1s infinite;
      }
      @keyframes break {
        0%, 100% { 
          transform: translateX(-50%) rotate(0deg); 
          opacity: 1;
        }
        50% { 
          transform: translateX(-50%) rotate(10deg) scale(1.1); 
          opacity: 0.8;
        }
      }
      .text {
        position: absolute;
        bottom: 300px;
        width: 900px;
        text-align: center;
        color: white;
        font-size: 70px;
        font-weight: bold;
        line-height: 1.4;
        text-shadow: 2px 2px 10px rgba(0,0,0,0.8);
      }
      .highlight {
        color: #FF0000;
        font-size: 90px;
      }
      .data-flow {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: repeating-linear-gradient(
          90deg,
          transparent 0px,
          transparent 50px,
          rgba(0,255,255,0.03) 50px,
          rgba(0,255,255,0.03) 52px
        );
        animation: flow 2s linear infinite;
      }
      @keyframes flow {
        0% { background-position: 0 0; }
        100% { background-position: 100px 0; }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="data-flow"></div>
      <div class="ban-sign"></div>
      <div class="dollar">$</div>
      <div class="text">
        <div class="highlight">第一个大瓜！</div>
        <div style="font-size: 50px; margin-top: 20px;">
          Anthropic被列为风险<br/>
          CEO爆料：没给特朗普捐款
        </div>
      </div>
    </div>
  </body>
  </html>
  `,
  
  // 场景3: 第二个大瓜
  `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { 
        width: 1080px; 
        height: 1920px;
        background: linear-gradient(135deg, #16213E 0%, #0F0F1E 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Microsoft YaHei', sans-serif;
      }
      .container {
        position: relative;
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
      }
      .eighteen-plus {
        position: absolute;
        width: 400px;
        height: 400px;
        border: 30px solid #FF0000;
        border-radius: 50%;
        top: 250px;
        left: 50%;
        transform: translateX(-50%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 180px;
        color: white;
        font-weight: bold;
        animation: pulse 1s infinite;
      }
      @keyframes pulse {
        0%, 100% { transform: translateX(-50%) scale(1); }
        50% { transform: translateX(-50%) scale(1.1); }
      }
      .cross-mark {
        position: absolute;
        width: 500px;
        height: 100px;
        background: #FF0000;
        top: 400px;
        left: 50%;
        transform: translateX(-50%) rotate(45deg);
        animation: cross 0.5s infinite;
      }
      @keyframes cross {
        0%, 100% { transform: translateX(-50%) rotate(45deg); }
        50% { transform: translateX(-50%) rotate(45deg) scale(1.05); }
      }
      .cross-mark::after {
        content: '';
        position: absolute;
        width: 100px;
        height: 500px;
        background: #FF0000;
        top: -200px;
        left: 200px;
      }
      .pause-btn {
        position: absolute;
        width: 300px;
        height: 300px;
        background: rgba(255,255,255,0.1);
        border: 10px solid rgba(255,255,255,0.3);
        border-radius: 50%;
        top: 800px;
        left: 50%;
        transform: translateX(-50%);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 30px;
      }
      .pause-bar {
        width: 40px;
        height: 120px;
        background: white;
        border-radius: 20px;
      }
      .question {
        position: absolute;
        font-size: 150px;
        color: rgba(255,255,255,0.2);
        animation: float 2s infinite;
      }
      @keyframes float {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-30px); }
      }
      .q1 { top: 1200px; left: 150px; animation-delay: 0s; }
      .q2 { top: 1100px; right: 150px; animation-delay: 0.5s; }
      .q3 { top: 1400px; left: 300px; animation-delay: 1s; }
      .q4 { top: 1300px; right: 300px; animation-delay: 1.5s; }
      .text {
        position: absolute;
        bottom: 250px;
        width: 900px;
        text-align: center;
        color: white;
        font-size: 60px;
        font-weight: bold;
        line-height: 1.5;
        text-shadow: 2px 2px 10px rgba(0,0,0,0.8);
      }
      .highlight {
        color: #00D9FF;
        font-size: 80px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="eighteen-plus">18+</div>
      <div class="cross-mark"></div>
      <div class="pause-btn">
        <div class="pause-bar"></div>
        <div class="pause-bar"></div>
      </div>
      <div class="question q1">?</div>
      <div class="question q2">?</div>
      <div class="question q3">?</div>
      <div class="question q4">?</div>
      <div class="text">
        <div class="highlight">第二个大瓜！</div>
        <div style="font-size: 50px; margin-top: 20px;">
          OpenAI推迟ChatGPT<br/>
          成人模式，优先搞<br/>
          "更重要的事"
        </div>
      </div>
    </div>
  </body>
  </html>
  `,
  
  // 场景4: 第三个大瓜
  `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { 
        width: 1080px; 
        height: 1920px;
        background: linear-gradient(135deg, #FFD700 0%, #FFA500 50%, #1A1A2E 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Microsoft YaHei', sans-serif;
        overflow: hidden;
      }
      .container {
        position: relative;
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
      }
      .halo {
        position: absolute;
        width: 700px;
        height: 700px;
        border: 30px solid rgba(255,215,0,0.6);
        border-radius: 50%;
        top: 200px;
        left: 50%;
        transform: translateX(-50%);
        box-shadow: 
          0 0 60px rgba(255,215,0,0.8),
          inset 0 0 60px rgba(255,215,0,0.4);
        animation: glow 2s infinite;
      }
      @keyframes glow {
        0%, 100% { 
          transform: translateX(-50%) scale(1);
          box-shadow: 0 0 60px rgba(255,215,0,0.8), inset 0 0 60px rgba(255,215,0,0.4);
        }
        50% { 
          transform: translateX(-50%) scale(1.1);
          box-shadow: 0 0 100px rgba(255,215,0,1), inset 0 0 80px rgba(255,215,0,0.6);
        }
      }
      .rocket {
        position: absolute;
        font-size: 300px;
        top: 350px;
        left: 50%;
        transform: translateX(-50%);
        animation: launch 2s infinite;
      }
      @keyframes launch {
        0%, 100% { transform: translateX(-50%) translateY(0); }
        50% { transform: translateX(-50%) translateY(-50px); }
      }
      .flame {
        position: absolute;
        font-size: 100px;
        top: 650px;
        left: 50%;
        transform: translateX(-50%);
        animation: flame 0.2s infinite;
      }
      @keyframes flame {
        0%, 100% { transform: translateX(-50%) scale(1); opacity: 1; }
        50% { transform: translateX(-50%) scale(1.2); opacity: 0.8; }
      }
      .chart {
        position: absolute;
        width: 800px;
        height: 500px;
        bottom: 400px;
        left: 50%;
        transform: translateX(-50%);
      }
      .chart-line {
        position: absolute;
        width: 100%;
        height: 100%;
      }
      .chart-bg {
        position: absolute;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.3);
        border-radius: 20px;
      }
      .growth-line {
        position: absolute;
        width: 4px;
        height: 400px;
        background: linear-gradient(to top, #00FF00, #00CC00);
        bottom: 50px;
        left: 50%;
        transform: translateX(-50%) rotate(-45deg);
        transform-origin: bottom center;
        animation: grow 2s infinite;
      }
      @keyframes grow {
        0%, 100% { transform: translateX(-50%) rotate(-45deg) scaleY(1); }
        50% { transform: translateX(-50%) rotate(-45deg) scaleY(1.2); }
      }
      .text {
        position: absolute;
        bottom: 150px;
        width: 900px;
        text-align: center;
        color: white;
        font-size: 70px;
        font-weight: bold;
        line-height: 1.4;
        text-shadow: 2px 2px 10px rgba(0,0,0,0.8);
      }
      .highlight {
        color: #FFD700;
        font-size: 90px;
      }
      .number {
        color: #00FF00;
        font-size: 80px;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="halo"></div>
      <div class="rocket">🚀</div>
      <div class="flame">🔥</div>
      <div class="chart">
        <div class="chart-bg"></div>
        <div class="growth-line"></div>
      </div>
      <div class="text">
        <div class="highlight">最绝的是第三个！</div>
        <div style="font-size: 50px; margin-top: 20px;">
          Claude注册量暴涨<br/>
          <span class="number">每天百万！</span>
        </div>
      </div>
    </div>
  </body>
  </html>
  `
];

// 生成图片的 HTML 文件
async function generateHTMLImages() {
  console.log('🎨 步骤 1/4: 生成场景图片...\n');
  
  // 检查是否有 ffmpeg 和 chromium
  try {
    await execAsync('which ffmpeg');
    await execAsync('which chromium || which chromium-browser || which google-chrome || which chrome');
  } catch {
    console.error('❌ 未找到必要的工具（ffmpeg 或 chromium）');
    throw new Error('Missing required tools');
  }
  
  // 为每个场景生成 HTML 文件
  for (let i = 0; i < HTML_TEMPLATES.length; i++) {
    const htmlPath = `scene_${i + 1}.html`;
    await fs.writeFile(htmlPath, HTML_TEMPLATES[i]);
    console.log(`✅ 场景 ${i + 1} HTML 文件生成完成`);
    
    // 使用 chromium-headless 截图
    const imgPath = `scene_${i + 1}.png`;
    try {
      await execAsync(
        `chromium --headless --disable-gpu --window-size=1080,1920 --screenshot="${imgPath}" "${htmlPath}" 2>/dev/null || ` +
        `chromium-browser --headless --disable-gpu --window-size=1080,1920 --screenshot="${imgPath}" "${htmlPath}" 2>/dev/null || ` +
        `google-chrome --headless --disable-gpu --window-size=1080,1920 --screenshot="${imgPath}" "${htmlPath}" 2>/dev/null || ` +
        `chrome --headless --disable-gpu --window-size=1080,1920 --screenshot="${imgPath}" "${htmlPath}"`
      );
      console.log(`✅ 场景 ${i + 1} 图片生成完成`);
    } catch (error) {
      console.error(`❌ 场景 ${i + 1} 图片生成失败: ${error.message}`);
      // 如果截图失败，使用备选方案：使用 ImageMagick 创建纯色背景图片
      await execAsync(`convert -size 1080x1920 xc:${CONFIG.scenes[i].bg.replace('#', '%23')} "${imgPath}"`);
      console.log(`⚠️  使用备选方案生成场景 ${i + 1} 图片`);
    }
  }
  
  console.log('\n✅ 所有场景图片生成完成\n');
}

// 生成配音（使用系统的 espeak 或 festival）
async function generateVoiceover() {
  console.log('🎙️  步骤 2/4: 生成配音...\n');
  
  // 合并所有文案
  const fullScript = `${SCRIPT.hook}\n${SCRIPT.part1}\n${SCRIPT.part2}\n${SCRIPT.part3}\n${SCRIPT.ending}`;
  await fs.writeFile('script.txt', fullScript);
  
  // 检查可用的 TTS 工具
  let ttsCommand = '';
  
  try {
    // 尝试使用 espeak
    await execAsync('which espeak');
    ttsCommand = 'espeak -f script.txt -s 150 -p 50 -v zh -w voiceover.wav';
    console.log('使用 espeak 生成配音...');
  } catch {
    try {
      // 尝试使用 festival
      await execAsync('which text2wave');
      ttsCommand = 'text2wave -eval "(voice_cmu_us_slt_arctic_clb)" -o voiceover.wav < script.txt';
      console.log('使用 festival 生成配音...');
    } catch {
      console.log('⚠️  未找到 TTS 工具，跳过配音生成');
      console.log('   (视频将无配音，可后续手动添加)\n');
      return;
    }
  }
  
  try {
    await execAsync(ttsCommand);
    
    // 转换为 MP3
    await execAsync('ffmpeg -y -i voiceover.wav -acodec libmp3lame -ab 192k voiceover.mp3 2>/dev/null || ffmpeg -y -i voiceover.wav voiceover.mp3 2>/dev/null');
    await fs.unlink('voiceover.wav');
    
    console.log('✅ 配音生成完成\n');
  } catch (error) {
    console.log('⚠️  配音生成失败，继续无配音版本');
  }
}

// 合成视频
async function composeVideo() {
  console.log('🎬 步骤 3/4: 合成视频...\n');
  
  // 创建临时图片列表文件
  const concatList = CONFIG.scenes.map((scene, i) => {
    const imgFile = `scene_${Math.min(i + 1, 4)}.png`;
    return `file '${imgFile}'\nduration ${scene.duration}`;
  }).join('\n');
  
  await fs.writeFile('concat.txt', concatList);
  
  // FFmpeg 命令
  let ffmpegCmd = `ffmpeg -y -f concat -safe 0 -i concat.txt -i voiceover.mp3 `;
  
  // 检查是否有配音文件
  try {
    await fs.access('voiceover.mp3');
    ffmpegCmd = `ffmpeg -y -f concat -safe 0 -i concat.txt -i voiceover.mp3 ` +
                `-map 0:v -map 1:a -shortest ` +
                `-c:v libx264 -preset medium -crf 23 -r ${CONFIG.fps} -pix_fmt yuv420p ` +
                `-c:a aac -b:a 192k ` +
                `-vsync vfr ` +
                `output.mp4`;
    console.log('合成视频（带配音）...');
  } catch {
    ffmpegCmd = `ffmpeg -y -f concat -safe 0 -i concat.txt ` +
                `-c:v libx264 -preset medium -crf 23 -r ${CONFIG.fps} -pix_fmt yuv420p ` +
                `-vsync vfr ` +
                `output.mp4`;
    console.log('合成视频（无配音）...');
  }
  
  await execAsync(ffmpegCmd);
  console.log('✅ 视频合成完成\n');
}

// 检查视频信息
async function checkVideo() {
  console.log('⏱️  步骤 4/4: 检查视频信息...\n');
  
  try {
    const { stdout } = await execAsync('ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 output.mp4 2>/dev/null || ffprobe -v error -show_entries format=duration output.mp4');
    const duration = parseFloat(stdout.trim());
    
    console.log('=== ✅ 视频生成完成 ===\n');
    console.log('📁 输出文件: output.mp4');
    console.log(`⏱️  时长: ${duration.toFixed(2)} 秒`);
    console.log(`📐 尺寸: ${CONFIG.width}x${CONFIG.height}`);
    console.log(`🎬 帧率: ${CONFIG.fps} fps\n`);
    
    console.log('🎥 视频分镜:');
    console.log('   0-3秒:   🔥 开头钩子');
    console.log('   3-13秒:  🚫 第一个大瓜');
    console.log('   13-23秒: ⏸️  第二个大瓜');
    console.log('   23-35秒: 🚀 第三个大瓜');
    console.log('   35-40秒: 💬 结尾互动\n');
    
    console.log('💡 提示:');
    console.log('   - 视频已按照 9:16 竖屏比例生成');
    console.log('   - 如果没有配音，可以后期添加配音和背景音乐');
    console.log('   - 建议添加节奏感强的背景音乐\n');
    
  } catch (error) {
    console.log('⚠️  无法获取视频时长');
    console.log('   但视频文件已生成: output.mp4\n');
  }
}

// 主函数
async function main() {
  console.log('=== 抖音视频生成器 v2 ===\n');
  console.log('📋 配置:');
  console.log(`   - 尺寸: ${CONFIG.width}x${CONFIG.height}`);
  console.log(`   - 帧率: ${CONFIG.fps} fps`);
  console.log(`   - 时长: ${CONFIG.totalDuration} 秒`);
  console.log(`   - 场景: ${CONFIG.scenes.length} 个\n`);
  
  try {
    await generateHTMLImages();
    await generateVoiceover();
    await composeVideo();
    await checkVideo();
    
  } catch (error) {
    console.error('\n❌ 生成失败:', error.message);
    console.error('\n💡 可能的解决方案:');
    console.error('   1. 安装 ffmpeg: sudo apt-get install ffmpeg');
    console.error('   2. 安装 chromium: sudo apt-get install chromium');
    console.error('   3. 或者使用 ImageMagick 生成简单图片\n');
    process.exit(1);
  }
}

main();
