# Charles抓HTTPS与改写

Charles 要看到 HTTPS 正文，三项必须同时成立：应用流量经过 Charles 代理；目标主机启用 SSL Proxying（HTTPS 解密代理）；客户端信任 Charles Root Certificate（根证书）。Windows 应把证书导入 Trusted Root Certification Authorities（受信任的根证书颁发机构），安装后重启目标应用并建立新连接。

改写响应时，在 `Tools > Rewrite` 中只匹配 `<目标域名>:443` 和 `<目标接口路径>`；规则选择 `Body`、`Response`，关闭 `Regex`，按原始响应逐字匹配。示例把 `"quotaMiB":5120` 替换为 `"quotaMiB":10240`。

验证时必须触发新请求，再查看 `Response > Raw / Text`；旧记录不会倒改。没有请求通常是应用未走代理，只有 `CONNECT` 多半是未启用 SSL Proxying，证书错误说明信任或重启未完成。仅调试自有或已授权系统，结束后关闭 Rewrite 并删除不再需要的根证书。
