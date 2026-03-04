#!/usr/bin/env node
/**
 * Orchestrator - 真正的多 Agent 编排器
 * 
 * 通过 sessions_spawn 创建独立的 Agent sessions
 * 实现真正的多 Agent 协同工作
 */

/**
 * 主执行函数
 * @param {string} userInput - 用户需求
 * @returns {object} 执行结果
 */
async function orchestrate(userInput) {
  console.log('🎯 Orchestrator 启动');
  console.log(`📝 输入: ${userInput}`);
  console.log('');
  
  const startTime = Date.now();
  const results = {};
  
  try {
    // Step 1: 分析需求，制定执行计划
    console.log('📋 Step 1: 分析需求');
    const plan = createExecutionPlan(userInput);
    console.log(`   执行模式: ${plan.workflow}`);
    console.log(`   需要 Agents: ${plan.agents.join(' → ')}`);
    console.log('');
    
    // Step 2: 依次创建和调用 Agents
    let previousResult = null;
    
    for (const agentName of plan.agents) {
      console.log(`🤖 Step ${results.length + 2}: ${agentName}`);
      
      // 创建独立的 Agent session
      const agentResult = await spawnAgent(agentName, userInput, previousResult);
      
      // 记录结果
      results[agentName] = agentResult;
      previousResult = agentResult;
      
      console.log(`   ✅ 完成`);
      console.log('');
    }
    
    // Step 3: 整合结果
    const finalResult = formatResults(results, userInput);
    
    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    console.log(`🎉 执行完成！耗时: ${duration}秒`);
    console.log('');
    
    return finalResult;
    
  } catch (error) {
    console.error(`❌ 执行失败: ${error.message}`);
    return {
      success: false,
      error: error.message,
      partial_results: results
    };
  }
}

/**
 * 创建执行计划
 */
function createExecutionPlan(userInput) {
  // 检测需求类型
  const hasVideo = userInput.includes('视频') || userInput.includes('抖音');
  const hasImage = userInput.includes('图片') || userInput.includes('配图') || userInput.includes('小红书');
  
  let agents = [];
  
  // 基础流程
  agents.push('requirement-agent');
  agents.push('research-agent');
  agents.push('content-agent');
  
  // 根据类型添加
  if (hasVideo) {
    agents.push('video-agent');
  } else if (hasImage) {
    agents.push('visual-agent');
  }
  
  // 质量审核
  agents.push('quality-agent');
  
  return {
    workflow: hasVideo ? 'video' : 'standard',
    agents: agents
  };
}

/**
 * 创建独立的 Agent session
 * 
 * 这是核心！每个 Agent 都是真正的独立 session
 */
async function spawnAgent(agentName, originalInput, previousResult) {
  // 构建 Agent 的任务描述
  const taskPrompt = buildAgentTask(agentName, originalInput, previousResult);
  
  console.log(`   📤 创建 ${agentName} session...`);
  
  // 使用 sessions_spawn 创建独立的 Agent session
  // 注意：这是在 OpenClaw 环境中执行，需要调用 sessions_spawn 工具
  const spawnResult = await sessions_spawn({
    task: taskPrompt,
    label: agentName,
    agentId: 'main',  // 使用 main agent 作为基础
    timeout: getAgentTimeout(agentName),
    thinking: 'low',  // 子 Agent 不需要深度思考
    cleanup: 'keep',  // 保持 session，可以后续交互
    runTimeoutSeconds: getAgentTimeout(agentName)
  });
  
  // 解析 Agent 的返回结果
  return parseAgentResult(spawnResult, agentName);
}

/**
 * 构建 Agent 任务描述
 */
