# DNS 四类记录与权威名称服务器迁移

## 白话结论

- `DNS (Domain Name System，域名系统)` 用不同类型的记录回答不同问题：网站地址、别名、收信服务器和验证文本不是一回事。
- 卡片讲解四类常见资源记录，但它们并不代表一个域名的全部配置。
- 更换 `NS (Name Server，名称服务器)` 等于把整个域名的权威答复权交给新的服务商。应先完整建立并核对新区域，再切换委派。
- 自动导入或扫描只能辅助，迁移后仍要实际验证网站、接口、邮件与域名认证。

## 卡片说明

1. `01-dns-a-cname-mx-txt.png`：解释四类常见记录，并给出更换权威名称服务器前的迁移顺序。

卡片中的 `example.test`、`service.test` 属于示例域名写法，`192.0.2.10` 属于文档示例地址，不代表真实站点或服务器。

## 四类记录分别管什么

### A：IPv4 地址

`A (Address，地址记录)` 把一个名称映射到 `IPv4 (Internet Protocol version 4，互联网协议第 4 版)` 地址。例如：

```text
api.example.test.  A  192.0.2.10
```

它让访问者知道应连接哪台服务器。`IPv6 (Internet Protocol version 6，互联网协议第 6 版)` 地址使用 `AAAA（IPv6 地址记录）`，不应写入 A 记录。

### CNAME：主机名别名

`CNAME (Canonical Name，规范名称/别名记录)` 把一个主机名指向另一个主机名。例如：

```text
www.example.test.  CNAME  app.service.test.
```

解析器会继续查询目标主机名的地址，因此云服务目标变化时，别名一侧通常不必跟着改地址。标准 DNS 中，作为 `CNAME` 的名称不能同时拥有其他普通数据；区域根名称还必须保留 `SOA (Start of Authority，授权起始)` 与 NS 记录，所以不能直接按普通 CNAME 使用。部分服务商提供 `ALIAS`、`ANAME` 或 CNAME Flattening（CNAME 扁平化）来模拟根域别名，但这些是服务商能力，应以其文档为准。

### MX：收信服务器

`MX (Mail Exchange，邮件交换记录)` 指定负责接收邮件的服务器，并带有优先级。例如：

```text
example.test.  MX  10 mail.example.test.
```

数字越小，优先级越高；相同优先级可供发送方选择。MX 的目标应是能解析出地址的主机名，不应把目标配置成 CNAME。`SMTP (Simple Mail Transfer Protocol，简单邮件传输协议)` 规范定义了无 MX 时尝试地址记录的兼容行为，但正式邮件域不应依赖这种回退。

### TXT：可查询文本

`TXT (Text，文本记录)` 发布可被 DNS 查询的文本。它常用于域名所有权验证，以及以下邮件认证机制：

- `SPF (Sender Policy Framework，发件人策略框架)`：声明哪些服务器可代表域名发信。
- `DKIM (DomainKeys Identified Mail，域名密钥识别邮件)`：发布用于验证邮件签名的公钥。
- `DMARC (Domain-based Message Authentication, Reporting, and Conformance，基于域名的邮件认证、报告与一致性)`：声明认证对齐与失败邮件处理策略，并可请求报告。

这些协议借用 TXT 保存数据，但 TXT 本身不会自动完成验证或邮件认证；具体语法和查询名称由对应协议规定。

## 为什么更换 NS 前必须迁移完整

注册商或上级区域中的 NS 委派决定“谁是这个域名的权威答复者”。切换后，递归解析器会逐步改问新服务商；新区域少一条记录，就可能让相应业务在部分地区失效。

除了卡片展示的四类记录，还应检查：

- AAAA、其他子域名、通配符和多值记录；
- `CAA (Certification Authority Authorization，证书颁发机构授权)`、`SRV (Service，服务定位记录)` 等业务确实使用的记录；
- MX 优先级、TXT 长文本拼接、代理与 `CDN (Content Delivery Network，内容分发网络)` 开关和服务商特有功能；
- `DNSSEC (Domain Name System Security Extensions，域名系统安全扩展)` 的签名、密钥与上级 `DS (Delegation Signer，委派签名者)` 记录。

如果旧的 DS 仍在上级区域，而新权威服务器不能提供与它匹配的 DNSSEC 证明，启用验证的解析器可能返回 `SERVFAIL`。DNSSEC 已开启时，应先按新旧服务商的官方迁移流程安排密钥和 DS，不能只复制可见的普通记录。

## 推荐迁移顺序

