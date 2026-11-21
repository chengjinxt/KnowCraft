# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 七张原创中文 Electron 安全知识卡片，严格 3:4 竖版
Audience: 熟悉前端、刚接触 Electron 安全模型的中文开发者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；钴蓝与青绿色圆角信息块；少量橙色重点；简洁浏览器、桥梁、盾牌、芯片、代码包与依赖链图标；大字号、留白充足、手机端易读。
Composition: 顶部标题与短副标题，中部使用纵向流程、对比面板或三段信息块解释一个中心问题，底部放一句准确结论。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、冒号、括号和布尔值；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实产品名、内部接口名、域名、仓库地址、本机绝对路径、账号、Token、Cookie、证书或凭据。
```

第 01 张不使用输入图片。第 02 至 07 张使用第 01 张最终成品作为视觉风格参考，只继承配色、标题层级、圆角信息块、扁平矢量图标语言和留白，不复制其中的文字或信息结构。

## 01 Electron preload 是什么

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第1张，严格3:4竖版手机信息图
Primary request: 用三层桥梁结构解释 Electron preload 的角色：页面只调用被允许的方法，preload 封装并校验，主进程执行高权限操作。强调 preload 是受控桥梁，不应把整套 Node.js 直接交给页面。
Audience: 熟悉前端、刚接触 Electron 安全模型的中文开发者。
Scene/backdrop: 完全不透明浅米白背景。
Style/medium: 清爽扁平矢量技术信息图；深海军蓝标题；钴蓝、青绿色圆角信息块；少量橙色重点；简洁浏览器窗口、桥梁、盾牌、桌面芯片图标；大字号、留白充足、手机端易读。
Composition/framing: 顶部大标题与短副标题；中部用三层纵向流程和箭头，从页面经过 preload 到主进程；底部橙色结论条；严格3:4竖版。
Text (verbatim), and do not add any other text:
Title: "Electron preload 是什么？"
Subtitle: "页面与桌面能力之间的受控桥梁"
Layer 1 title: "页面"
Layer 1 line: "只调用被允许的方法"
Layer 2 title: "preload"
Layer 2 line: "封装接口并校验参数"
Layer 3 title: "主进程"
Layer 3 line: "执行高权限操作"
Bottom reminder: "桥应当窄，不应把整套 Node.js 交给页面"
Constraints: 所有引号内文字必须逐字准确；准确保留 Electron、preload、Node.js 的英文大小写和点号；不要添加任何其他文字；无品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、产品名、域名、仓库地址、本机路径、账号、Token、Cookie、证书或凭据；严格3:4竖版，禁止横版。
```

## 02 同名 preload 的两种角色

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第2张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 区分两类容易同名的 preload：Electron preload 由 BrowserWindow 在页面脚本前加载，处在桌面权限桥接位置；Web 侧 SDK 门面只是普通页面脚本，用来统一调用方式，不会因此自动获得系统权限。
Composition/framing: 顶部大标题与短副标题；中部上下两个对比面板，每个面板配对应图标；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "同名 preload，角色可能不同"
Subtitle: "先看它由谁加载"
Panel 1 title: "Electron preload"
Panel 1 line 1: "由 BrowserWindow 加载"
Panel 1 line 2: "处在桌面权限桥接位置"
Panel 2 title: "Web 侧 SDK 门面"
Panel 2 line 1: "由页面脚本加载"
Panel 2 line 2: "统一调用方式，不自动获得系统权限"
Bottom reminder: "名字相同，不代表处在同一信任边界"
Constraints: 所有引号内文字必须逐字准确；准确保留 preload、Electron、BrowserWindow、Web、SDK 的英文大小写；不要添加任何其他文字；无品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、产品名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
```

## 03 contextIsolation 两个分支

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第3张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承配色、标题层级、圆角信息块、扁平矢量图标和留白；不要复制参考图文字或信息结构。
Primary request: 对比 contextIsolation 为 true 与 false 的实际影响。true 时页面和 preload 位于隔离的 JavaScript 世界，通过 contextBridge 暴露最小 API；false 时双方共享 window，页面脚本可能改写桥接对象。强调 process.contextIsolated 只是读取当前状态，不会开启隔离。
Composition/framing: 顶部大标题与短副标题；中部上下两个对比面板；true 面板使用盾牌与双层窗口图标，false 面板使用共享窗口与警示图标；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "contextIsolation 两个分支"
Subtitle: "决定页面与 preload 是否共享全局对象"
Panel 1 title: "contextIsolation: true"
Panel 1 line 1: "隔离两个 JavaScript 世界"
Panel 1 line 2: "用 contextBridge 暴露最小 API"
Panel 2 title: "contextIsolation: false"
Panel 2 line 1: "双方共享同一个 window"
Panel 2 line 2: "页面脚本可能改写桥接对象"
Bottom reminder: "process.contextIsolated 只读取状态，不会开启隔离"
Constraints: 所有引号内文字必须逐字准确；准确保留 contextIsolation、preload、JavaScript、contextBridge、API、window、process.contextIsolated 的英文大小写、点号和冒号；不要添加任何其他文字；无品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、产品名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
```

