# 最终生成提示词

## 01 SSL 与 TLS 版本

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创、简单易懂但技术准确的 SSL 与 TLS 版本演进卡片。核心要说明 SSL 是 TLS 的前身，不是今天应与 TLS 并行启用的另一套安全协议。
Scene/backdrop: 完全不透明浅米白背景，极淡网络连接与锁形纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，旧版本用灰红色，新版本用蓝绿色，圆角时间轴和短信息块，少量锁、协议文件、升级箭头图标；不用品牌 Logo。
Composition/framing: 顶部标题和双语全称；中部纵向版本时间轴；下部解释“SSL 证书”口语和现代部署建议；适合手机阅读。
Text (verbatim):
"SSL 与 TLS：别再把它们并列启用"
"SSL（Secure Sockets Layer，安全套接层）"
"TLS（Transport Layer Security，传输层安全协议）"
"白话：SSL 是历史前身，今天真正使用的是 TLS。"
"版本时间轴"
"SSL 2.0｜已禁止使用"
"SSL 3.0｜已禁止使用"
"TLS 1.0｜已弃用"
"TLS 1.1｜已弃用"
"TLS 1.2｜仍可安全使用，但必须采用现代配置"
"TLS 1.3｜优先使用，更精简、更快、更难配错"
"现代部署建议"
"优先启用 TLS 1.3"
"为兼容需要保留正确配置的 TLS 1.2"
"禁用 SSL 2.0 / 3.0 与 TLS 1.0 / 1.1"
"“SSL 证书”只是历史口语"
"今天网站使用的 X.509 Certificate（数字证书）通常服务于 TLS 握手。"
"OpenSSL 名字里有 SSL，也不代表连接正在使用旧 SSL。"
"最终版本由客户端与服务器协商：选择双方都支持且策略允许的最高版本。"
Constraints: 所有协议版本号、英文全称和中文释义逐字准确；清楚区分“已禁止/弃用”“仍可安全配置”“优先使用”；不使用绝对化的“TLS 1.2 已不安全”；背景100%不透明；无品牌 Logo；无水印；无页码或系列角标。
Avoid: 暗示继续启用 SSL、把 TLS 1.3 写成 SSL 1.3、把证书等同于加密算法、透明背景、黑色大背景、乱码、密集小字。
```

## 02 TLS 保护原理

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创 TLS 实现原理卡片，用白话解释身份认证、密钥协商、密钥派生、对称加密和完整性保护如何配合。
Scene/backdrop: 完全不透明浅米白背景，极淡数据包和安全通道纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，蓝绿主色、少量橙色提醒，圆角步骤块，客户端与服务器两端，中间用箭头、证书、钥匙和加密数据包图标；不用品牌 Logo。
Composition/framing: 顶部列出 TLS 三个安全目标；中部是五步握手与传输流程；下部解释证书、对称密钥和安全边界。适合手机阅读。
Text (verbatim):
"TLS 到底怎样保护数据？"
"TLS（Transport Layer Security，传输层安全协议）"
"三大目标"
"Authentication（身份认证）：确认连接对象"
"Confidentiality（机密性）：旁观者看不懂"
"Integrity（完整性）：数据被篡改能发现"
"建立安全通道的 5 步"
"① 协商：双方选择 TLS 版本与密码算法"
"② 认证：服务器发送 Certificate（数字证书）"
"客户端检查域名、有效期、签名与信任链"
"③ 密钥交换：现代配置通常使用 ECDHE"
"双方算出 Shared Secret（共享秘密），无需把会话密钥直接发到网上"
"④ 密钥派生：从共享秘密生成 Traffic Keys（流量密钥）"
"⑤ 加密传输：Record Layer（记录层）保护应用数据"
"现代配置常用 AEAD（Authenticated Encryption with Associated Data，带关联数据的认证加密）"
"AES-GCM 或 ChaCha20-Poly1305：一次完成加密与完整性校验"
"为什么不一直用公钥加密？"
"公钥密码适合认证和协商；对称加密更快，适合大量数据。"
"常见的单向 TLS：客户端验证服务器"
"mTLS（Mutual TLS，双向 TLS）：双方都验证证书"
"TLS 的边界"
"保护传输途中，不保护已经解密的终端、恶意网页内容或弱密码。"
"小锁表示通道和域名验证通过，不代表网站业务一定可信。"
Constraints: 所有英文术语、缩写和中文解释准确；流程必须表现为先建立密钥再用对称加密传输；不要画成证书直接加密所有业务数据；“现代配置通常使用 ECDHE”不能写成所有 TLS 必然如此；背景100%不透明；无品牌 Logo；无水印；无页码角标。
Avoid: 把私钥发送给客户端、把会话密钥直接明文传输、把 TLS 描述成防病毒软件、透明背景、黑色大背景、乱码、过小文字。
```

