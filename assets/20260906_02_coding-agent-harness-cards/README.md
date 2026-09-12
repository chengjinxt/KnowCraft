# Coding Agent、Model 与 Harness 知识卡片

本目录包含四张原创竖版知识卡片：

- `01-model-agent-harness.png`：解释 `Model（模型）`、`Harness（智能体运行框架）` 与 `Coding Agent（编程智能体）` 的关系。
- `02-integrated-coding-agents.png`：介绍 Codex、Claude Code、Gemini CLI 与 ZCode 这类官方整合型产品。
- `03-open-multimodel-agents.png`：介绍 OpenCode、Cline、Aider 与 Roo Code 这类开放、多模型工具。
- `04-harness-builders.png`：对比 Pi 与 DeepSeek Harness 两种面向 Harness 定制和开发的思路。

## 一句话理解

```text
Coding Agent ≈ Model + Harness + Tools + Project Context
```

- `Model（模型）`：负责理解、推理和生成内容，像“大脑”。
- `Harness（智能体运行框架）`：负责组织上下文、工具、权限、会话、沙箱和执行循环，像“工作台”。
- `Coding Agent（编程智能体）`：模型在 Harness 中围绕开发目标持续读取代码、修改文件、运行命令并验证结果。
- `Provider（模型服务商）`：提供模型推理接口、账号认证和计费服务；它会影响可选模型、价格、速度和数据路径。

产品通常同时包含多个层次，不能只凭“是否开源”一个勾叉判断整个产品。例如 Codex CLI 的客户端源码开放，但这不代表它所连接的模型权重也开放；同理，多模型 Harness 可以连接 DeepSeek 模型，但 DeepSeek 模型与 DeepSeek Harness 仍是两个不同概念。

## 工具定位速览

以下内容是定位归纳，不是性能跑分，也不表示某个产品绝对优于其他产品。

| 工具 | 主要形态 | 模型取向 | 适合的需求 |
| --- | --- | --- | --- |
| Codex | CLI、IDE、Desktop、Cloud | OpenAI | 希望使用完整产品化工作流、权限控制、工具与多 Agent 协作 |
| Claude Code | CLI、IDE、Desktop、Web | Claude | 希望深度使用 Claude、MCP、Hooks、项目指令和多 Agent 工作流 |
| Gemini CLI | CLI | Gemini | 希望在终端使用 Google 官方开源 Agent，并接入 MCP 与自动化 |
| ZCode | Desktop ADE | GLM | 希望处理长任务、Goals、多 Agent 和跨设备跟进 |
| OpenCode | Terminal、IDE、Desktop | 多 Provider 与本地模型 | 希望跨入口、多会话并细调 Agent 与权限 |
| Cline | VS Code、JetBrains、CLI | 多 Provider 与本地模型 | 希望在编辑器内查看 Diff、Checkpoint 并逐步批准 |
| Roo Code | VS Code Extension | Model-agnostic | 希望保留 VS Code 工作流并灵活选择模型服务商 |
| Aider | Terminal | 多种云端或本地 LLM | 希望围绕 Git、Repo Map、Lint 和 Test 进行轻量结对编程 |
| Pi | Terminal、RPC、SDK | 多 Provider 与本地模型 | 希望从极简核心出发，用扩展和技能自行组合工作流 |
| DeepSeek Harness | Web UI、源码框架 | 插件化模型层 | 希望研究或搭建可组合、可追踪、可回放的 Agent 基础设施 |

## DeepSeek Harness 的特殊之处

`DeepSeek Harness` 官方使用的核心表达是：

```text
Agent = Model + Harness
Everything is a Plugin（一切皆插件）
```

它把模型、工具、技能、会话、沙箱、存储、循环、调度和 UI 都设计成可组合插件，并用仅追加的会话事件流支持恢复、分叉、检索与回放。

