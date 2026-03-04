/**
 * Refly API Client
 * Handles communication with Refly service
 */

interface ReflyConfig {
  baseURL: string;
  apiKey: string;
  model?: string;
  timeout?: number;
}

interface ToolDefinition {
  id: string;
  name: string;
  description: string;
  parameters?: Record<string, any>;
  examples?: Array<{
    description: string;
    input: any;
  }>;
}

interface ParseContext {
  history?: any[];
  availableTools: ToolDefinition[];
}

interface WorkflowStep {
  toolId: string;
  input: any;
  condition?: string;
  retry?: number;
  timeout?: number;
}

interface WorkflowTrigger {
  type: 'cron' | 'manual' | 'event' | 'webhook';
  expression?: string;
  event?: string;
  webhookId?: string;
}

interface Workflow {
  name: string;
  description?: string;
  steps: WorkflowStep[];
  trigger: WorkflowTrigger;
}

interface WorkflowParseResult {
  workflow: Workflow;
  confidence: number; // 0-1
  clarifications: string[]; // Questions that need user confirmation
  alternatives?: WorkflowParseResult[]; // Other possible interpretations
}

interface ConversationResponse {
  message: string;
  questions?: string[];
  workflow?: WorkflowParseResult;
  finished: boolean;
  sessionId?: string;
}

export class ReflyClient {
  private baseURL: string;
  private apiKey: string;
  private model: string;
  private timeout: number;

  constructor(config: ReflyConfig) {
    this.baseURL = config.baseURL.replace(/\/$/, ''); // Remove trailing slash
    this.apiKey = config.apiKey;
    this.model = config.model || 'refly-latest';
    this.timeout = config.timeout || 30000;
  }

  /**
   * Parse natural language into structured workflow
   */
  async parseWorkflow(
    input: string,
    context: ParseContext
  ): Promise<WorkflowParseResult> {
    const startTime = Date.now();

    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), this.timeout);

      const response = await fetch(`${this.baseURL}/api/v1/workflow/parse`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          input,
          model: this.model,
          context: {
            ...context,
            timestamp: new Date().toISOString(),
          },
        }),
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(
          `Refly API error (${response.status}): ${errorText}`
        );
      }

      const result = await response.json();

      // Validate response structure
      if (!result.workflow || !result.confidence) {
        throw new Error('Invalid Refly response: missing required fields');
      }

      const duration = Date.now() - startTime;
      console.log(`[Refly] Parse completed in ${duration}ms, confidence: ${result.confidence}`);

      return result;
    } catch (error: any) {
      if (error.name === 'AbortError') {
        throw new Error(`Refly API timeout after ${this.timeout}ms`);
      }
      throw error;
    }
  }

  /**
   * Multi-turn conversation for clarification
   */
  async continueConversation(
    sessionId: string,
    userMessage: string,
    context: string = 'workflow-creation'
  ): Promise<ConversationResponse> {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), this.timeout);

    try {
      const response = await fetch(`${this.baseURL}/api/v1/conversation`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({
          sessionId,
          message: userMessage,
          context,
          model: this.model,
        }),
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(
          `Refly conversation error (${response.status}): ${errorText}`
        );
      }

      return await response.json();
    } catch (error: any) {
      if (error.name === 'AbortError') {
        throw new Error(`Refly API timeout after ${this.timeout}ms`);
      }
      throw error;
    }
  }

  /**
   * Health check
   */
  async healthCheck(): Promise<boolean> {
    try {
      const response = await fetch(`${this.baseURL}/health`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
        },
      });
      return response.ok;
    } catch {
      return false;
    }
  }

  /**
   * Get model info
   */
  getModel(): string {
    return this.model;
  }

  /**
   * Get client configuration
   */
  getConfig(): Omit<ReflyConfig, 'apiKey'> {
    return {
      baseURL: this.baseURL,
      model: this.model,
      timeout: this.timeout,
    };
  }
}

export type {
  ReflyConfig,
  ToolDefinition,
  ParseContext,
  WorkflowStep,
  WorkflowTrigger,
  Workflow,
  WorkflowParseResult,
  ConversationResponse,
};
