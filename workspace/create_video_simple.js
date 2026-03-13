#!/usr/bin/env node

/**
 * 抖音视频生成器 - 纯 JavaScript 实现
 * 使用 Canvas API 生成图片帧，然后合成视频
 */

const fs = require('fs').promises;
const path = require('path');
const { createCanvas } = require('canvas');

// 配置
const CONFIG = {
  width: 1080,
  height: 1920,
  fps: 30,
  scenes: [
    { duration: 3, name: '开头钩子', bg: ['#FF0000', '#FF6B00', '#1A1A2E'] },
    { duration: 10, name: '第一个大瓜', bg: ['#1A1A2E', '#0F0F1E'] },
    { duration: 10, name: '第二个大瓜', bg: ['#16213E', '#0F0F1E'] },
    { duration: 12, name: '第三个大瓜', bg: ['#FFD700', '#FFA500', '#1A1A2E'] },
    { duration: 5, name: '结尾', bg: ['#000000'] }
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

// 场景绘制函数
const SCENE_DRAWERS = [
  // 场景1: 开头钩子
  async (ctx, width, height, time) => {
    // 背景渐变
    const gradient = ctx.createLinearGradient(0, 0, width, height);
    gradient.addColorStop(0, '#FF0000');
    gradient.addColorStop(0.5, '#FF6B00');
    gradient.addColorStop(1, '#1A1A2E');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);
    
    // 火焰效果
    const pulse = Math.sin(time * 0.01) * 0.2 + 0.8;
    ctx.fillStyle = `rgba(255, 100, 0, ${0.3 * pulse})`;
    ctx.beginPath();
    ctx.arc(width / 2, height / 2, 800 * pulse, 0, Math.PI * 2);
    ctx.fill();
    
    // 故障艺术线条
    ctx.strokeStyle = `rgba(0, 255, 0, ${0.1 + Math.random() * 0.1})`;
    ctx.lineWidth = 2;
    for (let i = 0; i < 20; i++) {
      const y = Math.random() * height;
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(width, y);
      ctx.stroke();
    }
    
    // 标题
    ctx.save();
    ctx.translate(width / 2, height / 2);
    const scale = 1 + Math.sin(time * 0.005) * 0.05;
    ctx.scale(scale, scale);
    
    ctx.fillStyle = 'white';
    ctx.font = 'bold 180px "Microsoft YaHei", sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    
    // 文字阴影
    ctx.shadowColor = 'rgba(255, 0, 0, 0.8)';
    ctx.shadowBlur = 40;
    ctx.shadowOffsetX = 4;
    ctx.shadowOffsetY = 4;
    
    ctx.fillText('🔥 五角大楼', 0, -80);
    ctx.fillText('封杀AI？', 0, 120);
    
    ctx.restore();
  },
  
  // 场景2: 第一个大瓜
  async (ctx, width, height, time) => {
    // 背景
    const gradient = ctx.createLinearGradient(0, 0, width, height);
    gradient.addColorStop(0, '#1A1A2E');
    gradient.addColorStop(1, '#0F0F1E');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);
    
    // 数据流线条
    ctx.strokeStyle = 'rgba(0, 255, 255, 0.1)';
    ctx.lineWidth = 2;
    const offset = (time * 2) % 50;
    for (let x = 0; x < width; x += 50) {
      ctx.beginPath();
      ctx.moveTo(x + offset, 0);
      ctx.lineTo(x + offset, height);
      ctx.stroke();
    }
    
    // 禁止标志
    const banX = width / 2;
    const banY = 500;
    const shake = Math.sin(time * 0.02) * 10;
    
    ctx.strokeStyle = '#FF0000';
    ctx.lineWidth = 40;
    ctx.beginPath();
    ctx.arc(banX + shake, banY, 300, 0, Math.PI * 2);
    ctx.stroke();
    
    // 斜线
    ctx.beginPath();
    ctx.moveTo(banX - 200 + shake, banY + 200);
    ctx.lineTo(banX + 200 + shake, banY - 200);
    ctx.stroke();
    
    // 破碎的美元符号
    ctx.save();
    ctx.translate(banX, banY);
    const breakAngle = Math.sin(time * 0.01) * 0.2;
    ctx.rotate(breakAngle);
    ctx.fillStyle = '#FFD700';
    ctx.font = 'bold 200px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('$', 0, 0);
    ctx.restore();
    
    // 文案
    ctx.fillStyle = 'white';
    ctx.font = 'bold 70px "Microsoft YaHei", sans-serif';
    ctx.textAlign = 'center';
    ctx.shadowColor = 'rgba(0, 0, 0, 0.8)';
    ctx.shadowBlur = 10;
    
    ctx.fillText('第一个大瓜！', width / 2, 1100);
    
    ctx.font = '50px "Microsoft YaHei", sans-serif';
    ctx.fillStyle = '#FF0000';
    ctx.fillText('Anthropic被列为风险', width / 2, 1250);
    ctx.fillStyle = 'white';
    ctx.fillText('CEO爆料：没给特朗普捐款', width / 2, 1350);
  },
  
  // 场景3: 第二个大瓜
  async (ctx, width, height, time) => {
    // 背景
    const gradient = ctx.createLinearGradient(0, 0, width, height);
    gradient.addColorStop(0, '#16213E');
    gradient.addColorStop(1, '#0F0F1E');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);
    
    // 18+ 标志
    const eighteenX = width / 2;
    const eighteenY = 400;
    const pulse = 1 + Math.sin(time * 0.006) * 0.1;
    
    ctx.save();
    ctx.translate(eighteenX, eighteenY);
    ctx.scale(pulse, pulse);
    
    // 圆圈
    ctx.strokeStyle = '#FF0000';
    ctx.lineWidth = 30;
    ctx.beginPath();
    ctx.arc(0, 0, 200, 0, Math.PI * 2);
    ctx.stroke();
    
    // 18+
    ctx.fillStyle = 'white';
    ctx.font = 'bold 180px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('18+', 0, 0);
    
    ctx.restore();
    
    // 红叉
    ctx.strokeStyle = '#FF0000';
    ctx.lineWidth = 30;
    ctx.beginPath();
    ctx.moveTo(eighteenX - 250, eighteenY + 250);
    ctx.lineTo(eighteenX + 250, eighteenY - 250);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(eighteenX - 250, eighteenY - 250);
    ctx.lineTo(eighteenX + 250, eighteenY + 250);
    ctx.stroke();
    
    // 暂停按钮
    ctx.fillStyle = 'rgba(255, 255, 255, 0.1)';
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
    ctx.lineWidth = 10;
    ctx.beginPath();
    ctx.arc(width / 2, 900, 150, 0, Math.PI * 2);
    ctx.fill();
    ctx.stroke();
    
    ctx.fillStyle = 'white';
    ctx.fillRect(width / 2 - 40, 830, 30, 140);
    ctx.fillRect(width / 2 + 10, 830, 30, 140);
    
    // 浮动问号
    ctx.fillStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.font = 'bold 150px Arial';
    for (let i = 0; i < 4; i++) {
      const floatOffset = Math.sin(time * 0.003 + i) * 30;
      const x = 200 + i * 250;
      const y = 1200 + floatOffset;
      ctx.fillText('?', x, y);
    }
    
    // 文案
    ctx.fillStyle = 'white';
    ctx.font = 'bold 70px "Microsoft YaHei", sans-serif';
    ctx.textAlign = 'center';
    ctx.shadowColor = 'rgba(0, 0, 0, 0.8)';
    ctx.shadowBlur = 10;
    
    ctx.fillStyle = '#00D9FF';
    ctx.fillText('第二个大瓜！', width / 2, 1450);
    
    ctx.fillStyle = 'white';
    ctx.font = '50px "Microsoft YaHei", sans-serif';
    ctx.fillText('OpenAI推迟ChatGPT成人模式', width / 2, 1570);
    ctx.fillText('优先搞"更重要的事"', width / 2, 1650);
  },
  
  // 场景4: 第三个大瓜
  async (ctx, width, height, time) => {
    // 背景
    const gradient = ctx.createLinearGradient(0, 0, width, height);
    gradient.addColorStop(0, '#FFD700');
    gradient.addColorStop(0.5, '#FFA500');
    gradient.addColorStop(1, '#1A1A2E');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);
    
    // 金色光环
    const haloPulse = Math.sin(time * 0.003) * 0.1 + 1;
    ctx.save();
    ctx.translate(width / 2, 350);
    ctx.scale(haloPulse, haloPulse);
    
    ctx.strokeStyle = 'rgba(255, 215, 0, 0.6)';
    ctx.lineWidth = 30;
    ctx.shadowColor = 'rgba(255, 215, 0, 0.8)';
    ctx.shadowBlur = 60;
    ctx.beginPath();
    ctx.arc(0, 0, 350, 0, Math.PI * 2);
    ctx.stroke();
    
    ctx.restore();
    
    // 火箭
    const rocketOffset = Math.sin(time * 0.01) * 30;
    ctx.font = '300px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('🚀', width / 2, 500 + rocketOffset);
    
    // 火焰
    const flamePulse = Math.sin(time * 0.05) * 0.2 + 1;
    ctx.font = `${100 * flamePulse}px Arial`;
    ctx.fillText('🔥', width / 2, 700);
    
    // 增长曲线
    ctx.fillStyle = 'rgba(0, 0, 0, 0.3)';
    ctx.beginPath();
    ctx.roundRect(140, 900, 800, 500, 20);
    ctx.fill();
    
    // 增长线
    const growPulse = Math.sin(time * 0.005) * 0.2 + 1;
    ctx.save();
    ctx.translate(width / 2, 1150);
    ctx.scale(1, growPulse);
    ctx.rotate(-45 * Math.PI / 180);
    
    ctx.strokeStyle = '#00FF00';
    ctx.lineWidth = 8;
    ctx.shadowColor = '#00FF00';
    ctx.shadowBlur = 20;
    ctx.beginPath();
    ctx.moveTo(0, -200);
    ctx.lineTo(0, 200);
    ctx.stroke();
    
    ctx.restore();
    
    // 文案
    ctx.fillStyle = 'white';
    ctx.font = 'bold 70px "Microsoft YaHei", sans-serif';
    ctx.textAlign = 'center';
    ctx.shadowColor = 'rgba(0, 0, 0, 0.8)';
    ctx.shadowBlur = 10;
    
    ctx.fillStyle = '#FFD700';
    ctx.fillText('最绝的是第三个！', width / 2, 1520);
    
    ctx.fillStyle = 'white';
    ctx.font = '50px "Microsoft YaHei", sans-serif';
    ctx.fillText('Claude注册量暴涨', width / 2, 1650);
    
    ctx.fillStyle = '#00FF00';
    ctx.font = 'bold 80px "Microsoft YaHei", sans-serif';
    ctx.fillText('每天百万！', width / 2, 1750);
  }
];

