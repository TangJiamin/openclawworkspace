#!/usr/bin/env node

/**
 * Seedance to Refly Bridge Hook
 *
 * 自动桥接 Seedance Skill 到 Refly 工作流
 * 实现完全自动化的视频生成流程
 *
 * 工作流：
 * Seedance Skill → Hook → Refly 工作流 API → 视频生成 → 返回结果
 */

const axios = require('axios');

class SeedanceToReflyBridge {
  constructor() {
    this.name = 'Seedance to Refly Bridge';
    this.version = '1.0.0';

    // 从环境变量读取配置
    this.reflyWebhookUrl = process.env.REFLY_WEBHOOK_URL || 'https://refly.kmos.ai/api/workflows/run';
    this.reflyApiKey = process.env.REFLY_API_KEY;
    // 更新为你的实际工作流 ID
    this.reflyWorkflowId = process.env.REFLY_WORKFLOW_ID || 'c-s928vwenmmkobt5yuk32nl3u';
    this.autoGenerate = process.env.SEEDANCE_AUTO_GENERATE_VIDEO !== 'false';
  }

  /**
   * 主处理函数
   */
  async handle(event, context) {
    this.log('收到 Seedance 输出，准备自动生成视频...');

    try {
      // 1. 提取数据
      const { seedanceOutput } = event;

      if (!seedanceOutput) {
        throw new Error('缺少 seedanceOutput 数据');
      }

      // 2. 验证数据
      const validationResult = this.validateSeedanceOutput(seedanceOutput);
      if (!validationResult.valid) {
        throw new Error(validationResult.error);
      }

      // 3. 检查是否自动生成
      if (!this.autoGenerate) {
        this.log('自动生成已禁用，跳过视频生成');
        return {
          success: true,
          workflow: 'seedance-to-refly-bridge',
          action: 'skipped',
          reason: 'Auto-generation disabled',
          input: this.extractInput(seedanceOutput)
        };
      }

      // 4. 提取必需字段
      const { design_image_url, seedance_prompt } = this.extractData(seedanceOutput);

      // 5. 构建 Refly 兼容输入
      const reflyInput = this.buildReflyInput(design_image_url, seedance_prompt);

      // 6. 调用 Refly 工作流
      this.log('正在调用 Refly 工作流...');
      const reflyResult = await this.callReflyWorkflow(reflyInput);

      // 7. 返回结果
      return {
        success: true,
        workflow: 'seedance-to-refly-bridge',
        input: {
          design_image_url: design_image_url,
          seedance_prompt_preview: seedance_prompt.substring(0, 100) + '...'
        },
        output: reflyResult,
        video_url: reflyResult.output?.video_url,
        video_id: reflyResult.output?.video_id,
        message: '✅ 视频已自动生成！'
      };

    } catch (error) {
      this.log(`❌ 处理失败: ${error.message}`, 'ERROR');

      // 返回错误信息
      return {
        success: false,
        workflow: 'seedance-to-refly-bridge',
        error: error.message,
        input: event.seedanceOutput ? {
          design_image_url: event.seedanceOutput.input?.design_image_url
        } : null
      };
    }
  }

  /**
   * 验证 Seedance 输出
   */
  validateSeedanceOutput(output) {
    if (!output) {
      return { valid: false, error: 'Seedance 输出为空' };
    }

    if (!output.input?.design_image_url) {
      return { valid: false, error: '缺少 design_image_url' };
    }

    if (!output.seedance_prompt?.full_prompt) {
      return { valid: false, error: '缺少 seedance_prompt.full_prompt' };
    }

    // 验证 URL 格式
    try {
      new URL(output.input.design_image_url);
    } catch (e) {
      return { valid: false, error: 'design_image_url 不是有效的 URL' };
    }

    // 验证 Prompt 长度
    if (output.seedance_prompt.full_prompt.length < 50) {
      return { valid: false, error: 'seedance_prompt 太短' };
    }

    return { valid: true };
  }

  /**
   * 提取数据
   */
  extractData(seedanceOutput) {
    return {
      design_image_url: seedanceOutput.input.design_image_url,
      seedance_prompt: seedanceOutput.seedance_prompt.full_prompt
    };
  }

