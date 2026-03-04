#!/usr/bin/env node

/**
 * Agent 矩阵编排器
 * 真正的多 Agent 协同系统 - 通过 sessions_spawn 创建独立 Agent sessions
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// 配置
const CONFIG = {
  // Agent 定义
  agents: {
    'requirement-agent': {
      name: '需求理解 Agent',
      skill: 'requirement-analyzer',
      timeout: 60,
      description: '将自然语言需求转化为结构化任务规范'
    },
    'research-agent': {
      name: '资料收集 Agent',
      skill: 'material-collector', // 新建
      timeout: 120,
      description: '收集网络资讯、技术文档、飞书资料'
    },
    'content-agent': {
      name: '内容策划 Agent',
      skill: 'content-planner',
      timeout: 90,
      description: '生成内容策略和执行计划'
    },
    'visual-agent': {
      name: '视觉生成 Agent',
      skill: 'visual-generator',
      timeout: 60,
      description: '生成图片、信息图、封面'
    },
    'video-agent': {
      name: '视频生成 Agent',
      skill: 'seedance-storyboard',
      timeout: 120,
      description: '生成分镜提示词和视频'
    },
    'quality-agent': {
      name: '质量审核 Agent',
      skill: 'quality-reviewer',
      timeout: 30,
      description: '多维度质量检查和修改建议'
    }
  },

  // 工作流定义
  workflows: {
    // 线性流水线（最常用）
    'linear': [
      'requirement-agent',
      'research-agent',
      'content-agent',
      'visual-agent',
      'quality-agent'
    ],

    // 并行分支（多平台）
    'parallel': {
      'branch1': ['requirement-agent', 'research-agent', 'content-agent'],
      'branch2': ['visual-agent'],
      'branch3': ['video-agent'],
      'merge': 'quality-agent'
    },

    // 智能路由
    'router': {
      '文案-only': ['requirement-agent', 'research-agent', 'content-agent', 'quality-agent'],
      '图片-only': ['requirement-agent', 'visual-agent', 'quality-agent'],
      '视频-only': ['requirement-agent', 'video-agent', 'quality-agent'],
      'full': ['requirement-agent', 'research-agent', 'content-agent', 'visual-agent', 'quality-agent']
    }
  }
};

/**
 * 调用 openclaw sessions_spawn
 */
function spawnAgent(agentId, task, timeout) {
  const agent = CONFIG.agents[agentId];

  console.log(`\n🚀 启动 ${agent.name} (${agentId})`);
  console.log(`   任务: ${task.substring(0, 100)}...`);
  console.log(`   超时: ${timeout}秒`);

  try {
    // 构建 sessions_spawn 命令
    const cmd = `openclaw sessions spawn \
      --agent-id "${agentId}" \
      --task "${task}" \
      --timeout ${timeout} \
      --cleanup keep`;

    // 执行命令
    const result = execSync(cmd, {
      encoding: 'utf-8',
      stdio: 'pipe',
      timeout: timeout * 1000
    });

    console.log(`✅ ${agent.name} 完成`);
    return result;
  } catch (error) {
    console.error(`❌ ${agent.name} 失败: ${error.message}`);
    throw error;
  }
}

/**
 * 线性工作流执行
 */
async function executeLinearWorkflow(userInput) {
  console.log('\n📋 执行线性工作流');
  console.log('=' .repeat(60));

  const workflow = CONFIG.workflows['linear'];
  let context = { userInput };

  for (const agentId of workflow) {
    const agent = CONFIG.agents[agentId];

    // 构建任务（传递上下文）
    const task = JSON.stringify({
      input: context,
      agentRole: agent.description
    });

    try {
      const result = spawnAgent(agentId, task, agent.timeout);

      // 更新上下文（解析结果）
      context[agentId] = parseAgentResult(result);
    } catch (error) {
      console.error(`工作流中断于 ${agent.name}`);
      throw error;
    }
  }

  return context;
}

/**
 * 解析 Agent 返回结果
 */
function parseAgentResult(rawResult) {
  try {
    // 尝试解析 JSON
    return JSON.parse(rawResult);
  } catch {
    // 如果不是 JSON，返回原始文本
    return { raw: rawResult };
  }
}

/**
 * 格式化输出
 */
function formatOutput(context) {
  console.log('\n' + '='.repeat(60));
  console.log('🎯 Agent 矩阵执行结果');
  console.log('='.repeat(60));

  // 任务规范
  if (context['requirement-agent']) {
    console.log('\n📋 任务规范:');
    console.log(JSON.stringify(context['requirement-agent'], null, 2));
  }

  // 收集资料
  if (context['research-agent']) {
    console.log('\n📚 收集资料:');
    const research = context['research-agent'];
    console.log(`   数量: ${research.count || '未知'}`);
    console.log(`   来源: ${research.sources || '未知'}`);
  }

  // 内容策略
  if (context['content-agent']) {
    console.log('\n✍️  内容策略:');
    const content = context['content-agent'];
    console.log(`   类型: ${content.type || '未知'}`);
    console.log(`   大纲: ${content.outline || '未知'}`);
  }

  // 视觉参数
  if (context['visual-agent']) {
    console.log('\n🎨 视觉参数:');
    console.log(JSON.stringify(context['visual-agent'], null, 2));
  }

  // 质量报告
  if (context['quality-agent']) {
    console.log('\n✅ 质量报告:');
    const quality = context['quality-agent'];
    console.log(`   评分: ${quality.score || '未知'}/100`);
    console.log(`   状态: ${quality.passed ? '通过' : '不通过'}`);
  }

  console.log('\n' + '='.repeat(60));
}

/**
 * 主函数
 */
async function main() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.log('用法: node orchestrator.js "<用户需求>"');
    console.log('');
    console.log('示例:');
    console.log('  node orchestrator.js "生成小红书内容，推荐5个AI工具"');
    console.log('  node orchestrator.js "制作抖音视频，介绍ChatGPT技巧"');
    process.exit(1);
  }

  const userInput = args.join(' ');

  console.log('\n🎬 Agent 矩阵启动');
  console.log('用户需求:', userInput);
  console.log('时间:', new Date().toISOString());

  try {
    // 执行线性工作流
    const context = await executeLinearWorkflow(userInput);

    // 格式化输出
    formatOutput(context);

    console.log('\n✅ Agent 矩阵执行完成');
  } catch (error) {
    console.error('\n❌ Agent 矩阵执行失败:', error.message);
    process.exit(1);
  }
}

// 运行
if (require.main === module) {
  main();
}

module.exports = { CONFIG, executeLinearWorkflow };
