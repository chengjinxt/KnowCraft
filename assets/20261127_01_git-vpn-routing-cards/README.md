# Git 拉取时，FlClash、OpenVPN 与安全网关怎么分工

## 白话结论

拉取代码时，FlClash、OpenVPN 和安全网关不会根据“这是哪个仓库”互相协商。它们处在不同层，各自依据不同信息做决定：

- Git 和应用先决定是否使用代理；
- FlClash 收到流量后，按域名、规则集、代理组和节点选择逻辑出口；
- Windows 再根据目标 IP（Internet Protocol，网际协议）和路由表选择物理网卡或 VPN 隧道；
- 安全网关若启用，可以在进程、数据和网络策略层检查或限制行为。

因此，“VPN 已连接”“FlClash 已打开”都不能单独证明某次 `git clone` 或 `git pull` 经过了它。应从 Git 远程地址开始，一层层核对代理、DNS（Domain Name System，域名系统）和路由。

## 卡片清单

1. `01-who-handles-git-traffic.png`：三层总览——应用代理、系统路由与安全控制。
2. `02-git-protocol-path.png`：SSH 与 HTTPS 远程地址为什么可能走不同路径。
3. `03-flclash-region-selection.png`：FlClash 如何通过规则、代理组和节点选择出口地区。
4. `04-proxy-vs-route.png`：转场说明——代理选逻辑出口，Windows 路由选实际网卡。
5. `05-openvpn-split-routing.png`：OpenVPN 分流、最长前缀和 Metric（跃点值）。
6. `06-dns-vs-data-path.png`：DNS 查询与真实数据连接为什么可能分开走。
7. `07-security-gateway-layer.png`：安全网关在进程、数据和网络策略层的作用。
8. `08-git-path-checklist.png`：从 Git 地址到 VPN 路由的五步排查清单。
9. `09-route-correct-still-timeout.png`：本机路由命中 OpenVPN，但 TCP 仍超时时如何判断阻断范围。
10. `10-lan-vs-vpn-localization.png`：内网成功、VPN 超时的对照实验如何定位服务端链路。

## 1. 先看 Git 使用什么传输方式

常见远程地址分为两类：

```text
SSH：   git@<Git主机>:<组织>/<仓库>.git
HTTPS： https://<Git主机>/<组织>/<仓库>.git
```

### SSH

SSH（Secure Shell，安全外壳协议）通常由 OpenSSH 建立连接。若没有配置 `ProxyCommand`、`ProxyJump`、自定义 `sshCommand`，也没有被 TUN（Tunnel，三层虚拟网卡模式）透明接管，它会把目标地址直接交给系统解析和路由。

### HTTPS

HTTPS（Hypertext Transfer Protocol Secure，超文本传输安全协议）由 Git 的 HTTP 传输层处理。是否使用代理，主要看：

- `http.proxy`；
- `http.<url>.proxy`；
- `remote.<name>.proxy`；
- `HTTP_PROXY`、`HTTPS_PROXY`、`ALL_PROXY` 等环境变量。

Windows 系统代理主要服务于主动读取 WinINET/系统代理设置的程序。命令行 Git 是否使用该代理，应以 Git 自己的配置和实际连接为准。认证过程中弹出的浏览器可能使用系统代理，但 Git 后续传输仍可能走另一条路径。

## 2. FlClash 管什么

FlClash 是应用代理工具。流量进入它之后，才会执行类似以下流程：

```text
目标域名或应用
    ↓
规则匹配
    ↓
代理组
    ↓
具体节点
    ↓
公开出口地区
```

系统代理和 TUN 的覆盖范围不同：

- 系统代理：只影响主动遵循系统代理设置的应用；
- TUN：创建三层虚拟网卡并配合路由、DNS 接管更多流量；
- DIRECT（直连）：规则命中后不使用代理节点，直接建立目标连接。

即使应用已经把流量交给 FlClash，FlClash 到代理节点的真实连接仍然要经过 Windows 路由表。因此在 Full Tunnel（全隧道）VPN 下，可能出现“代理套在 VPN 里面”的情况：

```text
应用 → FlClash → OpenVPN → 代理节点 → 目标服务
```

最终目标看到的公开出口通常由最后一个代理节点决定，但底层链路仍可能经过 VPN。

## 3. Windows 路由怎么选网卡

Windows 不认识“代码仓库”“香港节点”“办公系统”这些业务名称。它根据目标 IP 匹配路由：

```text
<企业网段>/24  → OpenVPN 隧道
0.0.0.0/0      → 默认网络
```

选择原则是：

1. 多条路由都匹配时，最长前缀优先；
2. 前缀长度相同时，再比较路由 Metric 与接口 Metric；
3. 总 Metric 更低的路径优先。

