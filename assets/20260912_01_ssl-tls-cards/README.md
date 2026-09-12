# SSL / TLS 1.2 / TLS 1.3 知识卡片

本目录包含六张原创竖版知识卡片：

- `01-ssl-vs-tls-versions.png`：SSL 与 TLS 的关系、版本演进和现代部署建议。
- `02-how-tls-protects-data.png`：身份认证、密钥交换、密钥派生、对称加密与完整性保护。
- `03-tls12-handshake.png`：TLS 1.2 的简化完整握手和密码套件拆解。
- `04-tls13-handshake.png`：TLS 1.3 的 1-RTT、AEAD、前向保密及 0-RTT 风险。
- `05-tls-use-cases.png`：HTTPS、HTTP/3、API、邮件、数据库、mTLS 和 TLS 终止。
- `06-tls-troubleshooting.png`：网络、协议、证书、算法和中间设备的分层排查。

## SSL 与 TLS 是什么关系

`SSL (Secure Sockets Layer，安全套接层)` 是历史协议；`TLS (Transport Layer Security，传输层安全协议)` 是它的标准化后继者。今天口语中的“SSL 证书”“SSL 连接”往往实际指 X.509 证书和 TLS 连接。

版本状态应区分清楚：

- SSL 2.0 已被 RFC 6176 禁止。
- SSL 3.0 已被 RFC 7568 禁止。
- TLS 1.0 与 TLS 1.1 已被 RFC 8996 弃用；RFC 9325 要求实现不得协商这两个版本。
- RFC 9325 要求实现支持 TLS 1.2，并建议支持 TLS 1.3；支持 TLS 1.3 时应优先协商 TLS 1.3。
- TLS 1.2 在采用现代密码套件和正确配置时仍可安全使用，不应笼统说成“TLS 1.2 已经不安全”。

现代通用策略是优先 TLS 1.3，为仍有需要的兼容客户端保留正确配置的 TLS 1.2，并禁用更早版本。特定行业、合规体系和封闭遗留设备可能有更严格或暂时不同的策略，需要单独评估，不能直接照搬一张通用清单。

## TLS 保护数据的核心机制

TLS 的三个主要目标是：

- `Authentication（身份认证）`：确认连接对象，最常见的是客户端验证服务器证书。
- `Confidentiality（机密性）`：让旁观者无法读懂传输内容。
- `Integrity（完整性）`：让篡改能够被检测出来。

建立连接时大致发生：

1. 客户端和服务器协商协议版本、密码能力及扩展。
2. 服务器发送证书链；客户端检查目标域名、有效期、签名和信任路径。
3. 双方进行密钥交换。现代配置通常使用临时 `(EC)DHE`，双方各自算出共享秘密，而不是直接发送会话密钥。
4. 双方从共享秘密和握手上下文派生流量密钥。
5. 记录层使用对称算法保护应用数据。现代配置通常使用 `AEAD (Authenticated Encryption with Associated Data，带关联数据的认证加密)`，例如 AES-GCM 或 ChaCha20-Poly1305。

证书和公钥密码主要解决身份认证、签名和密钥建立问题；大量业务数据通常由更高效的对称密码保护。不要把 HTTPS 简化成“服务器用证书公钥把所有网页数据加密”。

`mTLS (Mutual TLS，双向 TLS)` 会让双方都出示并验证证书，但它不是“加密两次”。

## TLS 1.2：完整握手和密码套件

卡片采用常见的 ECDHE 服务器认证场景，省略了可选消息。简化流程是：

```text
ClientHello →
← ServerHello + Certificate + ServerKeyExchange + ServerHelloDone
ClientKeyExchange + ChangeCipherSpec + Finished →
← ChangeCipherSpec + Finished
```

首次完整握手通常用大约两次网络往返完成。会话恢复可以减少后续连接开销；实际消息数量会随密码套件、客户端证书、扩展和恢复方式变化。

TLS 1.2 密码套件名称通常同时描述多种算法。例如：

```text
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
```

- `ECDHE`：临时椭圆曲线 Diffie-Hellman 密钥交换，提供 `Forward Secrecy（前向保密）`。
- `RSA`：这里用于服务器身份签名，不表示用 RSA 加密全部应用数据。
- `AES_128_GCM`：用于记录层的 AEAD 对称加密。
- `SHA256`：用于相关的 PRF / 握手哈希计算。

TLS 1.2 是否安全很大程度取决于具体配置。现代配置通常选择 ECDHE 与 AEAD，并避免静态 RSA 密钥交换、3DES、CBC 旧组合和过时签名算法。

## TLS 1.3：为什么更快、更容易安全配置

TLS 1.3 客户端通常在第一次 `ClientHello` 中就发送 `key_share`。服务器通过 `ServerHello + key_share` 响应后，双方可以建立握手密钥；`ServerHello` 之后的主要握手消息会被加密。首次完整握手通常约为 1-RTT，但 `HelloRetryRequest` 等情况可能增加一次往返。

TLS 1.3 的主要变化包括：

- 对称算法只保留 AEAD 方案。
- 移除静态 RSA 和静态 Diffie-Hellman 密钥交换；基于公钥的密钥交换提供前向保密。
- 将身份认证、密钥交换与记录层密码套件拆开协商。
- TLS 1.3 密码套件 `TLS_AES_128_GCM_SHA256` 主要描述记录保护算法和 HKDF 使用的哈希，不再把证书签名和密钥交换写进套件名称。

