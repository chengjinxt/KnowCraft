# Electron 打包、`app.asar`、`.jsc` 与安全知识卡片

本目录包含六张原创竖版知识卡片：

- `01-electron-packaging-flow.png`：Electron 从源码到可分发应用的四层流程。
- `02-app-asar-explained.png`：解释 `app.asar`、虚拟文件系统、解包能力与 `app.asar.unpacked`。
- `03-jsc-bytecode-explained.png`：解释 `.jsc` 的常见含义、加载方式、兼容性和安全边界。
- `04-asar-jsc-node-comparison.png`：对比 `app.asar`、`.jsc` 与原生扩展 `.node`。
- `05-electron-security-layers.png`：把源码隐藏、完整性、代码签名、进程隔离、IPC 和服务端秘密分层。
- `06-electron-secure-release-checklist.png`：给出从依赖到安装后验证的八道发布闸门。

## 一句话先讲清

Electron 打包通常是把应用代码、Chromium、Node.js、资源和平台相关二进制组合成桌面应用，而不是把全部 JavaScript 编译成不可恢复的机器码。

```text
源码
  ↓ 构建 / Bundling
普通 JS + 可选的 .jsc + 资源 + 原生扩展
  ↓ ASAR 归档
app.asar + app.asar.unpacked
  ↓ 平台封装
Electron Runtime + 应用资源
  ↓ 签名 / 公证 / 制作分发包
Windows、macOS、Linux 对应的安装包或便携包
```

`Electron Forge`、`electron-builder`、`Electron Packager`、`NSIS` 是工具或工具链，不是同一种成品格式。最终产物可能是 Windows 的 `setup.exe / .msi`、macOS 的 `.app / .dmg`，或 Linux 的 `AppImage / .deb / .rpm`，具体取决于工具和配置。

## `app.asar` 到底是什么

`ASAR Archive（Electron 应用归档）` 是 Electron 为应用文件设计的归档格式。打包后的典型位置是：

```text
Windows / Linux: resources/app.asar
macOS:           MyApp.app/Contents/Resources/app.asar
```

Electron 对部分 Node.js 文件系统能力做了适配，因此 `require()`、`fs.readFile()` 等多数常用 API 可以把归档当作 `Virtual File System（虚拟文件系统）` 访问。使用 ASAR 的主要价值是：

- 把大量零散文件集中管理。
- 缓解部分 Windows 长路径问题。
- 在部分场景下改善 `require` 的读取性能。
- 避免用户打开安装目录时直接看到完整文件树，但只属于“防随手查看”。

它不是 `Encryption（加密）`。拿到安装目录的人通常可以查看文件列表或解包：

```powershell
npx @electron/asar list .\resources\app.asar
npx @electron/asar extract .\resources\app.asar .\out
```

所以不要把 API Key、私钥、数据库主密码、可直接伪造授权的根密钥或关键服务端凭据放进 `app.asar`。

### `app.asar.unpacked` 是什么

`app.asar.unpacked` 是归档外的配套目录，通常与 `app.asar` 同级。它仍是应用的一部分，但里面的文件拥有真实磁盘路径。常见内容包括：

- `Native Addon（原生扩展）`，例如 `.node` 文件。
- 需要由操作系统直接执行的可执行文件。
- 必须把真实文件路径传给底层系统调用或第三方库的资源。

不要把它理解成“解包后的整个 app.asar”，也不要把它理解成安全隔离区。它只是打包工具根据 `unpack` 规则放在归档外的文件集合。

## `.jsc` 到底是什么

`.jsc` 不是 Electron 官方统一规定的文件格式。必须先确认项目使用了什么生成工具和加载器。

以 `Bytenode` 为例，`.jsc` 通常保存由 V8 生成的 `Bytecode（字节码）`。典型过程是：

```text
JavaScript 源码
  ↓ 使用目标 Electron / V8 生成
.jsc 字节码
  ↓ Bytenode 等 Loader 加载
匹配的 Electron 运行时执行
```

它的现实价值是移除大部分直接可读的源码文本，提高随手复制和初级逆向的成本。它不等于：

- 对称加密或公钥加密。
- 不可反编译、不可调试或不可分析。
- 可以安全存放长期秘密。
- 可以在任意 Electron、Node.js、V8、平台和体系结构之间通用。

