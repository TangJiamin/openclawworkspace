#!/usr/bin/env node
/**
 * 批量内容编排器
 * 
 * 根据自然语言描述，批量生成多角度、多形式的内容
 */

/**
 * 解析自然语言需求
 */
function parseNaturalLanguage(input) {
  const config = {
    topic: null,
    angles: [],
    formats: [],
    count: 5,
    tone: '友好'
  };
  
  // 提取主题
  const topicMatch = input.match(/(?:主题|关于|生成|批量)(.+?)(?:的|，|\.|：)/);
  if (topicMatch) {
    config.topic = topicMatch[1].trim();
  } else {
    config.topic = input;
  }
  
  // 提取角度
  const angleKeywords = {
    '职场新人': ['职场', '新人', '小白', '入门'],
    '程序员': ['程序员', '开发', '代码', '编程'],
    '学生党': ['学生', '学习', '校园', '考试'],
    '自由职业': ['自由职业', '兼职', '副业'],
    '企业主': ['企业', '老板', '管理', '创业']
  };
  
  for (const [angle, keywords] of Object.entries(angleKeywords)) {
    if (keywords.some(kw => input.includes(kw))) {
      config.angles.push(angle);
    }
  }
  
  // 如果没有指定角度，使用默认
  if (config.angles.length === 0) {
    config.angles = ['职场新人', '程序员', '学生党'];
  }
  
  // 提取形式
  if (input.includes('图文') || input.includes('小红书')) {
    config.formats.push('图文');
  }
  if (input.includes('视频') || input.includes('抖音')) {
    config.formats.push('视频');
  }
  if (input.includes('文章') || input.includes('微信')) {
    config.formats.push('文章');
  }
  
  // 如果没有指定形式，使用默认
  if (config.formats.length === 0) {
    config.formats = ['图文'];
  }
  
  // 提取数量
  const countMatch = input.match(/(\d+)个|(\d+)篇|批量生成(\d+)/);
  if (countMatch) {
    config.count = parseInt(countMatch[1] || countMatch[2]);
  }
  
  return config;
}

/**
 * 批量生成主函数
 */
