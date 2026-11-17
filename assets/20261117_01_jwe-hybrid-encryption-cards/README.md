# JWE 混合加密：Web 如何把 ID Token 交给 Node.js

## 白话结论

JWE（JSON Web Encryption，JSON Web 加密）不是一种具体算法，而是一套“怎样把密文、加密后的密钥、随机数和完整性标签装进标准信封”的格式。

在 Web 页面取得 ID Token、Electron/Node.js 主进程需要接收它的场景中，可以让主进程每次登录生成临时非对称密钥对：

- 公钥交给 Web，只负责加密；
- 私钥只留在主进程，负责解密；
- Web 临时生成 CEK（Content Encryption Key，内容加密密钥），用 AES-GCM 加密 ID Token；
- 再用主进程公钥加密 CEK；
- 主进程收到 JWE 后，用私钥先解开 CEK，再解开 ID Token。

这样可以取消 Web 与主进程共享的对称解密密钥，IPC 中也不再传递明文 ID Token。但它不能防止 Web 页面中的恶意脚本在加密前读取明文，也不能替代 ID Token 的签名与声明校验。

## 卡片清单

1. \`01-what-is-jwe.png\`：说明 JWE 是标准加密数据格式，不是单一算法。
2. \`02-alg-vs-enc.png\`：区分 \`alg\` 的密钥管理职责与 \`enc\` 的内容加密职责。
3. \`03-hybrid-encryption-flow.png\`：解释 RSA 与 AES 为什么要组成混合加密。
4. \`04-jwk-public-key-parameters.png\`：解释 JWK 公钥的 \`kty\`、\`n\`、\`e\`、\`use\`、\`alg\`、\`kid\`。
5. \`05-web-to-node-flow.png\`：给出 Web → IPC → Node.js 主进程的一次性登录传输流程。
6. \`06-security-boundary.png\`：区分 JWE 能改善的问题与不能替代的安全措施。

## 1. JWE 到底是什么

JWE 是 JOSE（JSON Object Signing and Encryption，JSON 对象签名与加密）标准族中的加密格式。它描述：

- 使用什么算法管理内容加密密钥；
- 使用什么算法加密正文；
- 密文、随机数和认证标签如何编码；
- 接收方怎样知道应该使用哪把密钥和哪组算法。

JWE 本身不是 RSA、AES 或其他单一加密算法。可以把它理解成一只标准信封：信封结构固定，但里面可以使用标准允许的不同算法组合。

JWE Compact Serialization（JWE 紧凑序列化）由五段 Base64URL 文本组成：

\`\`\`text
protected.encrypted_key.iv.ciphertext.tag
\`\`\`

| 部分 | 白话作用 | 技术含义 |
|---|---|---|
| \`protected\` | 信封说明书 | 受完整性保护的 JOSE Header，包含 \`alg\`、\`enc\`、\`kid\` 等 |
| \`encrypted_key\` | 加密后的“小钥匙” | 使用接收方公钥保护后的 CEK |
| \`iv\` | 本次加密随机起点 | Initialization Vector（初始化向量） |
| \`ciphertext\` | 加密后的正文 | ID Token 加密后的字节 |
| \`tag\` | 防篡改封条 | Authentication Tag（认证标签），用于发现密文或受保护头部被修改 |

Base64URL 只是二进制到文本的编码，不提供保密能力。真正的保密性来自 \`alg\` 与 \`enc\` 指定的密码算法。

## 2. \`alg\` 与 \`enc\` 为什么要分开

JWE 同时处理“怎样保护临时密钥”和“怎样加密正文”两个问题，所以使用两个不同参数。

### \`alg\`：Key Management Algorithm（密钥管理算法）

\`alg\` 决定 CEK 如何被加密、包装、协商或派生。

本方案使用：

\`\`\`json
{
  "alg": "RSA-OAEP-256"
}
\`\`\`

\`RSA-OAEP-256\` 表示使用 RSAES-OAEP，并让 OAEP 与 MGF1 使用 SHA-256。它保护的是 CEK，不是直接加密整个 ID Token。

### \`enc\`：Content Encryption Algorithm（内容加密算法）

\`enc\` 决定正文怎样进行 Authenticated Encryption（认证加密）。

本方案使用：

\`\`\`json
{
  "enc": "A256GCM"
}
\`\`\`

\`A256GCM\` 表示使用 256 位 AES（Advanced Encryption Standard，高级加密标准）密钥，并采用 GCM（Galois/Counter Mode，加罗瓦/计数器模式）。它同时提供：

- Confidentiality（保密性）：没有 CEK 就看不到 ID Token；
- Integrity（完整性）：修改密文、受保护头部或认证标签会导致解密失败。

因此一句话记忆：

\`\`\`text
alg 管钥匙，enc 管正文
\`\`\`

## 3. 为什么不直接用 RSA 加密 ID Token

RSA 不适合直接加密任意长度的数据。

以 2048 位 RSA 和 SHA-256 OAEP 为例，单次能够加密的明文上限为：

\`\`\`text
256 - 2 × 32 - 2 = 190 字节
\`\`\`

实际 ID Token 往往是数百到数千字节，因此不能假设它能够直接放进一次 RSA 运算。

标准做法是 Hybrid Encryption（混合加密）：

1. Web 随机生成 256 位 CEK；
2. 使用 CEK 和 AES-GCM 加密整个 ID Token；
3. 使用 Node.js 主进程的 RSA 公钥加密短小的 CEK；
4. 把加密后的 CEK、IV、密文和认证标签装进 JWE；
5. Node.js 使用私钥解开 CEK；
6. 再使用 CEK 解开 ID Token。

AES 适合快速加密长内容，RSA 适合把一把短小的临时密钥安全交给私钥持有者。二者组合后，既绕开 RSA 明文长度限制，也避免共享长期对称密钥。

## 4. 非对称加密的基本原理

RSA 密钥对包含相互关联的公钥和私钥：

- Public Key（公钥）：可公开，用于加密 CEK；
- Private Key（私钥）：必须保密，用于解密 CEK。

RSA 公钥的数学核心是：

\`\`\`text
(n, e)
\`\`\`

- \`n\` 是 Modulus（模数），由两个大素数乘积构成；
- \`e\` 是 Public Exponent（公钥指数），常见值为 \`65537\`。

私钥包含 \`d\` 等私有参数。只有掌握私钥的一方才能高效完成对应的解密运算。

实际系统不能直接使用“裸 RSA”。OAEP（Optimal Asymmetric Encryption Padding，最优非对称加密填充）会在加密前加入随机化和结构校验。同一 CEK 使用同一公钥加密多次，也会得到不同密文。

还要注意：公钥加密只保证“只有私钥持有者能够解密”，不证明“密文一定来自可信 Web 页面”。任何拿到公钥的人都能生成一份可被私钥解密的密文。因此主进程还必须校验 IPC 发送者、登录会话以及 ID Token 自身的签名和声明。

## 5. JWK 公钥为什么包含很多参数

JWK（JSON Web Key，JSON Web 密钥）是用 JSON 表示密码学密钥的标准格式。一个经过脱敏的 RSA 公钥示例如下：

\`\`\`json
{
  "kty": "RSA",
  "n": "<Base64URL 编码的模数>",
  "e": "AQAB",
  "use": "enc",
  "alg": "RSA-OAEP-256",
  "kid": "<本次临时密钥编号>"
}
\`\`\`

| 参数 | 是否属于 RSA 数学值 | 作用 |
|---|---:|---|
| \`kty\` | 否 | Key Type（密钥类型），告诉接收方这是 RSA，而不是 EC 等其他密钥 |
| \`n\` | 是 | RSA Modulus（RSA 模数），通常占据绝大部分文本长度 |
| \`e\` | 是 | RSA Public Exponent（公钥指数）；\`AQAB\` 是整数 \`65537\` 的 Base64URL 表示 |
| \`use\` | 否 | Intended Use（预期用途）；\`enc\` 表示用于加密或密钥包装 |
| \`alg\` | 否 | 这把密钥预期搭配的算法；在 JWK 中是可选元数据 |
| \`kid\` | 否 | Key ID（密钥编号），用于从多把密钥中找到匹配项 |

所以“公钥参数很多”并不表示存在很多秘密：

- \`n\` 与 \`e\` 是 RSA 公钥的数学核心；
- \`kty\` 是 JWK 必须携带的类型说明；
- \`use\`、\`alg\`、\`kid\` 主要用于限制用途和选择密钥；
- 公钥本来就可以公开；
- 私钥参数 \`d\`、\`p\`、\`q\`、\`dp\`、\`dq\`、\`qi\` 绝不能发送给 Web。

如果不想使用 JSON，也可以传递 SPKI（SubjectPublicKeyInfo，主体公钥信息）格式。SPKI 会把算法标识、\`n\` 和 \`e\` 编码成 DER 二进制，再以 PEM 或 Base64 传输。内容并没有消失，只是从可读字段变成了二进制结构。Web 与 Node.js 交互时，JWK 通常更直观。

JWK 中的 \`alg\` 只是预期用途说明；JWE Protected Header 中的 \`alg\` 才描述本条消息实际使用的密钥管理算法。解密端必须固定算法白名单，并检查两者一致，不能因为密文声称使用某算法就自动接受。

## 6. Web → Node.js 的推荐实现流程

### 信任边界

- Node.js 主进程：保存私钥、解密并验证 ID Token；
- preload：只暴露两三个受限方法，不暴露通用 IPC；
- Web/renderer：能够获取公钥、生成 JWE、提交密文，但不能读取私钥；
- IPC（Inter-Process Communication，进程间通信）：只传登录上下文和密文。

### 第一步：主进程建立一次性登录会话

每次登录生成独立的：

- RSA 临时密钥对；
- \`sessionId\`；
- \`kid\`；
- \`expiresAt\`；
- 预期 \`webContents.id\`、主 frame 和 Origin；
- \`pending / processing / consumed\` 状态。

私钥只保存在主进程内存中。RSA 密钥应异步生成，避免阻塞主进程。RFC 7518 要求 RSA-OAEP 使用至少 2048 位 RSA 密钥；实际位数还应遵守组织的密码策略。

### 第二步：只向 Web 提供公钥上下文

\`\`\`json
{
  "version": 1,
  "sessionId": "<一次性登录会话>",
  "kid": "<临时密钥编号>",
  "expiresAt": 1790000000000,
  "publicKey": {
    "kty": "RSA",
    "n": "<示例省略>",
    "e": "AQAB",
    "use": "enc",
    "alg": "RSA-OAEP-256",
    "kid": "<临时密钥编号>"
  }
}
\`\`\`

\`expiresAt\` 只是格式示意，不代表真实系统时间。Web 获得公钥不会获得解密能力。

### 第三步：Web 生成 JWE

以下代码只展示调用结构，实际项目需要根据依赖版本处理错误、超时和类型：

\`\`\`js
const publicKey = await importJWK(
  context.publicKey,
  "RSA-OAEP-256"
);

const jwe = await new CompactEncrypt(
  new TextEncoder().encode(idToken)
)
  .setProtectedHeader({
    alg: "RSA-OAEP-256",
    enc: "A256GCM",
    kid: context.kid,
    sid: context.sessionId,
    typ: "id-token+jwe"
  })
  .encrypt(publicKey);
\`\`\`

符合 JOSE 的实现会负责生成 CEK、IV 和认证标签。Web 不应自己设计拼接格式，也不应复用 IV。

### 第四步：IPC 只提交会话编号和 JWE

\`\`\`json
{
  "sessionId": "<一次性登录会话>",
  "jwe": "<JWE Compact Serialization>"
}
\`\`\`

preload 应暴露明确的方法，例如：

\`\`\`js
window.desktopAuth.getEncryptionContext();
window.desktopAuth.submitEncryptedIdToken(payload);
\`\`\`

不要向远程 Web 页面暴露可以任意指定 channel 的通用 \`send(channel, ...args)\` 或 \`invoke(channel, ...args)\`。

### 第五步：主进程先检查上下文，再解密

主进程至少需要：

1. 校验 IPC \`sender\`、\`senderFrame\`、主 frame、Origin 和 \`webContents.id\`；
2. 校验 \`sessionId\` 存在、未过期且状态为 \`pending\`；
3. 原子地把状态改为 \`processing\`，阻止并发重放；
4. 只允许 \`RSA-OAEP-256\` 与 \`A256GCM\`；
5. 校验 Protected Header 中的 \`kid\`、\`sid\` 和预期值一致；
6. 使用对应私钥解密；
7. 无论成功还是失败，都消费会话并销毁临时私钥。

解密调用结构示意：

\`\`\`js
const result = await compactDecrypt(jwe, privateKey, {
  keyManagementAlgorithms: ["RSA-OAEP-256"],
  contentEncryptionAlgorithms: ["A256GCM"]
});

const idToken = new TextDecoder().decode(result.plaintext);
\`\`\`

不要根据密文传入的 \`alg\` 动态放宽允许算法，也不要为不同解密错误返回可被攻击者区分的详细信息。

### 第六步：独立验证 ID Token

JWE 解密成功只说明：

- 密文与受保护头部没有被 AES-GCM 检测到篡改；
- 当前主进程持有对应私钥。

它不代表 ID Token 一定由可信身份提供方签发。主进程仍要根据 OIDC（OpenID Connect，开放式身份连接）配置验证：

- JWS（JSON Web Signature，JSON Web 签名）；
- \`iss\`（Issuer，签发方）；
- \`aud\`（Audience，受众）；
- \`exp\`（Expiration Time，过期时间）；
- \`iat\`（Issued At，签发时间）；
- \`nonce\`；
- 多受众场景下需要的 \`azp\`（Authorized Party，被授权方）。

ID Token、解密错误细节和私钥都不应写入普通日志。

## 7. 相比共享对称密钥改善了什么

| 对比项 | Web 与主进程共享对称密钥 | 临时公钥 + JWE |
|---|---|---|
| Web 拿到的密钥 | 可加密也可解密 | 只能加密的公钥 |
| IPC 内容 | 取决于自定义协议，可能泄露明文或密钥 | 标准 JWE 密文 |
| 密钥泄露影响 | 共享密钥泄露后可解密对应密文 | 公钥泄露不会获得解密能力 |
| 密钥生命周期 | 容易被错误复用 | 每次登录临时生成并一次性消费 |
| 长 Token 支持 | 需要自行设计 | JWE 标准混合加密 |
| 防 XSS | 不能 | 仍然不能防止加密前读取明文 |
| Token 真实性 | 不能证明 | 仍须验证 ID Token 签名和声明 |

## 8. 这套方案没有解决什么

### 不能防止加密前读取

Web 页面必须先拿到 ID Token 才能加密，所以 XSS（Cross-Site Scripting，跨站脚本）或被控制的页面脚本仍可能：

- 在调用 JWE 加密前读取明文；
- 使用公钥加密攻击者选择的其他内容；
- 在有效登录窗口内调用受限桥接接口。

因此仍需 CSP（Content Security Policy，内容安全策略）、依赖治理、严格 Origin、\`nodeIntegration: false\`、\`contextIsolation: true\` 和最小化 preload API。

### 不能证明发送者可信

任何拿到公钥的代码都可以生成密文。必须通过 IPC sender 校验、主 frame 校验和一次性 \`sessionId\` 把密文绑定到预期登录窗口。

### 不能替代 Token 校验

加密回答“谁能看”，签名回答“谁签发、内容是否被改”。两者职责不同。

## 9. 实施检查清单

- [ ] 每次登录生成新的临时密钥对和 \`sessionId\`
- [ ] 私钥只存在于 Node.js 主进程内存
- [ ] 公钥使用 JWK 或 SPKI 标准格式
- [ ] 固定 \`RSA-OAEP-256\` + \`A256GCM\` 白名单
- [ ] 使用成熟 JOSE/JWE 实现，不自创密码协议
- [ ] Protected Header 绑定 \`kid\` 和 \`sid\`
- [ ] 校验 IPC sender、主 frame、Origin 和 \`webContents.id\`
- [ ] \`sessionId\` 设置短有效期并原子地一次性消费
- [ ] 成功或失败后销毁临时私钥
- [ ] 验证 ID Token 的签名、\`iss\`、\`aud\`、\`exp\`、\`nonce\` 等
- [ ] 不记录 ID Token、私钥、CEK 或可区分的解密错误细节
- [ ] 保持 \`nodeIntegration: false\` 与 \`contextIsolation: true\`
- [ ] 使用严格 CSP 并减少第三方脚本

## 参考资料

- IETF：[RFC 7516 — JSON Web Encryption (JWE)](https://www.rfc-editor.org/rfc/rfc7516.html)
- IETF：[RFC 7517 — JSON Web Key (JWK)](https://www.rfc-editor.org/rfc/rfc7517.html)
- IETF：[RFC 7518 — JSON Web Algorithms (JWA)](https://www.rfc-editor.org/rfc/rfc7518.html)
- IETF：[RFC 7638 — JSON Web Key Thumbprint](https://www.rfc-editor.org/rfc/rfc7638.html)
- IETF：[RFC 8725 — JSON Web Token Best Current Practices](https://www.rfc-editor.org/rfc/rfc8725.html)
- W3C：[Web Cryptography API](https://www.w3.org/TR/webcrypto-1/)
- Electron：[Security](https://www.electronjs.org/docs/latest/tutorial/security)

## 生成与检查说明

- 生成日期：2026-11-17。
- 生成方式：Codex 内置 ImageGen，逐张生成 6 张原创中文技术知识卡片；第 2 至 6 张使用第 1 张成品作为视觉风格参考。
- 保存目录：\`assets/20261117_01_jwe-hybrid-encryption-cards/\`。
- 画布：6 张图片均为 \`1086 × 1448\` 的精确 3:4 竖版画布。
- 视觉规范：浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量安全图标。
- 脱敏策略：只使用 \`<一次性登录会话>\`、\`<临时密钥编号>\`、\`<示例省略>\` 等占位符，不包含真实项目、域名、仓库 URL、本机路径、账号、Token、Cookie、证书或密钥。
- 图片检查：逐张核对 JWE、JWK、\`alg\`、\`enc\`、CEK、RSA、AES、IPC、XSS、\`sessionId\`、英文大小写及流程箭头，未发现影响理解的文字或流程错误。
- 正文检查：\`Content.md\` 一级标题为 14 个可见字符，正文按去除 Markdown 标记后的口径为 498 个可见字符。
- 视频生成：使用仓库内 \`card-video-generator/dist/knowcraft-video.exe\` 生成 \`shorts.mp4\`。
- 视频检查：单个 H.264 High Profile 视频流，\`1080 × 1920\`、30 fps、\`yuv420p\`、BT.709、TV range，无音轨，总时长 24 秒。
- 技术边界：卡片采用 \`RSA-OAEP-256\` + \`A256GCM\` 讲解现有 Web → Node.js 场景；实际落地仍需结合运行时支持、密码策略、身份提供方配置和威胁模型评审。
