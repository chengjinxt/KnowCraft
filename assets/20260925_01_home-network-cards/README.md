# 家庭网络设备连接

这组卡片面向有基础电脑使用经验、但不熟悉家庭网络术语的中文读者，解释光猫、路由器、IP 地址、路由跳数、ARP、路由器 VPN 与 FlClash 的区别，以及两个路由器下的终端如何互访。

所有设备名称、IP 地址和 MAC 地址均为抽象或合成示例。卡片没有使用对话中出现的真实品牌、型号、SSID、BSSID、MAC 地址、账号或订阅信息。

## 卡片顺序

1. `01-modem-router-gateway.png`：光猫、路由器和二合一智能网关分别负责什么。
2. `02-identify-device-by-ports.png`：结合 `PON / OPTICAL`、`WAN`、`LAN`、实际进线和工作模式判断设备角色。
3. `03-ip-address-roles.png`：区分本机 IPv4、默认网关、DHCP、DNS 和设备管理地址。
4. `04-multi-hop-topology.png`：解释手机热点、二级路由、多网段和 Double NAT（双重网络地址转换）。
5. `05-diagnose-home-network.png`：用 `ipconfig`、`netsh`、`tracert` 和 `curl` 画出家庭网络路径。
6. `06-read-arp-table.png`：解释 `arp -a` 的动态/静态条目，以及为什么 ARP 表看不到隔着路由器的光猫。
7. `07-vpn-vs-flclash.png`：说明传统 VPN 表单为什么不能直接接收 FlClash 订阅，以及 OpenClash/Mihomo 的适用位置。
8. `08-cross-subnet-access.png`：解释两个路由器分别管理不同网段时，为什么终端默认不能直接互访，以及 AP/桥接、静态路由、端口转发三种解决方向。

## 一条主线理解家庭网络

光猫首先处理运营商侧的光信号；路由器把家庭局域网接到上级网络，并常常提供 DHCP、NAT 和 Wi-Fi。运营商智能网关可能把两种角色合并到同一台设备，所以不能仅凭“能发 Wi-Fi、能插网线”判断。

判断设备角色时，应同时看三类信息：

1. 实际进线：光纤还是普通网线。
2. 接口标签：`PON / OPTICAL`、`WAN`、`LAN`、`POWER`。
3. 当前模式：路由、AP（Access Point，无线接入点）、中继或 Mesh。

## IP 地址各自代表什么

- IPv4 地址表示当前终端在该网段中的地址。
- Default Gateway（默认网关）是数据离开当前网段时的第一站。
- DHCP (Dynamic Host Configuration Protocol，动态主机配置协议) 自动下发 IP、掩码、网关和 DNS 等参数。
- DNS (Domain Name System，域名系统) 负责域名解析；它可以由路由器代理，也可以是其他服务器。
- 管理地址用于打开设备后台，常与网关相同，但不是从本机 IP 自动推导出来的。

卡片使用 `192.168.0.0/16` 中的私有示例网段。`192.0.2.53` 属于文档示例网段，仅用于说明，不代表真实公共 DNS。

## 多级路由与 ARP

手机热点、二级路由器或光网关如果都承担路由功能，数据就会依次经过多层网关，并可能形成 Double NAT。纯 AP/桥接通常只延伸同一个局域网，不会像路由器那样新增一个三层路由跳数。

ARP (Address Resolution Protocol，地址解析协议) 只在当前链路内解析 IPv4 地址对应的 MAC 地址。终端只需解析第一跳网关的 MAC；隔着路由器的光猫不会直接出现在本机 ARP 表中。`arp -a` 是邻居缓存，不是完整的在线设备扫描结果。

## VPN 与 FlClash

传统路由器 VPN 页面通常接收协议、服务器、用户名和密码。FlClash 使用 Clash/Mihomo 配置模型，常见输入是订阅、节点、代理组和分流规则，不能把订阅链接直接当成 PPTP 服务器地址。

只有 Clash 订阅时，需要运行 OpenClash/Mihomo 的兼容环境，例如已安装相应插件的 OpenWrt 路由器或独立旁路由。不能仅凭设备型号盲刷固件；必须先核对硬件版本、内存、闪存、备份和恢复方式。

## 两个路由器下的终端互访

当光猫后面同时接入两个独立路由器时，两个路由器的 LAN (Local Area Network，局域网) 往往是两个不同网段。终端默认只知道自己的第一跳网关，普通家用路由器还常用 NAT (Network Address Translation，网络地址转换) 和防火墙把下级 LAN 与上级网络隔离，所以 A 路由器下的电脑通常不能直接访问 B 路由器下的电脑。

解决方向取决于目标：

1. 想让所有设备像同一个局域网：把其中一台设备改为 AP (Access Point，无线接入点) / 桥接，关闭它的 DHCP (Dynamic Host Configuration Protocol，动态主机配置协议)。
2. 想保留两个网段又能互访：需要 Static Route（静态路由）告诉各级路由器去对方网段该走哪一台网关，并放行对应防火墙；很多家用固件不完整支持。
3. 只想访问某台电脑上的某个服务：使用 Port Forwarding（端口转发），把路由器某个端口转到目标电脑的服务端口。

## 参考依据

- [Microsoft Learn：ipconfig](https://learn.microsoft.com/windows-server/administration/windows-commands/ipconfig)
- [Microsoft Learn：tracert](https://learn.microsoft.com/windows-server/administration/windows-commands/tracert)
- [Microsoft Learn：arp](https://learn.microsoft.com/windows-server/administration/windows-commands/arp)
- [Microsoft Learn：Configure VPN protocols](https://learn.microsoft.com/windows-server/remote/remote-access/configure-vpn-protocols)
- [RFC 826：An Ethernet Address Resolution Protocol](https://www.rfc-editor.org/rfc/rfc826)
- [RFC 1918：Address Allocation for Private Internets](https://www.rfc-editor.org/rfc/rfc1918)
- [RFC 5737：IPv4 Address Blocks Reserved for Documentation](https://www.rfc-editor.org/rfc/rfc5737)
- [FlClash 官方仓库](https://github.com/chen08209/FlClash)
- [OpenClash 官方仓库](https://github.com/vernesong/OpenClash)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`。
- 版式：`3:4` 竖版、浅色不透明背景、高对比标题、圆角信息块和少量图标。
- 第 7 张首次生成后，将“支持 OpenWrt 的路由器”定向修订为“已安装相应插件的 OpenWrt 路由器”，避免暗示所有 OpenWrt 设备都自带 OpenClash/Mihomo。
- 第 8 张生成后，对标题中的“互访”做了本地确定性文字校正，避免生成器误写成“互访问”。
- 已逐张检查中文、英文大小写、接口箭头、地址归属和信息块关系。
- 剩余人工确认点：不同厂商固件对端口自动识别、AP/桥接、VPN 协议和插件安装能力的实现差异很大，实际操作仍应以目标设备说明书为准。
