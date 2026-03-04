# Orchestrator 真实环境测试指南

## 🧪 测试环境

### 环境要求

- ✅ OpenClaw 运行中
- ✅ main Agent session 激活
- ✅ workspace 已配置

### 当前状态

我们在 webchat 环境中，需要等待真实的 main Agent session 来测试。

---

## 🚀 真实测试步骤

### Step 1: 启动测试

在 **真实的 main Agent session** 中（webchat/其他平台）：

```
用户输入: orchestrate("生成小红书内容，推荐5个提升效率的AI工具")
```

### Step 2: 观察执行

**预期行为**:

1. **工具识别**
   ```
   🤖 识别到 orchestrate 工具
   ```

2. **创建 requirement-agent session**
   ```
   📤 调用 sessions_spawn
   📌 创建 requirement-agent session
   ```

3. **接收结果**
   ```
   ✅ requirement-agent 完成
   返回: {task_id: "req-001", ...}
   ```

4. **继续调用其他 Agents**
   ```
   📤 research-agent session
   ✅ 完成
   📤 content-agent session
   ✅ 完成
   ...
   ```

5. **整合结果**
   ```
   🎯 生成结果
   
   📝 文案: 【5个效率翻倍的AI工具】✨
   ...
   ```

---

## 🔍 故障排查

### 问题 1: 工具未识别

**症状**: 输入 `orchestrate(...)` 没有反应

**原因**: 
- tools.md 可能没有被加载
- 需要重启 main Agent

**解决**:
1. 检查 tools.md 是否在正确位置
2. 尝试重启 main Agent session

### 问题 2: sessions_spawn 未定义

**症状**: 提示 `sessions_spawn is not defined`

**原因**: 不在 OpenClaw Agent 环境中

**解决**: 确保在真实的 main Agent session 中执行

### 问题 3: Agent 超时

**症状**: 某个 Agent 长时间无响应

**原因**: 
- 任务太复杂
- 网络问题
- API 延迟

**解决**:
- 增加 timeout 参数
- 简化任务描述
- 检查网络连接

---

## 📊 测试检查清单

### 基础功能

- [ ] main Agent 识别 `orchestrate` 工具
- [ ] `sessions_spawn` 函数可用
- [ ] requirement-agent session 创建成功
- [ ] 结果返回到 Orchestrator
- [ ] 传递给下一个 Agent
- [ ] 所有 Agents 依次执行
- [ ] 最终结果格式化输出

### 结果验证

- [ ] requirement-agent 返回正确的任务规范
- [ ] research-agent 成功收集资料（模拟）
- [ ] content-agent 生成符合平台的内容
- [ ] visual-agent 推荐合适的视觉参数
- [ ] quality-agent 返回质量评分

### 性能指标

- [ ] 单个 Agent 执行时间 < 超时设置
- [ ] 总执行时间 < 5分钟
- [ ] 内存使用正常
- [ ] 无错误或异常

---

## 🎯 预期输出示例

### 成功案例

```markdown
🎯 Orchestrator 启动
📝 输入: 生成小红书内容，推荐5个提升效率的AI工具

📋 Step 1: 分析需求
   执行模式: standard
   需要 Agents: requirement-agent → research-agent → content-agent → visual-agent → quality-agent

🤖 Step 2: requirement-agent
   📤 创建 requirement-agent session...
   ✅ 完成
   任务规范: {task_id: "req-001", content_type: ["文案", "图片"], ...}

🤖 Step 3: research-agent
   📤 创建 research-agent session...
   ✅ 完成
   收集资料: 15条

🤖 Step 4: content-agent
   📤 创建 content-agent session...
   ✅ 完成
   生成内容: 【5个效率翻倍的AI工具】✨

🤖 Step 5: visual-agent
   📤 创建 visual-agent session...
   ✅ 完成
   视觉参数: {style: "fresh", layout: "list"}

🤖 Step 6: quality-agent
   📤 创建 quality-agent session...
   ✅ 完成
   质量评分: 88/100 (良好)

🎉 执行完成！耗时: 4.5分钟

🎯 生成结果

📝 文案:
【5个效率翻倍的AI工具】✨
还在为工作效率低烦恼？...

🎨 视觉参数:
- 风格: fresh
- 布局: list
- 配色: warm

✅ 质量评分: 88/100 (良好)
```

---

## 🐛 调试模式

如果遇到问题，启用调试模式：

```javascript
// 在 orchestrator.js 中添加
const DEBUG = true;

async function spawnAgent(agentName, userInput, previousResult) {
  if (DEBUG) {
    console.log(`🐛 [DEBUG] 创建 ${agentName}`);
    console.log(`🐛 [DEBUG] 输入:`, userInput);
    console.log(`🐛 [DEBUG] 前置结果:`, previousResult);
  }
  
  const result = await sessions_spawn({...});
  
  if (DEBUG) {
    console.log(`🐛 [DEBUG] 结果:`, result);
  }
  
  return result;
}
```

---

## 📝 测试记录模板

```markdown
## 测试记录

**日期**: 2026-03-02
**环境**: webchat
**测试输入**: orchestrate("生成小红书内容，推荐5个AI工具")

### 执行过程

1. 工具识别: ✅/❌
2. sessions_spawn 调用: ✅/❌
3. requirement-agent: ✅/❌
4. research-agent: ✅/❌
5. content-agent: ✅/❌
6. visual-agent: ✅/❌
7. quality-agent: ✅/❌

### 结果

- 总耗时: X 分钟
- 成功 Agents: X/5
- 失败 Agents: ...

### 问题

- [列出遇到的问题]

### 解决方案

- [记录解决方案]

### 结论

- [测试是否通过]
```

---

## 🚀 下一步

### 如果测试成功

1. ✅ 验证完整流程
2. 🎉 部署到生产环境
3. 📊 收集性能数据
4. 🔄 优化迭代

### 如果测试失败

1. 🔍 查看错误日志
2. 🐛 启用调试模式
3. 🔧 修复问题
4. 🔄 重新测试

---

**准备开始真实测试了吗？** 在 main Agent session 中输入：

```
orchestrate("生成小红书内容，推荐5个提升效率的AI工具")
```

然后观察执行过程，记录结果！🎯
