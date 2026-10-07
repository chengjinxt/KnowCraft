# CPU Architecture：x86、x86_64、x64 与 arm64 知识卡片

本目录包含五张原创竖版知识卡片：

- `01-architecture-basics.png`：解释 ABI 中的 Architecture，以及 x86、x86_64、arm64 的基本区别。
- `02-x86-vs-x86-64-naming.png`：重点解释为什么下载页面把 x86 当作 32 位，以及 x64、x86_64、AMD64、Intel 64 的关系。
- `03-x86-vs-x86-64-internals.png`：比较 32/64 位的指针、地址空间、寄存器、二进制格式和模块加载规则。
- `04-cross-architecture-compatibility.png`：解释 Windows、Linux、macOS 的原生执行、兼容层、Rosetta、WOW64 与驱动限制。
- `05-architecture-download-guide.png`：提供架构名称对照、查看命令和软件下载选择方法。

## Architecture 在 ABI 里是什么意思

`Architecture（体系结构）` 是一个较宽的概念。在软件下载和 `ABI (Application Binary Interface，应用二进制接口)` 语境中，通常首先关注：

- `ISA (Instruction Set Architecture，指令集架构)`：处理器认识哪些机器指令。
- `Bitness（位数）`：主流 ABI 中指针、寄存器和地址能力的基本宽度。
- 目标平台给这种架构规定的调用约定、寄存器使用、数据布局和二进制格式。

白话上可以理解为：源代码是“人写的说明”，编译后的机器码是“CPU 能直接执行的语言”。同一份 C/C++、Rust 或其他源代码可以分别编译为 x86、x86_64 和 arm64，但生成的机器码不能随意互换。

Architecture 只是 ABI 的一个维度。同为 x86_64：

```text
Windows 常用 PE / PE32+
Linux 常用 ELF
macOS 常用 Mach-O
```

操作系统 API、调用约定、动态链接方式和运行库也不同，因此不能因为 CPU 架构相同，就认为三个系统的二进制文件可以直接互换。

## 为什么 x86 通常表示 32 位

`x86` 最初是一个历史家族名，来自 `8086 → 80286 → 80386 → 80486` 等以“86”结尾的处理器名称。它本身不是“86 位”的意思，也并非从严格定义上只包含 32 位。

80386 建立了成熟的 32 位 x86 编程模型。Intel 官方通常称其为：

```text
IA-32 (Intel Architecture 32-bit)
```

随着 64 位版本出现，软件行业需要区分两类安装包，于是形成了约定俗成的下载标签：

```text
x86     → 通常表示 32 位 x86 软件
x86_64  → 明确表示 64 位 x86 软件
```

所以更准确的说法是：

- 严格的架构历史语境里，x86 是一个家族名。
- 今天的软件下载、构建配置和安装包命名里，单独写 `x86` 通常表示 32 位版本。

## x64、x86_64、AMD64、Intel 64 是什么关系

AMD 在传统 x86 基础上设计了向后兼容的 64 位扩展，称为 `AMD64`，也广泛称为 `x86-64`。Intel 的兼容实现称为 `Intel 64`。Microsoft 和许多 Windows 工具常用 `x64` 作为简写。

普通软件下载语境下，可以这样理解：

| 常见名称 | 通常指向 | 常见位置 |
|---|---|---|
| `x64` | 64 位 x86 | Windows、Node.js、Electron、.NET |
| `x86_64` | 64 位 x86 | Linux、Unix、macOS、`uname -m` |
| `AMD64` / `amd64` | 64 位 x86 | AMD 文档、Debian、Docker、Go 等 |
| `Intel 64` | Intel 对兼容 64 位 x86 的官方称呼 | Intel 文档 |

因此，标为 `amd64` 的 Linux 包或容器镜像并不表示“只能在 AMD CPU 上运行”。现代 Intel 64 处理器通常也运行同一类 64 位 x86 软件。

这些名称在架构实现的历史细节上并非所有地方都能简单说成绝对相同，但对普通应用下载和构建目标而言，通常表示同一个 64 位 x86 软件生态。

### 不要把 x86_64 与 IA-64 混淆

`IA-64` 是 Intel Itanium 使用的另一套架构，不是 `IA-32` 的普通 64 位模式，也不是 `x64 / x86_64 / AMD64` 的别名。

```text
x86_64 / x64 / AMD64 → 现在常见的 64 位 PC 与服务器架构
IA-64 / Itanium      → 另一套不同架构
```

## x86 与 x86_64 的技术差异

下面描述主流 ABI 的常见实现，不代表所有特殊 ABI。