## 03 TLS 1.2

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张 TLS 1.2 完整握手与密码套件知识卡片，既展示客户端和服务器消息顺序，也解释为什么“TLS 1.2 安不安全”取决于配置。
Scene/backdrop: 完全不透明浅米白背景，极淡数据包轨迹纹理。
Style/medium: 清爽扁平矢量时序信息图，深海军蓝标题，客户端蓝色、服务器绿色、加密阶段橙色，圆角消息块与箭头，等宽字体展示密码套件；不用品牌 Logo。
Composition/framing: 顶部一句核心结论；中部为客户端与服务器之间的四段简化时序；下部拆解一个现代 TLS 1.2 密码套件，并列安全配置要点。适合手机阅读。
Text (verbatim):
"TLS 1.2：完整握手怎样完成？"
"完整握手通常需要约 2-RTT（Round-Trip Time，往返时间）"
"以下以现代 ECDHE 配置为例，省略可选消息"
"Client（客户端）"
"Server（服务器）"
"① ClientHello →"
"支持的版本、Cipher Suites（密码套件）、随机数、SNI"
"② ← ServerHello + Certificate + ServerKeyExchange + ServerHelloDone"
"服务器选定参数，并用证书证明身份"
"③ ClientKeyExchange + ChangeCipherSpec + Finished →"
"客户端验证证书，计算共享秘密并切换到加密状态"
"④ ← ChangeCipherSpec + Finished"
"服务器确认握手完整性；随后传输加密的 Application Data（应用数据）"
"密码套件一眼拆开"
"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
"ECDHE：临时密钥交换，提供 Forward Secrecy（前向保密）"
"RSA：服务器身份签名；不是用 RSA 加密全部网页数据"
"AES_128_GCM：AEAD 对称加密"
"SHA256：PRF / 握手相关哈希"
"TLS 1.2 本身不等于不安全"
"推荐：ECDHE + AES-GCM 或 ChaCha20-Poly1305"
"避免：静态 RSA 密钥交换、CBC / 3DES、过时签名算法"
"Session Resumption（会话恢复）可减少再次连接的握手开销"
Constraints: 时序箭头方向和消息顺序准确；明确这是简化的 ECDHE 完整握手；密码套件必须逐字显示为 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256；不能说所有 TLS 1.2 都有前向保密；背景100%不透明；无品牌 Logo；无水印；无页码角标。
Avoid: 把 ClientHello 画成服务器发送、把 RSA 说成加密全部应用数据、把 TLS 1.2 一概标成不安全、透明背景、黑色大背景、乱码、错误套件名。
```

## 04 TLS 1.3

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张 TLS 1.3 握手与改进知识卡片，清楚展示 1-RTT、加密握手、AEAD、前向保密和 0-RTT 的收益与风险。
Scene/backdrop: 完全不透明浅米白背景，极淡高速数据通道纹理。
Style/medium: 清爽扁平矢量时序信息图，深海军蓝标题，客户端蓝、服务器绿色、加密阶段紫蓝、0-RTT 风险橙色，圆角消息块与箭头；不用品牌 Logo。
Composition/framing: 顶部突出“更少往返”；中部是 TLS 1.3 简化时序；下部四个核心改进与一个 0-RTT 风险区；适合手机阅读。
Text (verbatim):
"TLS 1.3：更快，也更难配错"
"首次完整握手通常约 1-RTT"
"Client（客户端）"
"Server（服务器）"
"① ClientHello + supported_versions + key_share + SNI →"
"客户端第一次消息就附带临时密钥份额"
"② ← ServerHello + key_share"
"双方获得握手密钥"
"ServerHello 之后的主要握手消息开始加密"
"③ ← EncryptedExtensions + Certificate + CertificateVerify + Finished"
"服务器证明身份并确认握手完整性"
"④ Finished →"
"客户端验证完成，随后发送加密的 Application Data（应用数据）"
"TLS 1.3 的关键变化"
"只保留 AEAD：AES-GCM、ChaCha20-Poly1305 等"
"移除静态 RSA / 静态 DH 密钥交换"
"公钥密钥交换提供 Forward Secrecy（前向保密）"
"密码套件更简单"
"TLS_AES_128_GCM_SHA256"
"只描述记录加密与 HKDF 哈希；认证和密钥交换另行协商"
"别误会：TLS 1.3 没有淘汰 RSA 证书"
"RSA 仍可用于数字签名，只是不再用于静态 RSA 密钥交换"
"0-RTT（Zero Round-Trip Time，零往返）"
"仅用于会话恢复时的 Early Data（早期数据）"
"更快，但可能被 Replay（重放），且不具备完整前向保密"
"适合可安全重试的幂等请求；支付、下单、状态变更不要直接使用"
Constraints: 时序消息方向准确；必须写清 ServerHello 之后的主要握手消息加密；不能说所有握手内容都隐藏；必须区分 RSA 证书签名与静态 RSA 密钥交换；0-RTT 只与会话恢复相关，并突出重放风险；背景100%不透明；无品牌 Logo；无水印；无页码角标。
Avoid: 把 TLS 1.3 写成 0-RTT 完整握手、声称 0-RTT 无重放风险、声称 TLS 1.3 不支持 RSA 证书、透明背景、黑色大背景、乱码。
```

