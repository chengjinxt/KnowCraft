# DNS 四类记录与迁移

`DNS (Domain Name System，域名系统)` 像互联网通讯录。

- `A (Address，地址记录)`：把域名指向 `IPv4 (Internet Protocol version 4，互联网协议第 4 版)` 地址。
- `CNAME (Canonical Name，规范名称/别名记录)`：主机名指向另一主机名。
- `MX (Mail Exchange，邮件交换记录)`：指定收信服务器；数字越小越优先。
- `TXT (Text，文本记录)`：常用于域名验证、`SPF (Sender Policy Framework，发件人策略框架)`、`DKIM (DomainKeys Identified Mail，域名密钥识别邮件)`、`DMARC (Domain-based Message Authentication, Reporting, and Conformance，基于域名的邮件认证、报告与一致性)`。

更换 `NS (Name Server，名称服务器)`，就是切换权威答复者。先盘点并复制旧记录，核对名称、类型、值和优先级，再更换 `NS`；随后验证网站、接口、收发信和认证。自动扫描只能辅助，别漏掉子域名与自定义记录。
