/**
 * OpenClaw Tools Registry
 * Maps OpenClaw tools to Refly-compatible format
 */

import { ToolDefinition } from './refly-client.js';

/**
 * Get all available OpenClaw tools in Refly format
 */
export function getOpenClawTools(): ToolDefinition[] {
  return [
    {
      id: 'message',
      name: '发送消息',
      description: '发送消息到任意平台（Telegram、WhatsApp、Discord、Feishu 等）',
      parameters: {
        channel: {
          type: 'string',
          enum: ['telegram', 'whatsapp', 'discord', 'feishu', 'slack', 'signal'],
          required: true,
          description: '目标平台',
        },
        message: {
          type: 'string',
          required: true,
          description: '消息内容，支持变量引用如 {{step1.result}}',
        },
        to: {
          type: 'string',
          required: false,
          description: '接收者（聊天 ID、用户名或频道名）',
        },
      },
      examples: [
        {
          description: '发送到 Telegram 频道',
          input: {
            channel: 'telegram',
            to: '@mychannel',
            message: 'Hello from OpenClaw!',
          },
        },
        {
          description: '发送到 WhatsApp',
          input: {
            channel: 'whatsapp',
            to: '+8613800138000',
            message: 'Reminder: Meeting at 3pm',
          },
        },
      ],
    },
    {
      id: 'web_search',
      name: '网络搜索',
      description: '使用 Brave Search 搜索网络信息',
      parameters: {
        query: {
          type: 'string',
          required: true,
          description: '搜索关键词',
        },
        count: {
          type: 'number',
          required: false,
          description: '返回结果数量（1-10，默认 5）',
        },
      },
      examples: [
        {
          description: '搜索天气',
          input: {
            query: '北京天气 今天',
            count: 3,
          },
        },
      ],
    },
    {
      id: 'web_fetch',
      name: '获取网页内容',
      description: '获取并提取网页的可读内容',
      parameters: {
        url: {
          type: 'string',
          required: true,
          description: '网页 URL',
        },
        extractMode: {
          type: 'string',
          enum: ['markdown', 'text'],
          required: false,
          description: '提取模式（默认 markdown）',
        },
      },
      examples: [
        {
          description: '获取文章',
          input: {
            url: 'https://example.com/article',
            extractMode: 'markdown',
          },
        },
      ],
    },
    {
      id: 'browser',
      name: '浏览器自动化',
      description: '控制浏览器进行网页操作（截图、点击、填表等）',
      parameters: {
        action: {
          type: 'string',
          enum: ['open', 'snapshot', 'screenshot', 'navigate', 'click', 'type'],
          required: true,
          description: '浏览器操作类型',
        },
        targetUrl: {
          type: 'string',
          required: false,
          description: '目标网址（用于 open/navigate）',
        },
        selector: {
          type: 'string',
          required: false,
          description: 'CSS 选择器（用于 click/type）',
        },
        text: {
          type: 'string',
          required: false,
          description: '输入文本（用于 type）',
        },
      },
      examples: [
        {
          description: '打开网页并截图',
          input: {
            action: 'open',
            targetUrl: 'https://example.com',
          },
        },
      ],
    },
    {
      id: 'exec',
      name: '执行命令',
      description: '在服务器上执行 shell 命令',
      parameters: {
        command: {
          type: 'string',
          required: true,
          description: '要执行的命令',
        },
        workdir: {
          type: 'string',
          required: false,
          description: '工作目录',
        },
      },
      examples: [
        {
          description: '列出文件',
          input: {
            command: 'ls -la',
          },
        },
      ],
    },
    {
      id: 'cron',
      name: '定时任务',
      description: '创建和管理定时任务',
      parameters: {
        action: {
          type: 'string',
          enum: ['add', 'remove', 'run'],
          required: true,
          description: '操作类型',
        },
        jobId: {
          type: 'string',
          required: false,
          description: '任务 ID（用于 remove/run）',
        },
      },
    },
    {
      id: 'calendar',
      name: '日历管理',
      description: '获取日程和日历事件（需要扩展支持）',
      parameters: {
        action: {
          type: 'string',
          enum: ['list', 'create', 'update'],
          required: true,
        },
        date: {
          type: 'string',
          required: false,
          description: '日期（YYYY-MM-DD 或 "today"）',
        },
      },
    },
    {
      id: 'weather',
      name: '获取天气',
      description: '获取指定城市的天气信息（需要扩展支持）',
      parameters: {
        city: {
          type: 'string',
          required: true,
          description: '城市名称',
        },
        unit: {
          type: 'string',
          enum: ['celsius', 'fahrenheit'],
          required: false,
          description: '温度单位（默认 celsius）',
        },
      },
    },
    {
      id: 'tts',
      name: '文字转语音',
      description: '将文字转换为语音文件',
      parameters: {
        text: {
          type: 'string',
          required: true,
          description: '要转换的文字',
        },
        channel: {
          type: 'string',
          required: false,
          description: '目标频道（用于选择输出格式）',
        },
      },
    },
    {
      id: 'nodes',
      name: '节点控制',
      description: '控制配对的设备节点',
      parameters: {
        action: {
          type: 'string',
          enum: ['status', 'notify', 'camera_snap', 'location_get'],
          required: true,
        },
        node: {
          type: 'string',
          required: false,
          description: '节点 ID 或名称',
        },
      },
    },
    {
      id: 'canvas',
      name: 'Canvas 展示',
      description: '在 Canvas 上展示内容',
      parameters: {
        action: {
          type: 'string',
          enum: ['present', 'hide', 'snapshot'],
          required: true,
        },
        url: {
          type: 'string',
          required: false,
          description: '要展示的 URL',
        },
      },
    },
  ];
}

/**
 * Get tool by ID
 */
export function getToolById(toolId: string): ToolDefinition | undefined {
  const tools = getOpenClawTools();
  return tools.find(t => t.id === toolId);
}

/**
 * Validate tool input against schema
 */
export function validateToolInput(
  toolId: string,
  input: any
): { valid: boolean; errors: string[] } {
  const tool = getToolById(toolId);
  if (!tool) {
    return { valid: false, errors: [`Unknown tool: ${toolId}`] };
  }

  const errors: string[] = [];

  if (tool.parameters) {
    for (const [paramName, paramDef] of Object.entries(tool.parameters)) {
      const def = paramDef as any;
      if (def.required && !(paramName in input)) {
        errors.push(`Missing required parameter: ${paramName}`);
      }

      if (paramName in input && def.enum) {
        if (!def.enum.includes(input[paramName])) {
          errors.push(
            `Invalid value for ${paramName}: must be one of ${def.enum.join(', ')}`
          );
        }
      }
    }
  }

  return { valid: errors.length === 0, errors };
}

/**
 * Format tool description for user
 */
export function formatToolDescription(tool: ToolDefinition): string {
  let desc = `🔧 **${tool.name}** (\`${tool.id}\`)\n`;
  desc += `   ${tool.description}\n`;

  if (tool.parameters) {
    const required = Object.entries(tool.parameters)
      .filter(([_, def]) => (def as any).required)
      .map(([name]) => name);
    if (required.length > 0) {
      desc += `   必需参数: ${required.join(', ')}\n`;
    }
  }

  return desc;
}
