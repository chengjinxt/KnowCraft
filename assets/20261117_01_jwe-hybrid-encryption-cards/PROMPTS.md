# ImageGen 提示词记录

## 统一视觉规范

\`\`\`text
Use case: scientific-educational
Asset type: 六张原创中文密码学知识卡片，严格 3:4 竖版
Audience: 有基础开发经验、但不熟悉 JOSE、JWE 和混合加密的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；钴蓝与青绿色圆角信息块；少量橙色重点；简洁信封、钥匙、盾牌、浏览器和主进程图标；大字号、留白充足、手机端易读。
Composition: 顶部标题与短副标题，中部使用标准信封、对比面板或纵向流程解释一个中心问题，底部放一句准确结论。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、连字符、中文括号和数字；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实 Token、真实密钥、项目名、域名、仓库地址、本机绝对路径、账号、Cookie、证书或凭据。
\`\`\`

第 01 张不使用输入图片。第 02 至 06 张使用第 01 张最终成品作为视觉风格参考，只继承配色、标题层级、圆角信息块、技术图标语言和留白，不复制其中的文字或信息结构。

## 01 JWE 到底是什么

\`\`\`text
Use case: scientific-educational
Asset type: 原创中文密码学知识卡片，系列第1张，严格3:4竖版手机卡片
Primary request: 用白话解释 JWE 是一种标准加密数据格式，不是某一种具体加密算法；用一个打开的标准信封容器示意五个组成部分。
Audience: 有基础开发经验、但不熟悉 JOSE/JWE 的中文读者。
Scene/backdrop: 完全不透明浅米白背景。
Style/medium: 清爽扁平矢量技术信息图；深海军蓝标题；钴蓝与青绿色圆角信息块；少量橙色重点；简洁信封、钥匙、盾牌图标；大字号、留白充足、手机端易读。
Composition/framing: 顶部大标题与短副标题；中部放一个打开的标准信封，信封里纵向排列五个清晰部件；下部放概念解释卡；底部放橙色结论条。
Text (verbatim), and do not add any other text:
Title: "JWE 到底是什么？"
Subtitle: "把加密内容装进标准信封"
Term: "JWE（JSON Web Encryption，JSON Web 加密）"
Definition: "它不是一种算法，而是加密数据格式"
Part 1: "受保护头部"
Part 2: "加密后的密钥"
Part 3: "IV"
Part 4: "密文"
Part 5: "认证标签"
Bottom reminder: "公钥保护钥匙，AES 保护正文"
Constraints: 所有引号内文字必须逐字准确；准确保留 JWE、JSON Web Encryption、IV、AES 的英文大小写和中文括号；不要添加任何其他文字；不要出现代码、真实 Token、真实密钥、品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
\`\`\`

## 02 alg 与 enc 的分工

\`\`\`text
Use case: scientific-educational
Asset type: 原创中文密码学知识卡片，系列第2张，严格3:4竖版手机卡片
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释 JWE Protected Header 中 alg 与 enc 的分工：alg 决定如何保护内容加密密钥 CEK，enc 决定如何加密 ID Token 正文。
Style/medium: 清爽扁平矢量技术信息图，手机端易读。
Composition/framing: 顶部大标题和短副标题；中部左右或上下两个对称大面板，alg 面板配公钥和小钥匙图标，enc 面板配文档和盾牌图标；下部放 CEK 释义；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "alg 和 enc 各管什么？"
Subtitle: "一个管钥匙，一个管正文"
Panel 1 title: "alg（Algorithm，密钥管理算法）"
Panel 1 algorithm: "RSA-OAEP-256"
Panel 1 line: "用公钥保护 CEK"
Panel 2 title: "enc（Encryption Algorithm，内容加密算法）"
Panel 2 algorithm: "A256GCM"
Panel 2 line: "用 AES-GCM 加密 ID Token"
Term: "CEK（Content Encryption Key，内容加密密钥）"
Bottom reminder: "alg 管钥匙，enc 管正文"
Constraints: 所有引号内文字必须逐字准确；准确保留 alg、enc、Algorithm、Encryption Algorithm、RSA-OAEP-256、A256GCM、AES-GCM、ID Token、CEK、Content Encryption Key 的英文大小写、连字符和中文括号；不要添加任何其他文字；无真实 Token、真实密钥、品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
\`\`\`

## 03 为什么要混合加密

\`\`\`text
Use case: scientific-educational
Asset type: 原创中文密码学知识卡片，系列第3张，严格3:4竖版手机卡片
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 用四步流程解释为什么 JWE 采用非对称加密与对称加密结合的混合加密：Node.js 生成密钥对并给 Web 公钥；Web 随机生成 CEK；AES-GCM 用 CEK 加密 ID Token；RSA-OAEP-256 用公钥加密 CEK；Node.js 用私钥按相反顺序解密。
Style/medium: 清爽扁平矢量技术流程信息图，手机端易读。
Composition/framing: 顶部大标题和短副标题；中部四步纵向箭头流程，节点使用浏览器、公钥、小钥匙、文档、主进程图标；下部用左右分区显示 RSA 与 AES 的职责；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "为什么要混合加密？"
Subtitle: "非对称管钥匙，对称管内容"
Step 1: "1 Node.js 生成密钥对"
Step 1 note: "公钥给 Web，私钥留在主进程"
Step 2: "2 Web 随机生成 CEK"
Step 3: "3 AES-GCM 加密 ID Token"
Step 4: "4 RSA-OAEP-256 加密 CEK"
Decrypt note: "Node.js 用私钥解开 CEK，再解开正文"
Bottom reminder: "RSA 管小钥匙，AES 管大内容"
Constraints: 所有引号内文字必须逐字准确；准确保留 Node.js、Web、CEK、AES-GCM、ID Token、RSA-OAEP-256、RSA、AES 的英文大小写、点号和连字符；流程顺序必须正确；不要添加任何其他文字；无真实 Token、真实密钥、品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
\`\`\`

## 04 JWK 公钥参数

\`\`\`text
Use case: scientific-educational
Asset type: 原创中文密码学知识卡片，系列第4张，严格3:4竖版手机卡片
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释 RSA 公钥采用 JWK 表示时为什么有多个参数；强调 n 与 e 是 RSA 公钥的数学核心，其他参数主要说明密钥类型、用途、算法和编号，公钥不是秘密。
Style/medium: 清爽扁平矢量技术信息图，手机端易读。
Composition/framing: 顶部大标题和短副标题；中部放一张 JSON 风格但不密集的公钥说明卡，左侧逐项显示参数，右侧显示中文作用；把 n 画成最长的一行；下部放 JWK 全称；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "JWK 公钥为何有这么多项？"
Subtitle: "核心数值不多，其余是说明书"
Row 1: "kty：RSA 密钥类型"
Row 2: "n：模数，公钥主体"
Row 3: "e：公钥指数，常见值 65537"
Row 4: "use：用途，例如 enc"
Row 5: "alg：预期使用的算法"
Row 6: "kid：密钥编号"
Term: "JWK（JSON Web Key，JSON Web 密钥）"
Bottom reminder: "RSA 公钥的数学核心是 n + e"
Constraints: 所有引号内文字必须逐字准确；准确保留 JWK、JSON Web Key、kty、RSA、n、e、use、enc、alg、kid、65537 的英文大小写和中文括号；不要绘制私钥参数 d、p、q；不要添加任何其他文字；无真实 Token、真实密钥、品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
\`\`\`

## 05 Web 到 Node.js 的流程

\`\`\`text
Use case: scientific-educational
Asset type: 原创中文密码学知识卡片，系列第5张，严格3:4竖版手机卡片
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 展示 Web 页面把 ID Token 安全交给 Electron/Node.js 主进程的推荐实现流程：主进程每次登录生成临时密钥对；通过受限 preload 只给 Web 公钥；Web 生成 JWE；通过 IPC 发送密文；主进程检查发送者和一次性会话，解密并验证 ID Token，随后销毁私钥。
Style/medium: 清爽扁平矢量技术流程信息图，手机端易读。
Composition/framing: 顶部大标题和短副标题；中部四步纵向流程，使用主进程、浏览器、公钥、加密信封和盾牌图标；下部放 IPC 中英文释义；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "Web 怎样把 Token 交给 Node.js？"
Subtitle: "每次登录使用一对临时密钥"
Step 1: "1 主进程生成密钥对和 sessionId"
Step 2: "2 preload 只把公钥交给 Web"
Step 3: "3 Web 把 ID Token 加密成 JWE"
Step 4: "4 IPC 传密文，主进程解密并验证"
Cleanup: "成功或失败后都销毁临时私钥"
Term: "IPC（Inter-Process Communication，进程间通信）"
Bottom reminder: "私钥不进 Web，密文只用一次"
Constraints: 所有引号内文字必须逐字准确；准确保留 Web、Token、Node.js、sessionId、preload、ID Token、JWE、IPC、Inter-Process Communication 的英文大小写、点号、连字符和中文括号；流程方向必须是 Web 加密、主进程解密；不要添加任何其他文字；无真实 Token、真实密钥、品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
\`\`\`

## 06 安全边界

\`\`\`text
Use case: scientific-educational
Asset type: 原创中文密码学知识卡片，系列第6张，严格3:4竖版手机卡片
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝和青绿色圆角信息块、少量橙色重点、扁平矢量图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 清楚区分 JWE 在 Web 到 Node.js 传递 ID Token 场景中解决的问题和不能解决的问题；强调加密传输与身份真实性验证是两件事。
Style/medium: 清爽扁平矢量安全边界信息图，手机端易读。
Composition/framing: 顶部大标题和短副标题；中部上下两个大圆角面板，上方蓝绿色勾选面板写“能改善”，下方浅橙警示面板写“不能替代”；底部深蓝结论条。
Text (verbatim), and do not add any other text:
Title: "JWE 解决了什么？"
Subtitle: "加密传输，不等于消灭风险"
Panel 1 title: "能改善"
Panel 1 line 1: "Web 不再持有共享解密密钥"
Panel 1 line 2: "IPC 不再传输明文 ID Token"
Panel 1 line 3: "临时密钥与 sessionId 限制重放"
Panel 2 title: "不能替代"
Panel 2 line 1: "XSS 仍可能在加密前读取明文"
Panel 2 line 2: "主进程仍要验证签名与声明"
Term: "XSS（Cross-Site Scripting，跨站脚本）"
Bottom reminder: "JWE 保护传递，Token 签名证明来源"
Constraints: 所有引号内文字必须逐字准确；准确保留 JWE、Web、IPC、ID Token、sessionId、XSS、Cross-Site Scripting、Token 的英文大小写、连字符和中文括号；不要添加任何其他文字；无真实 Token、真实密钥、品牌 Logo、水印、二维码、页码或平台标识；不出现真实项目名、域名、仓库地址、本机路径、账号或凭据；严格3:4竖版，禁止横版。
\`\`\`

六张最终图片均由对应基础提示词直接生成，没有执行局部修图或定向重生成。