所以 `/24` 企业网段会优先于 `/0` 默认路由。只有当 VPN 下发 `redirect-gateway` 或等价的更具体默认路由时，大部分公网流量才会被改为走 VPN。

## 4. OpenVPN 的“不同地区”怎么选择

VPN（Virtual Private Network，虚拟专用网络）配置文件通常对应一个服务端入口。连接某个地区的 Profile（连接配置）只表示当前隧道连向该入口，不等于所有流量都会从该地区出去。

- 未连接的 Profile 不参与路由；
- Split Tunnel（分流隧道）只为指定网段安装路由；
- Full Tunnel（全隧道）会接管默认路由或大部分公网前缀；
- 多条 VPN 同时连接时，Windows 仍按前缀长度和 Metric 选择。

OpenVPN 服务端还可以向客户端推送路由、DNS、域名后缀和其他连接参数。因此 `.ovpn` 文件中没写某条路由，不代表连接后一定不会出现；应检查连接后的实际路由表。

## 5. DNS 与数据连接要分开看

典型流程是：

```text
域名
  ↓
DNS 查询（可能经 VPN DNS）
  ↓
得到目标 IP
  ↓
Windows 再查路由表
  ↓
真实连接可能从默认网络发出
```

因此“域名能够通过企业 DNS 解析”只证明解析路径可用，不能证明随后的 SSH 或 HTTPS 数据一定经过同一条 VPN。浏览器自带 DoH（DNS over HTTPS，基于 HTTPS 的 DNS）时，还可能绕过系统 DNS 设置。

## 6. 安全网关与 VPN 的区别

安全网关可能同时包含 VPN 接入和端点安全能力。SDP（Software-Defined Perimeter，软件定义边界）或类似端点组件可能工作在以下位置：

- 进程层：识别应用并执行进程策略；
- 数据层：限制复制、打印、上传或外传；
- 网络层：过滤、阻断或限制访问；
- 驱动层：通过网络过滤驱动、虚拟网卡或其他内核组件实施策略。

是否真正参与当前流量，不能只看安装目录是否存在。至少要核对：

- 相关服务是否运行；
- 驱动是否加载；
- 虚拟网卡是否启用；
- 是否安装了对应路由；
- 目标进程是否加载相关模块；
- 管理端策略是否实际下发。

不要手工删除驱动文件或安全软件目录。需要移除时应使用厂商卸载程序，并遵循组织安全要求。

## 7. 实际排查命令

### 查看远程地址

```bash
git remote -v
```

### 查看 Git 代理和 SSH 命令配置

```bash
git config --show-origin --get-regexp "^(http\..*\.proxy|http\.proxy|https\.proxy|remote\..*\.proxy|core\.sshCommand)$"
```

### 查看 SSH 最终配置

```powershell
ssh -G <Git主机> | Select-String '^(hostname|port|proxycommand|proxyjump)\s'
```

### 查看代理环境变量

```powershell
Get-ChildItem Env: | Where-Object Name -match '^(HTTP|HTTPS|ALL|NO)_PROXY$'
```

### 查看路由与目标选择

```powershell
route print -4
Resolve-DnsName <Git主机> -Type A
Find-NetRoute -RemoteIPAddress <解析出的IP>
```

### 查看网卡与 DNS

```powershell
Get-NetAdapter
Get-DnsClientServerAddress -AddressFamily IPv4
Get-DnsClientNrptPolicy -Effective
```

命令输出中可能包含内网 IP、域名、网关和接口名称。公开排错材料前必须脱敏。

## 8. 路由正确但连接仍超时，说明什么

`Find-NetRoute` 显示目标已经选择 VPN 接口，只能证明本机把数据包交给了隧道。它不能证明 VPN 服务端已将数据包转发到企业网，也不能证明目标服务器的回包能够返回 VPN 客户端。

如果 `Test-NetConnection <内网服务IP> -Port 22` 的 TCP（Transmission Control Protocol，传输控制协议）连接仍超时，排查重点应移到隧道之后：

- VPN 服务端是否拥有到 `<内网服务IP>` 的路由并启用转发；
- ACL（Access Control List，访问控制列表）或防火墙是否允许 `<VPN客户端地址池>` 访问目标端口；
- 目标服务器是否只允许企业局域网来源，而拒绝 VPN 地址池；
- 企业网络是否有返回 `<VPN客户端地址池>` 的路由，或是否按设计执行 NAT（Network Address Translation，网络地址转换）。

### 用对照实验缩小范围

| 测试来源 | 同一目标、同一端口 | 含义 |
| --- | --- | --- |
| `<内网测试机>` | 连接成功 | 目标主机和 SSH 服务基本正常 |
| `<VPN客户端>` | 连接超时 | 问题集中在 VPN 转发、访问控制、来源策略或回程链路 |

