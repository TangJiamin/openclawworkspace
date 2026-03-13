#!/usr/bin/env node

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
  duration: 40, // 总时长40秒
  images: [
    { duration: 3, file: 'image_1.png' },   // 开头钩子
    { duration: 10, file: 'image_2.png' },  // 第一个大瓜
    { duration: 10, file: 'image_3.png' },  // 第二个大瓜
    { duration: 12, file: 'image_4.png' },  // 第三个大瓜
    { duration: 5, file: 'image_4.png' }    // 结尾（复用最后一张图）
  ]
};

// 文案
const SCRIPT = {
  hook: "五角大楼封杀AI公司？真相太离谱了！",
  part1: "第一个大瓜！Anthropic被五角大楼列为风险，CEO直接爆料：就是因为没给特朗普捐款",
  part2: "第二个！OpenAI突然推迟ChatGPT成人模式，说要优先搞更重要的事",
  part3: "最绝的是第三个！Claude被列入黑名单后，注册量反而暴涨到每天百万！",
  ending: "你怎么看五角大楼这波操作？评论区告诉我！点赞关注，下期更精彩！"
};

// 图片提示词
const IMAGE_PROMPTS = [
  // 图片1: 开头钩子
  `A dramatic TikTok video thumbnail with these elements:
- Fiery explosion effects in the background
- Glitch art distortion and digital artifacts
- Matrix-style digital rain (falling green code)
- Bold text: "五角大楼封杀AI？"
- High contrast, cyberpunk aesthetic
- Vertical 9:16 aspect ratio
- Intense red and orange color scheme
- Shocking news vibe`,
  
  // 图片2: 第一个大瓜
  `A dramatic news illustration with these elements:
- Red prohibition sign (banned symbol)
- Shattered broken dollar symbol
- Digital data flow lines and matrix code
- Pentagon building silhouette in background
- Political scandal vibe
- Dark background with red accents
- Vertical 9:16 aspect ratio
- Shocking revelation style`,
  
  // 图片3: 第二个大瓜
  `A mysterious tech news illustration with these elements:
- "18+" label with a red X cross mark
- Large pause button symbol
- Floating question marks
- OpenAI logo subtly in background
- Confused uncertain atmosphere
- Dark moody lighting
- Vertical 9:16 aspect ratio
- Mystery and delay theme`,
  
  // 图片4: 第三个大瓜
  `A triumphant success illustration with these elements:
- Golden glowing halo effect
- Rocket launching upward
- Exponential growth chart going up
- Celebratory confetti particles
- Claude AI branding
- Bright golden and blue colors
- Vertical 9:16 aspect ratio
- Viral success celebration vibe`
];

async function generateImages() {
  console.log('🎨 步骤 1/4: 生成图片...');
  
  // 检查是否有 OpenAI API key
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    console.error('❌ 未找到 OPENAI_API_KEY 环境变量');
    throw new Error('Missing OPENAI_API_KEY');
  }
  
  // 使用 OpenAI Images API 生成图片
  for (let i = 0; i < IMAGE_PROMPTS.length; i++) {
    console.log(`生成图片 ${i + 1}/${IMAGE_PROMPTS.length}...`);
    
    try {
      const response = await fetch('https://api.openai.com/v1/images/generations', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          model: 'dall-e-3',
          prompt: IMAGE_PROMPTS[i],
          n: 1,
          size: '1024x1792',
          quality: 'standard'
        })
      });
      
      if (!response.ok) {
        const error = await response.text();
        throw new Error(`OpenAI API error: ${error}`);
      }
      
      const data = await response.json();
      const imageUrl = data.data[0].url;
      
      // 下载图片
      const imageResponse = await fetch(imageUrl);
      const buffer = await imageResponse.arrayBuffer();
      await fs.writeFile(`image_${i + 1}.png`, Buffer.from(buffer));
      
      console.log(`✅ 图片 ${i + 1} 生成成功`);
    } catch (error) {
      console.error(`❌ 生成图片 ${i + 1} 失败:`, error.message);
      throw error;
    }
  }
  
  console.log('✅ 所有图片生成完成\n');
}

async function generateAudio() {
  console.log('🎙️  步骤 2/4: 生成配音...');
  
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    console.error('❌ 未找到 OPENAI_API_KEY 环境变量');
    throw new Error('Missing OPENAI_API_KEY');
  }
  
  // 合并所有文案
  const fullScript = `${SCRIPT.hook}\n\n${SCRIPT.part1}\n\n${SCRIPT.part2}\n\n${SCRIPT.part3}\n\n${SCRIPT.ending}`;
  
  try {
    const response = await fetch('https://api.openai.com/v1/audio/speech', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model: 'tts-1',
        input: fullScript,
        voice: 'alloy',
        speed: 1.1
      })
    });
    
    if (!response.ok) {
      const error = await response.text();
      throw new Error(`OpenAI TTS API error: ${error}`);
    }
    
    const buffer = await response.arrayBuffer();
    await fs.writeFile('voiceover.mp3', Buffer.from(buffer));
    
    console.log('✅ 配音生成完成\n');
  } catch (error) {
    console.error('❌ 生成配音失败:', error.message);
    throw error;
  }
}

