# 最终生成提示词

## 01 Electron 打包流程

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张 Electron 应用打包全流程卡片，面向有基础电脑经验的开发者。过程逻辑必须从源码到安装包逐层展开，并明确“打包不等于把所有 JavaScript 编译成原生机器码”。请严格区分构建工具、安装器制作工具与最终文件格式。
Scene/backdrop: 100%不透明浅米白背景，极淡桌面窗口、电路和文件纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，青蓝与绿色主色，橙色只用于提醒；圆角步骤块、清晰箭头、少量文件夹、盒子、盾牌图标；不用任何品牌 Logo。
Composition/framing: 顶部标题与一句白话结论；中部四层纵向流水线；下部展示成品结构、工具提示和关键提醒。留白充足，中文大字号，手机端易读。
Text (verbatim):
"Electron 打包：源码怎样变成安装包？"
"Electron = Chromium + Node.js + 应用代码"
"白话：把网页技术、运行时和资源装成可分发的桌面应用。"
"① Build（构建）"
"JS / TS + HTML + CSS + Assets"
"Bundler（打包器，可选）：合并、Tree Shaking、Minify"
"② Archive（归档）"
"应用文件 → app.asar"
"需真实文件路径的内容 → app.asar.unpacked"
"③ Package（封装）"
"Electron Runtime（运行时）+ resources + Native Modules（原生模块）"
"按 Windows / macOS / Linux 与 x64 / arm64 分别产出"
"④ Distribute（分发）"
"制作可分发包 → Code Signing（代码签名）→ Notarization（公证，macOS）"
"常见成品"
"Windows：setup.exe / .msi"
"macOS：.app / .dmg"
"Linux：AppImage / .deb / .rpm"
"工具与产物要分开"
"Electron Forge、electron-builder、NSIS 是工具或工具链；不是同一种文件格式。"
"关键提醒"
"打包 ≠ 全部编译成机器码"
"app.asar 是归档；JavaScript 通常仍可被读取或分析。"
"具体步骤和签名时机取决于平台与打包工具配置。"
Constraints: 四个阶段顺序不可打乱；所有英文大小写和中文释义逐字准确；必须把 NSIS 表示为工具而非文件格式；不得把 app.asar 画成加密保险箱；不得暗示所有平台能用同一个原生包；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 黑色大背景、透明区域、品牌商标、代码密集、乱码、过小文字、把 DMG 说成 Windows 安装包、把 NSIS 作为扩展名。
```

## 02 `app.asar`

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张重点解释 Electron app.asar 的知识卡片。核心结论必须醒目：“归档，不是加密”。要讲清典型位置、虚拟文件系统、可查看/解包、app.asar.unpacked 和真实路径限制。
Scene/backdrop: 100%不透明浅米白背景，极淡文件树和档案盒纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，青蓝主色，橙红色风险提示；圆角信息块、虚拟文件夹、放大镜、开箱图标；命令使用清晰等宽字体；不用品牌 Logo。
Composition/framing: 顶部用大标题和一句结论；中部左右两区“它做了什么 / 它没做什么”；下部展示 app.asar 与 app.asar.unpacked 的关系、两个查看命令和真实路径提醒。手机端易读。
Text (verbatim):
"app.asar：归档，不是加密"
"ASAR Archive（Electron 应用归档）"
"常见位置：resources/app.asar"
"它做了什么？"
"把大量应用文件装进一个归档"
"Electron 把它当作 Virtual File System（虚拟文件系统）"
"多数 require()、fs.readFile() 可直接读取归档内文件"
"减少零散文件，规避部分 Windows 长路径问题，并可加快 require"
"它没做什么？"
"不是 Encryption（加密）"
"不保证源码保密"
"拿到安装目录的人通常可以列出或解包内容"
"怎么查看？"
"npx @electron/asar list resources/app.asar"
"npx @electron/asar extract resources/app.asar out"
"app.asar.unpacked 是什么？"
"归档外的配套目录：仍属于应用的一部分"
"常放 Native Addon（原生扩展，.node）、可执行文件，或必须使用真实路径的资源"
"路径提醒"
"归档内路径是虚拟路径；底层系统调用若必须拿到真实文件，需解包或使用 unpack 配置。"
"一句话：ASAR 解决“怎么装”，不解决“谁能看”。"
Constraints: 命令、斜杠、点号、扩展名逐字准确；清楚表示 app.asar 与 app.asar.unpacked 是配套关系而非互相包含；“多数 API”不能绝对化为“所有 API”；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 把 ASAR 描述为压缩加密格式、画锁表示机密性、暗示改扩展名就安全、乱码、黑色大背景、透明区域、密集小字。
```

