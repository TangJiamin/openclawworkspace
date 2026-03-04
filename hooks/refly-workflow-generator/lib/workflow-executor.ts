/**
 * Workflow Executor
 * Executes Refly workflows using OpenClaw tools
 */

import { Workflow, WorkflowStep } from './refly-client.js';
import { getToolById, validateToolInput } from './tools-registry.js';

export interface ExecutionContext {
  sessionId: string;
  channel?: string;
  gateway?: any; // OpenClaw gateway interface
}

export interface StepResult {
  stepIndex: number;
  success: boolean;
  result?: any;
  error?: string;
  duration: number;
}

export interface ExecutionResult {
  workflow: string;
  success: boolean;
  steps: StepResult[];
  totalDuration: number;
  output?: any;
}

/**
 * Execute a complete workflow
 */
export async function executeWorkflow(
  workflow: Workflow,
  context: ExecutionContext
): Promise<ExecutionResult> {
  const startTime = Date.now();
  const steps: StepResult[] = [];
  const stepResults: any[] = [];

  console.log(`[Workflow] Starting execution: ${workflow.name}`);

  for (let i = 0; i < workflow.steps.length; i++) {
    const step = workflow.steps[i];
    const stepStartTime = Date.now();

    console.log(`[Workflow] Executing step ${i + 1}/${workflow.steps.length}: ${step.toolId}`);

    try {
      // Resolve template variables
      const resolvedInput = resolveVariables(step.input, stepResults);

      // Validate step
      const validation = validateToolInput(step.toolId, resolvedInput);
      if (!validation.valid) {
        throw new Error(`Invalid input: ${validation.errors.join(', ')}`);
      }

      // Execute step
      const result = await executeStep(step, resolvedInput, context);

      const stepResult: StepResult = {
        stepIndex: i,
        success: true,
        result,
        duration: Date.now() - stepStartTime,
      };

      steps.push(stepResult);
      stepResults.push(result);

      console.log(
        `[Workflow] Step ${i + 1} completed in ${stepResult.duration}ms`
      );
    } catch (error: any) {
      const stepResult: StepResult = {
        stepIndex: i,
        success: false,
        error: error.message,
        duration: Date.now() - stepStartTime,
      };

      steps.push(stepResult);

      // Check if we should continue on error
      if (step.retry && step.retry > 0) {
        console.log(`[Workflow] Step ${i + 1} failed, retrying...`);
        // Implement retry logic here
      } else {
        console.error(`[Workflow] Step ${i + 1} failed: ${error.message}`);
        // Stop execution on error
        break;
      }
    }
  }

  const totalDuration = Date.now() - startTime;
  const allSuccessful = steps.every(s => s.success);

  console.log(
    `[Workflow] Execution completed: ${allSuccessful ? 'SUCCESS' : 'FAILED'} in ${totalDuration}ms`
  );

  return {
    workflow: workflow.name,
    success: allSuccessful,
    steps,
    totalDuration,
    output: stepResults[stepResults.length - 1], // Last step result
  };
}

/**
 * Execute a single workflow step
 */
async function executeStep(
  step: WorkflowStep,
  input: any,
  context: ExecutionContext
): Promise<any> {
  const tool = getToolById(step.toolId);
  if (!tool) {
    throw new Error(`Unknown tool: ${step.toolId}`);
  }

  // This is where we'd integrate with OpenClaw's tool system
  // For now, we'll simulate the execution
  console.log(`[Workflow] Executing tool: ${tool.id}`);
  console.log(`[Workflow] Input:`, JSON.stringify(input, null, 2));

  // In the actual implementation, this would call OpenClaw tools
  // For example:
  // switch (step.toolId) {
  //   case 'message':
  //     return await context.gateway.message.send(input);
  //   case 'web_search':
  //     return await context.gateway.web_search(input);
  //   // ... etc
  // }

  // Simulated execution for demo
  return simulateToolExecution(step.toolId, input);
}