TLS 1.3 没有淘汰 RSA 证书。RSA 仍可用于数字签名；被移除的是静态 RSA 密钥交换。

### 0-RTT 不是“免费加速”

`0-RTT (Zero Round-Trip Time，零往返)` 只用于拥有 PSK/会话恢复状态时的 `Early Data（早期数据）`。RFC 8446 明确指出：0-RTT 数据不具备完整前向保密，而且服务器不能天然保证跨连接不被重放。

因此 0-RTT 只适合应用已经为重放设计好的操作。幂等读取仍需要结合应用语义评估；付款、下单、扣款、发送一次性验证码和其他状态变更不应直接接受可重放的 0-RTT 请求。

## 常见使用场景

- `HTTPS`：HTTP/1.1 和 HTTP/2 通常运行在 TLS/TCP 上。
- `HTTP/3`：运行在 QUIC 上，并将 TLS 1.3 握手集成进 QUIC；不能简单画成传统 TLS over TCP。
- API 与微服务：REST、gRPC 以及内部服务身份认证，常见单向 TLS 或 mTLS。
- 邮件：SMTPS、IMAPS、POP3S，以及从明文会话升级的 STARTTLS。若策略不强制，机会式 STARTTLS 可能降级为明文。
- 数据库与消息系统：数据库连接、Kafka、MQTT 等可以通过 TLS 防止链路窃听和篡改。
- 设备与 B2B：客户端证书可用于设备或合作方身份识别。
- 部分 VPN 和远程管理方案使用 TLS，但并不是所有 VPN 都基于 TLS。

`TLS Termination（TLS 终止）` 常发生在反向代理或负载均衡器：客户端 TLS 在那里结束，代理到后端的是另一条独立连接。后端链路不会自动继承前端连接的保护，应按网络边界和威胁模型决定是否再次使用 TLS/mTLS。

TLS 主要保护传输中的数据，不自动保护终端内存、日志、数据库落盘、弱密码、业务越权或恶意网页内容。浏览器小锁表示 TLS 通道和域名验证达到要求，不代表网站业务一定可信。

## 分层排查 TLS 失败

建议按以下顺序定位：

1. 网络：DNS、TCP 端口、防火墙和路由是否可达。
2. 协议：双方是否存在共同允许的 TLS 1.2/1.3。
3. 证书：域名、有效期、系统时间、中间证书和根 CA 信任。
4. 密码能力：密码套件、签名算法、曲线/密钥份额是否有交集。
5. 扩展与中间设备：SNI、ALPN、代理、VPN、防病毒软件和 TLS Inspection。

`SNI (Server Name Indication，服务器名称指示)` 在 `ClientHello` 中携带目标主机名，帮助同一 IP 上的服务器选择正确虚拟主机和证书。`ALPN (Application-Layer Protocol Negotiation，应用层协议协商)` 用于协商 `h2`、`http/1.1` 等上层协议。

### 快速诊断命令

```bash
openssl s_client -connect example.com:443 -servername example.com -tls1_2
openssl s_client -connect example.com:443 -servername example.com -tls1_3
curl -Iv https://example.com/
openssl x509 -in cert.pem -noout -dates -issuer -subject
```

把 `example.com` 替换为真实域名。`openssl s_client` 是诊断工具；如果要让验证失败立即返回并严格检查主机名，应结合 `-verify_return_error -verify_hostname example.com`。`curl -I` 发送 HTTP HEAD 请求，部分服务不支持 HEAD，但 TLS 握手信息仍可从详细输出中判断。

不要把 `curl -k` 或 `--insecure` 当作修复方案：它只是绕过身份验证，会掩盖真正的证书或信任链问题。

## 参考依据

- [RFC 6176：Prohibiting SSL 2.0](https://www.rfc-editor.org/info/rfc6176)
- [RFC 7568：Deprecating SSL 3.0](https://www.rfc-editor.org/info/rfc7568)
- [RFC 8996：Deprecating TLS 1.0 and TLS 1.1](https://www.rfc-editor.org/info/rfc8996)
- [RFC 5246：TLS 1.2](https://www.rfc-editor.org/info/rfc5246)
- [RFC 8446：TLS 1.3](https://www.rfc-editor.org/info/rfc8446)
- [RFC 9325：Recommendations for Secure Use of TLS and DTLS](https://www.rfc-editor.org/rfc/rfc9325.html)
- [NIST SP 800-52 Rev. 2：TLS Guidelines](https://csrc.nist.gov/pubs/sp/800/52/r2/final)
- [OpenSSL 3.6：s_client](https://docs.openssl.org/3.6/man1/openssl-s_client/)
- [OpenSSL 3.6：x509](https://docs.openssl.org/3.6/man1/openssl-x509/)
- [curl command-line manual](https://curl.se/docs/manpage.html)

## 生成与检查

- 生成方式：Codex 内置 `imagegen`。
- 版式：`3:4` 竖版、浅色不透明背景、高对比标题、圆角信息块。
- 完整最终提示词保存在 `PROMPTS.md`。
- 六张最终图片已逐张检查协议版本、握手方向、密码套件、0-RTT 风险和命令字符。
- 排错卡首稿因命令被视觉换行而弃用；最终稿改为四条全宽单行命令。
- 当前 Windows 环境安装了 OpenSSL 3.6.1 和 curl 8.13.0；命令参数已进行本机帮助级检查，未针对特定生产站点执行主动扫描。

