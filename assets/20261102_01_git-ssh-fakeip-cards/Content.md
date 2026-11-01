# Git SSH 代理排障

## 1 先看失败层级
认证前出现 `Connection closed`，先查端口、路由和代理。

## 2 理解 Fake-IP
`DNS (Domain Name System，域名系统)` 返回示例 Fake-IP，Mihomo 连接时再还原域名。

## 3 找到真正网关
FlClash 退出后仍有 Fake-IP，可能是 OpenWrt 网关仍在劫持 DNS。

## 4 别误读开关
“DNS 代理：停用”只控制 `respect-rules`，不等于关闭 Fake-IP 或 TUN。

## 5 看懂连接记录
MetaCubeXD 显示 `github.com:22`，说明域名已还原；再看规则与链路。

## 6 用日志定位
未收到服务端 SSH 标识，就还没进入密钥认证。

## 7 区分代理方式
系统代理要由应用主动读取；TUN 透明接管网络流量。

## 8 做端口对照
同一代理链上 443 通而 22 断，优先怀疑节点或上游限制 `TCP 22`。

## 9 明白缓存边界
清缓存会重建映射；Fake-IP 模式仍开就会再次生成，不能解除端口限制。

## 10 改走官方 443
把 `HostName` 改为 `ssh.github.com`、`Port` 改为 `443`，保留原私钥；改端口不等于直连。
