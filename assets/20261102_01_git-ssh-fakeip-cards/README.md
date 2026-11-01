# Git SSH、Fake-IP 与 443 排障

这套卡片整理一次典型故障：`git pull --rebase` 通过 SSH 连接 GitHub 时，在 `port 22` 收到 `Connection closed`；详细日志表明连接在身份认证前中断。通过 Windows、OpenWrt、OpenClash 和 MetaCubeXD 的交叉检查，最终确认 Fake-IP 映射、TUN 接管和规则匹配都正常，问题集中在代理节点或上游对 `TCP (Transmission Control Protocol，传输控制协议) 22` 的限制。把 SSH 别名改为 GitHub 官方的 `ssh.github.com:443` 后，仍经原代理链完成认证与拉取。

## 一、先判断失败发生在哪一层

Git 的结尾提示：

```text
fatal: Could not read from remote repository.
```

只是通用结果，不能单独证明仓库不存在、账号无权限或私钥失效。关键证据来自：

```powershell
ssh -vvv -T git@<GitHub别名>
```

若日志顺序为：

```text
Connection established.
Local version string SSH-2.0-...
kex_exchange_identification: Connection closed by remote host
```

说明本地已建立 TCP 连接并发出客户端 SSH 标识，但没有收到服务端 SSH 标识，流程还没进入公钥认证。此时应先查端口、路由、代理出口和中间防火墙；若真正进入密钥认证，通常会继续出现算法协商、主机密钥、公钥尝试或 `Permission denied (publickey)` 等信息。

## 二、Fake-IP 是什么

`DNS (Domain Name System，域名系统)` 通常把域名解析成真实地址。Mihomo 的 Fake-IP 模式会先从保留地址池分配一个内部代号，例如：

```text
github.com → 198.18.x.x（示例 Fake-IP）
```

客户端随后连接这个示例地址。OpenClash 在 TUN 或透明代理入口截获连接，通过内部映射表还原出 `github.com`，再按域名规则选择 `DIRECT` 或代理节点。它的实际价值是：

- 让连接阶段仍保留原始域名，便于按域名规则匹配。
- 把真实 DNS 查询交给代理侧处理，减少本地 DNS 污染与路径不一致。
- 让只会“解析后连 IP”的应用也能进入统一的规则引擎。

`198.18.0.0/15` 是用于网络设备基准测试的保留网段，不应被理解为 GitHub 的真实公网地址。不同的 FlClash、OpenClash 或 Mihomo 实例可以各自使用相同的默认地址池，它们不是在共享同一份缓存。

## 三、为什么 FlClash 退出后仍有 Fake-IP

排查时要区分“本机代理”和“网关透明代理”。以下现象可以排除 Windows 本机残留：

- FlClash 主程序和核心已退出。
- 没有本地 TUN 网卡或指向 `198.18.*` 的专用路由。
- 本地代理端口没有监听。
- Windows DNS 缓存中没有目标域名。

若下面的查询仍由网关返回 Fake-IP：

```powershell
nslookup github.com <网关IP>
```

而且向外部明文 DNS 服务器发出的查询也得到同样结果，就说明 OpenWrt 网关仍在进行 DNS 劫持和 Fake-IP 分配。电脑上的 FlClash 是否运行，不会关闭路由器上的 OpenClash。

## 四、“DNS 代理：停用”不等于 DNS 已关闭

OpenClash 首页的“DNS 代理”开关在当前界面中实际控制 `respect-rules（DNS 查询是否遵循代理规则）`。停用它表示上游 DNS 查询不一定跟随业务流量的代理规则，并不等于：

- 关闭 Mihomo DNS 服务。
- 关闭 Fake-IP 模式。
- 关闭 DNS 劫持。
- 关闭 TUN 对连接的透明接管。

判断实际状态时，要看字段与运行模式，不能只凭界面按钮名称推断。

## 五、如何读 MetaCubeXD 连接记录

一次完整链路可以概括为：

```text
电脑 → OpenClash TUN → Fake-IP 映射 → Rule / Match
     → 代理节点 → GitHub
```

连接记录重点看三组信息：

