# ImageGen 最终提示词

## 01 — TLS 1.2 握手与密钥派生

```text
Use case: scientific-educational
Asset type: 中文开发者知识卡片，3:4 竖版
Primary request: 从开发者角度讲清 TLS 1.2 完整握手如何从消息交换得到真正的流量密钥。不是只背消息名称，要把 ECDHE、证书签名、PRF、ChangeCipherSpec 与 Finished 的职责串起来。
Scene/backdrop: 完全不透明浅米白背景，极淡网络报文与密钥纹理。
Style/medium: 原创、严谨的扁平矢量协议时序图；深海军蓝标题，客户端蓝色、服务器绿色、密钥派生紫色、启用加密橙色；圆角消息块，代码使用等宽字体；不使用品牌 Logo。
Composition/framing: 顶部说明场景；中部为 Client 与 Server 双泳道四次消息飞行；下部为共享秘密和密钥派生流程；最底部给开发者结论。手机端文字必须清晰。

Text (verbatim):
"TLS 1.2 完整握手：密钥到底怎样来的？"
"场景：现代 ECDHE_RSA + AES-GCM｜TCP 已连接｜通常约 2-RTT"
"Client（客户端）"
"Server（服务器）"
"① ClientHello →"
"client_random｜版本｜Cipher Suites｜SNI / ALPN｜supported_groups｜signature_algorithms"
"② ← ServerHello + Certificate + ServerKeyExchange + ServerHelloDone"
"ServerHello：选择版本、套件，发送 server_random"
"Certificate：提供身份公钥与证书链"
"ServerKeyExchange：发送 server_ecdhe_public，并用证书私钥签名参数与随机数"
"③ ClientKeyExchange →"
"客户端先验证证书链、域名与签名"
"生成临时密钥对，只发送 client_ecdhe_public"
"双方独立计算同一个共享秘密"
"Z = ECDH(own_private, peer_public)"
"Z 和私钥从不在网络上传输"
"④ Client: ChangeCipherSpec + Finished →"
"⑤ ← Server: ChangeCipherSpec + Finished"
"ChangeCipherSpec：把待定加密状态切换为当前状态"
"Finished：校验整个握手 Transcript（消息摘要）是否一致"
"密钥派生"
"Z + client_random + server_random"
"→ PRF"
"→ master_secret"
"→ key_block"
"→ client/server write key + IV"
"随后：Application Data（应用数据）由 AES-GCM 等对称算法保护"
"三种密码材料，各司其职"
"证书私钥：证明服务器身份"
"ECDHE 临时私钥：算共享秘密，提供前向保密"
"对称流量密钥：高速加密真实业务数据"
"开发者结论：证书不负责加密全部网页；它认证 ECDHE 参数，真正的数据由派生出的对称密钥保护。"

Constraints: 所有报文方向和先后顺序准确；明确这是 TLS 1.2 的现代 ECDHE_RSA 示例，省略可选客户端证书消息；不得说网络上传输共享秘密或私钥；不得把 RSA 描述为加密所有应用数据；2-RTT 不包含 TCP 建连；文字清晰，不要页码、水印、透明背景或多余装饰。
Avoid: 把 ServerKeyExchange 写成 TLS 1.3 消息；把 PRF 写成 HKDF；把 Certificate 和 ECDHE 混为一件事；把 Finished 解释成业务数据；乱码或过小文字。
```

## 02 — TLS 1.3 握手与密钥调度

