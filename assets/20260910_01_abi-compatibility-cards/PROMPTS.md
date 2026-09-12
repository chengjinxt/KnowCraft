# 最终生成提示词

## 01 ABI 基础

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创、简单易懂的 ABI 基础知识卡片，面向有基础电脑经验但不了解底层链接机制的读者。核心比喻是“程序和动态库之间的二进制接头必须对得上”。
Scene/backdrop: 完全不透明、铺满画布的浅米白背景，极淡电路与拼图接口纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，蓝绿色与橙色强调，圆角信息块，少量 CPU、文件、动态库、拼图接头图标；专业但亲切。
Composition/framing: 顶部标题与一句白话解释；中部一条“编译后如何对接”的横向流程；下部两个并排区块分别说明 ABI 管什么、失配会怎样；底部一句结论。字号适合手机阅读。
Text (verbatim):
"ABI：二进制世界的“接口契约”"
"ABI（Application Binary Interface，应用二进制接口）"
"白话：程序和动态库的“二进制接头”必须完全对得上。"
"源代码 → 编译后的程序 → Loader（加载器）→ Dynamic Library（动态库）"
"ABI 管什么？"
"Architecture（体系结构）：x86｜x64｜arm64"
"Binary Format（二进制格式）：PE｜ELF｜Mach-O"
"Calling Convention（调用约定）：参数、返回值、寄存器与栈"
"Data Layout（数据布局）：类型大小、对齐与结构体布局"
"Symbol（符号）：函数名、序号、版本"
"Runtime（运行时）：操作系统与 C/C++ 运行库版本"
"API 和 ABI 别混淆"
"API（Application Programming Interface，应用程序编程接口）：源代码怎么写"
"ABI：编译后的机器码怎么对接"
"失配的常见信号"
"库找不到｜符号找不到｜体系结构不匹配｜启动即崩溃"
"同名动态库 ≠ ABI 兼容；能加载 ≠ 能正确调用。"
Constraints: 所有文字逐字准确；英文缩写与中文释义必须同属一个信息块；PE、ELF、Mach-O 大小写准确；信息清晰、留白充足；背景100%不透明；不用任何品牌 Logo；无水印；无页码；无“1/4”角标。
Avoid: 黑色大背景、透明区域、棋盘格、代码密集、乱码、把 API 与 ABI 含义画反、把 PE/ELF/Mach-O 画成三个互相兼容的格式。
```

## 02 Windows

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创 Windows ABI 故障知识卡片，重点解释“进程以 3221225785 退出”为什么等于 0xC0000139，以及如何安全排查。面向普通开发者和运维人员。
Scene/backdrop: 完全不透明的浅米白背景，极淡 Windows 窗口与二进制纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，Windows 蓝、青绿色与故障橙红色强调，圆角信息块，清晰等宽字体代码块，少量 EXE、DLL、放大镜、断开的函数接头图标；不用品牌 Logo。
Composition/framing: 顶部突出十进制与十六进制换算；中部用 EXE 导入表到 DLL 导出表的对接示意；下部列出常见原因与四步排查；底部放一个“别混淆错误码”的提示。字号适合手机。
Text (verbatim):
"Windows：3221225785 到底是什么？"
"3221225785 = 0xC0000139 = -1073741511"
"同一个 32 位值，工具可能按无符号十进制、十六进制或有符号十进制显示。"
"STATUS_ENTRYPOINT_NOT_FOUND（入口点未找到）"
"白话：DLL 找到了，但里面没有程序编译时要调用的那个入口点。"
"EXE Import Table（导入表）"
"需要函数 Foo"
"DLL Export Table（导出表）"
"找不到 Foo"
"→ 启动失败"
"常见原因"
"旧版或错误 DLL 抢先被加载"
"应用、插件与 DLL 版本不配套"
"程序依赖了目标系统或运行库没有的新函数"
"导出名称、序号或 C/C++ ABI 发生变化"
"怎么排查？"
"① 记录报错中的 DLL 名与入口点名"
"② 查看依赖：dumpbin /DEPENDENTS app.exe"
"③ 查看导入：dumpbin /IMPORTS app.exe"
"④ 核对导出：dumpbin /EXPORTS xxx.dll | findstr Foo"
"DUMPBIN 随 Visual Studio / Build Tools 提供"
"别混淆错误码"
"0xC0000135：STATUS_DLL_NOT_FOUND（DLL 未找到）"
"0xC000007B：STATUS_INVALID_IMAGE_FORMAT（映像格式无效，常见于体系结构不匹配）"
"修复原则：恢复应用官方配套 DLL，或用同一工具链和目标版本重新构建。"
"不要从未知下载站单独下载 DLL 覆盖系统文件。"
Constraints: 所有数字、十六进制、负号、命令、斜杠和英文大小写逐字准确；必须把 3221225785、0xC0000139、-1073741511 明确表示为同一个 32 位值的三种显示；不要暗示所有 ABI 故障都返回 0xC0000139；背景100%不透明；无品牌 Logo；无水印；无页码或“2/4”角标。
Avoid: 把 0xC0000139 写成 DLL 未找到、把 0xC000007B 写成入口点未找到、建议随意下载 DLL、乱码、命令断裂、密集小字、透明区域、黑色大背景。
```

