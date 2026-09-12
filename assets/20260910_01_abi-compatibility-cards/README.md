# Windows、Linux 与 macOS ABI 配套知识卡片

本目录包含四张原创竖版知识卡片：

- `01-abi-basics.png`：解释 ABI、API 以及二进制组件需要对齐的六类规则。
- `02-windows-entrypoint-not-found.png`：重点解释 `3221225785 / 0xC0000139 / STATUS_ENTRYPOINT_NOT_FOUND`。
- `03-linux-elf-abi-troubleshooting.png`：区分 Linux 上的共享库缺失、符号缺失、符号版本和体系结构问题。
- `04-macos-dyld-abi-troubleshooting.png`：区分 macOS 上的 `Library not loaded`、`Symbol not found` 与 `wrong architecture`。

## ABI 是什么

`ABI (Application Binary Interface，应用二进制接口)` 是编译后二进制组件之间的对接规则。它常涉及：

- `Architecture（体系结构）`：例如 `x86`、`x64 / x86_64`、`arm64`。
- `Binary Format（二进制格式）`：Windows 常见 `PE`，Linux 常见 `ELF`，macOS 使用 `Mach-O`。
- `Calling Convention（调用约定）`：参数和返回值怎样通过寄存器或栈传递。
- `Data Layout（数据布局）`：类型大小、内存对齐、结构体布局。
- `Symbol（符号）`：函数或数据的导入名、导出名、序号和版本。
- `Runtime（运行时）`：操作系统、C/C++ 运行库和语言运行时提供的二进制能力。

白话上可以理解为：`API (Application Programming Interface，应用程序编程接口)` 规定源代码怎么调用，ABI 规定源代码编译成机器码以后怎么对接。文件名相同不等于 ABI 兼容；库能被找到，也不等于程序需要的符号一定存在。

## Windows：`0xC0000139`

### 同一个值的三种显示

```text
无符号十进制：3221225785
十六进制：    0xC0000139
有符号十进制：-1073741511
```

它们是同一个 32 位值的不同表示方式。Microsoft 将 `0xC0000139` 定义为：

```text
STATUS_ENTRYPOINT_NOT_FOUND（入口点未找到）
```

这里的 `Entry Point（入口点）` 通常是 EXE 或 DLL 导入的过程符号，不要简单理解为程序唯一的 `main` 或 DLL 的 `DllMain`。Windows 加载器已经定位到某个 DLL，但没有在该映像的导出信息中解析到程序所需的函数名或序号，因此进程可能在进入业务代码前就退出。

### 常见原因

- 应用目录、环境变量或安装残留让旧版、错误版 DLL 抢先被加载。
- 主程序、插件和 DLL 来自不同版本或不同构建批次。
- 程序在较新的系统或 SDK 上构建，却直接依赖旧系统不存在的函数。
- 导出名称、导出序号、调用约定或 C++ 名称修饰发生变化。
- C/C++ 运行库或其他原生运行时没有按应用要求配套。

### 用 DUMPBIN 排查

在 Visual Studio Developer Command Prompt 中执行：

```cmd
dumpbin /DEPENDENTS app.exe
dumpbin /IMPORTS app.exe
dumpbin /EXPORTS xxx.dll | findstr Foo
dumpbin /HEADERS app.exe | findstr /I machine
dumpbin /HEADERS xxx.dll | findstr /I machine
```

- `/DEPENDENTS` 查看依赖的 DLL 名称。
- `/IMPORTS` 查看程序从各 DLL 导入的具体符号。
- `/EXPORTS` 查看 DLL 实际提供的导出符号。
- `/HEADERS` 可帮助核对 `x86 / x64 / ARM64` 等映像机器类型。

`DUMPBIN` 随 Visual Studio 或 Visual Studio Build Tools 提供。`where xxx.dll` 只能查询当前目录和 `PATH` 能找到的文件，不能完整模拟 Windows DLL 搜索与加载过程，因此不能单独作为结论。

### 相邻错误不要混淆

| NTSTATUS | 含义 | 白话判断 |
|---|---|---|
| `0xC0000135 / STATUS_DLL_NOT_FOUND` | DLL 未找到 | 库文件没有被定位到 |
| `0xC0000139 / STATUS_ENTRYPOINT_NOT_FOUND` | 入口点未找到 | DLL 找到了，但缺少需要的函数/入口点 |
| `0xC000007B / STATUS_INVALID_IMAGE_FORMAT` | 映像格式无效 | 常见于体系结构或二进制格式不匹配，但并非只有这一种原因 |

优先从应用官方安装包恢复配套 DLL，或用一致的工具链、体系结构和最低目标版本重新构建。不要从未知下载站单独下载 DLL，更不要随意覆盖系统 DLL。

