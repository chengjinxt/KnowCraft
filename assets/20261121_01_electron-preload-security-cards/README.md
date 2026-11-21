# Electron preload：桥接、安全配置与共享 SDK

## 白话结论

Electron 的 `preload` 不是普通的“提前加载脚本”，而是渲染页面与桌面高权限能力之间的信任边界。安全目标不是让页面什么都能调，而是只给它当前业务真正需要的少量能力。

`contextIsolation: true` 用来隔离页面脚本与 preload 的 JavaScript 全局环境；`nodeIntegration: false` 用来阻止渲染页面直接使用 Node.js。二者解决的问题不同，通常要一起使用。即使开启 `contextBridge`，如果仍把原始 `ipcRenderer` 或可指定任意 `channel` 的通用 RPC 暴露给页面，桥接面依然过宽。

另一个常见误区是把 Web 侧的 SDK 门面也叫作 preload。它可以统一调用方式，却不会自动获得 Electron 权限。共享 SDK 源码包通常同时承载运行时门面、类型契约和浏览器兜底；在调用方、别名、工作区依赖和构建脚本迁移完成前，不能直接删除整个包。可稳定重建的 `dist` 产物则通常可以清理后重新生成。

## 卡片清单

1. `01-what-is-preload.png`：preload 是页面与桌面能力之间的受控桥梁。
2. `02-two-preloads.png`：区分 Electron preload 与 Web 侧同名 SDK 门面。
3. `03-context-isolation.png`：解释 `contextIsolation` 两个分支和 `process.contextIsolated`。
4. `04-node-integration.png`：解释 `nodeIntegration` 对渲染页面的实际影响。
5. `05-security-baseline.png`：对比典型高风险组合与更安全的配置基线。
6. `06-safe-bridge-api.png`：说明 `contextBridge` 为什么仍需最小权限设计。
7. `07-can-sdk-be-deleted.png`：区分 SDK 源码包、`dist` 产物与依赖链。

## 1. preload 在哪一层

典型调用链可以抽象为：

```text
页面 → preload 暴露的细粒度 API → IPC → 主进程 → 操作系统或本地服务
```

页面只应知道业务动作，例如“读取设置”或“选择文件”，不应知道任意 IPC 通道、底层模块名或本地协议细节。preload 负责把页面请求转换成受控调用；主进程负责真正的高权限操作和最终校验。

不要只凭文件名判断脚本角色：

- 由 `BrowserWindow` 的 `webPreferences.preload` 加载的脚本，属于 Electron 权限桥接层；
- 由 `<script>`、打包器或页面入口加载的同名模块，仍是普通 Web 代码；
- Web 侧 SDK 可以做类型统一、参数适配和浏览器兜底，但不会因为叫 preload 就跨越安全边界。

## 2. `contextIsolation` 两个分支

### `contextIsolation: true`

页面与 preload 运行在不同的 JavaScript 世界，双方不共享同一个原型链和全局对象。preload 应通过 `contextBridge.exposeInMainWorld` 暴露窄接口。页面看到的是桥接后的 API，不是 preload 自身的全部运行环境。

### `contextIsolation: false`

页面与 preload 共享同一个 `window`。直接执行 `window.desktopAPI = api` 虽然兼容旧代码，但页面脚本也能观察、覆盖或伪造这个对象；一旦出现 XSS 或第三方脚本失陷，攻击面更大。

`process.contextIsolated` 只是读取当前窗口是否启用了隔离，适合在 preload 中选择兼容分支；它本身不会修改 `BrowserWindow` 配置，也不会开启隔离。

## 3. `nodeIntegration` 控制什么

`nodeIntegration: true` 让渲染页面直接获得 Node.js 能力。若页面加载远程内容、可变 HTML 或复杂第三方依赖，普通 XSS 可能升级为文件、进程或本地资源级别的高影响问题。

`nodeIntegration: false` 关闭的是页面的直接 Node.js 入口，不等于 preload 失去全部职责。安全做法是让 preload 保留完成桥接所需的最小能力，再把少量业务 API 暴露给页面。

## 4. 为什么配置要组合看

以下组合会互相放大风险：

```text
nodeIntegration: true
contextIsolation: false
sandbox: false
webSecurity: false
webviewTag: true
```

更安全的基线通常是：

```text
nodeIntegration: false
contextIsolation: true
sandbox: true
webSecurity: true
webviewTag: false  // 不需要时
```

