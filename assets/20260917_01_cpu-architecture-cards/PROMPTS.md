# 最终生成提示词

## 01 Architecture 基础

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张解释 ABI 语境中 Architecture 的基础卡片，重点区分 x86、x64/x86_64、arm64/AArch64。面向普通开发者，先用“CPU 能听懂哪种机器语言”作白话解释，再给出严谨边界。
Scene/backdrop: 100%不透明浅米白背景，极淡 CPU、二进制指令和拼图接口纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题；x86 用橙色、x86_64 用蓝色、arm64 用绿色；三列圆角信息块，少量 CPU、程序文件和齿轮图标；不用品牌 Logo。
Composition/framing: 顶部标题与定义；中部三列架构对比；下部展示“源码分别编译”和 ABI 边界。中文大字号，留白充足，手机端易读。
Text (verbatim):
"Architecture：CPU 能听懂哪种机器语言？"
"Architecture（体系结构）"
"在软件下载与 ABI 语境中，通常重点指 CPU Instruction Set Architecture（指令集架构）和位数。"
"白话：程序里的机器指令，必须是处理器与运行环境认识的那一套。"
"x86"
"常见含义：32-bit x86"
"正式名称常写 IA-32"
"常见标记：x86｜i386｜i686"
"指针通常为 32 位"
"x64 / x86_64"
"含义：64-bit x86"
"也常写 AMD64 或 Intel 64"
"是 x86 的向后兼容 64 位扩展"
"arm64 / AArch64"
"含义：64-bit Arm"
"使用 A64 指令集"
"与 x86_64 是不同的指令体系"
"同一份源代码"
"分别编译 → x86 二进制｜x86_64 二进制｜arm64 二进制"
"关键边界"
"Architecture 只是 ABI（Application Binary Interface，应用二进制接口）的一部分。"
"同为 x86_64，Windows PE、Linux ELF、macOS Mach-O 仍不能直接互换。"
"一句话：源码可以跨平台，编译后的机器码必须对架构和系统。"
Constraints: 所有大小写、下划线、连字符与中文释义逐字准确；不得把 arm64 画成 x86_64 的子集；不得暗示同架构即可跨操作系统直接运行；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 将 Architecture 等同于操作系统、把 x86_64 写成 86×64、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```

## 02 x86 与 x86_64 命名

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张专门解释 x86 与 x86_64 命名关系的卡片。要清楚说明 x86 原本是一个历史家族名，但在今天软件下载页面通常约定俗成表示 32 位；x86_64 是该家族的 64 位扩展，并解释 x64、AMD64、Intel 64 的关系。
Scene/backdrop: 100%不透明浅米白背景，极淡时间轴、芯片和指令码纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题；历史部分用灰橙色，32 位用橙色，64 位用蓝色；树状谱系加时间轴、圆角术语卡；不用品牌 Logo。
Composition/framing: 顶部直接回答“为什么一个叫 x86，一个叫 x86_64”；中部左侧历史时间轴、右侧名称对照；下部列出三个常见误区。手机端大字号，留白充足。
Text (verbatim):
"为什么 x86 是 32 位，x86_64 是 64 位？"
"先说结论"
"严格说，x86 是一个历史指令集家族名；"
"但在今天的软件下载安装语境中，x86 通常特指 32 位版本。"
"名字从哪里来？"
"8086 → 80286 → 80386 → 80486"
"多代处理器名称都以“86”结尾，于是形成 x86 家族叫法。"
"32 位分支"
"80386 引入成熟的 32 位体系"
"IA-32（Intel Architecture 32-bit）"
"下载页常简写：x86"
"64 位扩展"
"AMD 在 x86 基础上扩展 64 位能力"
"架构名：AMD64 / x86-64"
"Linux / Unix 常写：x86_64 或 amd64"
"Windows 常写：x64"
"Intel 的兼容实现称：Intel 64"
"在普通软件下载语境中"
"x64 ≈ x86_64 ≈ AMD64"
"都表示 64 位 x86 软件目标"
"三个常见误区"
"① x86 名字本身不等于“只有 32 位”；要看上下文。"
"② x86_64 不是独立于 x86 的陌生架构，而是兼容扩展。"
"③ x64 / x86_64 不等于 IA-64；IA-64 是 Itanium 的另一套架构。"
"一句话：x86 是家族名，下载页把 x86 当 32 位；加上 _64 才明确表示 64 位扩展。"
Constraints: 必须保留“严格含义”和“软件下载约定”两层表述；不得声称 x64、AMD64、Intel 64 在所有底层细节上绝对完全相同，只说明普通软件下载目标通常相同；IA-64 必须与 x86_64 区分；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 把 x86 解释成 86 位、把 x86_64 写成 x86×64、把 IA-64 画成 x86_64 别名、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```

