# 最终生成提示词

以下是四张卡片写入 `imagegen` 的最终提示词。保留它们是为了后续按相同视觉语言修订文字或生成系列扩展卡。

## 01 Model / Agent / Harness

```text
生成一张原创中文社交媒体技术知识卡片，3:4竖版，高清信息图，浅米白背景，深海军蓝主色，青绿色与橙色点缀，圆角模块，轻微纸张质感，简洁扁平矢量插图。不要模仿任何现有账号或平台模板，不放平台Logo，不放页码，不放“1/4”等序号角标。中心问题只讲“Model、Harness、Coding Agent 的区别”。所有文字必须清晰、横平竖直、简体中文与英文拼写准确，不能擅自增删或改写下列核心文字。

顶部大标题：
别再把模型、Agent、Harness 混为一谈
副标题：
同一个模型，换一套 Harness，工作方式也会变

中部从上到下三个独立圆角模块，并用箭头连接：

模块一：
Model（模型）
像“大脑”：理解、推理、生成代码
例：GPT｜Claude｜Gemini｜DeepSeek

模块二：
Harness（智能体运行框架）
像“工作台”：组织上下文、工具、权限与执行循环
Context 上下文｜Tools 工具｜Sandbox 沙箱
Session 会话｜Memory 记忆｜Loop 循环

模块三：
Coding Agent（编程智能体）
像“会干活的工程师”：围绕目标持续行动
读代码 → 做计划 → 改文件 → 跑命令 → 测试验证

底部高亮公式：
Coding Agent ≈ Model + Harness + Tools + Project Context

底部小提示：
产品常把多层打包在一起。DeepSeek 是模型家族；DeepSeek Harness 是运行框架。

视觉上用“大脑芯片—工具箱—循环工作的机器人”三个简洁图标辅助理解，图标不得代替文字。留白充足，字号适合手机阅读。
```

## 02 官方整合型 Coding Agent

```text
生成一张原创中文社交媒体技术知识卡片，3:4竖版，高清信息图，浅米白背景，深海军蓝标题，蓝紫、青绿、橙黄点缀，圆角卡片式布局，现代开发者工具气质。不要模仿现有品牌海报，不画品牌Logo，只用准确的产品名称文字；不要页码和序号角标。主题是“官方整合型 Coding Agent”，用2×2网格对比四个产品。所有文字必须清晰，简体中文与英文拼写准确。

顶部大标题：
官方整合型：模型与 Harness 一起打磨
副标题：
Coding Agent（编程智能体）＝开箱即用的开发工作流

四个同等大小模块：

Codex
入口：CLI｜Desktop｜IDE｜Cloud
模型侧：OpenAI
亮点：权限控制、工具、Skills、Subagents
定位：完整的产品化工作台
角标：Codex CLI 源码开放

Claude Code
入口：CLI｜IDE｜Desktop｜Web
模型侧：Claude
亮点：MCP、Hooks、CLAUDE.md、多 Agent
定位：Claude 生态深度整合

Gemini CLI
入口：CLI
模型侧：Gemini
亮点：Open Source、MCP、GEMINI.md、自动化
定位：终端优先的官方开源 Agent

ZCode
入口：Desktop ADE
模型侧：GLM
亮点：Goals、长任务、多 Agent、远程跟进
定位：GLM 官方 Harness

底部醒目标语：
适合：希望少折腾，直接把需求交给 Agent 的开发者

底部注释：
Open Source（开源）描述客户端或框架，不等于模型权重开放。
注：功能与入口会随版本更新。

每个模块配一个不同但抽象的线性图标，例如终端、对话气泡、星形终端、桌面工作台。布局清爽，不使用星级打分，不做胜负排名。
```

## 03 开放多模型 Coding Agent

```text
生成一张原创中文社交媒体技术知识卡片，3:4竖版，高清信息图，浅灰白背景，墨黑与深蓝文字，青绿色为主强调色，少量橙色，圆角网格卡片，专业但轻松。不要模仿现有作品，不使用品牌Logo，只使用准确的产品名文字；不要页码和序号角标。主题是“开放、多模型的 Coding Agent 怎么选”。所有中文英文必须清晰准确。

顶部大标题：
开放多模型型：自由选择 Provider
副标题：
Provider（模型服务商）会影响能力、价格、速度与数据路径

中部2×2网格：

OpenCode
形态：Terminal｜IDE｜Desktop
模型：多服务商 + Local Models
强项：多会话、自定义 Agent、细粒度权限
一句话：自由度高的通用 Coding Agent

Cline
形态：VS Code｜JetBrains｜CLI
模型：多服务商 + Local Models
强项：可视化 Diff、Checkpoint、人工审批、MCP
一句话：编辑器内的人机协作型 Agent

Aider
形态：Terminal
模型：多种 Cloud / Local LLM
强项：Repo Map、Git 提交、Lint 与 Test
一句话：轻量的 AI Pair Programmer（AI 结对编程）

Roo Code
形态：VS Code Extension
模型：Model-agnostic（模型无关）
强项：多 Provider、IDE 内完成任务
一句话：偏好 VS Code 与灵活模型接入

底部三条选择建议，短而醒目：
想跨入口、多会话 → OpenCode
想在 IDE 看 Diff 再批准 → Cline / Roo Code
想围绕 Git 快速结对编程 → Aider

底部注释：
多模型不等于零配置：仍需选择账号、API Key、费用与数据去向。
视觉元素用可切换插头、模型节点、终端和代码差异图标。不要星级评分，不宣传绝对“最好”。
```

## 04 Harness 定制与开发

```text
生成一张原创中文社交媒体技术知识卡片，3:4竖版，高清信息图，浅米白背景，深海军蓝标题，紫色和青绿色点缀，圆角模块，技术框架蓝图风格但易读。不要模仿现有账号，不画产品Logo，只显示准确产品名称；不要页码和序号角标。中心问题是“想自己造 Agent，为什么要看 Harness 层”。所有文字必须清晰，简体中文和英文拼写准确。

顶部大标题：
想自己造 Agent？看 Harness 层
副标题：
Harness（智能体运行框架）决定模型怎样使用工具、保存状态并持续执行

中部左右两大圆角模块：

Pi
英文说明：Minimal Terminal Coding Harness
中文说明：极简终端编程运行框架
默认四工具：read｜write｜edit｜bash
可扩展：Extensions｜Skills｜Prompt Templates｜Packages
多模型：支持多 Provider 与本地模型
设计取向：核心保持小，把工作流交给你组合
小字：部分能力并非内置，可通过扩展实现

DeepSeek Harness
状态：Developer Preview（开发者预览）
核心公式：Agent = Model + Harness
Everything is a Plugin（一切皆插件）
可组合：模型｜工具｜技能｜会话｜沙箱｜存储｜循环｜调度｜UI
可追踪：恢复｜分叉｜检索｜回放
形态：Web UI｜源码｜多种运行模式

底部“怎么选”三条：
要极简核心，按自己习惯搭 → Pi
要插件化基础设施与运行轨迹 → DeepSeek Harness
只想尽快完成项目 → 先选成熟 Coding Agent 产品

底部安全提醒：
Agent 能运行命令和改文件。请限制权限或使用 Sandbox（沙箱），并人工审查 Diff 与测试结果。
注：DeepSeek Harness 仍在预览阶段，API 与插件可能变化。

配图用可插拔积木、事件轨迹线、终端工具箱，关系清晰，字号适合手机阅读，不做性能排名。
```
