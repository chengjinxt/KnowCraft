# TLS 1.2 / TLS 1.3 开发者知识卡片

这组卡片只讨论 `TLS 1.2` 和 `TLS 1.3`，重点从开发者视角解释消息为什么这样排列、密钥怎样产生，以及调试时应该观察什么。

## 卡片顺序

1. `01-tls12-handshake-key-derivation.png`：TLS 1.2 的 ECDHE 完整握手、共享秘密、PRF、`master_secret`、`key_block`、`ChangeCipherSpec` 和 `Finished`。
2. `02-tls13-handshake-key-schedule.png`：TLS 1.3 为什么能在 1-RTT 建立密钥，以及 HKDF 如何分阶段派生握手密钥和应用流量密钥。
3. `03-tls12-vs-tls13-core-differences.png`：从 RTT、密钥份额位置、密码套件语义、密钥派生、加密边界、前向保密和恢复机制对比两代协议。
4. `04-session-resumption-and-0rtt.png`：TLS 1.2 Session ID / Ticket 与 TLS 1.3 PSK / NewSessionTicket 的区别，及 0-RTT 重放风险。
5. `05-developer-debugging.png`：协商交集、抓包可见范围、TLS 1.3 兼容字段、OpenSSL 配置 API、诊断命令和日志字段。

## 一条主线理解握手

TLS 握手不只是“交换几个 Hello”。它要完成三件事：

1. 协商双方都支持且策略允许的协议参数。
2. 验证对端身份，并把本次握手消息绑定到认证结果。
3. 建立只有双方知道的流量密钥，随后由记录层保护业务数据。

证书私钥通常用于身份签名；ECDHE 临时私钥用于计算共享秘密；真正大量加密业务数据的是派生出的对称流量密钥。共享秘密、临时私钥和最终流量密钥都不会直接通过网络明文传输。

## TLS 1.2 原理

卡片采用常见的 `ECDHE_RSA + AES-GCM` 服务器认证场景：

```text
ClientHello →
← ServerHello + Certificate + ServerKeyExchange + ServerHelloDone
ClientKeyExchange + ChangeCipherSpec + Finished →
← ChangeCipherSpec + Finished
Application Data ↔
```

- `ServerKeyExchange` 携带服务器临时 ECDHE 公钥份额，并由证书对应的私钥签名。
- 客户端验证证书链、域名和签名后生成自己的临时密钥对，只发送公钥份额。
- 双方分别用“自己的临时私钥 + 对方的临时公钥”计算同一个 ECDH 共享秘密 `Z`。
- TLS 1.2 使用 PRF 从共享秘密和双方随机数派生 `master_secret`，再扩展为记录层需要的 `key_block`。
- `ChangeCipherSpec` 让待定的密码状态成为当前状态；`Finished` 绑定握手 Transcript，用来发现握手被篡改或双方状态不一致。

首次完整握手通常约为 2-RTT，不包含 TCP 建连时间。TLS 1.2 是否安全高度依赖配置；现代部署应限制为临时 `(EC)DHE`、AEAD 和现代签名算法。

## TLS 1.3 原理

TLS 1.3 把客户端 `key_share` 前移到第一次 `ClientHello`：

```text
ClientHello + key_share →
← ServerHello + key_share
← {EncryptedExtensions + Certificate + CertificateVerify + Finished}
{Finished + Application Data} →
```

大括号表示使用握手密钥保护的消息。双方收到对方 `key_share` 后就能计算共享秘密，并通过 HKDF 与 Transcript Hash 派生握手流量密钥，因此 `ServerHello` 之后的主要握手消息可以加密。

TLS 1.3 的密钥调度把 Early、Handshake、Master、Application、Exporter 和 Resumption 等秘密分层派生，减少不同密码用途之间错误复用密钥材料的机会。

两个常见误区：

- TLS 1.3 的 `ClientHello.legacy_version` 正常情况下仍写作 `0x0303`；真正的版本列表在 `supported_versions` 扩展中，TLS 1.3 的编码值是 `0x0304`。
- 抓包里可能出现兼容用的 dummy `ChangeCipherSpec`，但它没有 TLS 1.2 中“切换当前密码状态”的协议语义。

## 两者主要区别