## 03 x86 与 x86_64 内部差异

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张深入但易懂的 x86 与 x86_64 技术差异卡片，从指针、地址空间、寄存器、二进制格式、DLL/动态库兼容和性能误区讲清 32 位与 64 位。必须使用“通常”限定主流 ABI，避免把所有实现绝对化。
Scene/backdrop: 100%不透明浅米白背景，极淡内存格、寄存器和二进制文件纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题；左侧 x86 用橙色，右侧 x86_64 用蓝色；中央对比箭头，圆角表格，底部风险提示；不用品牌 Logo。
Composition/framing: 顶部结论；中部五行左右对比；下部单列解释“64 位不等于两倍快”和同进程模块规则。手机端大字号、留白充足。
Text (verbatim):
"x86 与 x86_64：不只是数字变大"
"主流 ABI 下：32 位和 64 位改变了指针、寄存器、地址空间与二进制接口。"
"x86（32 位）"
"Pointer（指针）：通常 32 位"
"地址数量上限：2³² = 4 GiB"
"这是单个进程的理论虚拟地址范围；实际可用量由操作系统与配置决定。"
"通用寄存器：8 个，常见 EAX、EBX、ESP"
"常见二进制：PE32｜ELF32｜Mach-O i386"
"x86_64（64 位）"
"Pointer（指针）：通常 64 位"
"虚拟地址空间大幅增加"
"实际 CPU 与操作系统通常只实现 64 位地址中的一部分。"
"通用寄存器：16 个，RAX 及 R8–R15"
"常见二进制：PE32+｜ELF64｜Mach-O x86_64"
"同一进程的硬规则"
"32 位进程不能直接加载 64 位 DLL / 动态库"
"64 位进程也不能直接加载 32 位 DLL / 动态库"
"需要拆成两个进程时，可通过 IPC（Inter-Process Communication，进程间通信）协作。"
"64 位一定更快吗？"
"不一定。更多寄存器和更大地址空间可能有利；但指针变大也会增加部分内存占用。"
"最终性能取决于算法、编译器、缓存、指令和工作负载。"
"一句话：64 位的核心是更大的寻址能力和新的 ABI，不是简单“速度翻倍”。"
Constraints: 2³²、4 GiB、EAX、ESP、RAX、R8–R15、PE32+ 大小写和符号逐字准确；不得把 4 GiB 写成每个 x86 程序必然全部可用；不得声称所有 x86_64 ABI 指针都必然 64 位；不得承诺性能翻倍；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 把 bit 等同于 CPU 核心数、把 PE32+ 写成 32 位格式、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```

## 04 跨架构兼容规则

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张“不同架构能不能运行与混用”的兼容性卡片，分别说明 Windows、Linux、macOS 在 x86、x86_64、arm64 之间的原生执行、兼容层和硬限制。核心结论是“能启动不等于能在同一进程混装模块”。
Scene/backdrop: 100%不透明浅米白背景，极淡系统窗口、齿轮与桥接层纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题；原生执行用绿色、翻译/兼容层用蓝色、不能混用用红色；三段系统卡片和一个同进程示意；不用品牌 Logo。
Composition/framing: 顶部给出 Compatibility（兼容性）判断公式；中部按 Windows、Linux、macOS 分三块；下部突出 DLL/插件/驱动规则。手机端大字号、留白充足。
Text (verbatim):
"能运行 ≠ 能混装：架构兼容要分层"
"Compatibility（兼容性）= CPU + 操作系统 + 兼容层 + 应用及依赖"
"Windows x64"
"x64 应用：原生运行"
"x86 应用：通常通过 WOW64（Windows 32-bit on Windows 64-bit）运行"
"硬限制：x86 进程只能加载 x86 DLL；x64 进程只能加载 x64 DLL"
"Linux x86_64"
"x86_64 应用：原生运行"
"32 位 x86 应用：需要内核兼容能力、32 位 Loader（加载器）和对应库"
"是否可用取决于发行版与安装的 multilib 组件"
"macOS"
"Intel Mac：原生目标通常是 x86_64"
"Apple silicon：原生目标是 arm64"
"Rosetta 可把许多 x86_64 Mac 应用翻译后运行在 Apple silicon"
"macOS Catalina 10.15 起不再兼容 32 位应用"
"同一进程不能混装"
"x86 主程序 ↔ x64 DLL：不行"
"arm64 主程序 ↔ x86_64 插件：通常不行"
"翻译通常作用于整个进程，插件与动态库仍要匹配该进程的架构。"
"Windows on Arm"
"Windows 11 on Arm 可模拟许多 x86 与 x64 用户态应用"
"Kernel Driver（内核驱动）必须是原生 arm64，不能依赖用户态模拟。"
"一句话：兼容层可以让旧应用启动，但不会自动改造所有 DLL、插件和驱动。"
Constraints: WOW64 全称、Rosetta、macOS Catalina 10.15、arm64、x86_64、multilib 拼写准确；不得暗示 Linux 必然预装 32 位库；不得暗示 Rosetta 支持 32 位 x86 应用；不得暗示 Windows 驱动可以模拟；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 把 WOW64 解释成 Windows 64 位应用、把 Rosetta 画成跨操作系统运行工具、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```