## 03 `.jsc` V8 字节码

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张严谨解释 Electron 项目中 .jsc 的卡片。必须强调“.jsc 不是 Electron 官方统一格式”，常见含义是特定工具生成的 V8 字节码；它提高逆向门槛但不是加密，也有严格运行时兼容边界。
Scene/backdrop: 100%不透明浅米白背景，极淡字节、芯片和代码文件纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，紫蓝和青绿色主色，橙红风险提示；圆角流程块、代码文件、齿轮、指纹、警告图标；不用品牌 Logo。
Composition/framing: 顶部是定义与醒目结论；中部纵向流程“源码→字节码→加载”；下部两栏“能保护什么 / 不能保护什么”，再放兼容性和上线检查。手机端大字号、留白充足。
Text (verbatim):
".jsc：通常是 V8 字节码，不是万能保险箱"
"先确认工具：.jsc 不是 Electron 官方统一文件格式"
"常见工具（如 Bytenode）用 .jsc 保存 V8 Bytecode（V8 字节码）"
"典型流程"
"JavaScript Source（源码）"
"↓ 使用目标 Electron / V8 编译"
".jsc Bytecode（字节码）"
"↓ 由 Loader（加载器）送入匹配的运行时"
"Electron 执行"
"它能做到"
"移除大部分直接可读的源码文本"
"提高随手查看、复制和初级逆向的成本"
"可只处理少量核心模块"
"它做不到"
"不是 Encryption（加密）"
"不能保证逻辑不可恢复或不可分析"
"不能安全保存 API Key、私钥、主密码或授权根逻辑"
"兼容性是最大坑"
"必须按生成工具要求匹配 Electron / Node.js / V8"
"还要关注进程类型、目标平台、体系结构与 V8 标志"
"升级 Electron 后应重新生成 .jsc 并做回归测试"
"部分依赖 Function.prototype.toString、调试器或特殊语法的代码可能不兼容"
"以 Bytenode 为例"
"Electron 主进程字节码应使用匹配的目标 Electron 生成；不要跨平台盲目复用。"
"上线前自测"
"冷启动｜主进程｜preload｜打包后路径｜目标系统｜升级场景"
"安全结论：.jsc 是 Obfuscation / Hardening（混淆 / 加固）的一层，不是秘密保险柜。"
Constraints: 必须区分“文件扩展名”和“统一标准”；不得把 .jsc 说成 Java Class 文件；不得承诺无法反编译；不得笼统宣称所有 .jsc 都具有相同兼容性；所有点号、斜杠和英文大小写逐字准确；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 绝对安全承诺、锁死保险柜视觉、品牌 Logo、黑色大背景、透明区域、乱码、过小文字、暗示把私钥编译成 .jsc 就安全。
```

## 04 三类文件对比

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张 Electron 打包中 app.asar、.jsc、.node 三类文件的对比卡片，读者看完能分清归档、V8 字节码和原生扩展，并理解三者如何组合。
Scene/backdrop: 100%不透明浅米白背景，极淡文件树和模块拼装纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题；app.asar 用蓝色，.jsc 用紫色，.node 用绿色，风险提示用橙色；三列圆角对比表和底部装配流程；不用品牌 Logo。
Composition/framing: 顶部一句“它们不是同一层”；中部三列对比，列标题醒目；底部展示推荐组合流程和两个注意点。手机端易读，避免小字。
Text (verbatim):
"app.asar、.jsc、.node：别再混为一谈"
"它们分别属于：归档层｜字节码层｜原生二进制层"
"app.asar"
"身份：ASAR Archive（应用归档）"
"里面可放 JS、HTML、CSS、图片、.jsc 等文件"
"运行：Electron Virtual File System（虚拟文件系统）"
"配套：app.asar.unpacked"
"安全边界：可列出、可解包；不是加密"
".jsc"
"身份：工具生成的 V8 Bytecode（V8 字节码）"
"用途：隐藏直接可读的部分 JavaScript 源码"
"运行：Loader + 匹配的 Electron / V8"
"安全边界：提高逆向成本；仍可分析"
".node"
"身份：Native Addon（原生扩展）"
"本质：C / C++ / Rust 等编译出的原生二进制"
"运行：必须匹配 OS、CPU 与 Electron ABI"
"常见位置：app.asar.unpacked"
"安全边界：机器码也能逆向，不等于保密"
"可以怎样组合？"
"JS / TS → Bundler（打包器）→ 选定模块编译为 .jsc → 装入 app.asar"
"Native Addon（.node）→ 通常放入 app.asar.unpacked"
"Electron Runtime（运行时）同时加载它们"
"两个关键点"
"app.asar 可以装 .jsc，但不会把普通 JS 自动变成字节码"
".jsc 不是 .node；升级 Electron 时两者都要重新验证，.node 通常还需 @electron/rebuild"
"一句话：ASAR 管“装箱”，JSC 管“形态”，NODE 管“原生能力”。"
Constraints: 三列内容必须严格对应，不得把 .jsc 说成原生机器码，不得把 .node 说成 V8 字节码；清楚画出 app.asar 与 app.asar.unpacked 是同级配套；英文扩展名、@electron/rebuild 和斜杠逐字准确；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 暗示三者任意互换、把 app.asar 画成加密包、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```

