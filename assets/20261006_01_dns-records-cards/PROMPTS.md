# DNS records card prompt

## Generation method

- Built-in `image_gen`
- Use case: `infographic-diagram`
- Canvas: 3:4 portrait

## Final prompt

Create an original Chinese social-media knowledge card for mobile reading. Explain `DNS (Domain Name System，域名系统)` through four common record types: `A (Address，地址记录)`, `CNAME (Canonical Name，规范名称/别名记录)`, `MX (Mail Exchanger，邮件交换记录)`, and `TXT (Text，文本记录)`.

Use a light warm background, high-contrast dark-blue headings, teal and orange accents, rounded information blocks, and a few clear flat-vector icons. Arrange the four record types in a 2×2 grid. For each record, show what it maps, what it controls, and one short example. Use only `.test` placeholder hostnames and documentation IPv4 address `192.0.2.10`; do not show any real business domain, vendor brand, logo, QR code, or watermark.

Required explanations:

- `A`: domain name to IPv4 address; lets a website or API find its server.
- `CNAME`: one hostname to another hostname; useful when a subdomain follows a cloud-service target and the target IP may change.
- `MX`: domain to receiving mail server, with priority; missing or incorrect records may stop incoming mail.
- `TXT`: publishes text that DNS can return; commonly used for domain verification and `SPF / DKIM / DMARC` email authentication.

Add a lower section titled “为什么换托管商前必须迁移完整？”. Explain that changing `NS (Name Server，名称服务器)` changes the authoritative answerer. Show the flow “盘点旧记录 → 复制并人工核对 → 更换 NS → 验证网站、邮件与认证”. State that automatic scans are only an aid and may miss custom records. End with the large conclusion “先搬记录，再换 NS”.

Keep all English capitalization, punctuation, arrows, numbers, and technical relationships accurate. Use large typography and short lines; avoid dense paragraphs and tiny footnotes.

## Technical references

- [RFC 1035: Domain Names - Implementation and Specification](https://datatracker.ietf.org/doc/rfc1035/)
- [Cloudflare DNS records quick scan](https://developers.cloudflare.com/dns/zone-setups/reference/dns-quick-scan/)
- [Cloudflare full setup](https://developers.cloudflare.com/dns/zone-setups/full-setup/setup/)
