/**
 * Intent Detector
 * Detects if a user message is a workflow creation request
 */

export interface IntentDetectionResult {
  isWorkflowRequest: boolean;
  confidence: number;
  keywords: string[];
  suggestions?: string[];
}

/**
 * Workflow creation keywords (Chinese and English)
 */
const WORKFLOW_KEYWORDS = [
  // Chinese
  '创建工作流',
  '新建工作流',
  '添加工作流',
  '自动化',
  '定时任务',
  '每当',
  '每天',
  '每周',
  '每月',
  '帮我做一个',
  '帮我创建',
  '我要一个',
  '设置提醒',
  '设置通知',
  '发送到',
  '自动发送',
  '定时发送',
  // English
  'create workflow',
  'new workflow',
  'add workflow',
  'automation',
  'schedule',
  'every day',
  'every week',
  'every morning',
  'every night',
  'remind me',
  'send to',
  'auto send',
  'when',
  'whenever',
  'trigger',
];

/**
 * Negative keywords (phrases that indicate NOT a workflow request)
 */
const NEGATIVE_KEYWORDS = [
  '什么是',
  '如何',
  '怎么',
  'how to',
  'what is',
  'explain',
  '解释',
  '介绍',
];

/**
 * Detect if a message is a workflow creation request
 */
export function detectWorkflowIntent(message: string): IntentDetectionResult {
  const normalized = message.toLowerCase().trim();

  // Check negative keywords first
  const hasNegativeKeyword = NEGATIVE_KEYWORDS.some(kw =>
    normalized.includes(kw.toLowerCase())
  );

  if (hasNegativeKeyword) {
    return {
      isWorkflowRequest: false,
      confidence: 0.1,
      keywords: [],
    };
  }

  // Check for workflow keywords
  const matchedKeywords: string[] = [];
  for (const keyword of WORKFLOW_KEYWORDS) {
    if (normalized.includes(keyword.toLowerCase())) {
      matchedKeywords.push(keyword);
    }
  }

  // Calculate confidence based on keyword matches
  let confidence = 0;
  if (matchedKeywords.length > 0) {
    // Base confidence for having any keyword
    confidence = 0.5;

    // Increase confidence for multiple keywords
    confidence += Math.min(matchedKeywords.length * 0.15, 0.3);

    // Boost for strong keywords
    const strongKeywords = ['创建工作流', '新建工作流', 'create workflow', 'automation'];
    if (strongKeywords.some(kw => normalized.includes(kw.toLowerCase()))) {
      confidence = Math.min(confidence + 0.2, 1.0);
    }
  }

  // Check for temporal patterns (indicates scheduling intent)
  const timePatterns = [
    /\b(早上|下午|晚上|午夜|凌晨)\b/,
    /\b\d{1,2}(:\d{2})?\s*(am|pm|点)\b/i,
    /\b(morning|afternoon|evening|night|midnight)\b/i,
    /\b\d{1,2}(:\d{2})?\b/, // Time
  ];

  const hasTimePattern = timePatterns.some(pattern => pattern.test(message));
  if (hasTimePattern) {
    confidence = Math.min(confidence + 0.15, 1.0);
  }

  // Check for action patterns (verbs + targets)
  const actionPatterns = [
    /发送(到|至)/,
    /获取/,
    /检查/,
    /通知/,
    /提醒/,
    /send (to|via)/i,
    /get/i,
    /check/i,
    /notify/i,
    /remind/i,
  ];

  const hasActionPattern = actionPatterns.some(pattern => pattern.test(message));
  if (hasActionPattern) {
    confidence = Math.min(confidence + 0.1, 1.0);
  }

  const isWorkflowRequest = confidence >= 0.5;

  // Generate suggestions for low-confidence requests
  let suggestions: string[] | undefined;
  if (confidence >= 0.3 && confidence < 0.5) {
    suggestions = [
      '您是否想创建一个自动化工作流？',
      '如果是，请明确说"创建工作流"或"自动化"',
    ];
  }

  return {
    isWorkflowRequest,
    confidence: Math.round(confidence * 100) / 100,
    keywords: matchedKeywords,
    suggestions,
  };
}

/**
 * Extract workflow parameters from message
 */
export function extractWorkflowParams(message: string): {
  name?: string;
  description?: string;
  trigger?: string;
  actions?: string[];
} {
  const params: any = {};

  // Extract potential workflow name
  const namePattern = /(?:叫|名为?|name[:\s]*)["']?([^"'\n，。]+?)["']?(?:$|[，。])/i;
  const nameMatch = message.match(namePattern);
  if (nameMatch) {
    params.name = nameMatch[1].trim();
  }

  // Extract time/trigger info
  const timePattern = /(早上|下午|晚上|午夜|凌晨|\d{1,2}点|\d{1,2}:\d{2}|morning|afternoon|evening|\d{1,2}(am|pm))/i;
  const timeMatch = message.match(timePattern);
  if (timeMatch) {
    params.trigger = timeMatch[1];
  }

  // Extract actions
  const actionIndicators = ['获取', '发送', '检查', '通知', 'get', 'send', 'check', 'notify'];
  const actions: string[] = [];

  for (const indicator of actionIndicators) {
    const regex = new RegExp(`${indicator}([^，。。]+?)(?:[，。。]|$)`, 'gi');
    const matches = message.matchAll(regex);
    for (const match of matches) {
      if (match[1]) {
        actions.push(`${indicator}${match[1].trim()}`);
      }
    }
  }

  if (actions.length > 0) {
    params.actions = actions;
  }

  // Default description is the whole message
  params.description = message.trim();

  return params;
}

/**
 * Suggest workflow template based on message content
 */
export function suggestTemplate(message: string): string | null {
  const normalized = message.toLowerCase();

  // Daily report workflow
  if (normalized.includes('天气') && (normalized.includes('每天') || normalized.includes('每日'))) {
    return 'daily-weather-report';
  }

  // Reminder workflow
  if (normalized.includes('提醒') || normalized.includes('remind')) {
    return 'reminder';
  }

  // Notification workflow
  if (normalized.includes('通知') || normalized.includes('notify')) {
    return 'notification';
  }

  // Monitoring workflow
  if (normalized.includes('监控') || normalized.includes('检查') || normalized.includes('monitor')) {
    return 'monitoring';
  }

  return null;
}

/**
 * Format intent detection result for debugging
 */
export function formatIntentResult(result: IntentDetectionResult, message: string): string {
  let output = `🔍 意图检测结果\n\n`;
  output += `消息: "${message}"\n\n`;
  output += `是否为工作流请求: ${result.isWorkflowRequest ? '✅ 是' : '❌ 否'}\n`;
  output += `置信度: ${(result.confidence * 100).toFixed(0)}%\n`;

  if (result.keywords.length > 0) {
    output += `匹配关键词: ${result.keywords.map(k => `"${k}"`).join(', ')}\n`;
  }

  if (result.suggestions && result.suggestions.length > 0) {
    output += `\n💡 建议:\n`;
    for (const suggestion of result.suggestions) {
      output += `  - ${suggestion}\n`;
    }
  }

  return output;
}
