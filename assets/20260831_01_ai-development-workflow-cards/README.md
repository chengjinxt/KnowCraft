# AI 开发流程与 Codex 自测知识卡片

本组包含两张横屏知识卡片：第一张保留参考图的五步流程和主要文字，只重做信息网格；第二张展开说明如何让 Codex 真正执行 AI 自测。

## 图片清单

- `01-five-step-development-workflow.png`：环境搭建 → 产品设计 → 技术设计 → 产品实现 → 人工验证。
- `02-codex-ai-self-test.png`：准备 Codex 的操作能力，并按“计划 → 检查 → 操作 → 留证 → 复测”形成自测闭环。

## 五步流程

1. `Environment（环境搭建）`：准备 `Git` 和项目级 `AGENTS.md`。
2. `Product Design（产品设计）`：明确产品方案，尽早用 `Demo` 验证思路。
3. `Technical Design（技术设计）`：确定技术方案、模块边界和风险。
4. `Implementation（产品实现）`：编写代码并让 AI 自测。
5. `Human Validation（人工验证）`：由人确认功能、体验和高风险操作。

## 如何让 Codex 执行 AI 自测

### 1. 准备操作能力

- 正确名称是 `Computer Use（电脑操作）`，不是 `Computer User`。
- 在 ChatGPT 桌面应用的 `Plugins` 页面安装 `Computer Use`，并启用对应的 server 和 skill。它让 Codex 看见并操作图形界面，适合点击、输入和跨应用流程。
- 测试 `localhost` 等本地网页时，优先使用内置 `@Browser`。
- 如果必须复用普通 Chrome 中已有的登录状态，在桌面应用 `Settings → Computer Use` 中选择 Chrome，按提示安装 `ChatGPT browser extension（ChatGPT 浏览器扩展）`；新建 Codex 会话后用 `@Chrome` 指定浏览器。
- 内置 Browser 目前用于 ChatGPT 桌面应用或 Web 中的 Codex，不等同于 Codex CLI 或 IDE 扩展里的浏览器能力。

### 2. 给出可执行的测试计划

至少写清以下内容：

- 测试环境：`local`、`staging` 或其他明确地址。
- 核心流程：例如登录、填写表单、提交和查看结果。
- 预期结果：每一步完成后应该看到什么。
- 异常路径：例如空值、错误凭据、断网或重复提交。

### 3. 让 Codex 运行并操作

先执行项目已有的 `lint → test → build`，再打开真实界面检查 UI。命令失败时先读取日志并定位问题；界面测试则使用 Browser 或 Computer Use 完成点击、输入、跳转和跨应用操作。

### 4. 要求留下可复现证据

每个问题至少记录：

- `Reproduction steps（复现步骤）`
- `Expected（预期结果）`
- `Actual（实际结果）`
- `Severity（严重程度）`
- 截图、日志或终端输出

### 5. 修复后沿同一路径复测

不要把“代码已经修改”当作完成。按 `Fail → Fix → Retest（失败 → 修复 → 复测）` 沿原路径重新执行，确认旧问题消失且没有引入明显回归。

## 可直接交给 Codex 的自测提示词

```text
请在 local 环境完成一次端到端自测：
1. 先运行项目已有的 lint、test 和 build；
2. 使用 @Browser 打开本地网页，验证登录、表单填写和提交主流程；
3. 同时检查空值和错误输入；
4. 每个问题记录复现步骤、Expected、Actual、Severity，并附截图或日志；
5. 修复后沿相同路径复测；
6. 涉及账号、支付、删除或外部发送时先停下等待人工确认。
```

如果要复用 Chrome 的既有登录状态，把 `@Browser` 改为 `@Chrome`，并先完成浏览器扩展安装和授权。

## 平台与安全边界

- Windows：使用 Computer Use 时，目标应用需要保持在当前活动桌面并处于前台可见状态。
- macOS：通常需要授予 `Screen Recording（屏幕录制）` 和 `Accessibility（辅助功能）` 权限。
- 网页内容属于不可信上下文；账号、支付、删除、发布和外部消息等敏感操作应保持人工在场。
- 有结构化插件、连接器或 MCP 可用时，优先使用结构化能力；Computer Use 更适合没有可靠接口的可视化交互。

## 参考资料

- [QA your app with computer use](https://learn.chatgpt.com/use-cases/qa-your-app-with-computer-use)
- [Computer use](https://learn.chatgpt.com/docs/computer-use)
- [Browser](https://learn.chatgpt.com/docs/browser)
- [Browser extension](https://learn.chatgpt.com/docs/chrome-extension)
- [Plugins](https://learn.chatgpt.com/docs/plugins)

## 生成与检查

- 生成方式：Codex 内置 `imagegen`。
- 第一张以用户提供的五步流程图作为内容参考，以项目已有卡片作为视觉气质参考；第二张基于官方 Codex 文档重新组织为自测流程。
- 已人工检查横屏比例、五步顺序、主要中文和关键英文术语；图片中的界面是知识图示，不代表产品设置页面的逐像素截图。