1. `主机 / 端口`：若显示 `github.com:22`，说明 Fake-IP 已成功还原为域名。
2. `规则 / 链路`：例如命中 `Match`，并显示代理组和最终节点，说明它不是直连。
3. `流向 / 流量`：同一代理节点地址可以同时承载多个目标域名；右侧地址不应直接当作 GitHub 的真实地址。

## 六、同节点对照为何能定位端口限制

对照实验保持代理规则和最终节点不变，只改变目标端口：

| 连接 | 结果 | 能说明什么 |
| --- | --- | --- |
| `github.com:22` | 在服务端 SSH 标识前关闭 | 22 路径失败 |
| `ssh.github.com:443` | 有双向流量并完成 SSH 握手 | Fake-IP、TUN、规则和代理链可用 |
| 普通 HTTPS 443 | 有正常双向流量 | 节点本身在线，443 可传输 |

变量只剩目标端口后，最可能是当前节点、机场策略、出口网络或中间防火墙限制 TCP 22。也应检查 OpenClash 是否启用了“仅代理常用端口”或存在 `DST-PORT,22` 规则。

## 七、系统代理与 TUN 的边界

`System Proxy（系统代理）` 依赖应用主动读取代理设置。Windows OpenSSH 默认不会因为系统代理开关打开，就自动把 SSH 流量交给该代理；若必须使用显式 HTTP/SOCKS 代理，需要另配 `ProxyCommand` 等机制。

`TUN（网络层虚拟隧道接口）` 在网络层透明接管 IP 流量，SSH 客户端不需要理解代理协议。路由器上的 OpenClash TUN 与 Windows 上的 FlClash 是两个独立入口，所以即使 FlClash 退出，路由器仍可继续接管电脑流量。

## 八、清理 Fake-IP 缓存能解决什么

OpenClash 的“清理 DNS 缓存”会调用 Mihomo 接口清理 Fake-IP 池和 DNS 缓存：

```text
POST /cache/fakeip/flush
POST /cache/dns/flush
```

它适合处理映射表异常或 DNS 缓存过期。若 Fake-IP 模式仍开启，下一次查询会重新分配一个 `198.18.x.x`，甚至可能再次得到同一地址。清缓存不会修改代理规则、切换节点，也不会打开被节点或上游限制的端口。

路由器清理后，可再清 Windows DNS 缓存：

```powershell
Clear-DnsClientCache
```

或：

```cmd
ipconfig /flushdns
```

## 九、使用 GitHub 官方 SSH 443 入口

在 `~/.ssh/config` 中保留原私钥配置，只调整目标主机和端口：

```sshconfig
Host github-work
    HostName ssh.github.com
    Port 443
    User git
    IdentityFile <保留原来的私钥路径>
```

验证：

```powershell
ssh -T git@github-work
git pull --rebase
```

仓库远程地址若原本使用同一 SSH 别名，可以保持不变。`ssh.github.com:443` 是 GitHub.com 官方提供的 SSH over HTTPS port 入口。改用 443 只改变目标端口；在 OpenClash 的 TUN 与规则模式下，它仍可能经过原代理链，并不自动等于直连。

首次连接新主机名时，SSH 可能要求写入 `known_hosts`。应先与 GitHub 官方公布的 SSH 主机密钥指纹核对，再确认连接，不能仅凭“端口是 443”放松主机身份验证。

## 十、建议的最短排查顺序

1. 用 `ssh -vvv` 判断是否进入公钥认证。
2. 用 `Resolve-DnsName` 或 `nslookup` 判断 Fake-IP 是本机还是网关返回。
3. 检查本机代理端口、TUN 网卡、路由和 DNS 缓存。
4. 在 MetaCubeXD 查看主机、端口、规则、链路和流量。
5. 保持节点不变，对照 22 与 443。
6. 切换节点复测，区分单节点限制与统一策略。
7. 必要时改用 GitHub 官方 `ssh.github.com:443`。

`Test-NetConnection <Fake-IP> -Port 22` 成功，只能说明连接到达了透明代理入口，不能证明已经到达 GitHub SSH 服务端。