async function createVideo() {
  console.log('🎬 步骤 3/4: 合成视频...');
  
  // 检查是否有 ffmpeg
  try {
    await execAsync('which ffmpeg');
  } catch {
    console.error('❌ 未找到 ffmpeg，请先安装');
    throw new Error('ffmpeg not found');
  }
  
  // 创建临时图片列表文件
  const filterComplex = [];
  let currentDuration = 0;
  
  // 生成图片序列和滤镜
  for (let i = 0; i < CONFIG.images.length; i++) {
    const img = CONFIG.images[i];
    const startTime = currentDuration;
    currentDuration += img.duration;
    
    // 添加缩放和帧率滤镜
    filterComplex.push(
      `[${i}:v]scale=${CONFIG.width}:${CONFIG.height}:force_original_aspect_ratio=decrease,pad=${CONFIG.width}:${CONFIG.height}:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=${CONFIG.fps}[v${i}];`
    );
  }
  
  // 创建时间线
  const segments = CONFIG.images.map((img, i) => {
    const startTime = CONFIG.images.slice(0, i).reduce((sum, x) => sum + x.duration, 0);
    return `[v${i}]trim=0:${img.duration},setpts=PTS-STARTPTS[${i}v];`;
  });
  
  const concatInputs = CONFIG.images.map((_, i) => `[${i}v]`).join('');
  
  // 完整的 filter complex
  const fullFilter = filterComplex.join('') + 
    segments.join('') +
    concatInputs + `concat=n=${CONFIG.images.length}:v=1:a=0[outv]`;
  
  // FFmpeg 命令
  const ffmpegCmd = `ffmpeg -y \
    ${CONFIG.images.map((img, i) => `-loop 1 -t ${img.duration} -i ${img.file}`).join(' ')} \
    -i voiceover.mp3 \
    -filter_complex "${fullFilter}" \
    -map "[outv]" \
    -map 4:a \
    -c:v libx264 -preset medium -crf 23 \
    -c:a aac -b:a 192k \
    -shortest \
    -pix_fmt yuv420p \
    output.mp4`;
  
  console.log('执行 FFmpeg 命令...');
  await execAsync(ffmpegCmd);
  
  console.log('✅ 视频合成完成\n');
}

async function checkDuration() {
  console.log('⏱️  步骤 4/4: 检查视频时长...');
  
  try {
    const { stdout } = await execAsync('ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 output.mp4');
    const duration = parseFloat(stdout.trim());
    console.log(`✅ 视频时长: ${duration.toFixed(2)} 秒`);
    console.log(`✅ 视频尺寸: ${CONFIG.width}x${CONFIG.height}`);
    console.log(`✅ 帧率: ${CONFIG.fps} fps\n`);
    return duration;
  } catch (error) {
    console.error('❌ 检查视频时长失败:', error.message);
    throw error;
  }
}

async function main() {
  console.log('=== 抖音视频生成器 ===\n');
  console.log('📋 配置:');
  console.log(`   - 尺寸: ${CONFIG.width}x${CONFIG.height}`);
  console.log(`   - 帧率: ${CONFIG.fps} fps`);
  console.log(`   - 时长: ${CONFIG.duration} 秒`);
  console.log(`   - 图片数: ${IMAGE_PROMPTS.length} 张\n`);
  
  try {
    // 步骤 1: 生成图片
    await generateImages();
    
    // 步骤 2: 生成配音
    await generateAudio();
    
    // 步骤 3: 合成视频
    await createVideo();
    
    // 步骤 4: 检查时长
    const duration = await checkDuration();
    
    console.log('=== ✅ 视频生成完成 ===');
    console.log('📁 输出文件: output.mp4');
    console.log(`⏱️  时长: ${duration} 秒`);
    console.log(`📐 尺寸: ${CONFIG.width}x${CONFIG.height}`);
    console.log(`🎬 帧率: ${CONFIG.fps} fps\n`);
    
    console.log('🎥 视频分镜:');
    console.log('   0-3秒:   开头钩子');
    console.log('   3-13秒:  第一个大瓜');
    console.log('   13-23秒: 第二个大瓜');
    console.log('   23-35秒: 第三个大瓜');
    console.log('   35-40秒: 结尾互动\n');
    
  } catch (error) {
    console.error('\n❌ 生成失败:', error.message);
    process.exit(1);
  }
}

main();