/**
 * Simulate tool execution (for demo purposes)
 * In production, replace with actual OpenClaw tool calls
 */
async function simulateToolExecution(toolId: string, input: any): Promise<any> {
  // Simulate network delay
  await new Promise(resolve => setTimeout(resolve, 500));

  switch (toolId) {
    case 'message':
      return {
        success: true,
        channel: input.channel,
        messageId: `msg_${Date.now()}`,
        delivered: true,
      };

    case 'web_search':
      return {
        results: [
          {
            title: '北京天气预报',
            url: 'https://weather.example.com',
            snippet: '今天北京晴，温度 15-25°C',
          },
        ],
        count: 1,
      };

    case 'weather':
      return {
        city: input.city || '北京',
        temp: 20,
        condition: '晴',
        humidity: 45,
        unit: input.unit || 'celsius',
      };

    case 'web_fetch':
      return {
        url: input.url,
        content: 'Example page content...',
        extracted: true,
      };

    case 'exec':
      return {
        exitCode: 0,
        stdout: `Executed: ${input.command}`,
        stderr: '',
      };

    default:
      return {
        tool: toolId,
        input,
        executed: true,
        timestamp: new Date().toISOString(),
      };
  }
}

/**
 * Resolve template variables in input
 * Supports: {{step1.result}}, {{step1.result.weather.temp}}, etc.
 */
function resolveVariables(input: any, stepResults: any[]): any {
  if (typeof input === 'string') {
    // Replace template variables
    return input.replace(/\{\{step(\d+)\.result(.*)\}\}/g, (_, stepNum, path) => {
      const index = parseInt(stepNum) - 1;
      if (index < 0 || index >= stepResults.length) {
        return `{{ERROR: Invalid step reference ${stepNum}}}`;
      }

      let value = stepResults[index];
      if (path) {
        // Navigate the path (e.g., ".weather.temp")
        try {
          const keys = path.split('.').filter(k => k);
          for (const key of keys) {
            value = value[key];
          }
        } catch {
          return `{{ERROR: Cannot resolve path ${path}}}`;
        }
      }

      return typeof value === 'object' ? JSON.stringify(value) : String(value);
    });
  }

  if (Array.isArray(input)) {
    return input.map(item => resolveVariables(item, stepResults));
  }

  if (typeof input === 'object' && input !== null) {
    const resolved: any = {};
    for (const [key, value] of Object.entries(input)) {
      resolved[key] = resolveVariables(value, stepResults);
    }
    return resolved;
  }

  return input;
}

/**
 * Format execution result for display
 */
export function formatExecutionResult(result: ExecutionResult): string {
  let output = `\n📊 **工作流执行报告: ${result.workflow}**\n\n`;

  // Overall status
  output += `状态: ${result.success ? '✅ 成功' : '❌ 失败'}\n`;
  output += `总耗时: ${result.totalDuration}ms\n\n`;

  // Step details
  output += `📝 执行步骤:\n`;
  for (const step of result.steps) {
    const icon = step.success ? '✅' : '❌';
    output += `  ${icon} 步骤 ${step.stepIndex + 1}: ${step.duration}ms`;

    if (!step.success && step.error) {
      output += ` (${step.error})`;
    }

    output += `\n`;
  }

  // Final output
  if (result.output) {
    output += `\n📤 输出:\n`;
    output += `\`\`\`\n${JSON.stringify(result.output, null, 2)}\n\`\`\`\n`;
  }

  return output;
}

/**
 * Get workflow statistics
 */
export function getWorkflowStats(result: ExecutionResult): {
  totalSteps: number;
  successfulSteps: number;
  failedSteps: number;
  avgStepDuration: number;
} {
  const totalSteps = result.steps.length;
  const successfulSteps = result.steps.filter(s => s.success).length;
  const failedSteps = totalSteps - successfulSteps;
  const avgStepDuration = result.totalDuration / totalSteps;

  return {
    totalSteps,
    successfulSteps,
    failedSteps,
    avgStepDuration,
  };
}