这个对照实验不能证明目标服务器绝对没有问题，但能排除“服务整体宕机”这一大类原因，并把排查范围缩小到来源相关策略和 VPN 中间链路。

### 在三个边界抓包

SYN（Synchronize，同步序列号，用于发起 TCP 建连）与同时设置 SYN、ACK（Acknowledgment，确认）标志的返回包，可以帮助判断数据包丢在哪个边界：

1. VPN 隧道入口收到 SYN，但企业网接口没有发出：检查 VPN 服务端路由、转发和 ACL。
2. 企业网接口发出 SYN，但目标没有返回 SYN-ACK：检查目标防火墙、来源限制和回程路由。
3. VPN 服务端收到 SYN-ACK，但客户端没有收到：检查隧道回程转发、NAT 和 ACL。

可以将以下脱敏信息交给 VPN 或网络管理员：

```text
VPN 客户端访问 <内网服务IP>:22 时，本机路由已命中 VPN 隧道，但 TCP 连接超时；
<内网测试机> 访问同一目标和端口成功。
请检查 VPN 服务端路由、转发、ACL、目标来源策略和返回 <VPN客户端地址池> 的路由。
```

## 9. 常见误解

### “VPN 已连接，所以 Git 一定走 VPN”

不一定。Split Tunnel 只接管指定网段，公网 Git 主机可能仍走默认网络。

### “系统代理开启，所以所有命令行都走 FlClash”

不一定。命令行程序是否读取系统代理取决于实现和配置；Git 和 SSH 应分别检查自己的代理设置。

### “连接了某地区 OpenVPN，所以出口就是该地区”

不一定。只有匹配该隧道路由的流量才会进入 VPN；分流模式下，普通公网流量可能完全不经过它。

### “DNS 经 VPN，数据也一定经 VPN”

不一定。DNS 解析完成后，真实连接仍要重新查 Windows 路由表。

### “安全网关目录还在，所以它一定正在拦截”

不一定。目录残留、服务运行、驱动加载、虚拟网卡启用和策略生效是不同状态，需要分别验证。

## 适用边界

- 本文适用于 Windows 上的 Git、FlClash、OpenVPN 与端点安全工具的通用分层判断。
- IPv4 与 IPv6 有独立路由表，本文卡片中的 `0.0.0.0/0` 仅表示 IPv4 默认路由。
- 浏览器、IDE、Git GUI、子系统、容器和虚拟机可能使用独立代理或网络栈。
- 不同 FlClash、OpenVPN 和安全网关版本的开关名称、虚拟网卡与驱动实现可能不同。
- 企业安全策略有合规要求时，不应通过禁用驱动、绕过注入或修改路由来规避控制。

## 参考资料

- Microsoft Learn：[Metric：最长前缀与同前缀 Metric 规则](https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-tcpip-interfaces-interface-routes-route-metric)
- Microsoft Learn：[Configure the Order of Network Interfaces](https://learn.microsoft.com/en-us/windows-server/networking/technologies/network-subsystem/net-sub-interface-metric)
- Git：[git-config Documentation](https://git-scm.com/docs/git-config)
- OpenSSH：[ssh_config(5)](https://man.openbsd.org/ssh_config)
- OpenVPN：[OpenVPN 2.6 Manual](https://openvpn.net/community-docs/community-articles/openvpn-2-6-manual/)
- OpenVPN：[VPN Settings Overview](https://openvpn.net/as-docs/vpn-settings-overview/)
- FlClash：[官方项目仓库](https://github.com/chen08209/FlClash)

## 生成与检查说明

- 生成日期：2026-11-27。
- 更新日期：2026-11-28，新增“路由正确仍超时”和“内网成功、VPN 超时”两张卡片。
- 生成方式：Codex 内置 ImageGen。第 1 张直接生成并进行一次释义括号定向修订；第 2 至 10 张仅把第 1 张最终成品作为视觉风格参考。
- 保存目录：`assets/20261127_01_git-vpn-routing-cards/`。
- 视觉规范：3:4 竖版、浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标。
- 脱敏策略：所有企业网段、域名、仓库、节点、账户与本机路径均改为通用描述或 `<企业网段>`、`<Git主机>` 等占位符。
- 图片检查：逐张核对中文、英文大小写、命令、点号、斜杠、尖括号和流程含义；中英文释义括号由生成器统一采用半角视觉样式，不影响术语含义。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 视频检查：单个 H.264 视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长 40 秒，与 10 张卡片每张 4 秒一致。
- 残余风险：实际流量路径受 Git 版本、远程协议、FlClash 模式、OpenVPN 服务端推送、IPv6、DNS 策略和端点安全产品实现影响；“内网成功、VPN 超时”只能缩小范围，最终仍应以 VPN 服务端、企业网出口和目标主机三个边界的抓包与日志为准。