`.jsc` 需要运行时真正执行其中逻辑，因此面对能够控制本机、调试进程或修改加载链路的攻击者，只能提高分析成本，不能提供绝对机密性。安全设计应假设客户端代码最终可以被观察。

### Bytenode 的兼容性提醒

Bytenode 文档明确要求字节码与生成时的 Node.js / Electron 运行时配套，并要求相同体系结构。当前文档还特别说明：

- Electron 主进程使用的字节码应由匹配版本的 Electron 生成。
- 对 Electron 42 及其 V8 14.8 以上版本，主进程字节码需要在真实 Electron 主进程内生成，例如使用 `compileElectronMainCode()` 或 `electronMain: true`；旧的 `ELECTRON_RUN_AS_NODE` 路径可能因 V8 snapshot 校验不匹配而崩溃。
- 主进程字节码不能假设可以跨操作系统或体系结构构建；应在目标平台构建机上生成并测试。
- 依赖 `Function.prototype.toString` 的代码、部分调试器和特殊语法可能出现兼容问题。

这些要求属于 Bytenode 当前实现，不应推广成所有 `.jsc` 工具的统一规则。工具升级后要重新核对其文档。

### 更稳妥的使用策略

- 只对少量确有隐藏需求的核心模块使用 `.jsc`，不要为了“看起来安全”把整个项目盲目转换。
- 固定 Electron、Node.js、V8、生成工具和目标平台版本。
- 每次升级 Electron 后重新生成字节码。
- 在真实安装目录测试冷启动、主进程、`preload`、IPC、自动更新和失败回退。
- 服务端保存真正的秘密和授权判定；客户端只拿最小权限、短期有效的 Token。

## `app.asar`、`.jsc` 与 `.node` 的区别

| 对象 | 所属层次 | 主要作用 | 运行依赖 | 安全边界 |
|---|---|---|---|---|
| `app.asar` | 归档层 | 把 JS、HTML、CSS、图片、`.jsc` 等文件装入一个归档 | Electron 的 ASAR 虚拟文件系统 | 可列出、可解包，不是加密 |
| `.jsc` | V8 字节码层 | 隐藏直接可读的部分 JavaScript 源码 | 特定生成工具、Loader 和匹配的 Electron / V8 | 提高逆向成本，仍可分析 |
| `.node` | 原生二进制层 | 把 C、C++、Rust 等原生能力暴露给 Node.js / Electron | 目标 OS、CPU 和 Electron ABI | 机器码也能逆向，不是秘密保险柜 |

Electron 使用的 `ABI (Application Binary Interface，应用二进制接口)` 与普通 Node.js 可能不同。升级 Electron、切换 `x64 / arm64` 或更换平台后，原生扩展通常需要重新取得匹配的预编译版本或运行 `@electron/rebuild`。

常见组合是：

```text
JS / TS → Bundler → 选定模块生成 .jsc → 装入 app.asar
.node / 外部可执行文件 → app.asar.unpacked
Electron Runtime → 同时加载两部分
```

## 安全控制不能互相替代

| 目标 | 更合适的控制 | 它不解决什么 |
|---|---|---|
| 减少随手查看源码 | Bundling、Minify、Obfuscation、选择性 `.jsc` | 不保证机密性，不阻止有能力的逆向 |
| 发现 `app.asar` 被修改 | ASAR Integrity + Electron Fuses | 不隐藏源码，也不覆盖归档外所有文件 |
| 证明发布者并发现签名对象被改 | Code Signing；macOS 按发布方式 Notarization | 不自动保证业务逻辑、权限设计或依赖安全 |
| 限制不可信网页取得本机能力 | `nodeIntegration: false`、`contextIsolation: true`、`sandbox: true` | 不替代 IPC 校验和服务端鉴权 |
| 限制渲染器滥用主进程权限 | 最小化 `preload` API、IPC 允许列表、校验 `sender / origin` | 不替代内容安全策略和依赖治理 |
| 保护 API Key、私钥和授权根逻辑 | 服务端保存秘密、短期 Token、最小权限、服务端授权判定 | 无法靠客户端混淆得到同等级保护 |

### ASAR Integrity 与 Fuses

`ASAR Integrity（ASAR 完整性校验）` 会在运行时验证归档。Electron 官方文档说明：