## 03 Linux

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创 Linux ABI 与动态库故障排查卡片，说明 Linux 上与 Windows“入口点未找到”同类但提示不同的问题。面向开发者和运维人员。
Scene/backdrop: 完全不透明浅米白背景，极淡终端与链接链条纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，Linux 相关内容用青绿、蓝色与故障橙色强调，圆角信息块，清晰等宽字体代码块，少量 ELF 文件、齿轮、链接器与放大镜图标；不用任何品牌吉祥物或 Logo。
Composition/framing: 顶部解释 ELF 与动态链接器；中部列出三类典型报错及白话含义；下部用四步命令排查；底部是兼容性与安全提醒。适合手机阅读。
Text (verbatim):
"Linux：同类 ABI 问题怎么看？"
"ELF（Executable and Linkable Format，可执行与可链接格式）"
"ld.so / ld-linux.so（动态链接器/加载器）"
"它负责找到共享库、装入进程，并解析程序需要的 Symbol（符号）。"
"看到什么，先判断哪一层"
"error while loading shared libraries"
"→ Shared Library（共享库）名称或路径没找到"
"undefined symbol: foo"
"→ 库找到了，但需要的符号不存在或不兼容"
"version 'GLIBC_2.xx' not found"
"→ 程序要求的符号版本高于当前运行环境"
"cannot execute binary file: Exec format error"
"→ 常见于体系结构或文件格式不匹配"
"四步排查"
"① 看格式与架构：file ./app"
"② 看直接依赖：readelf -d ./app | grep NEEDED"
"③ 查动态符号：readelf -Ws libfoo.so | grep foo"
"④ 跟踪加载：LD_DEBUG=libs,versions ./app"
"也可用 ldd ./app 查看完整依赖树"
"安全提醒：不要对不可信二进制执行 ldd"
"Linux 不是只有一种 ABI"
"x86_64 / arm64｜glibc / musl｜libstdc++ 版本都可能影响兼容性"
"修复原则"
"使用匹配的架构、发行版基线和运行库；必要时在最老目标环境中重新构建。"
"不要用 LD_LIBRARY_PATH 长期“硬顶”生产问题。"
Constraints: 所有命令、点号、斜杠、单引号、大小写和错误短语逐字准确；明确区分“库没找到”“符号没找到”“符号版本不满足”“体系结构不匹配”；不要把 Linux 描述为单一统一 ABI；背景100%不透明；无品牌 Logo；无水印；无页码或“3/4”角标。
Avoid: 把 undefined symbol 解释成文件不存在、把 GLIBC 版本错误解释成 CPU 错误、建议对未知文件运行 ldd、乱码、命令断裂、透明区域、黑色大背景。
```

## 04 macOS

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创 macOS ABI 与动态库故障排查卡片，说明 dyld 的“库未找到、符号未找到、体系结构不匹配”三类问题。面向开发者和运维人员。
Scene/backdrop: 完全不透明浅米白背景，极淡芯片、链接与终端纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，靛蓝、青绿色与故障橙色强调，圆角信息块，清晰等宽字体代码块，少量 Mach-O 文件、dyld、放大镜、双架构芯片图标；不用 Apple Logo。
Composition/framing: 顶部解释 Mach-O 与 dyld；中部列出三类典型错误和白话含义；下部四步排查；底部解释 Universal 2、Rosetta 2 与修复原则。适合手机阅读。
Text (verbatim):
"macOS：dyld 报错也是 ABI 失配"
"Mach-O（macOS 可执行文件格式）"
"dyld（Dynamic Link Editor，动态链接器/加载器）"
"它负责装入 dylib / framework，并解析程序需要的 Symbol（符号）。"
"三类典型提示"
"Library not loaded: @rpath/libfoo.dylib"
"→ 库的安装名、@rpath 或嵌入位置不正确"
"Symbol not found: _foo"
"→ 库找到了，但里面没有程序需要的符号"
"mach-o, but wrong architecture"
"→ 进程与库的 x86_64 / arm64 架构不匹配"
"四步排查"
"① 看文件架构：file MyApp libfoo.dylib"
"② 看架构切片：lipo -info MyApp"
"③ 看依赖路径：otool -L MyApp"
"④ 查导出符号：nm -gU libfoo.dylib | grep _foo"
"跟踪加载：DYLD_PRINT_LIBRARIES=1 ./MyApp"
"Universal 2（通用二进制）"
"一个 Mach-O 同时包含 arm64 与 x86_64 切片"
"Rosetta 2 能运行 Intel 进程，但不能让 x86_64 进程加载 arm64-only dylib。"
"还要检查"
"Deployment Target（部署目标）是否兼容旧系统"
"framework 是否正确 Embed & Sign（嵌入并签名）"
"修复原则"
"统一架构、工具链和部署目标；修正 @rpath；重新嵌入并签名匹配的 framework。"
Constraints: 所有命令、下划线、斜杠、连字符、@ 符号与英文大小写逐字准确；明确区分 Library not loaded、Symbol not found、wrong architecture；Rosetta 2 说明准确；背景100%不透明；不用 Apple Logo；无水印；无页码或“4/4”角标。
Avoid: 把 Mach-O 写成 ELF、把 dyld 写成 DLL、声称 Rosetta 2 可以混载两种架构的库、乱码、命令断裂、透明区域、黑色大背景、品牌 Logo。
```