// 生成视频帧
async function generateFrames() {
  console.log('🎨 生成视频帧...\n');
  
  // 安装 canvas 包
  console.log('检查依赖...');
  try {
    require('canvas');
  } catch {
    console.log('安装 canvas 包...');
    await execAsync('npm install canvas 2>&1 | tail -5');
  }
  
  // 创建输出目录
  await fs.mkdir('frames', { recursive: true });
  
  let totalFrames = 0;
  
  // 为每个场景生成帧
  for (let sceneIdx = 0; sceneIdx < CONFIG.scenes.length; sceneIdx++) {
    const scene = CONFIG.scenes[sceneIdx];
    const frameCount = Math.floor(scene.duration * CONFIG.fps);
    const drawer = SCENE_DRAWERS[Math.min(sceneIdx, SCENE_DRAWERS.length - 1)];
    
    console.log(`生成场景 ${sceneIdx + 1}/${CONFIG.scenes.length}: ${scene.name} (${frameCount} 帧)`);
    
    for (let frameIdx = 0; frameIdx < frameCount; frameIdx++) {
      const canvas = createCanvas(CONFIG.width, CONFIG.height);
      const ctx = canvas.getContext('2d');
      
      const time = frameIdx / CONFIG.fps * 1000;
      await drawer(ctx, CONFIG.width, CONFIG.height, time);
      
      const filename = `frames/frame_${String(totalFrames).padStart(6, '0')}.png`;
      await fs.writeFile(filename, canvas.toBuffer('image/png'));
      
      totalFrames++;
      
      if (frameIdx % 30 === 0) {
        process.stdout.write(`\r  进度: ${frameIdx}/${frameCount}`);
      }
    }
    
    console.log(`\r  ✅ 完成 (${frameCount} 帧)`);
  }
  
  console.log(`\n✅ 总共生成 ${totalFrames} 帧\n`);
  return totalFrames;
}