这不是一条可以机械复制到所有窗口的最终配置。某些本地功能可能依赖 Node 原生模块、特殊导航或嵌入内容，需要逐窗口评估和迁移；但兼容性需求不应被当成安全边界。

## 5. `contextBridge` 不是自动安全

不推荐：

```js
contextBridge.exposeInMainWorld("desktopAPI", {
  ipcRenderer,
  invoke: (channel, ...args) => ipcRenderer.invoke(channel, ...args)
});
```

推荐把能力收敛成明确动作：

```js
contextBridge.exposeInMainWorld("desktopAPI", {
  readSettings: () => ipcRenderer.invoke("settings:read"),
  chooseFile: () => ipcRenderer.invoke("file:choose")
});
```

主进程仍要检查参数结构、长度和取值范围，并根据场景校验 `sender`、主 frame、Origin、目标窗口和当前会话。桥接对象只做最小编排，不把任意 IPC、文件系统、Shell 或进程控制能力直接交给页面。

## 6. 共享 SDK 为什么不能直接删

共享 SDK 包可能同时承担：

- 运行时门面：让不同页面使用一致的调用方式；
- 类型契约：约束页面、preload 和主进程之间的输入输出；
- 浏览器兜底：在非 Electron 环境返回可预测结果；
- 工作区入口：被 `imports`、打包器 `alias`、workspace 依赖和构建命令引用。

因此应分开判断：

- `dist`、声明文件或打包输出若能由固定命令稳定重建，通常可以删除后重建；
- 整个 SDK 源码包只有在全部引用已迁移、替代契约已落地、构建链已更新并完成回归后才能删除；
- 单纯删除目录通常只会把问题推迟到类型检查、打包或运行时。

## 7. 渐进迁移顺序

1. 盘点每个窗口加载的内容、Origin 和实际需要的能力；
2. 按窗口关闭 `nodeIntegration`，补齐必要的 preload API；
3. 开启 `contextIsolation`，把直接写入 `window` 改为 `contextBridge`；
4. 把通用 IPC 改成业务级允许列表，并增加参数与发送者校验；
5. 评估并启用 sandbox、恢复 `webSecurity`、移除不必要的 `webviewTag`；
6. 对导航、弹窗、新窗口、下载、文件选择和远程内容做回归；
7. 最后再清理旧兼容分支与不再引用的共享 SDK 代码。

## 适用边界与前置条件

- 适用于 Electron 渲染窗口、preload、IPC 与前端共享 SDK 的通用架构判断。
- 卡片讲的是安全边界和迁移原则，不替代具体 Electron 版本的兼容性测试。
- 页面即使只加载本地资源，也应把 XSS、依赖供应链和导航劫持纳入威胁模型。
- `contextIsolation`、sandbox 和 `webSecurity` 的具体行为应以实际 Electron 版本文档和回归结果为准。
- 删除共享包前必须验证类型检查、构建、打包、运行时加载和浏览器兜底路径。

## 参考资料

- Electron：[Security](https://www.electronjs.org/docs/latest/tutorial/security)
- Electron：[Context Isolation](https://www.electronjs.org/docs/latest/tutorial/context-isolation)
- Electron：[contextBridge](https://www.electronjs.org/docs/latest/api/context-bridge)
- Electron：[WebPreferences](https://www.electronjs.org/docs/latest/api/structures/web-preferences)

## 生成与检查说明

- 生成日期：2026-11-21。
- 生成方式：Codex 内置 ImageGen。第 1 张直接生成；第 2 至 7 张仅把第 1 张最终成品作为视觉风格参考。
- 保存目录：`assets/20261121_01_electron-preload-security-cards/`。
- 画布：7 张图片均为 `1086 × 1448`，精确 3:4 竖版。
- 视觉规范：浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标。
- 脱敏策略：未使用真实产品名、内部接口名、域名、仓库地址、本机路径、账号、Token、Cookie、证书或凭据；代码和路径均为中性示例。
- 图片检查：逐张核对标题、中文、英文大小写、布尔值、冒号、点号、括号和流程含义，未发现影响理解的文字或结构错误。
- 正文检查：`Content.md` 一级标题和正文长度均按仓库规则验证。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 视频检查：单个 H.264 High Profile 视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长 28 秒，与每张 4 秒一致。
- 残余风险：不同 Electron 版本、窗口来源和原生模块会影响迁移顺序；上线前仍需结合具体威胁模型、CSP、导航限制和端到端回归评审。