function buildAgentTask(agentName, originalInput, previousResult) {
  const tasks = {
    'requirement-agent': {
      role: '需求理解专家',
      task: `分析以下用户需求，生成结构化的任务规范。

用户需求: ${originalInput}

请提取:
1. 内容类型 (文案/图片/视频)
2. 目标平台 (小红书/抖音/微信)
3. 主题内容
4. 风格和调性
5. 长度要求

返回 JSON 格式。`
    },
    
    'research-agent': {
      role: '资料收集专家',
      task: `基于以下任务规范，收集相关资料。

任务规范: ${JSON.stringify(previousResult)}

请使用 metaso-search 搜索相关资料，提取至少 5 个关键信息点。

返回结构化的资料数组。`
    },
    
    'content-agent': {
      role: '内容生产专家',
      task: `基于以下需求和资料，生成高质量内容。

任务规范: ${JSON.stringify(previousResult?.task_spec || previousResult)}
资料: ${JSON.stringify(previousResult?.materials || [])}

请生成符合平台规范的内容，包括:
1. 吸引人的标题
2. 完整的正文
3. 相关话题标签

返回完整的内容。`
    },
    
    'visual-agent': {
      role: '视觉生成专家',
      task: `基于以下内容，生成视觉参数建议。

内容: ${JSON.stringify(previousResult)}

请分析内容类型，推荐:
1. 风格 (style)
2. 布局 (layout)
3. 配色 (palette)
4. 生成提示词

返回视觉参数 JSON。`
    },
    
    'video-agent': {
      role: '视频生成专家',
      task: `基于以下内容，生成视频分镜。

内容: ${JSON.stringify(previousResult)}

请设计:
1. 时间轴 (60秒)
2. 场景划分
3. 镜头描述
4. 分镜提示词

返回视频分镜方案。`
    },
    
    'quality-agent': {
      role: '质量审核专家',
      task: `对以下内容进行多维度质量审核。

内容: ${JSON.stringify(previousResult)}

请检查:
1. 内容质量 (连贯性/准确性/可读性/吸引力) - 40分
2. 平台合规 (敏感词/版权/格式) - 30分
3. 品牌一致性 (调性/视觉) - 20分
4. 用户要求匹配 (长度/格式) - 10分

返回质量评分和审核报告。`
    }
  };
  
  const taskConfig = tasks[agentName];
  if (!taskConfig) {
    throw new Error(`未知的 Agent: ${agentName}`);
  }
  
  return `你是 ${taskConfig.role} (${agentName})

${taskConfig.task}

重要:
- 只返回结果，不要解释
- 使用 JSON 或结构化格式
- 保持简洁和专业`;
}

/**
 * 获取 Agent 超时时间
 */
function getAgentTimeout(agentName) {
  const timeouts = {
    'requirement-agent': 60,
    'research-agent': 120,
    'content-agent': 90,
    'visual-agent': 60,
    'video-agent': 120,
    'quality-agent': 30
  };
  return timeouts[agentName] || 60;
}

/**
 * 解析 Agent 结果
 */
function parseAgentResult(spawnResult, agentName) {
  // sessions_spawn 返回的结果格式
  // 需要根据实际情况解析
  
  if (typeof spawnResult === 'string') {
    try {
      return JSON.parse(spawnResult);
    } catch {
      return { raw_result: spawnResult };
    }
  }
  
  return spawnResult;
}

/**
 * 格式化最终结果
 */
function formatResults(results, originalInput) {
  let output = `🎯 生成结果\n\n`;
  output += `📝 原始需求: ${originalInput}\n\n`;
  
  // requirement-agent
  if (results['requirement-agent']) {
    output += `📋 任务规范:\n`;
    output += JSON.stringify(results['requirement-agent'], null, 2) + '\n\n';
  }
  
  // research-agent
  if (results['research-agent']) {
    const materials = results['research-agent'];
    output += `📚 收集资料: ${materials.length || 0} 条\n\n`;
  }
  
  // content-agent
  if (results['content-agent']) {
    const content = results['content-agent'];
    output += `✍️  生成内容:\n`;
    if (content.title) output += `${content.title}\n`;
    if (content.body) output += `${content.body}\n`;
    if (content.hashtags) output += `${content.hashtags.join(' ')}\n`;
    output += `\n`;
  }
  
  // visual-agent
  if (results['visual-agent']) {
    output += `🎨 视觉参数:\n`;
    output += JSON.stringify(results['visual-agent'], null, 2) + '\n\n';
  }
  
  // video-agent
  if (results['video-agent']) {
    output += `🎬 视频分镜:\n`;
    output += JSON.stringify(results['video-agent'], null, 2) + '\n\n';
  }
  
  // quality-agent
  if (results['quality-agent']) {
    const quality = results['quality-agent'];
    output += `✅ 质量审核:\n`;
    output += `评分: ${quality.overall_score || 'N/A'}/100\n`;
    if (quality.grade) output += `等级: ${quality.grade}\n`;
    if (quality.passed !== undefined) output += `状态: ${quality.passed ? '通过' : '不通过'}\n`;
    output += `\n`;
  }
  
  return {
    success: true,
    formatted: output,
    raw: results
  };
}

// 导出
module.exports = {
  orchestrate,
  spawnAgent,
  createExecutionPlan
};

// 如果直接运行（测试）
if (require.main === module) {
  const testInput = process.argv[2] || '生成小红书内容，推荐5个提升效率的AI工具';
  
  orchestrate(testInput)
    .then(result => {
      console.log('=== 最终结果 ===');
      console.log(result.formatted || JSON.stringify(result, null, 2));
    })
    .catch(error => {
      console.error('执行失败:', error);
      process.exit(1);
    });
}