截至 `2026-09-06`，DeepSeek Harness 仍标注为 `Developer Preview（开发者预览）`，核心插件与基础 API 可能继续变化。它更适合 Harness 开发、Agent 研究和深度定制，不应把“预览版框架”与“成熟产品化 Coding Agent”直接放在同一条性能排行中。

## Pi 的特殊之处

Pi 把自己定义为 `Minimal Terminal Coding Harness（极简终端编程运行框架）`。默认给模型提供 `read`、`write`、`edit` 和 `bash` 四个工具，并通过 `Extensions`、`Skills`、`Prompt Templates` 和 `Packages` 扩展。

Pi 有意不把 Subagents、Plan Mode、MCP 或权限弹窗等能力全部做进核心；需要这些能力时，可以通过扩展、第三方包或外部隔离环境自行组合。这意味着自由度更高，也意味着使用者要承担更多架构与安全设计工作。

## 选型时真正该看什么

- 想少配置、快速开始：优先看官方整合型产品及其账号、平台和模型生态。
- 想灵活切换模型：看 Provider 支持、本地模型支持、API Key 管理和数据去向。
- 想在 IDE 里逐步审查：看 Diff、Checkpoint、人工审批和回滚体验。
- 想开发自己的 Agent：看 SDK、插件机制、权限模型、会话状态、可观测性与回放能力。
- 想用于企业代码：额外核对数据处理、模型服务商条款、代理设置、网络出口和密钥保存方式。

`Open Source（开源）`、`Open Weight（开放权重）`、`Local Model（本地模型）` 和 `Cloud Service（云服务）` 是四个不同维度，不能互相替代。

## 安全边界

Coding Agent 可能读取仓库、修改文件、运行命令、访问网络或调用第三方工具。无论使用哪一种产品，都建议：

- 只授予完成任务所需的最小权限；
- 对高风险项目使用 `Sandbox（沙箱）`、容器或隔离虚拟机；
- 不把密钥、生产数据和隐私文件无差别暴露给 Agent；
- 人工审查 `Diff（差异）`，并运行最接近改动的测试、构建和静态检查；
- 在合并或发布前确认模型生成内容的许可证、安全性与业务正确性。

## 参考依据

- [Codex CLI 官方文档](https://learn.chatgpt.com/zh-Hans/docs/codex/cli)
- [Codex CLI 官方开源仓库](https://github.com/openai/codex)
- [Claude Code 官方概览](https://code.claude.com/docs/en/overview)
- [Gemini CLI 官方介绍](https://blog.google/innovation-and-ai/technology/developers-tools/introducing-gemini-cli-open-source-ai-agent/)
- [Gemini CLI 官方开源仓库](https://github.com/google-gemini/gemini-cli)
- [ZCode 官方文档](https://zcode.z.ai/cn/docs/agents)
- [OpenCode 官方网站](https://opencode.ai/)
- [OpenCode Agent 官方文档](https://opencode.ai/docs/agents/)
- [Cline 官方开源仓库](https://github.com/cline/cline)
- [Roo Code Provider 官方文档](https://roocodeinc.github.io/Roo-Code/providers/)
- [Aider 官方网站](https://aider.chat/)
- [Pi 官方开源仓库](https://github.com/earendil-works/pi/tree/main/packages/coding-agent)
- [DeepSeek Harness 官方页面](https://www.deepseek.com/harness/)
- [DeepSeek Harness 官方开源仓库](https://github.com/deepseek-ai/deepseek-harness)

## 生成与检查

- 生成方式：Codex 内置 `imagegen`。
- 版式：`3:4` 竖版、浅色背景、高对比标题、圆角信息块；没有页码或系列序号角标。
- 提示词：完整最终提示词保存在 `PROMPTS.md`。
- 检查重点：产品名称、`Harness`、`Provider`、`Subagents`、`Developer Preview`、中英文释义、卡片间概念归属，以及 Open Source 与模型权重的区别。
- 时效说明：产品入口、支持模型、开源范围、定价和功能会更新；本文档与卡片按 `2026-09-06` 的官方资料整理。