## 卡片清单

1. `01-failure-layer.png`：先判断失败是否发生在身份认证前。
2. `02-fake-ip-principle.png`：Fake-IP 的分配、还原与域名规则。
3. `03-gateway-source.png`：FlClash 退出后从网关继续获得 Fake-IP。
4. `04-dns-proxy-toggle.png`：`respect-rules` 开关的真实边界。
5. `05-proxy-chain.png`：MetaCubeXD 中的完整代理链。
6. `06-ssh-log-layer.png`：从 SSH 日志判断失败层级。
7. `07-system-proxy-vs-tun.png`：系统代理与 TUN 的区别。
8. `08-port-comparison.png`：同节点 22 与 443 对照实验。
9. `09-cache-boundary.png`：清缓存能做什么、不能做什么。
10. `10-ssh-443-fix.png`：SSH 443 配置、验证和安全提醒。
11. `shorts.mp4`：按 01～10 自然顺序播放的 9:16 Shorts 视频。

## 生成方式与检查结果

- 10 张图片由 Codex 内置 `imagegen` 生成，采用原创 3:4 中文技术信息图；用户截图只用于诊断，没有作为生成输入。
- 所有真实用户名、仓库路径、远程地址、节点名称、订阅信息和局域网地址均已移除，统一使用公开示例或 `<占位符>`。
- 第 5 张初稿把控制面板写成 `Metacubexd`，已定向修订为正确大小写 `MetaCubeXD`。
- 第 10 张初稿出现 GitHub 猫形标识，已定向替换为原创通用代码仓库图标；其他文字和布局保持不变。
- 已逐张检查 `Fake-IP`、`OpenClash`、`FlClash`、`respect-rules`、`MetaCubeXD`、`SSH`、`TUN`、`TCP`、`HostName ssh.github.com`、`Port 443`、`IdentityFile`、`ssh -T` 与 `git pull --rebase`。
- 所有图片为 1086×1448，保持 3:4 比例。
- `shorts.mp4` 由仓库自带 `card-video-generator` 生成，每张停留 4 秒，共 40 秒；完整保留卡片并用同图模糊背景填充 9:16 画布。
- `ffprobe` 验证结果：仅一个 H.264 视频流，1080×1920、30 fps、`yuv420p`、BT.709、`color_range=tv`，无音频流。

## 参考资料

- [GitHub Docs：Using SSH over the HTTPS port](https://docs.github.com/en/authentication/troubleshooting-ssh/using-ssh-over-the-https-port)
- [GitHub Docs：SSH key fingerprints](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)
- [Mihomo Docs：DNS configuration](https://wiki.metacubex.one/config/dns/)
- [Mihomo API：清理 Fake-IP 与 DNS 缓存](https://github.com/MetaCubeX/Meta-Docs/blob/main/docs/api/index.md)
- [OpenClash：状态页中 DNS Proxy / respect-rules 的实现](https://github.com/vernesong/OpenClash/blob/master/luci-app-openclash/luasrc/view/openclash/status.htm)
- [OpenClash：清理缓存接口实现](https://github.com/vernesong/OpenClash/blob/master/luci-app-openclash/luasrc/controller/openclash.lua)
- [RFC 2544：198.18.0.0/15 基准测试保留网段](https://datatracker.ietf.org/doc/html/rfc2544)
- [OpenBSD manual：ssh_config 与 ProxyCommand](https://man.openbsd.org/ssh_config)
- [Microsoft Learn：Clear-DnsClientCache](https://learn.microsoft.com/powershell/module/dnsclient/clear-dnsclientcache)

## 仍需人工确认的技术风险

- 不同 OpenClash 版本的界面文案和菜单位置可能变化，应以实际字段与当前配置为准。
- 代理服务商是否限制 TCP 22 属于外部策略，只能通过换节点、查看连接日志或咨询服务商确认。
- `ssh.github.com:443` 适用于 GitHub.com；私有 GitHub Enterprise Server 或其他 Git 托管平台不能直接套用。
- 首次连接必须人工核对官方主机密钥指纹；卡片不会替用户完成信任决策。