// 使用 Python 合成视频
async function composeWithPython(totalFrames) {
  console.log('🎬 合成视频...\n');
  
  // 创建 Python 脚本
  const pythonScript = `
import cv2
import numpy as np
import os

# 设置
fps = ${CONFIG.fps}
width = ${CONFIG.width}
height = ${CONFIG.height}
output_file = 'output.mp4'

# 创建视频写入器
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
video = cv2.VideoWriter(output_file, fourcc, fps, (width, height))

# 读取并写入帧
frames_dir = 'frames'
frame_files = sorted([f for f in os.listdir(frames_dir) if f.endswith('.png')])

print(f'处理 {len(frame_files)} 帧...')

for idx, frame_file in enumerate(frame_files):
    frame_path = os.path.join(frames_dir, frame_file)
    frame = cv2.imread(frame_path)
    
    if frame is not None:
        video.write(frame)
    
    if idx % 100 == 0:
        print(f'进度: {idx}/{len(frame_files)}')

video.release()
print(f'✅ 视频已保存: {output_file}')
`;
  
  await fs.writeFile('compose_video.py', pythonScript);
  
  // 检查 Python 和 opencv-python
  try {
    require('child_process').execSync('python3 -c "import cv2"', { stdio: 'ignore' });
  } catch {
    console.log('安装 opencv-python...');
    await execAsync('python3 -m pip install opencv-python-headless -q 2>&1 | tail -3');
  }
  
  // 运行 Python 脚本
  await execAsync('python3 compose_video.py');
  console.log('✅ 视频合成完成\n');
}

