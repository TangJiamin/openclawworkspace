/**
 * Refly Workflow Generator Hook
 * Main handler for intercepting and processing workflow creation requests
 */

import { HookContext } from '@openclaw/gateway';
import { ReflyClient } from './lib/refly-client.js';
import { getOpenClawTools } from './lib/tools-registry.js';
import { convertToCronJob, formatCronJob } from './lib/workflow-converter.js';
import { executeWorkflow, formatExecutionResult } from './lib/workflow-executor.js';
import {
  detectWorkflowIntent,
  extractWorkflowParams,
  formatIntentResult,
} from './lib/intent-detector.js';

// Configuration from environment
const REFLY_URL = process.env.REFLY_URL || 'http://refly.kmos.ai';
const REFLY_API_KEY = process.env.REFLY_API_KEY || '';
const REFLY_MODEL = process.env.REFLY_MODEL || 'refly-latest';
const REFLY_TIMEOUT = parseInt(process.env.REFLY_TIMEOUT || '30000', 10);
const CONFIDENCE_THRESHOLD = parseFloat(process.env.REFLY_CONFIDENCE_THRESHOLD || '0.8');

// Conversation state storage (in production, use Redis or database)
const conversationState = new Map<string, any>();

/**
 * Main hook handler
 */
export async function handler(ctx: HookContext): Promise<void> {
  const { event, gateway } = ctx;

  // Only handle message events
  if (event.type !== 'message') {
    return;
  }

  const { content, sessionId, channel, userId } = event;

  // Skip empty messages
  if (!content || !content.trim()) {
    return;
  }

  console.log(`[Refly Hook] Processing message from session ${sessionId}`);

  // Check if this is a continuation of a previous conversation
  if (conversationState.has(sessionId)) {
    await handleConversationContinuation(ctx, content, sessionId);
    return;
  }

  // Detect workflow creation intent
  const intent = detectWorkflowIntent(content);

  console.log(`[Refly Hook] Intent detection: confidence=${intent.confidence}, isWorkflow=${intent.isWorkflowRequest}`);

  // Log intent detection for debugging
  if (process.env.DEBUG === 'true') {
    console.log(formatIntentResult(intent, content));
  }

  // If not a workflow request, exit
  if (!intent.isWorkflowRequest) {
    return;
  }

  // Process workflow creation request
  await handleWorkflowCreation(ctx, content, sessionId, channel);
}

/**
 * Handle workflow creation request
 */
async function handleWorkflowCreation(
  ctx: HookContext,
  content: string,
  sessionId: string,
  channel: string
): Promise<void> {
  const { gateway } = ctx;

  try {
    // Send processing message
    await gateway.message.send({
      channel,
      message: '🤖 正在分析您的需求，请稍候...',
    });

    // Initialize Refly client
    if (!REFLY_API_KEY) {
      throw new Error('REFLY_API_KEY not configured');
    }

    const refly = new ReflyClient({
      baseURL: REFLY_URL,
      apiKey: REFLY_API_KEY,
      model: REFLY_MODEL,
      timeout: REFLY_TIMEOUT,
    });

    // Check Refly health
    const isHealthy = await refly.healthCheck();
    if (!isHealthy) {
      throw new Error('Refly service is not responding');
    }

    // Parse workflow from natural language
    const parseResult = await refly.parseWorkflow(content, {
      availableTools: getOpenClawTools(),
      history: [], // Could load user's workflow history here
    });

    console.log(`[Refly Hook] Parse result: confidence=${parseResult.confidence}`);

    // Check if clarification is needed
    if (parseResult.confidence < CONFIDENCE_THRESHOLD || parseResult.clarifications.length > 0) {
      await requestClarification(ctx, parseResult, sessionId, channel);
      return;
    }

    // Convert to cron job
    const conversion = convertToCronJob(parseResult.workflow);

    if (!conversion.success) {
      throw new Error(`Workflow conversion failed: ${conversion.errors.join(', ')}`);
    }

    // Log warnings
    if (conversion.warnings.length > 0) {
      console.warn(`[Refly Hook] Conversion warnings:`, conversion.warnings);
    }

    // Create cron job
    const cronJob = conversion.cronJob!;
    await gateway.cron.add({
      job: cronJob,
    });

    console.log(`[Refly Hook] Cron job created: ${cronJob.name}`);

    // Send success message
    const successMessage = formatSuccessMessage(parseResult, cronJob, conversion.warnings);
    await gateway.message.send({
      channel,
      message: successMessage,
    });

    // Optional: Test run the workflow
    if (process.env.REFLY_AUTO_TEST === 'true') {
      await testWorkflow(ctx, parseResult.workflow, sessionId, channel);
    }

  } catch (error: any) {
    console.error(`[Refly Hook] Error:`, error);

    await gateway.message.send({
      channel,
      message: formatErrorMessage(error),
    });
  }
}

/**
 * Request clarification from user
 */
async function requestClarification(
  ctx: HookContext,
  parseResult: any,
  sessionId: string,
  channel: string
): Promise<void> {
  const { gateway } = ctx;

  // Store conversation state
  conversationState.set(sessionId, {
    parseResult,
    startTime: Date.now(),
  });

  let message = '🤔 我需要更多信息来创建工作流：\n\n';

  if (parseResult.clarifications.length > 0) {
    message += '❓ 请确认以下问题：\n';
    for (let i = 0; i < parseResult.clarifications.length; i++) {
      message += `${i + 1}. ${parseResult.clarifications[i]}\n`;
    }
  }

  message += '\n💬 请回复您的选择，或说"取消"放弃创建。';

  await gateway.message.send({
    channel,
    message,
  });
}