| 项目 | x86（32 位） | x86_64（64 位） |
|---|---|---|
| 指针 | 通常 32 位 | 通常 64 位 |
| 理论地址数量 | `2^32 = 4 GiB` | 大幅增加；实际 CPU/OS 通常只实现 64 位地址中的一部分 |
| 通用寄存器 | 8 个，常见 `EAX`、`EBX`、`ESP` | 16 个，常见 `RAX` 与 `R8–R15` |
| Windows 映像 | 常见 `PE32` | 常见 `PE32+` |
| Linux 映像 | 常见 `ELF32` | 常见 `ELF64` |
| macOS 映像 | 历史上常见 `i386` slice | 常见 `x86_64` slice |

`2^32 = 4 GiB` 指 32 位地址能表示的理论地址数量。单个进程实际可用的虚拟地址空间会受到操作系统、内核划分、可执行文件标志和配置影响，不能简单说每个 32 位进程一定拥有完整 4 GiB 可用内存。

64 位也不等于“速度自动翻倍”：

- 更多寄存器和更大地址空间可能提高某些工作负载的效率。
- 64 位指针更大，某些对象、指针密集结构和缓存占用也会增加。
- 最终性能取决于算法、编译器、缓存、向量指令、内存访问和实际工作负载。

## 最容易踩坑的规则：进程与模块必须配套

在同一个传统原生进程里：

```text
x86 主程序   → 加载 x86 DLL / 动态库
x64 主程序   → 加载 x64 DLL / 动态库
arm64 主程序 → 加载 arm64 DLL / 动态库
```

32 位进程不能直接加载 64 位 DLL，64 位进程也不能直接加载 32 位 DLL。类似规则同样影响：

- 浏览器或编辑器插件。
- Shell Extension（外壳扩展）。
- `Native Addon（原生扩展）`，例如 Node.js / Electron 的 `.node` 文件。
- COM in-process server。
- 注入到其他进程的 DLL。

确实需要跨位数协作时，可以把组件拆成独立进程，再通过 `IPC (Inter-Process Communication，进程间通信)`、本地网络协议或 out-of-process COM 通信。

## Windows 的兼容规则

### x64 Windows

64 位 Windows 通常通过 `WOW64 (Windows 32-bit on Windows 64-bit)` 运行 32 位 x86 用户态程序。WOW64 提供系统调用转换、32 位系统库，以及文件系统和注册表重定向等兼容机制。

它不会允许 x86 进程直接加载 x64 DLL，也不会把一个 32 位插件自动变成 64 位插件。

### Windows on Arm

Microsoft 当前文档说明：

- Windows 11 on Arm 可以模拟许多 x86 和 x64 用户态应用。
- Windows 10 on Arm 主要提供 x86 应用模拟，不应据此假定所有 x64 应用都可运行。
- 内核驱动不能依赖用户态模拟，必须为 Arm64 原生构建。
- Shell 扩展、进程注入模块和其他需要进入原生系统进程的 DLL，也必须匹配目标进程架构。

兼容层让很多旧程序“能启动”，但原生 arm64 版本通常有更好的性能、功耗和完整兼容性。

## Linux 的兼容规则

`x86_64` Linux 内核可能提供 32 位兼容能力，但运行 32 位 x86 应用通常还需要：

- 32 位 ELF Loader（加载器）。
- 应用依赖的 32 位 C/C++ 运行库和其他动态库。
- 发行版提供并启用 multilib / multiarch 支持。

是否开箱即用取决于发行版和安装内容。只有 64 位库时，32 位程序仍会因为 Loader 或依赖缺失而启动失败。

arm64 Linux 与 x86_64 是不同指令体系。运行另一架构的软件通常需要 QEMU、容器多架构支持或虚拟机等明确的翻译/模拟方案；仅仅把文件复制过去不会变成原生兼容。

## macOS 的兼容规则

- Intel Mac 的原生应用目标通常是 `x86_64`。
- Apple silicon 的原生目标是 `arm64`。
- Rosetta 可以把许多 `x86_64` Mac 应用翻译后运行在 Apple silicon。
- Rosetta 的翻译作用于整个进程；动态加载的插件和库仍需与该进程运行的架构匹配。
- 从 macOS Catalina 10.15 开始，32 位应用不再兼容。

`Universal Binary（通用二进制）` 可以在同一个 Mach-O 文件中同时包含 `x86_64` 和 `arm64` slice。系统会在对应硬件上选择合适的 slice，这不是在同一进程里混合执行两套机器码。

## 不同工具为什么使用不同名称

| 目标架构 | 下载页常见 | Node.js / Electron | Linux / Unix 常见 | Debian / Docker 常见 |
|---|---|---|---|---|
| 32 位 x86 | `x86`、`32-bit` | `ia32` | `i386`、`i686` | `i386` |
| 64 位 x86 | `x64`、`x86_64` | `x64` | `x86_64` | `amd64` |
| 64 位 Arm | `arm64`、`AArch64` | `arm64` | `aarch64`、`arm64` | `arm64` |

