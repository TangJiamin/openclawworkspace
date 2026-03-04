#!/usr/bin/env node

/**
 * AI Daily Digest Skill - OpenClaw Wrapper
 *
 * 从 90 个顶级技术博客抓取最新文章，AI 评分筛选，生成每日精选摘要
 * 原项目：https://github.com/vigorX777/ai-daily-digest
 */

const { exec } = require('child_process');
const { promisify } = require('util');
const fs = require('fs');
const path = require('path');

const execAsync = promisify(exec);

class AIDailyDigestSkill {
  constructor() {
    this.name = 'AI Daily Digest';
    this.version = '1.0.0';

    // 配置
    this.configPath = process.env.AI_DIGEST_CONFIG_PATH || path.join(process.env.HOME, '.hn-daily-digest', 'config.json');
    this.outputDir = process.env.AI_DIGEST_OUTPUT_DIR || path.join(process.cwd(), 'data', 'digests');
  }

  /**
   * 主处理函数
   */
  async handle(message, options = {}) {
    this.log('AI Daily Digest 启动...');

    try {
      // 解析参数
      const params = this.parseParams(message, options);

      // 检查配置
      const config = await this.loadOrCreateConfig(params);

      // 运行 digest
      const result = await this.runDigest(config);

      // 返回结果
      return {
        success: true,
        workflow: 'ai-daily-digest',
        params,
        output: result.digest,
        output_path: result.outputPath,
        stats: result.stats
      };

    } catch (error) {
      this.log(`❌ 执行失败: ${error.message}`, 'ERROR');
      return {
        success: false,
        workflow: 'ai-daily-digest',
        error: error.message
      };
    }
  }

  /**
   * 解析参数
   */
  parseParams(message, options) {
    const params = {
      hours: 48,
      topN: 15,
      lang: 'zh'
    };

    // 从 message 解析
    const hoursMatch = message.match(/(\d+)\s*(小时|hour|hours|h)/i);
    if (hoursMatch) {
      params.hours = parseInt(hoursMatch[1]);
    }

    const topMatch = message.match(/(\d+)\s*(篇|articles|posts)/i);
    if (topMatch) {
      params.topN = parseInt(topMatch[1]);
    }

    const langMatch = message.match(/(中文|english|en|zh)/i);
    if (langMatch) {
      const lang = langMatch[1].toLowerCase();
      params.lang = (lang === '中文' || lang === 'zh') ? 'zh' : 'en';
    }

    // 从 options 覆盖
    return {
      ...params,
      ...options
    };
  }

  /**
   * 加载或创建配置
   */
  async loadOrCreateConfig(params) {
    try {
      // 检查配置文件是否存在
      if (fs.existsSync(this.configPath)) {
        const configData = fs.readFileSync(this.configPath, 'utf-8');
        const config = JSON.parse(configData);

        this.log('✅ 使用已保存配置');

        // 返回配置（如果 params 有值，覆盖配置）
        return {
          ...config,
          ...params
        };
      }
    } catch (error) {
      this.log(`⚠️  配置文件读取失败: ${error.message}`, 'WARN');
    }

    // 创建新配置
    const config = {
      ...params,
      geminiApiKey: process.env.ZHIPU_API_KEY || process.env.GEMINI_API_KEY || '',
      openaiApiKey: process.env.OPENAI_API_KEY || '',
      openaiApiBase: process.env.OPENAI_API_BASE || 'https://api.openai.com/v1',
      openaiModel: process.env.OPENAI_MODEL || '',
      lastUsed: new Date().toISOString()
    };

    // 验证 API Key
    if (!config.geminiApiKey && !config.openaiApiKey) {
      throw new Error('缺少 API Key，请设置 ZHIPU_API_KEY（推荐）或 GEMINI_API_KEY / OPENAI_API_KEY 环境变量');
    }

    // 保存配置
    await this.saveConfig(config);

    this.log('✅ 新配置已创建');

    return config;
  }

