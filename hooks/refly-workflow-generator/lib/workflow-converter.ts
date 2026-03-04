/**
 * Workflow Converter
 * Converts Refly workflows to OpenClaw cron jobs
 */

import { Workflow, WorkflowStep, WorkflowTrigger } from './refly-client.js';

export interface CronJobDefinition {
  name: string;
  schedule: {
    kind: 'cron' | 'every' | 'at';
    expr?: string;
    everyMs?: number;
    at?: string;
  };
  payload: {
    kind: 'systemEvent' | 'agentTurn';
    text?: string;
    message?: string;
  };
  sessionTarget: 'main' | 'isolated';
  enabled: boolean;
}

export interface ConversionResult {
  success: boolean;
  cronJob?: CronJobDefinition;
  warnings: string[];
  errors: string[];
}

/**
 * Convert Refly workflow to OpenClaw cron job
 */
export function convertToCronJob(workflow: Workflow): ConversionResult {
  const warnings: string[] = [];
  const errors: string[] = [];

  try {
    // Validate workflow
    if (!workflow.name) {
      errors.push('Workflow name is required');
      return { success: false, warnings, errors };
    }

    if (!workflow.steps || workflow.steps.length === 0) {
      errors.push('Workflow must have at least one step');
      return { success: false, warnings, errors };
    }

    if (!workflow.trigger) {
      errors.push('Workflow must have a trigger');
      return { success: false, warnings, errors };
    }

    // Convert trigger
    const schedule = convertTrigger(workflow.trigger, warnings);
    if (!schedule) {
      errors.push(`Unsupported trigger type: ${workflow.trigger.type}`);
      return { success: false, warnings, errors };
    }

    // Build workflow execution payload
    const workflowData = {
      action: 'execute-refly-workflow',
      workflow: workflow.name,
      description: workflow.description,
      steps: workflow.steps,
      trigger: workflow.trigger,
    };

    // Create cron job definition
    const cronJob: CronJobDefinition = {
      name: workflow.name,
      schedule,
      payload: {
        kind: 'systemEvent',
        text: JSON.stringify(workflowData),
      },
      sessionTarget: 'main',
      enabled: true,
    };

    // Validate steps
    for (let i = 0; i < workflow.steps.length; i++) {
      const step = workflow.steps[i];
      const stepErrors = validateStep(step, i);
      errors.push(...stepErrors);
    }

    if (errors.length > 0) {
      return { success: false, warnings, errors };
    }

    return {
      success: true,
      cronJob,
      warnings,
      errors: [],
    };
  } catch (error: any) {
    errors.push(`Conversion error: ${error.message}`);
    return { success: false, warnings, errors };
  }
}

/**
 * Convert Refly trigger to OpenClaw schedule
 */
function convertTrigger(
  trigger: WorkflowTrigger,
  warnings: string[]
): CronJobDefinition['schedule'] | null {
  switch (trigger.type) {
    case 'cron':
      if (!trigger.expression) {
        warnings.push('Cron trigger missing expression, using default');
        return { kind: 'cron', expr: '0 9 * * *' };
      }
      return { kind: 'cron', expr: trigger.expression };

    case 'manual':
      warnings.push('Manual trigger will be converted to on-demand cron job');
      return { kind: 'cron', expr: '0 0 * * *' }; // Midnight

    case 'event':
      warnings.push(
        `Event triggers (${trigger.event}) are not fully supported, using cron fallback`
      );
      // Could potentially use webhooks here
      return { kind: 'cron', expr: '0 * * * *' }; // Every hour

    case 'webhook':
      warnings.push(
        'Webhook triggers require external setup, using cron fallback'
      );
      return { kind: 'cron', expr: '*/5 * * * *' }; // Every 5 minutes

    default:
      return null;
  }
}

/**
 * Validate workflow step
 */
function validateStep(step: WorkflowStep, index: number): string[] {
  const errors: string[] = [];
  const stepPrefix = `Step ${index + 1}`;

  if (!step.toolId) {
    errors.push(`${stepPrefix}: Missing toolId`);
  }

  if (!step.input) {
    errors.push(`${stepPrefix}: Missing input`);
  }

  // Check for template variables
  const inputStr = JSON.stringify(step.input);
  const variablePattern = /\{\{step(\d+)\.(.+?)\}\}/g;
  let match;
  while ((match = variablePattern.exec(inputStr)) !== null) {
    const stepNum = parseInt(match[1]);
    if (stepNum >= index + 1) {
      errors.push(
        `${stepPrefix}: Cannot reference future step ${stepNum} in variable ${match[0]}`
      );
    }
  }

  // Validate retry and timeout
  if (step.retry !== undefined && (typeof step.retry !== 'number' || step.retry < 0)) {
    errors.push(`${stepPrefix}: Invalid retry value`);
  }

  if (step.timeout !== undefined && (typeof step.timeout !== 'number' || step.timeout <= 0)) {
    errors.push(`${stepPrefix}: Invalid timeout value`);
  }

  return errors;
}

/**
 * Format cron job for display
 */
export function formatCronJob(cronJob: CronJobDefinition): string {
  let output = `📋 **${cronJob.name}**\n\n`;

  // Schedule
  output += `⏰ **触发时间**: `;
  if (cronJob.schedule.kind === 'cron' && cronJob.schedule.expr) {
    output += `\`${cronJob.schedule.expr}\`\n`;
  } else if (cronJob.schedule.kind === 'every') {
    output += `每 ${cronJob.schedule.everyMs}ms\n`;
  } else if (cronJob.schedule.kind === 'at' && cronJob.schedule.at) {
    output += `${cronJob.schedule.at}\n`;
  }

  // Status
  output += `📊 **状态**: ${cronJob.enabled ? '✅ 已启用' : '❌ 已禁用'}\n`;

  // Session target
  output += `🎯 **目标**: ${cronJob.sessionTarget === 'main' ? '主会话' : '独立会话'}\n`;

  return output;
}

/**
 * Parse workflow data from cron job payload
 */
export function parseWorkflowPayload(cronJob: CronJobDefinition): any {
  try {
    if (cronJob.payload.kind === 'systemEvent' && cronJob.payload.text) {
      return JSON.parse(cronJob.payload.text);
    }
    return null;
  } catch {
    return null;
  }
}

/**
 * Estimate next run time for cron expression
 */
export function getNextRunTime(cronExpression: string): Date {
  // Simple estimation (for demo purposes)
  // In production, use a proper cron library like 'node-cron'
  const now = new Date();
  now.setMinutes(now.getMinutes() + 1);
  return now;
}

/**
 * Validate cron expression
 */
export function validateCronExpression(expr: string): boolean {
  // Basic validation (5 parts separated by spaces)
  const parts = expr.trim().split(/\s+/);
  if (parts.length !== 5) {
    return false;
  }

  // More sophisticated validation could be added here
  return true;
}
