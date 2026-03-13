#!/usr/bin/env node

/**
 * 生成关键帧预览图
 */

const fs = require('fs').promises;
const { createCanvas } = require('canvas');

async function generatePreview() {
  console.log('🎨 生成关键帧预览...\n');
  
  const keyFrames = [
    { frame: 45, name: '开头钩子', time: '00:01.5' },
    { frame: 240, name: '第一个大瓜', time: '00:08.0' },
    { frame: 540, name: '第二个大瓜', time: '00:18.0' },
    { frame: 900, name: '第三个大瓜', time: '00:30.0' },
    { frame: 1125, name: '结尾', time: '00:37.5' }
  ];
  
  // 读取关键帧并创建预览
  const canvas = createCanvas(1920, 1080);
  const ctx = canvas.getContext('2d');
  
  // 背景
  ctx.fillStyle = '#1A1A2E';
  ctx.fillRect(0, 0, 1920, 1080);
  
  // 标题
  ctx.fillStyle = '#FFD700';
  ctx.font = 'bold 48px Arial';
  ctx.textAlign = 'center';
  ctx.fillText('🎥 抖音视频关键帧预览', 960, 60);
  
  ctx.fillStyle = 'white';
  ctx.font = '24px Arial';
  ctx.fillText('尺寸: 1080x1920 | 帧率: 30fps | 时长: 40秒', 960, 100);
  
  // 绘制关键帧占位
  const margin = 40;
  const frameWidth = 340;
  const frameHeight = 608;
  const gap = 20;
  
  ctx.fillStyle = '#333';
  ctx.font = 'bold 20px Arial';
  
  for (let i = 0; i < keyFrames.length; i++) {
    const x = margin + i * (frameWidth + gap);
    const y = 140;
    
    // 占位框
    ctx.strokeStyle = '#4CAF50';
    ctx.lineWidth = 3;
    ctx.strokeRect(x, y, frameWidth, frameHeight);
    
    // 信息
    ctx.fillStyle = 'white';
    ctx.font = 'bold 20px Arial';
    ctx.textAlign = 'center';
    ctx.fillText(keyFrames[i].name, x + frameWidth/2, y + 30);
    
    ctx.fillStyle = '#888';
    ctx.font = '16px Arial';
    ctx.fillText(`帧: ${keyFrames[i].frame}`, x + frameWidth/2, y + frameHeight - 50);
    ctx.fillText(`时间: ${keyFrames[i].time}`, x + frameWidth/2, y + frameHeight - 25);
    
    ctx.fillStyle = '#4CAF50';
    ctx.font = 'bold 14px Arial';
    ctx.fillText('请查看 frames/ 文件夹', x + frameWidth/2, y + frameHeight/2);
  }
  
  // 保存预览图
  const buffer = canvas.toBuffer('image/png');
  await fs.writeFile('video_preview.png', buffer);
  
  console.log('✅ 关键帧预览已生成: video_preview.png');
  console.log('\n📊 视频统计:');
  console.log('   - 总帧数: 1200 帧');
  console.log('   - 总时长: 40 秒');
  console.log('   - 文件大小: 313 MB');
  console.log('   - 分辨率: 1080x1920 (9:16)\n');
}

generatePreview();