| 维度 | TLS 1.2 | TLS 1.3 |
| --- | --- | --- |
| 首次完整握手 | 通常约 2-RTT | 通常约 1-RTT；`HelloRetryRequest` 会增加往返 |
| 密钥份额 | 服务器先发 `ServerKeyExchange`，客户端再发 `ClientKeyExchange` | 客户端第一次 `ClientHello` 就发送 `key_share` |
| 密码套件 | 通常同时描述密钥交换、认证、记录加密和 PRF 哈希 | 只描述记录层 AEAD 和 HKDF 哈希；密钥组与签名算法分开协商 |
| 密钥派生 | PRF：pre-master → master → key block | HKDF：Early → Handshake → Master，并在多个阶段绑定 Transcript |
| 加密边界 | 大部分握手消息在 `ChangeCipherSpec` 前可见 | `ClientHello` / `ServerHello` 可见，之后的主要握手消息加密 |
| 算法表面积 | 历史组合较多，需要主动限制 | 移除静态 RSA / 静态 DH、压缩和重新协商，只保留 AEAD 套件 |
| 前向保密 | 取决于密码套件；ECDHE 有，静态 RSA 没有 | 公钥密钥交换使用临时 `(EC)DHE`；PSK-only 是例外 |
| 恢复 | Session ID / Session Ticket | 统一为 PSK / NewSessionTicket，并可受控使用 0-RTT |

`TLS_AES_128_GCM_SHA256` 这样的 TLS 1.3 套件名称不包含 ECDHE 或 RSA，不表示协议没有密钥交换和身份签名，而是表示这些角色已经改为通过 `supported_groups`、`key_share` 和 `signature_algorithms` 等扩展分别协商。

## 会话恢复和 0-RTT

TLS 1.2 常见 Session ID 和 Session Ticket。TLS 1.3 则使用统一的 PSK 恢复模型：首次握手后服务器发送 `NewSessionTicket`，客户端在下次 `ClientHello` 中携带 `pre_shared_key`、`psk_key_exchange_modes` 和 PSK Binder。

恢复连接不等于直接重复使用旧流量密钥。PSK 是新连接密钥调度的输入，新的握手上下文仍会派生新的流量密钥。

TLS 1.3 的 `0-RTT Early Data（零往返早期数据）` 在收到本次 `ServerHello` 之前就发送，因此它：

- 不依赖本次服务器随机数和新的 DHE 贡献。
- 不具备完整前向保密。
- TLS 层不能天然保证跨连接不被重放。

应用必须明确选择是否启用 0-RTT，并只发送可以安全重放的数据。付款、下单、发券、权限修改和验证码等操作不能直接放进 0-RTT。即使是 GET，也要评估计费、限额、审计、缓存和时序副作用。

## 开发调试重点

握手成功需要多组参数同时有交集：协议版本、密码套件、密钥组 / `key_share`、签名算法、证书能力及应用层协议。

```bash
openssl s_client -connect example.com:443 -servername example.com -tls1_2 -state -msg
openssl s_client -connect example.com:443 -servername example.com -tls1_3 -state -msg
```

OpenSSL 中要区分：

- `SSL_CTX_set_cipher_list()`：配置 TLS 1.2 及以下密码套件。
- `SSL_CTX_set_ciphersuites()`：配置 TLS 1.3 密码套件。
- TLS 1.3 的 groups 和 signature algorithms 仍需单独配置或使用经过维护的安全默认值。

生产日志建议至少记录：`negotiated_version`、`cipher`、`group`、`signature_algorithm`、`ALPN`、是否恢复连接，以及 Early Data 是接受还是拒绝。

## 标准依据

- [RFC 9846：The Transport Layer Security (TLS) Protocol Version 1.3](https://www.rfc-editor.org/rfc/rfc9846.html)
- [RFC 5246：The Transport Layer Security (TLS) Protocol Version 1.2](https://www.rfc-editor.org/rfc/rfc5246.html)
- [RFC 5869：HMAC-based Extract-and-Expand Key Derivation Function](https://www.rfc-editor.org/rfc/rfc5869.html)
- [OpenSSL：SSL_CTX_set_cipher_list / SSL_CTX_set_ciphersuites](https://docs.openssl.org/master/man3/SSL_CTX_set_ciphersuites/)
- [OpenSSL：s_client](https://docs.openssl.org/3.0/man1/openssl-s_client/)

`RFC 9846` 于 2025 年发布，是当前 TLS 1.3 标准，取代了 `RFC 8446`，并对 TLS 1.2 实现增加了新要求。`RFC 5246` 仍用于理解 TLS 1.2 的历史协议结构，但部署时还应遵守后续标准的安全限制。

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`。
- 版式：`3:4` 竖版、浅色不透明背景、时序箭头、等宽代码和开发者提示。
- 输入截图仅作为“原内容过于笼统”的问题参考；本组卡片为重新设计的原创内容，没有复制截图版式。
- 第 4 张首次生成时过度省略了恢复握手中的 `Finished`，已定向补回服务器和客户端 `Finished`，并再次修正 0-RTT 说明行。
- 完整生成提示词和定向修订提示词保存在 `PROMPTS.md`。