```text
Use case: scientific-educational
Asset type: 中文开发者知识卡片，3:4 竖版
Primary request: 从开发者角度讲清 TLS 1.3 首次完整握手如何把 key_share 前移，并通过 HKDF 分阶段派生握手密钥与应用流量密钥。重点解释 ServerHello 后为什么能够加密证书等握手消息。
Scene/backdrop: 完全不透明浅米白背景，极淡高速数据通道与密钥树纹理。
Style/medium: 原创、严谨的扁平矢量协议时序图；深海军蓝标题，客户端蓝、服务器绿、加密握手紫、HKDF 密钥树橙紫；圆角模块、清晰箭头、等宽代码；无品牌 Logo。
Composition/framing: 顶部说明 1-RTT 场景；中部 Client / Server 双泳道；在 ServerHello 处画明显“加密边界”；下部画简化 HKDF Key Schedule；最底部列两个开发者易错点。

Text (verbatim):
"TLS 1.3 完整握手：为什么 1-RTT 就能建密钥？"
"场景：证书认证 + (EC)DHE｜TCP 已连接｜通常约 1-RTT"
"Client（客户端）"
"Server（服务器）"
"① ClientHello →"
"supported_versions｜cipher_suites｜supported_groups｜signature_algorithms｜key_share｜SNI / ALPN"
"key_share：客户端第一条消息就附带临时公钥份额"
"兼容字段 legacy_version = 0x0303"
"真正版本由 supported_versions 协商"
"② ← ServerHello + key_share"
"服务器选择版本、AEAD 套件和密钥组，并返回自己的临时公钥份额"
"双方立刻计算 Z = (EC)DH(own_private, peer_public)"
"HKDF + Transcript Hash → Handshake Traffic Secrets"
"加密边界：ServerHello 之后的主要握手消息全部加密"
"③ ← EncryptedExtensions + Certificate + CertificateVerify + Finished"
"Certificate：身份公钥与证书链"
"CertificateVerify：证书私钥对握手 Transcript 签名"
"Finished：用握手密钥确认 Transcript 完整性"
"④ Finished →"
"客户端完成验证，发送加密 Finished"
"随后使用 Application Traffic Secrets 保护应用数据"
"简化 HKDF Key Schedule（密钥调度）"
"PSK（可选）→ Early Secret"
"(EC)DHE 共享秘密 Z → Handshake Secret"
"Transcript Hash → client/server handshake traffic secret"
"→ Master Secret"
"→ client/server application traffic secret"
"→ exporter / resumption secret"
"为什么比 TLS 1.2 少一次往返？"
"TLS 1.2 要等 ServerKeyExchange 后才发送客户端密钥份额"
"TLS 1.3 把 key_share 放进第一次 ClientHello"
"开发者易错点"
"HelloRetryRequest 会要求新的 key_share，并额外增加往返"
"TLS 1.3 没有有意义的 ChangeCipherSpec；抓包里可能出现兼容用 dummy CCS，应忽略其状态切换含义"
"开发者结论：TLS 1.3 不是简单删消息，而是重做了握手状态机与密钥分层。"

Constraints: 只描述 TLS 1.3 首次完整证书握手的常见流程；ServerHello 保持明文，只有其后的主要握手消息加密；明确实际版本由 supported_versions 而非 legacy_version 决定；HKDF 分阶段派生要准确；不得声称所有 TLS 1.3 都必然使用证书或都具备相同前向保密；1-RTT 不包含 TCP 建连；无水印、页码、透明背景。
Avoid: 把 ClientHello 画成加密消息；把 TLS 1.3 写成 0-RTT 完整握手；把 Certificate 当作密钥交换；把 ChangeCipherSpec 画成真实切换步骤；乱码或密集小字。
```

## 03 — TLS 1.2 与 TLS 1.3 核心差异

```text
Use case: scientific-educational
Asset type: 中文开发者知识卡片，3:4 竖版
Primary request: 制作一张 TLS 1.2 与 TLS 1.3 核心设计差异卡。不是只比较“2-RTT 和 1-RTT”，而是让开发者看懂两者在密钥交换位置、密码套件语义、密钥派生、握手加密边界与协议表面积上的根本区别。
Scene/backdrop: 完全不透明浅米白背景，极淡协议栈与报文纹理。
Style/medium: 原创、严谨、清爽的双栏对照信息图；TLS 1.2 用蓝色，TLS 1.3 用紫绿色；中间用清晰对比行和少量代码；深海军蓝标题；无品牌 Logo。
Composition/framing: 顶部先写共同目标；主体为左右两栏、七行差异矩阵；底部放迁移结论。手机端易读，不要过小字号。

Text (verbatim):
"TLS 1.2 vs TLS 1.3：不只是少 1 次 RTT"
"共同目标：认证对端 → 建立流量密钥 → 加密并校验 Record（记录）"
"TLS 1.2"
"TLS 1.3"
"① 首次完整握手"
"约 2-RTT"
"约 1-RTT；HelloRetryRequest 会增加往返"
"② 密钥份额出现位置"
"ServerKeyExchange 后，客户端才发送 ClientKeyExchange"
"客户端在第一次 ClientHello 就发送 key_share"
"③ Cipher Suite（密码套件）语义"
"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
"同时绑定：密钥交换 + 身份认证 + 记录加密 + PRF 哈希"
"TLS_AES_128_GCM_SHA256"
"只描述：AEAD 记录加密 + HKDF 哈希"
"密钥组与签名算法分别协商"
"④ Key Derivation（密钥派生）"
"PRF：pre-master secret → master_secret → key_block"
"HKDF：Early → Handshake → Master，密钥分层且绑定 Transcript"
"⑤ 握手加密边界"
"大部分握手消息明文；ChangeCipherSpec 后启用保护"
"ClientHello 与 ServerHello 明文；ServerHello 后的主要握手消息加密"
"⑥ 算法与配置表面积"
"协议允许的历史组合较多；现代部署必须主动限制为 ECDHE + AEAD"
"只保留 AEAD，移除静态 RSA / 静态 DH、压缩与重新协商"
"⑦ Forward Secrecy（前向保密）"
"取决于套件；ECDHE 有，静态 RSA 没有"
"基于公钥的密钥交换使用临时 (EC)DHE；PSK-only 是例外"
"⑧ 恢复连接"
"Session ID / Session Ticket，缩短握手"
"统一为 PSK / NewSessionTicket；可选择 1-RTT 恢复或受限 0-RTT Early Data"
"一句话看本质"
"TLS 1.2：用一个大套件描述多数密码角色，配置空间更大"
"TLS 1.3：拆开协商角色，用 HKDF 和 Transcript 构建更清晰的密钥状态机"
"迁移建议"
"服务端优先 TLS 1.3；为兼容保留经过现代化限制的 TLS 1.2。"
"不要把 TLS 1.3 当成“压缩版 TLS 1.2”，抓包、配置项和故障定位方法都不同。"

Constraints: 左右列逐行严格对应；密码套件名称逐字准确；TLS 1.3 套件不得包含 ECDHE 或 RSA；不得声称 TLS 1.3 所有模式必然前向保密；说明静态 RSA 是 TLS 1.2 历史能力而非现代推荐；RTT 不包含 TCP 建连；无水印、页码、透明背景。
Avoid: 只做速度比较；把 TLS 1.2 一概写成不安全；声称 TLS 1.3 淘汰 RSA 证书；把 0-RTT 等同完整握手；乱码和密集小字。
```