## 04 nodeIntegration 的影响

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第4张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承配色、标题层级、圆角信息块、扁平矢量图标和留白；不要复制参考图文字或信息结构。
Primary request: 对比 nodeIntegration 为 true 与 false 的实际影响。true 时渲染页面可直接使用 Node.js 能力，XSS 的影响可能扩展到本机；false 时页面没有直接 Node.js 入口，需要通过受限 preload 调用。强调该配置控制的是页面环境，不是 preload 自身。
Composition/framing: 顶部大标题与短副标题；中部上下两个对比面板；true 面板用打开的终端和警示盾牌，false 面板用浏览器与受控桥梁；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "nodeIntegration 有什么影响？"
Subtitle: "它控制渲染页面能否直接使用 Node.js"
Panel 1 title: "nodeIntegration: true"
Panel 1 line 1: "页面可直接使用 Node.js 能力"
Panel 1 line 2: "XSS 影响可能扩展到本机"
Panel 2 title: "nodeIntegration: false"
Panel 2 line 1: "页面没有直接 Node.js 入口"
Panel 2 line 2: "通过受限 preload 调用"
Bottom reminder: "它控制的是页面，不是 preload"
Constraints: 所有引号内文字必须逐字准确；准确保留 nodeIntegration、Node.js、XSS、preload 的英文大小写、点号和冒号；不要添加任何其他文字；无品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、产品名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
```

## 05 高风险组合与安全基线

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第5张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 对比 Electron 渲染窗口的典型高风险配置组合与更安全的基线，说明多个开关叠加会改变页面漏洞的影响范围。
Composition/framing: 顶部大标题与短副标题；中部上下两个大面板，高风险面板使用浅橙警示风格，更安全面板使用蓝绿色盾牌风格；每个面板四行等宽字体配置；底部深蓝或橙色结论条。
Text (verbatim), and do not add any other text:
Title: "安全性差别不只两个开关"
Subtitle: "配置组合决定漏洞的影响范围"
Panel 1 title: "高风险组合"
Panel 1 row 1: "nodeIntegration: true"
Panel 1 row 2: "contextIsolation: false"
Panel 1 row 3: "sandbox: false"
Panel 1 row 4: "webSecurity: false"
Panel 2 title: "更安全的基线"
Panel 2 row 1: "nodeIntegration: false"
Panel 2 row 2: "contextIsolation: true"
Panel 2 row 3: "sandbox: true"
Panel 2 row 4: "webSecurity: true"
Bottom reminder: "非必要不开 webviewTag；远程内容始终按不可信处理"
Constraints: 所有引号内文字必须逐字准确；准确保留 nodeIntegration、contextIsolation、sandbox、webSecurity、webviewTag 的英文大小写和冒号；不要添加任何其他文字；无品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、产品名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
```

## 06 contextBridge 也可能用错

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第6张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释 contextBridge 并不会自动让桥接安全。不要暴露原始 ipcRenderer 或允许页面自行指定任意 channel 的通用 RPC；应暴露明确、细粒度的方法，并在主进程校验参数、sender 和 Origin。
Composition/framing: 顶部大标题与短副标题；中部上下两个对比面板，上方警示“不要这样暴露”，下方安全“改成明确能力”；搭配桥梁、锁和检查清单图标；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "contextBridge 也可能用错"
Subtitle: "开启隔离，不等于桥接自动安全"
Panel 1 title: "不要这样暴露"
Panel 1 line 1: "raw ipcRenderer"
Panel 1 line 2: "invoke(channel, ...args)"
Panel 2 title: "改成明确能力"
Panel 2 line 1: "readSettings()"
Panel 2 line 2: "chooseFile()"
Panel 2 line 3: "校验 args、sender 与 Origin"
Bottom reminder: "允许列表 + 参数校验 + 发送者校验"
Constraints: 所有引号内文字必须逐字准确；准确保留 contextBridge、raw ipcRenderer、invoke(channel, ...args)、readSettings()、chooseFile()、args、sender、Origin 的英文大小写、空格、点号和括号；不要添加任何其他文字；无品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、产品名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
```

## 07 共享 SDK 能直接删除吗

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第7张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 回答 monorepo 中共享 SDK 目录能否删除。区分 SDK 源码包、dist 构建产物和引用依赖链：源码包通常承载运行时门面与类型契约；dist 多数可以重建；删除整个包前必须迁移 imports、alias、workspace 和 build 引用。
Composition/framing: 顶部大标题与短副标题；中部三个纵向圆角信息块，依次用代码包、构建箱、依赖链图标；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "共享 SDK 能直接删除吗？"
Subtitle: "先分清源码、产物和依赖链"
Block 1 title: "SDK 源码包"
Block 1 line: "运行时门面 + 类型契约"
Block 2 title: "dist 构建产物"
Block 2 line: "通常可删除后重建"
Block 3 title: "删除前检查"
Block 3 line: "imports / alias / workspace / build"
Bottom reminder: "只删可重建产物最安全；删源码包必须先迁移依赖"
Constraints: 所有引号内文字必须逐字准确；准确保留 SDK、dist、imports / alias / workspace / build 的英文大小写、空格和斜杠；不要添加任何其他文字；无品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、产品名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
```

七张最终图片均由对应基础提示词直接生成；第 2 至 7 张仅使用第 1 张作为风格参考，没有执行局部修图或定向重生成。