## 05 Electron 安全分层

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张 Electron 安全纵深防御卡片，把防随手查看、防篡改、发布者身份、渲染器隔离、IPC 边界和服务器端秘密保护分成不同层。核心观点是“安全不是一个打包开关”。
Scene/backdrop: 100%不透明浅米白背景，极淡盾牌、窗口与网络节点纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，六层盾牌阶梯；蓝、青、绿为安全控制，紫色表示代码形态，橙色表示边界提醒；圆角信息块；不用品牌 Logo。
Composition/framing: 顶部结论；中部六层由外到内的纵向防线，每层含“目标→措施”；下部放 ASAR Integrity 的平台边界和总原则。手机端大字号、留白充足。
Text (verbatim):
"Electron 安全：不是一个打包开关"
"Defense in Depth（纵深防御）：每一层只解决一种风险"
"① 提高阅读成本"
"Bundling / Minify / Obfuscation / .jsc"
"作用：减少直接可读源码；不等于加密"
"② 验证归档完整性"
"ASAR Integrity（ASAR 完整性校验）"
"EnableEmbeddedAsarIntegrityValidation + OnlyLoadAppFromAsar"
"作用：运行时发现 app.asar 被替换或修改"
"边界：不负责源码保密；app.asar.unpacked 不属于 ASAR 归档内容"
"③ 建立分发信任"
"Code Signing（代码签名）+ Notarization（公证，macOS）"
"作用：证明签名对象的发布者，并检测签名后的修改"
"④ 隔离不可信网页"
"nodeIntegration: false"
"contextIsolation: true"
"sandbox: true"
"⑤ 收紧特权通道"
"preload 只暴露最小 API"
"IPC（Inter-Process Communication，进程间通信）使用允许列表并校验 sender / origin"
"限制导航、新窗口、权限与 shell.openExternal"
"⑥ 把真正的秘密留在服务端"
"API Key、私钥、授权判定不要随客户端发布"
"服务端鉴权 + 短期 Token + 最小权限"
"平台边界"
"Electron 官方 ASAR Integrity：macOS（Electron ≥ 16）、Windows（Electron ≥ 30）"
"Linux 当前不由这项机制覆盖；应依赖发行包签名、系统包管理与其他完整性措施。"
"总原则：源码隐藏 ≠ 防篡改 ≠ 身份可信 ≠ 权限安全"
Constraints: 六层目标与措施必须严格对应；三个 webPreferences 代码值逐字准确；两个 Fuse 名称逐字准确；不得暗示 ASAR Integrity 支持所有平台或保护 app.asar.unpacked；不得把公证说成代码加密；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 一个大锁代表全部安全、绝对安全承诺、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```

## 06 安全发布闸门

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: 制作一张 Electron 安全发布闸门卡片，用清晰顺序说明从依赖、构建、.jsc、原生模块、ASAR、Fuses、签名到安装后测试的完整自检。要特别提示“只测试开发模式不算验证完成”。
Scene/backdrop: 100%不透明浅米白背景，极淡 CI 流水线、检查清单和盾牌纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，青蓝流程、绿色通过标志、橙色失败闸门；8 个编号圆角步骤块，少量锁文件、芯片、归档、证书、安装包图标；不用品牌 Logo。
Composition/framing: 顶部标题和发布公式；中部八步蛇形或纵向检查流；下部“威胁→正确控制”四行对照，以及醒目红线。手机端易读。
Text (verbatim):
"Electron 安全发布：8 道闸门"
"Build → Harden → Sign → Install → Verify"
"① 锁定输入"
"锁文件、依赖审计、可信下载源、干净 CI 环境"
"② 构建目标矩阵"
"Windows / macOS / Linux × x64 / arm64"
"③ 处理 Native Addon（.node）"
"匹配 Electron ABI；必要时运行 @electron/rebuild"
"④ 生成 .jsc（如果使用）"
"用目标 Electron / V8 与正确进程类型生成；升级后重建"
"⑤ 归档应用"
"确认 app.asar 与 app.asar.unpacked 的文件归属和运行路径"
"⑥ 配置完整性"
"在支持平台启用 ASAR Integrity，并配合 OnlyLoadAppFromAsar"
"⑦ 签名与公证"
"先完成全部文件修改，再 Code Signing；macOS 按发布方式 Notarization"
"⑧ 安装后验证"
"从真实安装目录冷启动，测试主进程、preload、IPC、自动更新与离线失败"
"威胁 → 正确控制"
"随手看源码 → Minify / .jsc"
"修改 app.asar → ASAR Integrity + Fuses"
"冒充发布者 → Code Signing / Notarization"
"窃取密钥或伪造授权 → 服务端保存秘密并做授权判定"
"红线"
"开发模式能跑 ≠ 打包后能跑"
"安装包能启动 ≠ 安全边界正确"
"任何一步失败：停止发布，修复后从受影响步骤重新验证。"
Constraints: 八个步骤顺序清楚；不得把依赖审计写成自动消除所有供应链风险；不得把 .jsc 设为必选项；@electron/rebuild、app.asar、app.asar.unpacked 和 OnlyLoadAppFromAsar 逐字准确；背景完全不透明；无水印；无页码；无系列角标。
Avoid: 把签名放在后续还会修改文件之前、把开发模式测试当作最终验证、绝对安全承诺、品牌 Logo、黑色大背景、透明区域、乱码、过小文字。
```