## 04 — 会话恢复与 0-RTT

```text
Use case: scientific-educational
Asset type: 中文开发者知识卡片，3:4 竖版
Primary request: 制作一张 TLS 1.2 与 TLS 1.3 会话恢复机制卡，重点说明 TLS 1.3 的 NewSessionTicket、PSK、Binder、1-RTT 恢复和 0-RTT Early Data 是什么关系，以及开发者为什么必须处理重放。
Scene/backdrop: 完全不透明浅米白背景，极淡票据、时钟和重复报文纹理。
Style/medium: 原创扁平矢量安全信息图；蓝色表示 TLS 1.2，紫绿表示 TLS 1.3，橙红表示 0-RTT 风险；清晰箭头、票据和重放图标；无品牌 Logo。
Composition/framing: 上半部左右对比恢复链路；中部展开 TLS 1.3 的 PSK 与两条恢复路径；下部放 0-RTT 风险与开发规则。手机端易读。

Text (verbatim):
"会话恢复：TLS 1.2 与 TLS 1.3 到底差在哪？"
"目标：复用上次握手建立的信任材料，减少再次连接的成本"
"TLS 1.2：两套常见机制"
"Session ID：服务器保存会话状态"
"Session Ticket：客户端保存服务器加密的会话状态"
"再次连接：进行 Abbreviated Handshake（简化握手）"
"应用数据仍要等恢复握手推进后发送"
"TLS 1.3：统一为 PSK 恢复模型"
"首次握手完成"
"→ Server 发送 NewSessionTicket"
"→ Client 保存 Ticket 与 resumption PSK"
"下次 ClientHello 携带"
"pre_shared_key｜psk_key_exchange_modes｜PSK Binder"
"Binder：证明客户端确实持有 PSK，并绑定本次 ClientHello"
"两条恢复路径"
"1-RTT Resumption"
"PSK + 新的 (EC)DHE key_share"
"重新派生新流量密钥；可为后续应用数据保留前向保密"
"0-RTT Early Data"
"ClientHello 后、ServerHello 前就发送应用数据"
"Early Data 使用由 PSK 派生的 early traffic key"
"此时还没有本次服务器随机数和新 DHE 贡献"
"收益：省等待｜代价：可被 Replay（重放），且早期数据不具备完整前向保密"
"重要：恢复连接 ≠ 直接重复使用旧流量密钥"
"PSK 只是密钥调度输入；每次连接会结合新的握手上下文派生新密钥"
"开发者安全规则"
"默认关闭 0-RTT，除非应用明确选择"
"只发送即使被重复执行也安全的请求"
"支付、下单、发券、修改权限、发送验证码：禁止直接放入 0-RTT"
"服务端需要 Anti-Replay（防重放）状态；多节点必须考虑一致性"
"即使是 GET，也要评估限额消耗、审计和时序副作用"
"服务器可拒绝 Early Data；客户端必须按应用协议安全重试，不能盲目自动重发"
"一句话：1-RTT 恢复主要是性能优化；0-RTT 会把重放风险推给应用层。"

Constraints: 明确 0-RTT 只属于 TLS 1.3 恢复场景，不是首次完整握手；明确 early data 可重放且不具备完整前向保密；不要承诺“幂等就绝对安全”；不得说恢复直接复用旧流量密钥；无水印、页码、透明背景。
Avoid: 把 Session Ticket 等同长期密码；把 Binder 写成服务器签名；把 0-RTT 画成服务器先响应；建议支付类操作使用 0-RTT；乱码和过小文字。
```

