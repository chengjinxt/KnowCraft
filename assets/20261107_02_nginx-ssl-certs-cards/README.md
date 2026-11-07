# SSL 证书验证与 Nginx 部署

## 白话结论

申请免费 SSL（Secure Sockets Layer，安全套接层，泛指 TLS 证书）证书时卡在"验证中"，不是域名解析坏了，就是 CA 在等一条 DNS 记录。把验证记录放到当前权威 DNS 服务商处并确认全网可查，验证就能通过；证书签发后，下载对应服务器格式的文件，在 Nginx 里配两行证书指令就能上线 HTTPS（Hypertext Transfer Protocol Secure，安全超文本传输协议）。

## 证书"验证中"在等什么

- DV（Domain Validation，域名验证）证书只验证"你能否控制这个域名"，不验证企业主体。
- CA（Certificate Authority，证书颁发机构）会反复查询域名的 DNS 验证记录，通常是主机名 `_dnsauth` 下的 TXT（Text Record，文本记录）。
- 记录值是一串一次性 token（令牌）；CA 查到且匹配后自动签发，状态变为"已签发"。
- 常见误区：以为提交申请后不用管。实际上记录不存在时 CA 会一直等待，部分平台超过时限（如 3 天）会自动取消订单。

## 换 DNS 服务商为什么验证会卡住

- NS（Name Server，域名服务器）决定"谁来回答这个域名的查询"，公网递归解析以权威 NS 的答案为准。
- NS 切换到新服务商后，旧平台上的记录不再对公网生效，即使旧平台界面里还能看到它们。
- 正确做法：在新服务商按原主机名、原记录值逐字重建 TXT 验证记录；只删除旧记录或只在新平台改其他记录都不够。
- 通用规则：NS 在谁家，验证记录、解析记录都必须维护在谁家。

## 验证卡住的定位方法

按顺序排查，先确认记录侧，再怀疑审核侧：

1. 用多个公共解析器（如 `8.8.8.8`、`1.1.1.1`、`119.29.29.29`、`114.114.114.114`）查询验证记录主机名，多个结果应一致。
2. 直接向权威 NS 发起查询，确认源头上记录存在。
3. 记录全网生效但状态仍停留在"验证中"，问题在审核侧：使用平台提供的催审入口，或等超时后取消并重新申请。
4. 修改记录前先核对平台详情页当前显示的 token；部分操作会让 token 重新生成，旧值立即失效。
5. 验证弹窗中的 CAA（Certificate Authority Authorization，证书颁发机构授权）检测显示"正常"，说明签发权限没有被域名侧拦截。

## 证书下载格式与服务器对应关系

| 服务器类型 | 证书文件 |
|---|---|
| Nginx（适用大部分场景） | pem + key |
| Apache | crt + key |
| Tomcat | jks 或 pfx |
| IIS | pfx |

- pem（Privacy-Enhanced Mail，文本编码证书格式）与 crt 内容相同，二选一。
- Nginx 版下载通常包含证书链文件（bundle）和私钥文件两个文件。
- key（私钥文件）只保存在服务器上，不进代码仓库、不进聊天窗口；泄露应立即吊销重签。

## Nginx 静态站 HTTPS 最小配置

```nginx
server {
    listen       443 ssl;
    server_name  <站点域名>;
    ssl_certificate      <证书文件>;
    ssl_certificate_key  <私钥文件>;
    root   <静态目录>;
    index  index.html;
}
```

- 纯静态站不需要 `proxy_pass`；只有反代后端服务时才需要 `proxy_set_header` 系列指令。
- 常见的反代头：`Host`（原始域名）、`X-Real-IP` / `X-Forwarded-For`（真实 IP）、`X-Forwarded-Proto`（原始协议为 https）。缺这些头时，后端看到的是 `127.0.0.1`，限流、日志定位和链接生成都会出问题。
- 80 端口保留一个 server 块做 `301` 跳转到 HTTPS。
- 静态站与后端服务分属不同服务器时，互不影响；API 流量走独立子域名即可。

## Windows 服务器上的高频报错

| 报错片段 | 原因 | 解法 |
|---|---|---|
| `No such file or directory` | 证书或配置引用的文件路径写错 | 逐字核对路径；注意安装目录可能多套一层 |
| `logs ... Access is denied` | 当前 cmd 权限不足，写不了日志 | 右键"以管理员身份运行"再执行 |
| `nginx.pid 找不到` | 服务未运行就执行了停止命令 | 无害，忽略；先 `start nginx` |
| `bind() ... failed` | 80/443 被其他服务占用 | 先让出端口或改监听 |

操作顺序：`nginx -t` 测试 → `start nginx` 启动 → `nginx -s reload` 重载。`nginx -t` 输出 `test is successful` 才算配置通过。

## 安全与维护提醒

- 防火墙与云安全组都要放行 443 端口。
- 证书签发后可删除 DNS 验证记录，保持解析列表干净。
- 私钥文件的存放目录不要放在 Web 可访问路径下。
- 提前规划续期：免费证书有效期通常一年，到期前重新申请即可，旧证书在有效期内不受影响。

## 版本与适用边界

- 本卡片整理于 2026-11-07，流程以主流云平台的免费 DV 证书与 Nginx 1.2x 为准，不同平台菜单文字略有差异。
- 具体验证记录主机名与值以证书详情页实时显示为准，不要沿用历史截图。
- 免费证书不支持通配符与多域名自由组合；多域名需求按平台规则申请。

## 参考资料

- MDN：[HTTP over TLS](https://developer.mozilla.org/en-US/docs/Glossary/HTTPS)
- Let's Encrypt：[DNS 验证说明](https://letsencrypt.org/docs/)
- Nginx 官方：[ssl_module 文档](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)
- RFC 8659：CAA 记录规范

## 图片清单

1. `01-dv-validation-flow.png`：证书"验证中"的等待机制。
2. `02-dns-provider-migration.png`：更换 DNS 服务商后记录要重建。
3. `03-validation-stuck-triage.png`：验证卡住的三步定位法。
4. `04-cert-download-formats.png`：证书下载格式与服务器对照。
5. `05-nginx-static-https-config.png`：Nginx 静态站 HTTPS 最小配置。
6. `06-nginx-common-errors.png`：Nginx 高频报错与解法。

## 生成与检查说明

- 生成方式：WorkBuddy 内置 `ImageGen`，以 `assets/20261107_01_charles-https-rewrite-cards/01-three-prerequisites.png` 作为视觉风格参考，逐张生成 6 张原创卡片。
- 保存目录：`assets/20261107_02_nginx-ssl-certs-cards/`。
- 画布：生成尺寸 1024×1536，统一两侧扩展至 1152×1536（精确 3:4），留白逐行复制内容边缘色。
- 脱敏策略：不出现真实域名、IP、账号、token 值、证书指纹或本机绝对路径；配置示例统一使用 `<证书文件>`、`<私钥文件>`、`<静态目录>` 占位符。
- 图片检查：6 张均为 1152×1536 精确 3:4；逐张核对 DV、CA、TXT、`_dnsauth`、NS、PEM、pem + key、`ssl_certificate`、`index.html`、`test is successful` 等英文与代码拼写；已清理生成图右下角水印与提示词泄漏文字；第 2 张条带右下角经几何重绘修复。
- 正文检查：`Content.md` 一级标题 15 个可见字符，正文按去除 Markdown 标记后口径计算 500 个可见字符，符合 500 字上限。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 技术风险：不同云平台的验证记录主机名和审核时限可能不同；证书续期规则以平台当前文档为准；`nginx.pid` 类报错的提示文字因版本而异。