## 05 使用场景

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张“TLS 不只用于 HTTPS”的使用场景知识卡片，说明常见协议如何借助 TLS，以及单向 TLS、mTLS、TLS 终止和保护边界。
Scene/backdrop: 完全不透明浅米白背景，极淡网络拓扑纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，蓝绿主色，不同场景用少量橙紫色区分，圆角场景卡，浏览器、API、邮件、数据库、设备与负载均衡器的通用图标；不用品牌 Logo。
Composition/framing: 顶部一句总览；中部六宫格使用场景；下部对比单向 TLS 与 mTLS，并展示 TLS Termination 的两段链路；底部边界提醒。适合手机阅读。
Text (verbatim):
"TLS 不只给 HTTPS 用"
"只要数据要穿过不可信网络，就可能需要安全通道"
"常见使用场景"
"Web 网站"
"HTTPS = HTTP over TLS"
"HTTP/1.1、HTTP/2 通常使用 TLS over TCP"
"HTTP/3 使用 QUIC，并集成 TLS 1.3"
"API 与微服务"
"REST、gRPC；内部服务常用 mTLS 识别彼此"
"邮件"
"SMTP STARTTLS、SMTPS、IMAPS、POP3S"
"敏感系统应强制 TLS，避免静默降级为明文"
"数据库与消息系统"
"数据库连接、Kafka、MQTT 等可用 TLS 防窃听和篡改"
"设备与 B2B"
"IoT Device（物联网设备）、合作方接口常使用客户端证书"
"部分远程接入"
"某些 VPN 与远程管理协议使用 TLS；不是所有 VPN 都基于 TLS"
"两种认证模式"
"单向 TLS：Client 验证 Server，常见于公共网站"
"mTLS（Mutual TLS，双向 TLS）：双方都验证证书"
"TLS Termination（TLS 终止）"
"用户 ← TLS → 负载均衡器 ← 另一条安全连接 → 后端"
"前端 TLS 在负载均衡器结束后，后端链路不会自动获得同一层保护"
"TLS 能保护什么？"
"保护传输中的数据；不自动保护终端、日志、数据库落盘和业务权限。"
Constraints: HTTP/3 必须表现为 QUIC 集成 TLS 1.3，不能画成普通 TLS over TCP；不能声称所有 VPN 都使用 TLS；TLS 终止必须明确前后是两段连接；术语中英文准确；背景100%不透明；无品牌 Logo；无水印；无页码角标。
Avoid: 把 HTTPS 写成加密整个互联网、把 mTLS 写成双重加密、把 STARTTLS 一概描述为强制安全、透明背景、黑色大背景、乱码、密集小字。
```

## 06 分层排错

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 重新制作 TLS 连接失败的分层排查卡片。最重要的排版要求：四条诊断命令必须放在四个独立的全宽横向代码框内，每条命令从左到右完整单行显示，绝对不能换行或拆成多行。为保证字号，可以减少装饰图标和空白。
Scene/backdrop: 完全不透明浅米白背景，极淡终端与诊断波形纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，蓝绿步骤、橙红风险提醒，圆角排错卡和清晰等宽代码块；不用品牌 Logo。
Composition/framing: 顶部标题；上半部分五层横向故障步骤；下半部分“快速诊断”采用四个从上到下排列、接近画布全宽的单行代码框；底部安全配置清单。不要四列命令网格。
Text (verbatim):
"TLS 连不上：别只盯着“证书错误”"
"按 网络 → 协议 → 证书 → 算法 → 中间设备 分层排查"
"① 网络层：DNS、端口、防火墙、路由是否可达？"
"注意：TCP 端口可达 ≠ TLS 握手成功"
"② 协议版本：双方是否有共同的 TLS 1.2 / 1.3？"
"protocol version / handshake failure"
"③ 证书验证"
"域名不匹配｜过期或尚未生效｜系统时间错误｜中间证书缺失｜根 CA 不受信"
"④ 密码能力"
"Cipher Suite（密码套件）、Signature Algorithm（签名算法）、Key Share（密钥份额）是否有交集？"
"⑤ SNI、ALPN 与中间设备"
"SNI（Server Name Indication，服务器名称指示）：决定虚拟主机证书"
"ALPN（Application-Layer Protocol Negotiation，应用层协议协商）：选择 h2 / http/1.1"
"代理、VPN、防病毒软件可能进行 TLS Inspection（TLS 检查）"
"快速诊断｜每条命令保持完整单行"
"TLS 1.2：openssl s_client -connect example.com:443 -servername example.com -tls1_2"
"TLS 1.3：openssl s_client -connect example.com:443 -servername example.com -tls1_3"
"HTTP：curl -Iv https://example.com/"
"证书：openssl x509 -in cert.pem -noout -dates -issuer -subject"
"安全配置清单"
"优先 TLS 1.3，兼容现代 TLS 1.2；禁用旧 SSL 与 TLS 1.0 / 1.1"
"服务器发送完整证书链，并自动续期"
"不要在生产环境用 -k / --insecure 绕过证书验证"
"握手成功 ≠ 应用成功：HTTP 401 / 403 / 500 属于更上层"
Constraints: 四条命令必须逐字准确、清晰可读、各自完整单行；为每条命令使用接近全画布宽度的独立代码框；禁止在 -connect、-servername 或任何参数前后换行；不能把 TCP 可达等同于 TLS 成功；不能建议绕过证书验证；背景100%不透明；无品牌 Logo；无水印；无页码角标。
Avoid: 四列命令布局、窄代码框、命令换行、错误参数、把 -k 当成修复、把所有失败归因于证书、透明背景、黑色大背景、乱码。
```