Node.js 的 `process.arch` / `os.arch()` 返回的是当前 Node.js 二进制编译目标，例如 `ia32`、`x64` 或 `arm64`，不一定等于物理 CPU 的原生架构。`os.machine()` 更接近系统报告的机器类型，但在翻译或模拟环境中仍要区分宿主架构和当前进程架构。

Electron Packager 使用的官方架构名称也包括：

```text
ia32 | x64 | armv7l | arm64 | mips64el | universal
```

其中 `universal` 主要用于同时包含 macOS `x86_64` 与 `arm64` slice 的通用应用，不代表一个包能跨 Windows、Linux 和 macOS 通用。

## 如何查看系统、进程和文件架构

### Windows PowerShell

```powershell
[System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
[System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture
```

- `OSArchitecture`：当前操作系统架构。
- `ProcessArchitecture`：当前 PowerShell 进程架构。

如果系统返回 `X64`，但进程返回 `X86`，说明正在 64 位系统上运行 32 位 PowerShell 或其他 32 位宿主。

检查 Windows PE 文件可以使用 Visual Studio Developer Command Prompt 中的：

```cmd
dumpbin /headers app.exe | findstr /i machine
```

### Linux

```bash
uname -m
file ./app
readelf -h ./app
```

常见输出：

```text
x86_64          → 64 位 x86
i386 / i686     → 32 位 x86
aarch64 / arm64 → 64 位 Arm
```

### macOS

```bash
uname -m
file /path/to/MyApp
lipo -archs /path/to/MyApp
```

在 Apple silicon 上，如果终端本身通过 Rosetta 运行，`uname -m` 可能报告 `x86_64`。因此还要结合“关于本机”、活动监视器、`file` / `lipo` 结果以及进程是否处于翻译状态判断。



## IA32 和 IA-64区别



IA32 和 IA-64 虽然名字很像，但实际上是两套完全不同的东西。

ia32 = 32 位 x86  Intel Architecture
x86-64 / x64 / AMD64 = 现在主流的 64 位 x86
IA-64 = Intel Itanium 安腾，另一套已经基本淘汰的架构


ia32 指：
Intel Architecture 32-bit

Intel Itanium 架构
一句话记忆
ia32 是 32 位 x86；IA-64 是 Itanium，二者不是一回事。





## 下载软件时怎样选择

1. 先确认操作系统的原生架构，不要只看当前终端进程。
2. 系统是 `X64 / x86_64 / AMD64`，通常优先下载 x64 版本。
3. 系统是 `ARM64 / aarch64`，通常优先下载原生 arm64 版本。
4. 只有旧 32 位系统，或明确需要与 32 位 DLL/插件共存时，选择 x86 / ia32。
5. 如果只能取得其他架构版本，先核对操作系统是否提供兼容层，并检查插件、驱动、Native Addon 和安装器是否同时兼容。

不要仅根据 CPU 品牌选择：Intel 与 AMD 的现代 PC 处理器通常都使用 64 位 x86 生态；Apple、Qualcomm 等设备可能使用 arm64，但最终应以系统报告、应用文档和安装包标记为准。

## 参考资料

- [Microsoft Learn：x64 Architecture](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/x64-architecture)
- [Microsoft Learn：Running 32-bit Applications / WOW64](https://learn.microsoft.com/en-us/windows/win32/winprog64/running-32-bit-applications)
- [Microsoft Learn：Windows on Arm](https://learn.microsoft.com/en-us/windows/arm/overview)
- [Microsoft Learn：How emulation works on Arm](https://learn.microsoft.com/en-ca/windows/arm/apps-on-arm-x86-emulation)
- [AMD：AMD64 Architecture Programmer’s Manual](https://docs.amd.com/api/khub/documents/sfvvekC9mDflu6vd3R0NXA/content)
- [Intel：Intel 64 and IA-32 Architectures Manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [Arm：Armv8-A Instruction Set Architecture](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20Instruction%20Set%20Architecture.pdf)
- [Apple：About the Rosetta translation environment](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment)
- [Apple：Building a universal macOS binary](https://developer.apple.com/documentation/apple-silicon/building-a-universal-macos-binary)
- [Apple Support：32-bit app compatibility with macOS](https://support.apple.com/en-ie/103076)
- [Node.js：`os.arch()` 与 `os.machine()`](https://nodejs.org/api/os.html)
- [Electron Packager：Supported architectures](https://electron.github.io/packager/main/types/OfficialArch.html)

## 技术边界

- 卡片描述的是桌面软件和主流 ABI 中最常见的含义；嵌入式系统、特殊 ABI、x32 ABI、虚拟机和跨架构容器可能有额外规则。
- “可运行”是操作系统版本、兼容层、CPU 特性、二进制格式和依赖共同作用的结果，不能只根据一个架构标签保证。
- 构建和发布时应在每个目标系统/架构上验证启动、原生依赖、插件、更新和安装器，而不是只验证纯脚本部分。