- macOS 从 Electron 16 起支持。
- Windows 从 Electron 30 起支持。
- 当前不覆盖 Linux。
- 需要 `@electron/asar` 生成带完整性信息的归档。
- 通过 `EnableEmbeddedAsarIntegrityValidation` fuse 开启。
- 通常应同时开启 `OnlyLoadAppFromAsar`，避免 Electron 回退加载未校验的 `app/` 目录或 `default_app.asar`。

归档头包含 SHA-256 完整性元数据，打包产物中还会嵌入 ASAR 头哈希。校验缺失或不匹配时，Electron 会强制终止应用。

`app.asar.unpacked` 不在 ASAR 归档内，不能因为启用了 ASAR Integrity 就假设归档外文件也受同一机制保护。原生二进制、外部资源和更新内容应结合平台代码签名、受信安装器、文件权限、独立哈希/签名及更新验证进行保护。

Fuses 会修改 Electron 二进制中的功能开关，因此必须在最终代码签名前设置。签名后再改二进制或资源，通常会破坏签名或完整性链。

## Electron 运行时安全基线

下面是比“藏源码”更重要的安全基线：

```javascript
new BrowserWindow({
  webPreferences: {
    nodeIntegration: false,
    contextIsolation: true,
    sandbox: true
  }
})
```

还应做到：

- 只加载可信内容，远程资源使用 HTTPS。
- 定义限制性的 `Content-Security-Policy（内容安全策略）`。
- `preload` 只通过 `contextBridge` 暴露最小、按功能划分的 API，不把整个 `ipcRenderer` 或任意文件系统能力直接交给页面。
- 所有特权 IPC 处理器都验证调用者 `sender` / `origin`，并对参数做模式校验。
- 限制导航、新窗口、权限请求、`webview` 和 `shell.openExternal` 的目标。
- 使用仍受支持的近期 Electron 版本，及时获得 Chromium、Node.js 和 Electron 的安全修复。
- 依赖使用锁文件，构建来源可追踪，发布前进行依赖审计、恶意包检查和安装后回归。

## 发布自检顺序

1. 锁定依赖和构建输入，在干净、受控的 CI 环境构建。
2. 建立 `Windows / macOS / Linux × x64 / arm64` 的目标矩阵。
3. 为目标 Electron ABI 准备 `.node`，需要时运行 `@electron/rebuild`。
4. 如果使用 `.jsc`，用匹配的目标运行时和正确进程类型重新生成。
5. 核对 `app.asar` 与 `app.asar.unpacked` 的文件归属和运行路径。
6. 在支持平台配置 ASAR Integrity 和相关 Fuses。
7. 完成全部会改变文件的步骤后再代码签名；macOS 再按发布方式公证。
8. 从真实安装目录冷启动并测试主进程、`preload`、IPC、原生模块、自动更新、离线和失败路径。

开发模式能跑，不代表打包后能跑；安装包能启动，也不代表安全边界已经正确。

## 参考资料

- [Electron：Packaging Your Application](https://www.electronjs.org/docs/latest/tutorial/tutorial-packaging)
- [Electron：Application Packaging](https://www.electronjs.org/docs/latest/tutorial/application-distribution)
- [Electron：ASAR Archives](https://www.electronjs.org/docs/latest/tutorial/asar-archives)
- [Electron：ASAR Integrity](https://www.electronjs.org/docs/latest/tutorial/asar-integrity)
- [Electron：Electron Fuses](https://www.electronjs.org/docs/latest/tutorial/fuses)
- [Electron：Security Checklist](https://www.electronjs.org/docs/latest/tutorial/security)
- [Electron：Code Signing](https://www.electronjs.org/docs/latest/tutorial/code-signing)
- [Electron：Native Node Modules](https://www.electronjs.org/docs/latest/tutorial/using-native-node-modules)
- [`@electron/asar` 官方仓库](https://github.com/electron/asar)
- [Bytenode 官方仓库与 `.jsc` 说明](https://github.com/bytenode/bytenode)

## 技术边界

- 卡片中的 `.jsc` 以 Bytenode 的常见用法为重点；其他工具可能使用同一扩展名表示不同内容。
- Electron、Bytenode、打包工具和平台签名规则会更新；实际项目应固定版本并以所用版本文档为准。
- 卡片讲的是通用安全架构，不替代对具体威胁模型、许可证方案、更新系统、供应链和合规要求的评审。