1. 从旧服务商导出或逐项盘点全部记录，同时记录名称、类型、值、`TTL (Time to Live，生存时间)`、优先级和特殊开关。
2. 如需缩短切换后的缓存等待时间，提前降低相关 TTL；已经进入缓存的旧值仍会按原 TTL 到期。
3. 在新服务商创建区域并导入记录，人工复核根域、子域、通配符、邮件认证与 DNSSEC。
4. 直接查询新权威服务器，确认它在正式接管前已能正确回答。
5. 在注册商处更换 NS；缓存过渡期间同时保留旧区域，不要立即删除旧配置。
6. 从不同网络验证网站、接口、收发信、SPF、DKIM、DMARC 和证书签发相关记录。

## Windows 查询示例

下面的域名、地址和服务器名均为示例或占位符：

```powershell
nslookup -type=A api.example.test
nslookup -type=CNAME www.example.test
nslookup -type=MX example.test
nslookup -type=TXT example.test
nslookup -type=TXT _dmarc.example.test
nslookup -type=NS example.test

# 切换前，直接询问新的权威 DNS 服务器
nslookup -type=A api.example.test <新权威DNS服务器地址>
nslookup -type=MX example.test <新权威DNS服务器地址>
```

`nslookup` 的默认查询结果可能来自递归缓存。迁移核对时，应同时直接查询新旧权威服务器，并比较公开递归解析器的最终结果。

## 常见误解

- “复制了 A 记录就迁完了”：邮件、验证、证书、子域名或 IPv6 仍可能依赖其他记录。
- “换 NS 后立刻全球生效”：NS 委派与记录都可能被缓存，实际过渡时间取决于原 TTL 和各级缓存状态。
- “TXT 就是邮件认证”：TXT 只是承载文本；SPF、DKIM、DMARC 各自还有查询名称、语法和校验规则。
- “扫描工具能找到全部记录”：DNS 不提供公开枚举所有名称的通用机制，自定义子域名和服务商特有配置可能被漏掉。

## 参考资料

- [RFC 1034：Domain Names - Concepts and Facilities](https://www.rfc-editor.org/rfc/rfc1034)
- [RFC 1035：Domain Names - Implementation and Specification](https://www.rfc-editor.org/rfc/rfc1035)
- [RFC 2181：Clarifications to the DNS Specification](https://www.rfc-editor.org/rfc/rfc2181)
- [RFC 2606：Reserved Top Level DNS Names](https://www.rfc-editor.org/rfc/rfc2606)
- [RFC 5737：IPv4 Address Blocks Reserved for Documentation](https://www.rfc-editor.org/rfc/rfc5737)
- [RFC 5321：Simple Mail Transfer Protocol](https://www.rfc-editor.org/rfc/rfc5321)
- [RFC 7208：Sender Policy Framework (SPF)](https://www.rfc-editor.org/rfc/rfc7208)
- [RFC 6376：DomainKeys Identified Mail (DKIM) Signatures](https://www.rfc-editor.org/rfc/rfc6376)
- [RFC 9989：Domain-Based Message Authentication, Reporting, and Conformance (DMARC)](https://www.rfc-editor.org/rfc/rfc9989)
- [RFC 4033：DNS Security Introduction and Requirements](https://www.rfc-editor.org/rfc/rfc4033)

## 生成与检查说明

- 原图由 Codex 内置 `image_gen` 生成，统一视觉规范和最终提示词记录在 `PROMPTS.md`；本次将其中误写的 `Mail Exchanger` 同步修正为正确术语 `Mail Exchange`，没有编辑图片。
- 原图为 PNG 位图，尺寸为 `1086 × 1448`，比例为 `3:4` 竖版。
- `shorts.mp4` 由仓库自带生成器从原图生成；本次按规则重新生成后，文件内容与仓库原版本一致。
- 已逐项核对图片中的中英文术语、示例域名、示例地址、四类记录含义和 NS 迁移流程；文档补充了卡片篇幅未展开的 CNAME、MX、缓存和 DNSSEC 边界。
- 本目录按公开发布内容处理；文档仅使用保留示例域名、文档示例地址和明确占位符，未包含真实项目地址、账号、口令或内部服务信息。

## 仍需人工确认的风险

- 不同 DNS 服务商对根域别名、记录导入、代理/CDN、DNSSEC 和迁移工具的实现不同，正式操作前应以新旧服务商当前文档为准。
- TXT 记录的拆分、转义和长度展示方式因控制台而异，迁移邮件认证记录时应对比权威查询结果，而不是只比较控制台外观。