  /**
   * 提取输入（用于日志和错误报告）
   */
  extractInput(seedanceOutput) {
    return {
      design_image_url: seedanceOutput.input?.design_image_url,
      description: seedanceOutput.input?.description,
      duration: seedanceOutput.input?.duration
    };
  }

  /**
   * 构建 Refly 兼容输入
   */
  buildReflyInput(designImageUrl, seedancePrompt) {
    return JSON.stringify({
      success: true,
      workflow: 'seedance-storyboard',
      data: {
        design_image_url: designImageUrl,
        seedance_prompt: seedancePrompt
      }
    }, null, 2);
  }

  /**
   * 调用 Refly 工作流
   */
  async callReflyWorkflow(reflyInput) {
    try {
      this.log(`正在调用 Refly 工作流: ${this.reflyWorkflowId}`);

      // 构建请求体
      const requestBody = {
        workflow_id: this.reflyWorkflowId,
        input: {
          seedance_data: reflyInput
        }
      };

      this.log(`请求 URL: ${this.reflyWebhookUrl}`);
      this.log(`工作流 ID: ${this.reflyWorkflowId}`);

      const response = await axios.post(
        this.reflyWebhookUrl,
        requestBody,
        {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.reflyApiKey}`
          },
          timeout: 300000  // 5 分钟超时
        }
      );

      this.log(`Refly API 响应状态: ${response.status}`);

      if (response.data?.success) {
        this.log('✅ Refly 工作流执行成功');

        // 提取视频 URL
        const videoUrl = response.data.output?.video_url;
        if (videoUrl) {
          this.log(`📹 视频已生成: ${videoUrl}`);
        }

        return response.data;
      } else {
        throw new Error(response.data?.error || 'Refly 工作流返回失败');
      }

    } catch (error) {
      if (error.response) {
        // API 返回了错误响应
        const status = error.response.status;
        const errorData = error.response.data;
        this.log(`Refly API 错误响应: ${status}`, 'ERROR');
        this.log(`错误详情: ${JSON.stringify(errorData)}`, 'ERROR');
        throw new Error(`Refly API 错误: ${status} - ${errorData?.error || error.message}`);
      } else if (error.request) {
        // 请求已发送但没有收到响应
        this.log('Refly API 无响应，请检查网络连接', 'ERROR');
        throw new Error('Refly API 无响应，请检查网络连接');
      } else {
        // 请求配置出错
        this.log(`请求配置错误: ${error.message}`, 'ERROR');
        throw new Error(`请求配置错误: ${error.message}`);
      }
    }
  }

  /**
   * 日志输出
   */
  log(message, level = 'INFO') {
    const timestamp = new Date().toISOString();
    const logMessage = `[${timestamp}] [${level}] Seedance-to-ReflBridge: ${message}`;
    console.log(logMessage);
  }
}

// 导出
module.exports = SeedanceToReflyBridge;

// 如果直接运行此文件
if (require.main === module) {
  const bridge = new SeedanceToReflyBridge();

  // 测试数据
  const testEvent = {
    seedanceOutput: {
      success: true,
      input: {
        design_image_url: 'https://refly.kmos.ai/designs/ai-tools.png',
        description: '展示 AI 工具的 5 个核心功能',
        duration: 60,
        style: 'Tech'
      },
      seedance_prompt: {
        full_prompt: 'Tech style, 60 seconds, 9:16 vertical, cool futuristic atmosphere\n\n0-5s: Wide shot floating, Floating interface, AI assistant guiding user, tool icons highlighting\n\n5-15s: Medium shot scaling, Showcasing each tool with animated demonstrations'
      }
    }
  };

  // 执行测试
  bridge.handle(testEvent, {})
    .then(result => {
      console.log('\n✅ 测试成功！');
      console.log(JSON.stringify(result, null, 2));
      process.exit(0);
    })
    .catch(error => {
      console.error('\n❌ 测试失败！');
      console.error(error);
      process.exit(1);
    });
}
