# SSL证书验证与Nginx部署

证书卡在"验证中"，是在等 CA（Certificate Authority，证书颁发机构）确认 DNS 验证记录：DV（Domain Validation，域名验证）证书要求添加主机名形如 `_dnsauth` 的 TXT 记录，查不到就等待。

更换 DNS 服务商后，NS（Name Server，域名服务器）指向新平台，公网以权威 NS 为准，旧记录不再生效，须照原值重建。

验证卡住先多路查公共 DNS，再直查权威 NS；全网生效仍卡住，问题在审核侧，催审或重新申请。改记录前确认 token 未换新。

证书按服务器选：Nginx 用 pem + key，Apache 用 crt + key，Tomcat 用 jks 或 pfx，IIS 用 pfx。key 是私钥，勿外传。

Nginx 静态站最小配置：`listen 443 ssl;` 加证书、私钥两行，`root` 指向静态目录，`index index.html;`，80 端口 301 跳 HTTPS；纯静态站不用 proxy_pass。

高频报错：`No such file or directory` 是路径写错；`Access is denied` 需管理员运行；`nginx.pid` 找不到说明服务未运行。`nginx -t` 出现 `test is successful` 才算通过。
