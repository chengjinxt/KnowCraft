# 路由器跨网段访问与 OpenClash 分流知识卡片

这组卡片面向有基础电脑使用经验、但不熟悉路由表、防火墙、OpenClash 规则和 SMB 共享细节的中文读者。内容来自一次家庭网络排障：A 路由器网段、B 路由器网段、Mihomo/OpenClash 分流、静态路由、端口转发和 Windows 共享访问。

所有 IP 地址均为示例地址；没有使用真实 MAC 地址、SSID、账号、订阅链接、设备序列号或真实共享名。

## 卡片顺序

1. `01-router-modes.png`：解释 B 路由器的路由模式、AP/桥接模式、中继/Mesh/旁路由的区别，以及 Mihomo 与默认网关的关系。
2. `02-openclash-direct-rules.png`：区分 `IP-CIDR` 和 `SRC-IP-CIDR`，说明 OpenClash 直连规则只负责“不走代理”，不负责打通防火墙。
3. `03-route-type-unicast.png`：解释静态路由里 `unicast`、`local`、`broadcast`、`multicast`、`unreachable`、`prohibit`、`blackhole`、`anycast`、`throw` 的区别，强调家用静态路由通常选 `unicast`。
4. `04-cidr-192-168-2-0-24.png`：解释 `CIDR (Classless Inter-Domain Routing，无类别域间路由)`，以及 `192.168.2.0/24`、`/32`、`0.0.0.0/0` 的含义。
5. `05-static-route-three-gates.png`：说明静态路由只解决“往哪走”，跨网段访问还要经过 B 路由器防火墙和目标电脑防火墙。
6. `06-port-forwarding-smb-445.png`：解释 `3389` 通但 `445` 不通时，端口转发、SMB 和 Windows 共享路径的限制。

## 核心结论

- B 保持路由模式时，B 会建立自己的 LAN (Local Area Network，局域网)，例如 `192.168.2.0/24`；B 下设备默认网关通常是 B。
- AP (Access Point，无线接入点) / 桥接模式会让 B 更像无线交换机，下级设备通常进入 A 的网段，互访更简单，但 B 不再适合单独接管下级流量。
- OpenClash/Mihomo 规则里的 `IP-CIDR` 是目的地址规则，`SRC-IP-CIDR` 是来源地址规则；它们影响是否走代理，不等于修改路由器防火墙。
- A 路由器的静态路由 `192.168.2.0/24 → 192.168.100.2` 只表示“去 B 网段找 B 的 WAN 地址”。B 是否允许从 WAN 进入 LAN，是另一道防火墙规则。
- Windows 共享使用 SMB (Server Message Block，服务器消息块协议)，常见端口是 `TCP 445`。资源管理器里的 UNC 路径不能像 HTTP 那样写 `\\192.168.100.2:1445\` 来指定 SMB 端口。

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen` 生成无文字网络主题底图；随后使用本地确定性文字排版生成最终 PNG，确保中文、英文缩写、IP 地址、CIDR、规则行和反斜杠不被图片模型误写。
- 版式：`3:4` 竖版、浅色不透明背景、高对比标题、圆角信息块和少量网络图标。
- 已检查：标题、`OpenClash`、`Mihomo`、`IP-CIDR`、`SRC-IP-CIDR`、`192.168.2.0/24`、`192.168.100.2`、`TCP 445`、`\\192.168.100.2:1445\` 等关键文本。
- 剩余人工确认点：不同路由器固件对 WAN 管理、WAN 到 LAN 放行、端口转发、SMB `445` 过滤、OpenClash 访问控制入口的支持差异很大，实际设置仍应以设备后台和固件文档为准。