  /**
   * 保存配置
   */
  async saveConfig(config) {
    const configDir = path.dirname(this.configPath);

    // 创建目录
    if (!fs.existsSync(configDir)) {
      fs.mkdirSync(configDir, { recursive: true });
    }

    // 保存配置
    fs.writeFileSync(this.configPath, JSON.stringify(config, null, 2));

    this.log('✅ 配置已保存');
  }

  /**
   * 运行 digest
   */
  async runDigest(config) {
    this.log(`参数：${config.hours}小时，精选${config.topN}篇，语言${config.lang}`);

    // 创建输出目录
    if (!fs.existsSync(this.outputDir)) {
      fs.mkdirSync(this.outputDir, { recursive: true });
    }

    // 生成输出文件名
    const date = new Date().toISOString().split('T')[0].replace(/-/g, '');
    const outputPath = path.join(this.outputDir, `digest-${date}.md`);

    // 构建 digest.ts 路径
    const digestScript = path.join(__dirname, 'scripts', 'digest.ts');

    // 检查脚本是否存在
    if (!fs.existsSync(digestScript)) {
      throw new Error(`digest.ts 脚本不存在: ${digestScript}`);
    }

    // 构建命令
    const command = this.buildCommand(digestScript, config, outputPath);

    this.log('正在运行 digest...');

    // 执行命令
    const { stdout, stderr } = await execAsync(command);

    // 读取输出文件
    let digest = '';
    if (fs.existsSync(outputPath)) {
      digest = fs.readFileSync(outputPath, 'utf-8');
    }

    // 解析统计信息
    const stats = this.parseStats(digest);

    return {
      digest,
      outputPath,
      stats
    };
  }

  /**
   * 构建命令
   */
  buildCommand(scriptPath, config, outputPath) {
    let cmd = `npx -y bun ${scriptPath}`;
    cmd += ` --hours ${config.hours}`;
    cmd += ` --top-n ${config.topN}`;
    cmd += ` --lang ${config.lang}`;
    cmd += ` --output ${outputPath}`;

    // 设置环境变量
    const env = {
      GEMINI_API_KEY: config.geminiApiKey,
      OPENAI_API_KEY: config.openaiApiKey,
      OPENAI_API_BASE: config.openaiApiBase,
      OPENAI_MODEL: config.openaiModel
    };

    // 合并到命令
    Object.keys(env).forEach(key => {
      if (env[key]) {
        cmd = `${key}="${env[key]}" ${cmd}`;
      }
    });

    return cmd;
  }

  /**
   * 解析统计信息
   */
  parseStats(digest) {
    const stats = {
      total_sources: 0,
      total_articles: 0,
      selected_articles: 0,
      top_3: []
    };

    // 解析数据概览
    const overviewMatch = digest.match(/扫描源数[：:]\s*(\d+)/);
    if (overviewMatch) {
      stats.total_sources = parseInt(overviewMatch[1]);
    }

    const articlesMatch = digest.match(/抓取文章数[：:]\s*(\d+)/);
    if (articlesMatch) {
      stats.total_articles = parseInt(articlesMatch[1]);
    }

    const selectedMatch = digest.match(/精选文章数[：:]\s*(\d+)/);
    if (selectedMatch) {
      stats.selected_articles = parseInt(selectedMatch[1]);
    }

    return stats;
  }

  /**
   * 日志输出
   */
  log(message, level = 'INFO') {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] [${level}] AI Daily Digest: ${message}`);
  }
}

// 导出
module.exports = AIDailyDigestSkill;

// 如果直接运行
if (require.main === module) {
  const skill = new AIDailyDigestSkill();

  // 测试
  skill.handle('生成最近 48 小时的技术文章摘要', { hours: 48, topN: 15, lang: 'zh' })
    .then(result => {
      console.log('\n✅ 测试成功！');
      console.log(`输出路径: ${result.output_path}`);
      console.log(`\n统计信息:`);
      console.log(`  扫描源数: ${result.stats.total_sources}`);
      console.log(`  抓取文章数: ${result.stats.total_articles}`);
      console.log(`  精选文章数: ${result.stats.selected_articles}`);
      process.exit(0);
    })
    .catch(error => {
      console.error('\n❌ 测试失败！');
      console.error(error);
      process.exit(1);
    });
}