## Linux：ELF 与动态链接器

Linux 原生程序常使用 `ELF (Executable and Linkable Format，可执行与可链接格式)`。`ld.so / ld-linux.so（动态链接器/加载器）` 会查找共享对象、装入进程并解析符号。

常见提示分别指向不同层次：

- `error while loading shared libraries`：共享库名称或搜索路径没有解析成功。
- `undefined symbol: foo`：库通常已经找到，但需要的符号不存在或无法满足。
- `version 'GLIBC_2.xx' not found`：程序要求的符号版本高于当前运行环境能够提供的版本。
- `cannot execute binary file: Exec format error`：常见于体系结构或文件格式不匹配。

建议先用不会运行目标程序的静态检查：

```bash
file ./app
readelf -h ./app
readelf -d ./app | grep NEEDED
readelf -Ws libfoo.so | grep foo
readelf --version-info ./app
```

对自己构建或确定可信的程序，可继续观察动态加载：

```bash
LD_DEBUG=libs,versions ./app
ldd ./app
```

`ldd` 在通常情况下通过动态链接器检查依赖；官方手册明确提醒不要对不可信可执行文件使用它。检查不可信文件的直接依赖时，可使用：

```bash
objdump -p ./app | grep NEEDED
```

Linux 不是一个单一 ABI。体系结构、`glibc / musl`、`libstdc++`、编译器设置和发行版基线都可能影响二进制兼容性。可靠方案通常是使用匹配的运行环境，或在计划支持的最老环境/容器中重新构建；不要把全局修改 `LD_LIBRARY_PATH` 当成长期修复。

## macOS：Mach-O 与 dyld

macOS 使用 `Mach-O（macOS 可执行文件格式）`；`dyld (Dynamic Link Editor，动态链接器/加载器)` 负责装入 `dylib / framework` 并解析符号。

- `Library not loaded: @rpath/...`：安装名、运行路径或嵌入位置不正确。
- `Symbol not found: _foo`：库找到了，但运行时库没有程序所需的符号。
- `mach-o, but wrong architecture`：当前进程与库的体系结构切片不匹配。

常用检查命令：

```bash
file MyApp libfoo.dylib
lipo -info MyApp
otool -L MyApp
nm -gU libfoo.dylib | grep _foo
DYLD_PRINT_LIBRARIES=1 ./MyApp
```

`Universal 2（通用二进制）` 通常同时包含 `arm64` 和 `x86_64` 切片。Rosetta 2 可以转换并运行 Intel 进程，但不会允许一个 `x86_64` 进程直接加载只含 `arm64` 切片的动态库。

还应核对 `Deployment Target（部署目标）`、API 可用性、`@rpath`、Framework 的嵌入方式和代码签名。修复时应尽量在构建阶段统一架构、工具链和部署目标，而不是在发布后随意替换单个 `dylib`。

## 参考依据

- [Microsoft Learn：NTSTATUS Values](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-erref/596a1078-e883-4972-9bbc-49e60bebca55)
- [Microsoft Learn：PE Format](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format)
- [Microsoft Learn：DUMPBIN /DEPENDENTS](https://learn.microsoft.com/en-us/cpp/build/reference/dependents)
- [Microsoft Learn：DUMPBIN /IMPORTS](https://learn.microsoft.com/en-us/cpp/build/reference/imports-dumpbin)
- [Microsoft Learn：x64 ABI conventions](https://learn.microsoft.com/en-us/cpp/build/x64-software-conventions)
- [Linux man-pages：ld.so(8)](https://man7.org/linux/man-pages/man8/ld.so.8.html)
- [Linux man-pages：ldd(1)](https://man7.org/linux/man-pages/man1/ldd.1.html)
- [Linux man-pages：readelf(1)](https://man7.org/linux/man-pages/man1/readelf.1.html)
- [GNU C Library：Dynamic Linker Environment Variables](https://sourceware.org/glibc/manual/latest/html_node/Dynamic-Linker-Environment-Variables.html)
- [Apple：Dynamic Library Identification](https://developer.apple.com/forums/thread/736719)
- [Apple：Embedding Frameworks In An App](https://developer.apple.com/library/archive/technotes/tn2435/_index.html)
- [Apple：Dynamic Library Design Guidelines](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/DynamicLibraryDesignGuidelines.html)

## 生成与检查

- 生成方式：Codex 内置 `imagegen`。
- 版式：`3:4` 竖版、浅色不透明背景、高对比标题、圆角信息块。
- 完整最终提示词保存在 `PROMPTS.md`。
- 已逐张检查错误码、十进制/十六进制换算、体系结构名称、错误短语和命令参数。
- Windows 数值换算已在本机复核；Linux 与 macOS 命令依据官方文档和手册静态核对，未在对应系统上执行。

