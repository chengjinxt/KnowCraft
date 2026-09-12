# Mac 芯片与软件兼容知识卡片

## 卡片

- `01-mac-chip-software-guide.png`：识别 Mac 的处理器架构，并选择正确的软件安装包。

## 核心知识

Mac 软件兼容性主要按两类处理器架构判断：

1. `Apple silicon（苹果芯片）`：采用 `arm64 / aarch64` 架构，常见于 M 系列 Mac。下载软件时选择 `Apple silicon`、`ARM64` 或 `arm64` 版本。
2. `Intel（英特尔芯片）`：采用 `x86_64 / x64` 架构。下载软件时选择 `Intel`、`x86_64` 或 `x64` 版本。

查看方法：打开系统菜单中的 `About This Mac（关于本机）`：

- 显示 `Chip（芯片）`，表示 Mac 使用 Apple silicon。
- 显示 `Processor（处理器）`，并列出 Intel 处理器，表示它是 Intel Mac。

## 软件下载与使用

- `Universal（通用版）`同时包含 `arm64` 和 `x86_64` 代码，能在两类 Mac 上原生运行；仍需确认软件要求的 macOS 版本。
- `Rosetta 2（转译层）`可以让 Apple silicon Mac 运行许多只含 `x86_64` 代码的 Intel 应用，但不是所有应用或组件都能兼容。
- Intel Mac 不能运行只提供 `arm64` 的 `Apple-silicon-only（仅苹果芯片版）`应用。
- 即使主程序可以运行，驱动、插件、扩展、虚拟机、命令行工具和带原生模块的开发环境也可能需要单独适配。
- Homebrew、Python、Node.js 及其原生扩展应尽量保持同一架构，混用 `arm64` 与 `x86_64` 环境容易产生依赖或加载错误。
- Apple silicon 上优先选择原生版或 Universal 版，通常能获得更好的性能和未来兼容性。

## 容易误解的地方

- Apple T2 是部分 Intel Mac 中的安全芯片，不是第三种 Mac 软件架构；判断软件版本时仍把这类机器归为 Intel Mac。
- M1、M2、M3、M4 等属于具体芯片系列名称，选择普通软件安装包时通常关注 `Apple silicon / arm64`，不需要为每一代 M 芯片分别下载。
- `Universal` 只解决处理器架构兼容，不代表软件一定兼容当前 macOS 版本、外设或插件。
- Apple 已说明 Rosetta 是过渡技术。截至 2026-08-30，Apple 表示 Rosetta 对普通 Intel 应用的广泛支持将保留至 macOS 27，从 macOS 28 起只为部分依赖 Intel 框架的旧游戏保留有限功能，因此不应把 Rosetta 当作长期兼容保证。

## 官方参考

- [Mac computers with Apple silicon](https://support.apple.com/en-ie/116943)
- [Using Intel-based apps on a Mac with Apple silicon](https://support.apple.com/en-ca/102527)
- [Building a universal macOS binary](https://developer.apple.com/documentation/apple-silicon/building-a-universal-macos-binary)
- [About the Rosetta translation environment](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment)

## 生成说明

- 生成方式：Codex 内置 `imagegen`。
- 画面规格：3:4 竖版、暖白网格背景、高对比标题、圆角信息块，适合手机阅读。
- Prompt：两类 Mac 架构对比、关于本机识别方法、安装包选择、Universal 与 Rosetta 2、开发工具和插件注意事项。
- 视觉参考：项目既有 Microsoft Store 卡片的配色与版式语言；未复制官方标志或产品界面。
- 检查结果：中英文术语、架构名称和软件兼容关系已逐项核对；无页码角标、水印或二维码。