// 生成配音文件（文本格式）
async function generateScriptFiles() {
  console.log('📝 生成文案文件...\n');
  
  const fullScript = `${SCRIPT.hook}\n\n${SCRIPT.part1}\n\n${SCRIPT.part2}\n\n${SCRIPT.part3}\n\n${SCRIPT.ending}`;
  await fs.writeFile('voiceover.txt', fullScript, 'utf-8');
  
  // 生成带时间戳的脚本
  const timestamp = 0;
  const timedScript = `
[00:00.000] ${SCRIPT.hook}
[00:03.000] ${SCRIPT.part1}
[00:13.000] ${SCRIPT.part2}
[00:23.000] ${SCRIPT.part3}
[00:35.000] ${SCRIPT.ending}
`;
  await fs.writeFile('script_with_timestamps.txt', timedScript, 'utf-8');
  
  console.log('✅ 文案文件生成完成:');
  console.log('   - voiceover.txt (纯文本)');
  console.log('   - script_with_timestamps.txt (带时间戳)\n');
}

// 主函数
async function main() {
  console.log('=== 抖音视频生成器 (Canvas 版) ===\n');
  console.log('📋 配置:');
  console.log(`   - 尺寸: ${CONFIG.width}x${CONFIG.height}`);
  console.log(`   - 帧率: ${CONFIG.fps} fps`);
  console.log(`   - 场景: ${CONFIG.scenes.length} 个\n`);
  
  try {
    // 生成帧
    const totalFrames = await generateFrames();
    
    // 合成视频
    await composeWithPython(totalFrames);
    
    // 生成文案文件
    await generateScriptFiles();
    
    // 输出总结
    console.log('=== ✅ 视频生成完成 ===\n');
    console.log('📁 输出文件:');
    console.log('   - output.mp4 (视频文件)');
    console.log('   - voiceover.txt (配音文本)');
    console.log('   - script_with_timestamps.txt (带时间戳的脚本)');
    console.log('   - frames/ (所有帧图片)\n');
    
    console.log('🎥 视频分镜:');
    console.log('   0-3秒:   🔥 开头钩子');
    console.log('   3-13秒:  🚫 第一个大瓜');
    console.log('   13-23秒: ⏸️  第二个大瓜');
    console.log('   23-35秒: 🚀 第三个大瓜');
    console.log('   35-40秒: 💬 结尾互动\n');
    
    console.log('💡 后期处理建议:');
    console.log('   1. 使用 TTS 工具为 voiceover.txt 生成配音');
    console.log('   2. 使用视频编辑软件添加配音到视频');
    console.log('   3. 添加节奏感强的背景音乐');
    console.log('   4. 调整转场效果\n');
    
  } catch (error) {
    console.error('\n❌ 生成失败:', error.message);
    process.exit(1);
  }
}

const execAsync = (cmd) => {
  return new Promise((resolve, reject) => {
    require('child_process').exec(cmd, (error, stdout, stderr) => {
      if (error) reject(error);
      else resolve(stdout);
    });
  });
};

main();