async function batchProduce(input) {
  console.log('🚀 批量内容生产系统');
  console.log(`📝 输入: ${input}\n`);
  
  try {
    // Step 1: 解析自然语言
    console.log('📋 Step 1: 解析需求');
    const config = parseNaturalLanguage(input);
    console.log(`   主题: ${config.topic}`);
    console.log(`   角度: ${config.angles.join(', ')}`);
    console.log(`   形式: ${config.formats.join(', ')}`);
    console.log(`   数量: ${config.count}个角度\n`);
    
    // Step 2: 生成任务列表
    console.log('📋 Step 2: 生成任务列表');
    const tasks = [];
    
    for (const angle of config.angles) {
      for (const format of config.formats) {
        const platform = getPlatformForFormat(format);
        
        tasks.push({
          id: `task-${tasks.length + 1}`,
          topic: config.topic,
          perspective: angle,
          platform,
          format,
          tone: getToneForAngle(angle),
          length: getLengthForFormat(format)
        });
      }
    }
    
    console.log(`   生成了 ${tasks.length} 个任务\n`);
    
    // Step 3: 并行生成内容
    console.log('✍️  Step 3: 并行生成内容');
    const startTime = Date.now();
    
    const contentPromises = tasks.map(async (task) => {
      const result = await sessions_send({
        sessionKey: "content-producer",
        message: `生成${task.format}内容，主题：${task.topic}，角度：${task.perspective}，平台：${task.platform}，调性：${task.tone}，长度：${task.length}`
      });
      
      return { task, result };
    });
    
    const contentResults = await Promise.all(contentPromises);
    
    const contentTime = ((Date.now() - startTime) / 1000).toFixed(1);
    console.log(`   ✅ 完成！耗时: ${contentTime}秒\n`);
    
    // Step 4: 并行生成视觉/视频
    console.log('🎨 Step 4: 并行生成视觉/视频');
    const visualStartTime = Date.now();
    
    const visualPromises = [];
    
    for (const { task, result } of contentResults) {
      if (task.format === '图文') {
        visualPromises.push(
          sessions_send({
            sessionKey: "visual-designer",
            message: `生成视觉参数，基于内容：${result.substring(0, 200)}...`
          }).then(r => ({ task, result: r }))
        );
      } else if (task.format === '视频') {
        visualPromises.push(
          sessions_send({
            sessionKey: "video-producer",
            message: `生成视频分镜，基于内容：${result.substring(0, 200)}...`
          }).then(r => ({ task, result: r }))
        );
      }
    }
    
    const visualResults = await Promise.all(visualPromises);
    
    const visualTime = ((Date.now() - visualStartTime) / 1000).toFixed(1);
    console.log(`   ✅ 完成！耗时: ${visualTime}秒\n`);
    
    // Step 5: 质量审核
    console.log('✅ Step 5: 质量审核');
    const qualityStartTime = Date.now();
    
    const qualityPromises = [];
    
    for (const { task, result: content } of contentResults) {
      const visual = visualResults.find(v => v.task.id === task.id);
      
      qualityPromises.push(
        sessions_send({
          sessionKey: "quality-reviewer",
          message: `审核内容，主题：${task.topic}，角度：${task.perspective}，\n\n内容：${content.substring(0, 300)}\n\n视觉：${JSON.stringify(visual.result)}`
        }).then(r => ({ task, result: r }))
      );
    }
    
    const qualityResults = await Promise.all(qualityPromises);
    
    const qualityTime = ((Date.now() - qualityStartTime) / 1000).toFixed(1);
    console.log(`   ✅ 完成！耗时: ${qualityTime}秒\n`);
    
    // Step 6: 整合结果
    const totalTime = ((Date.now() - startTime) / 1000).toFixed(1);
    console.log(`🎉 批量生成完成！总耗时: ${totalTime}秒\n`);
    
    return formatBatchReport(tasks, contentResults, visualResults, qualityResults);
    
  } catch (error) {
    console.error(`❌ 批量生成失败: ${error.message}`);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * 辅助函数
 */
function getPlatformForFormat(format) {
  const platforms = {
    '图文': '小红书',
    '视频': '抖音',
    '文章': '微信'
  };
  return platforms[format] || '小红书';
}

function getToneForAngle(angle) {
  const tones = {
    '职场新人': '友好',
    '程序员': '专业',
    '学生党': '轻松',
    '自由职业': '活泼',
    '企业主': '权威'
  };
  return tones[angle] || '友好';
}

function getLengthForFormat(format) {
  const lengths = {
    '图文': '150-200字',
    '视频': '60秒',
    '文章': '1000-1500字'
  };
  return lengths[format] || '150-200字';
}

/**
 * 格式化批量报告
 */
function formatBatchReport(tasks, contentResults, visualResults, qualityResults) {
  let output = `🎯 批量生成报告\n\n`;
  output += `📝 主题: ${tasks[0]?.topic || '未指定'}\n`;
  output += `📊 总任务数: ${tasks.length}\n\n`;
  output += `## 生成内容\n\n`;
  
  contentResults.forEach(({ task, result }, index) => {
    const visual = visualResults.find(v => v.task.id === task.id);
    const quality = qualityResults.find(q => q.task.id === task.id);
    
    output += `### ${index + 1}. ${task.perspective} - ${task.platform} ${task.format}\n\n`;
    output += `✍️  文案 (${result.length}字):\n`;
    output += `${result.substring(0, 150)}...\n\n`;
    
    if (visual && visual.result) {
      output += `🎨 视觉: ${visual.result.substring(0, 100)}...\n\n`;
    }
    
    if (quality && quality.result) {
      const q = JSON.parse(quality.result);
      output += `✅ 质量评分: ${q.overall_score}/100 (${q.grade})\n\n`;
    }
    
    output += `---\n\n`;
  });
  
  // 统计
  const avgScore = qualityResults
    .map(q => JSON.parse(q.result))
    .reduce((sum, q) => sum + q.overall_score, 0) / qualityResults.length;
  
  output += `📊 统计\n`;
  output += `- 总生成: ${contentResults.length}篇\n`;
  output += `- 平均分: ${avgScore.toFixed(1)}/100\n`;
  output += `- 成功率: 100%\n`;
  
  return {
    success: true,
    formatted: output,
    summary: {
      total: contentResults.length,
      avgScore: avgScore.toFixed(1)
    }
  };
}

// 导出
module.exports = {
  batchProduce,
  parseNaturalLanguage
};

// 如果直接运行
if (require.main === module) {
  const testInput = process.argv[2] || '批量生成 5 篇关于AI工具的文案，包括职场新人、程序员、学生党等角度';
  
  batchProduce(testInput)
    .then(result => {
      console.log('\n');
      console.log('='.repeat(60));
      console.log('📊 最终报告');
      console.log('='.repeat(60));
      console.log('\n');
      console.log(result.formatted);
    })
    .catch(error => {
      console.error('\n❌ 失败:', error);
      process.exit(1);
    });
}
