/**
 * Refly 视觉设计师 Hook 处理程序
 *
 * 功能：集成 Refly 视觉设计工作流，实现 AI 驱动的视觉素材生成
 * 工作流 ID: c-anlbsxecm4d201aj4zgnph8y
 */

import axios from 'axios';

// ========== 配置 ==========

const REFLY_CONFIG = {
  url: process.env.REFLY_URL || 'http://refly.kmos.ai',
  apiKey: process.env.REFLY_API_KEY || '',
  visualWorkflowId: process.env.REFLY_VISUAL_WORKFLOW_ID || 'c-anlbsxecm4d201aj4zgnph8y',
  timeout: parseInt(process.env.REFLY_TIMEOUT || '60000', 10),
};

// ========== 类型定义 ==========

interface DesignRequest {
  type: 'cover' | 'infographic' | 'social' | 'brand' | 'presentation';
  title: string;
  description?: string;
  style?: string;
  size?: string;
  data?: any;
}

interface ReflyResponse {
  success: boolean;
  result?: any;
  error?: string;
  imageUrl?: string;
  designUrl?: string;
}

// ========== 工具函数 ==========

/**
 * 提取设计参数从用户消息
 */
function extractDesignParams(message: string): DesignRequest | null {
  const lowerMsg = message.toLowerCase();

  // 检测设计类型
  let type: DesignRequest['type'] = 'cover';
  if (lowerMsg.includes('信息图') || lowerMsg.includes('infographic') || lowerMsg.includes('数据可视化')) {
    type = 'infographic';
  } else if (lowerMsg.includes('小红书') || lowerMsg.includes('instagram') || lowerMsg.includes('社交')) {
    type = 'social';
  } else if (lowerMsg.includes('logo') || lowerMsg.includes('海报') || lowerMsg.includes('banner')) {
    type = 'brand';
  } else if (lowerMsg.includes('ppt') || lowerMsg.includes('演示')) {
    type = 'presentation';
  }

  // 提取标题/主题
  const titleMatch = message.match(/(?:标题|主题|：|:)\s*([^\n]+)/);
  const title = titleMatch ? titleMatch[1].trim() : message.replace(/^(生成|设计|创建)\s*(封面图|信息图|配图|海报)\s*(：|:)?\s*/, '').trim();

  // 提取风格
  const styleKeywords = ['科技感', '商务', '简约', '现代', '可爱', '清新', '艺术', '深色', '渐变'];
  let style = 'modern';
  for (const keyword of styleKeywords) {
    if (message.includes(keyword)) {
      style = keyword;
      break;
    }
  }

  // 提取尺寸
  const sizeMatch = message.match(/(\d+:\d+|1:1|16:9|4:3|9:16|21:9)/);
  const size = sizeMatch ? sizeMatch[1] : '16:9';

  return {
    type,
    title,
    style,
    size,
  };
}

/**
 * 调用 Refly API 生成设计
 */
async function generateDesign(params: DesignRequest): Promise<ReflyResponse> {
  try {
    const payload = {
      workflowId: REFLY_CONFIG.visualWorkflowId,
      input: {
        designType: params.type,
        title: params.title,
        description: params.description || '',
        style: params.style || 'modern',
        size: params.size || '16:9',
        data: params.data || {},
      },
    };

    console.log('[Refly Visual Designer] 发送请求:', JSON.stringify(payload, null, 2));

    const response = await axios.post(
      `${REFLY_CONFIG.url}/api/v1/workflows/execute`,
      payload,
      {
        headers: {
          'Authorization': `Bearer ${REFLY_CONFIG.apiKey}`,
          'Content-Type': 'application/json',
        },
        timeout: REFLY_CONFIG.timeout,
      }
    );

    console.log('[Refly Visual Designer] 收到响应:', response.status);

    if (response.data.success) {
      return {
        success: true,
        imageUrl: response.data.result?.imageUrl,
        designUrl: response.data.result?.designUrl,
        result: response.data.result,
      };
    } else {
      return {
        success: false,
        error: response.data.error || '未知错误',
      };
    }
  } catch (error: any) {
    console.error('[Refly Visual Designer] API 调用失败:', error.message);
    return {
      success: false,
      error: error.message,
    };
  }
}

/**
 * 保存设计记录到本地
 */
function saveDesignRecord(params: DesignRequest, result: ReflyResponse): void {
  const fs = require('fs');
  const path = require('path');

  const dataDir = path.join(process.env.HOME || '', '.openclaw/workspace/skills/ai-media-pipeline/data/designs');
  const imagesDir = path.join(dataDir, 'images');

  // 确保目录存在
  fs.mkdirSync(dataDir, { recursive: true });
  fs.mkdirSync(imagesDir, { recursive: true });

  // 保存记录
  const today = new Date().toISOString().split('T')[0];
  const recordFile = path.join(dataDir, `designs_${today}.json`);

  let records = [];
  if (fs.existsSync(recordFile)) {
    records = JSON.parse(fs.readFileSync(recordFile, 'utf-8'));
  }

  const record = {
    id: Date.now(),
    timestamp: new Date().toISOString(),
    params,
    result: {
      success: result.success,
      imageUrl: result.imageUrl,
      designUrl: result.designUrl,
    },
  };

  records.push(record);
  fs.writeFileSync(recordFile, JSON.stringify(records, null, 2));

  console.log('[Refly Visual Designer] 设计记录已保存:', recordFile);
}

// ========== 消息处理器 ==========

/**
 * 主处理函数
 */
export async function handleMessage(context: any): Promise<any> {
  const { message, sessionId, sendResponse } = context;

  console.log('[Refly Visual Designer] 收到消息:', message);

  // 意图检测
  const designKeywords = [
    '生成封面', '设计封面', '制作封面',
    '生成信息图', '设计信息图', '数据可视化',
    '生成配图', '设计配图', '制作配图',
    '生成海报', '设计海报', '制作海报',
    '生成logo', '设计logo', '制作logo',
    '视觉设计', '图片设计', '素材设计',
  ];

  const isDesignRequest = designKeywords.some(keyword => message.includes(keyword));

  if (!isDesignRequest) {
    return null; // 不是设计请求，交给其他 Hook 处理
  }

  // 立即响应
  await sendResponse({
    text: '🎨 正在生成设计，请稍候...',
  });

  // 提取参数
  const params = extractDesignParams(message);
  if (!params) {
    await sendResponse({
      text: '❌ 无法识别设计需求。请提供更详细的描述，例如：\n\n生成封面图：AI时代的生产力革命\n风格：科技感\n尺寸：16:9',
    });
    return { handled: true };
  }

  console.log('[Refly Visual Designer] 设计参数:', params);

  // 调用 Refly 生成设计
  const result = await generateDesign(params);

  // 保存记录
  saveDesignRecord(params, result);

  // 返回结果
  if (result.success && result.imageUrl) {
    await sendResponse({
      text: `✅ 设计完成！\n\n📌 标题: ${params.title}\n🎨 风格: ${params.style}\n📐 尺寸: ${params.size}\n\n`,
      media: result.imageUrl,
    });
  } else {
    await sendResponse({
      text: `❌ 设计生成失败：${result.error || '未知错误'}\n\n请检查：\n- Refly API 配置\n- 工作流 ID 是否正确\n- API 额度是否充足`,
    });
  }

  return { handled: true };
}

// ========== 导出 ==========

export default {
  name: 'refly-visual-designer',
  version: '1.0.0',
  handleMessage,
};
