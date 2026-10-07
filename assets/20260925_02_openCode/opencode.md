如果你说的是 **OpenCode（opencode.ai）**，它是一款**开源 AI Coding Agent（AI 编程代理）**。可以把它理解成和 Claude Code、Codex CLI 这一类工具相近的产品：它不只是“聊天生成代码”，而是可以直接进入你的项目目录，理解代码库、搜索文件、修改代码、执行命令，并围绕一个开发任务连续工作。([OpenCode](https://opencode.ai/en/docs?utm_source=chatgpt.com))

[OpenCode 官网](https://opencode.ai/?utm_source=chatgpt.com)
[OpenCode 官方文档](https://opencode.ai/docs/?utm_source=chatgpt.com)

### OpenCode 到底是什么？

传统的 ChatGPT/Copilot 更像：

> 你问问题 → AI 给代码 → 你复制进去 → 编译 → 出错 → 再问。

OpenCode 更偏向 **Agent 模式**：

> 你给任务 → OpenCode 分析整个项目 → 搜索相关代码 → 制定修改方案 → 修改多个文件 → 执行命令/测试 → 根据错误继续修改。

例如进入一个 Qt/C++ 项目后运行：

```bash
cd my-project
opencode
```

然后直接告诉它：

```text
分析这个项目的 socket 连接逻辑，
找到断线重连相关代码，
检查有没有资源泄漏，并给出修改方案。
```

它可以自己读取相关源文件，而不是要求你把几十个 `.cpp/.h` 文件逐个复制给 AI。

### 它比较突出的地方

OpenCode 最大特点之一是**模型无关**。官方目前宣称通过 Models.dev 支持 75+ LLM Provider，可以使用 Claude、GPT、Gemini 以及本地模型等；也就是说 OpenCode 本身主要负责 **Agent、工具调用、代码上下文和交互界面**，真正负责推理和生成代码的是后面的模型。([OpenCode](https://opencode.ai/en/?utm_source=chatgpt.com))

可以把架构简单理解为：

```text
              OpenCode
                  │
       ┌──────────┼──────────┐
       │          │          │
    Claude       GPT       Gemini
       │          │          │
       └──────────┼──────────┘
                  │
             Agent Engine
                  │
       ┌──────────┼──────────┐
       │          │          │
     文件系统     Shell       LSP
       │          │          │
       └──────────┼──────────┘
                  │
              你的代码项目
```

因此它与某一家模型厂商绑定的 Coding Agent 有一个明显区别：**Agent 框架和模型是可以分开的。**

官方当前还列出了 LSP、同一项目多会话并行、会话分享、GitHub Copilot 登录，以及终端、IDE、桌面端等能力。([OpenCode](https://opencode.ai/en/?utm_source=chatgpt.com))

### Agent 机制也比较有意思

OpenCode 支持定义自己的 Agent。一个 Agent 可以包含自己的 **System Prompt、模型选择、权限和行为规则**，还可以作为 subagent 被其他 Agent 调用。([OpenCode](https://opencode.ai/v2/docs/agents?utm_source=chatgpt.com))

比如可以专门定义：

```text
main agent
   │
   ├── reviewer
   │     └── 只负责 Code Review
   │
   ├── debugger
   │     └── 分析 bug / 日志
   │
   └── test
         └── 编写和执行测试
```

这和你之前研究 AI Agent/Skills 的思路比较接近：**模型只是“大脑”，Agent 决定模型拥有什么上下文、工具、权限和工作流程。**

### 项目上下文：AGENTS.md

首次进入项目后，可以执行：

```bash
opencode
```

再执行：

```text
/init
```

OpenCode 会分析项目并生成 `AGENTS.md`，官方还建议把它提交到 Git。这个文件可以帮助 OpenCode理解项目结构、开发规范和代码模式。([OpenCode](https://opencode.ai/en/docs?utm_source=chatgpt.com))

例如里面可以描述：

```text
这是一个 Qt 6 + C++ 项目。

src/network/
负责网络通信

src/ui/
负责界面

要求：
- 使用 C++17
- 不允许裸指针
- socket 使用 QTcpSocket
- 日志统一使用 INFOW_LOG
```

以后你让 Agent 修改项目时，它就能按照这些项目约定工作。

### OpenCode 和 Claude Code / Cursor 的关系

粗略从产品定位看：

| 维度         | OpenCode                 | Claude Code      | Cursor       |
| ------------ | ------------------------ | ---------------- | ------------ |
| 主要形态     | Terminal / IDE / Desktop | Terminal         | IDE          |
| Agent 编程   | 强                       | 强               | 强           |
| 开源         | **是**                   | 否               | 否           |
| 模型选择     | **非常灵活**             | Claude 为核心    | 多模型       |
| 本地项目操作 | 是                       | 是               | 是           |
| Shell        | 是                       | 是               | 是           |
| LSP          | **支持**                 | 支持代码理解能力 | 深度集成     |
| 自定义 Agent | **支持**                 | 支持             | 支持         |
| 更适合       | CLI/Agent 爱好者         | Claude 用户      | GUI/IDE 用户 |

所以如果你本身经常使用 **Windows + WSL2 + C++/Qt/Python** 这一类开发环境，OpenCode 是比较值得研究的一类工具，因为它更像：

**“开源、模型可替换的 Claude Code/Codex CLI 式 Agent 框架。”**

另外一个值得关注的方向是它的 **Agent + LSP + Shell + 文件系统 + 多模型 Provider** 的组合，这也是理解现在 AI Coding Agent 工作原理的一个很好的开源案例。

如果你接下来想深入，我可以直接从 **OpenCode 的架构和源码调用流程**讲起，把“用户输入 → Agent → LLM → Tool Call → Shell/文件修改 → 再次调用 LLM”的完整链路画出来，并顺便和 **Claude Code、Codex CLI、Gemini CLI** 做一张架构对比图。