## 05 下载与查看指南

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张软件下载安装与构建时的架构名称对照卡片，重点解决 x86、ia32、x64、x86_64、amd64、arm64、aarch64 在不同工具中的命名差异，并给出 Windows、macOS、Linux 查看系统架构的可靠方法。
Scene/backdrop: 100%不透明浅米白背景，极淡下载按钮、终端和 CPU 标签纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题；三种架构分别用橙、蓝、绿；名称对照表、选择流程和等宽字体命令块；不用品牌 Logo。
Composition/framing: 顶部一句选择原则；中部三行名称映射表；下部按 Windows、macOS、Linux 给出查看方法；底部放下载决策和两个注意事项。手机端大字号、留白充足。
Text (verbatim):
"下载软件时，x86、x64、amd64 到底选谁？"
"先看 OS Architecture（操作系统架构），再看应用和原生依赖是否匹配。"
"同一种架构，不同工具可能换名字"
"32-bit x86"
"下载页：x86 / 32-bit"
"Node.js / Electron：ia32"
"Linux 常见：i386 / i686"
"64-bit x86"
"下载页：x64 / x86_64"
"Debian / Docker 常见：amd64"
"Node.js / Electron：x64"
"64-bit Arm"
"下载页：arm64 / AArch64"
"Linux uname 常见：aarch64"
"Node.js / Electron：arm64"
"Windows PowerShell"
"[System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture"
"[System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture"
"OSArchitecture 看系统；ProcessArchitecture 看当前 PowerShell 进程。"
"macOS / Linux"
"uname -m"
"x86_64 → 64 位 x86"
"aarch64 或 arm64 → 64 位 Arm"
"macOS 还可用：file /path/to/app"
"Universal Binary（通用二进制）可同时包含 x86_64 与 arm64 切片。"
"快速选择"
"系统是 X64 / x86_64 / AMD64 → 优先选 x64"
"系统是 ARM64 / aarch64 → 优先选 arm64"
"只有旧 32 位系统，或明确需要 32 位进程 → 选 x86 / ia32"
"注意"
"Apple silicon 的 Rosetta 终端可能报告 x86_64；还要核对芯片与进程是否被翻译。"
"主程序、DLL / 插件、Native Addon（原生扩展）必须匹配同一进程架构。"
"一句话：名称可以不同，真正要对齐的是同一套机器指令与 ABI。"
Constraints: ia32 必须说明是 Node.js/Electron 对 32 位 x86 的标记，不得暗示 IA-32 等于 IA-64；amd64 必须映射到 64 位 x86；aarch64 必须映射到 64 位 Arm；两条 RuntimeInformation 属性名称逐字准确；不得把 uname -m 描述为永远不受翻译环境影响；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 建议所有用户一律下载 x64、把 amd64 解释成只支持 AMD CPU、把 arm64 与 x86_64 视为同义词、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```