/**
 * Handle conversation continuation
 */
async function handleConversationContinuation(
  ctx: HookContext,
  content: string,
  sessionId: string
): Promise<void> {
  const { gateway } = ctx;
  const state = conversationState.get(sessionId);

  // Check if user wants to cancel
  if (content.toLowerCase().includes('取消') || content.toLowerCase().includes('cancel')) {
    conversationState.delete(sessionId);
    await gateway.message.send({
      channel: ctx.event.channel,
      message: '❌ 已取消工作流创建',
    });
    return;
  }

  try {
    // Continue conversation with Refly
    const refly = new ReflyClient({
      baseURL: REFLY_URL,
      apiKey: REFLY_API_KEY!,
      model: REFLY_MODEL,
      timeout: REFLY_TIMEOUT,
    });

    const response = await refly.continueConversation(
      sessionId,
      content,
      'workflow-creation'
    );

    console.log(`[Refly Hook] Conversation response:`, response);

    // Check if conversation is finished
    if (response.finished && response.workflow) {
      // Clear conversation state
      conversationState.delete(sessionId);

      // Convert and create cron job
      const conversion = convertToCronJob(response.workflow);

      if (!conversion.success) {
        throw new Error(`Workflow conversion failed: ${conversion.errors.join(', ')}`);
      }

      const cronJob = conversion.cronJob!;
      await gateway.cron.add({
        job: cronJob,
      });

      await gateway.message.send({
        channel: ctx.event.channel,
        message: `✅ 工作流已创建：**${cronJob.name}**\n\n${formatCronJob(cronJob)}`,
      });

    } else {
      // Continue conversation
      let message = response.message;

      if (response.questions && response.questions.length > 0) {
        message += '\n\n请选择：\n';
        for (let i = 0; i < response.questions.length; i++) {
          message += `${i + 1}. ${response.questions[i]}\n`;
        }
      }

      await gateway.message.send({
        channel: ctx.event.channel,
        message,
      });
    }

  } catch (error: any) {
    console.error(`[Refly Hook] Conversation error:`, error);
    conversationState.delete(sessionId);

    await gateway.message.send({
      channel: ctx.event.channel,
      message: `❌ 对话出错：${error.message}`,
    });
  }
}

/**
 * Test run a workflow
 */
async function testWorkflow(
  ctx: HookContext,
  workflow: any,
  sessionId: string,
  channel: string
): Promise<void> {
  const { gateway } = ctx;

  try {
    await gateway.message.send({
      channel,
      message: '🧪 正在测试运行工作流...',
    });

    const result = await executeWorkflow(workflow, {
      sessionId,
      channel,
      gateway,
    });

    const testMessage = formatExecutionResult(result);
    await gateway.message.send({
      channel,
      message: testMessage,
    });

  } catch (error: any) {
    console.error(`[Refly Hook] Test run error:`, error);
  }
}

/**
 * Format success message
 */
function formatSuccessMessage(
  parseResult: any,
  cronJob: any,
  warnings: string[]
): string {
  let message = '✅ **工作流已创建**\n\n';

  message += `📋 **名称**: ${parseResult.workflow.name}\n`;
  message += `📊 **置信度**: ${Math.round(parseResult.confidence * 100)}%\n\n`;

  message += formatCronJob(cronJob);

  if (warnings.length > 0) {
    message += `\n⚠️ **注意事项**:\n`;
    for (const warning of warnings) {
      message += `  - ${warning}\n`;
    }
  }

  message += `\n💡 **提示**: 您可以使用以下命令管理工作流：\n`;
  message += `  - \`openclaw cron list\` 查看所有工作流\n`;
  message += `  - \`openclaw cron run ${cronJob.name}\` 立即运行\n`;
  message += `  - \`openclaw cron remove ${cronJob.name}\` 删除工作流\n`;

  return message;
}

/**
 * Format error message
 */
function formatErrorMessage(error: any): string {
  let message = '❌ **创建工作流失败**\n\n';

  if (error.message.includes('API key')) {
    message += '🔑 Refly API 密钥未配置或无效。\n\n';
    message += '请在 gateway.env 中设置 REFLY_API_KEY';
  } else if (error.message.includes('timeout')) {
    message += '⏱️ Refly API 请求超时，请稍后重试。';
  } else if (error.message.includes('not responding')) {
    message += '🔴 Refly 服务无响应，请检查服务状态。';
  } else {
    message += `错误详情: ${error.message}`;
  }

  return message;
}

/**
 * Cleanup old conversation states (call periodically)
 */
export function cleanupConversations(maxAge: number = 3600000): void {
  const now = Date.now();
  for (const [sessionId, state] of conversationState.entries()) {
    if (now - state.startTime > maxAge) {
      conversationState.delete(sessionId);
      console.log(`[Refly Hook] Cleaned up expired conversation: ${sessionId}`);
    }
  }
}

// Run cleanup every 10 minutes
if (typeof setInterval !== 'undefined') {
  setInterval(() => cleanupConversations(), 600000);
}
