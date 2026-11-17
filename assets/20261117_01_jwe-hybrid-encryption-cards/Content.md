# JWE 如何保护 ID Token

## JWE 是标准信封

JWE（JSON Web Encryption，JSON Web 加密）不是具体算法。紧凑格式包含受保护头部、加密密钥、IV、密文和认证标签。

## alg 管钥匙，enc 管正文

\`alg\`（Algorithm，密钥管理算法）保护 CEK；\`enc\`（Encryption Algorithm，内容加密算法）加密正文。\`RSA-OAEP-256\` 保护 CEK，\`A256GCM\` 加密 ID Token。

## 混合加密

CEK（Content Encryption Key，内容加密密钥）负责正文，RSA 只加密 CEK。Node.js 用私钥按相反顺序解开。

## 公钥参数

JWK（JSON Web Key，JSON Web 密钥）中，RSA 公钥核心是 \`n\` 和 \`e\`；其他字段说明类型、用途和编号。

## 实施流程

每次登录生成临时密钥对：公钥给 Web，私钥留在主进程。IPC（Inter-Process Communication，进程间通信）只传 JWE；主进程校验发送者和 \`sessionId\`。

## 安全边界

JWE 取消共享解密密钥与 IPC 明文，但 XSS（Cross-Site Scripting，跨站脚本）仍能在加密前读 Token。主进程仍须验证签名与声明。