第 4 张定向修订 1：

```text
Change only the message labels inside the green lower-left box titled "1-RTT Resumption". Keep every other element, color, icon, title, warning, layout and text exactly unchanged.
Replace its second message label with: "2. ServerHello + EncryptedExtensions + Finished"
Add: "选择 PSK，派生握手密钥并确认服务器 Finished"
Replace its third message label with: "3. Client Finished + Application Data"
Add: "客户端确认 Finished，再使用新派生的流量密钥发送应用数据"
```

第 4 张定向修订 2：

```text
Fix exactly one corrupted line in the orange bullet list inside the "0-RTT Early Data" box. Replace the third orange bullet with this exact text: "此时还没有本次服务器随机数和新 DHE 贡献". Change only that single bullet line.
```

## 05 — 开发调试与抓包

```text
Use case: scientific-educational
Asset type: 中文开发者知识卡片，3:4 竖版
Primary request: 制作一张 TLS 1.2 / 1.3 开发调试卡，让开发者能从协商依赖、抓包可见范围、OpenSSL 配置和错误信息判断握手卡在哪一层。
Scene/backdrop: 完全不透明浅米白背景，极淡终端、Wireshark 波形与协议栈纹理。
Style/medium: 原创、清爽、严谨的开发者信息图；深海军蓝标题，蓝绿步骤，紫色 TLS 1.3 提醒，橙红故障提示；全宽等宽代码框；无品牌 Logo。
Composition/framing: 顶部是协商依赖链；中部左右为抓包视角和 TLS 1.3 易错点；下部是两条诊断命令、错误映射和上线日志清单。手机端易读。

Text (verbatim):
"TLS 1.2 / 1.3：开发者怎样判断卡在哪一步？"
"握手是一组“交集”"
"TCP 可达"
"→ 协议版本有交集"
"→ Cipher Suite 有交集"
"→ Group / key_share 有交集"
"→ Signature Algorithm 与证书匹配"
"→ 证书链、域名、时间可信"
"→ Finished 验证通过"
"→ ALPN 与应用协议继续"
"TCP 成功 ≠ TLS 成功｜TLS 成功 ≠ HTTP 成功"
"抓包能看见什么？"
"TLS 1.2"
"ClientHello、ServerHello、Certificate、ServerKeyExchange 通常可见"
"ChangeCipherSpec 后的 Finished 与应用数据受保护"
"TLS 1.3"
"ClientHello、ServerHello 可见"
"ServerHello 后的 EncryptedExtensions、Certificate、CertificateVerify、Finished 受保护"
"Wireshark 想解密，需要客户端 Key Log，例如 SSLKEYLOGFILE 或 OpenSSL -keylogfile"
"TLS 1.3 两个抓包陷阱"
"legacy_version = 0x0303 很正常"
"真正选择 TLS 1.3 看 supported_versions = 0x0304"
"dummy ChangeCipherSpec 可能出现"
"它只为中间设备兼容，不表示真正切换密钥"
"OpenSSL 配置不是同一个开关"
"SSL_CTX_set_cipher_list()：TLS 1.2 及以下"
"SSL_CTX_set_ciphersuites()：TLS 1.3"
"TLS 1.3 的 groups、signature algorithms 仍要分别配置"
"强制测试 TLS 1.2"
"openssl s_client -connect example.com:443 -servername example.com -tls1_2 -state -msg"
"强制测试 TLS 1.3"
"openssl s_client -connect example.com:443 -servername example.com -tls1_3 -state -msg"
"常见错误 → 优先检查"
"protocol_version → 双方版本或策略无交集"
"no shared cipher / handshake_failure → 套件、签名、密钥组或证书能力不匹配"
"certificate verify failed → 域名、时间、证书链、根 CA"
"no suitable key share / HelloRetryRequest → supported_groups 与 key_share"
"wrong version number → 目标端口可能不是 TLS，或代理转发了明文协议"
"上线必须记录"
"negotiated_version｜cipher｜group｜signature_algorithm｜ALPN｜resumed｜early_data accepted/rejected"
"部署原则：优先 TLS 1.3，兼容现代 TLS 1.2；使用维护中的 TLS 库，不要自己实现密码协议。"

Constraints: 两条 OpenSSL 命令必须各自完整单行、逐字准确、全宽展示；准确区分 TLS 1.2 与 TLS 1.3 的抓包可见范围；准确说明 legacy_version 0x0303；准确区分 OpenSSL 的 cipher_list 与 ciphersuites API；不要把 HelloRetryRequest 本身一概当成故障；无水印、页码、透明背景。
Avoid: 建议 curl -k 或关闭证书验证；声称抓包必然能看见 TLS 1.3 证书；把 TCP 错误、TLS 错误和 HTTP 错误混为一类；命令换行；乱码或过小文字。
```
