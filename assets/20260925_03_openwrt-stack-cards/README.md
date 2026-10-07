# Mesh、OpenWrt 软件栈与刷机边界知识卡片

这组卡片面向有基础电脑使用经验、但容易把 Mesh、路由器固件、代理插件和代理核心混在一起的中文读者。

卡片不使用对话中出现的真实品牌、设备型号、IP 地址、MAC 地址、SSID、密码、账号、订阅或二维码。图中的路由器、芯片和终端均为抽象示意。

## 卡片顺序

1. `01-mesh-needs-multiple-nodes.png`：一台路由器能正常上网，但至少需要两个彼此兼容的节点，才构成多节点 Mesh。
2. `02-mesh-vs-wps.png`：区分 Mesh 节点协同与 WPS 终端配对，并解释两种功能为什么可能共用按钮。
3. `03-router-software-stack.png`：区分 U-Boot、路由器操作系统、OpenClash 和 Mihomo 所在层级。
4. `04-openwrt-family.png`：比较 OpenWrt、ImmortalWrt、iStoreOS、QWRT 与 Kwrt 的定位。
5. `05-openclash-mihomo-flclash.png`：说明 OpenClash、Mihomo 与 FlClash 的调用和分工关系。
6. `06-qwrt-vs-kwrt-naming.png`：解释 QWRT、Kwrt 为什么不应被强行拆成英文全称。
7. `07-uboot-flashing-boundary.png`：解释 U-Boot 的启动位置、刷错风险和刷机前核对项。

## Mesh 与 WPS

Mesh（网状网络）解决的是多个兼容路由节点长期协同覆盖的问题。一个路由器可以独立提供 Wi-Fi，但没有第二个节点时，不存在多节点之间的回程、漫游和拓扑协调。

WPS (Wi-Fi Protected Setup，Wi-Fi 保护设置) 解决的是终端快速加入 Wi-Fi 的配对问题。它不是 Mesh，也不是独立的无线加密协议。设备可以通过短按、长按或不同状态，让同一物理按钮触发 Mesh 配对或 WPS 配对；实际操作必须以设备说明书为准。

无线回程部署方便，但会占用无线资源；有线回程通常更稳定。即使设备都标有 Mesh，也仍需确认是否采用彼此兼容的方案。

## 路由器软件栈

从底层到上层，可以概括为：

```text
通电
  ↓
U-Boot
  ↓
OpenWrt / ImmortalWrt / iStoreOS / QWRT / Kwrt
  ↓
OpenClash
  ↓
Mihomo
  ↓
代理节点
```

- U-Boot (Universal Boot Loader，通用引导加载程序)：初始化必要硬件并加载操作系统，也可能提供恢复能力。
- OpenWrt 等固件：完整的路由器操作系统，通常在同一台设备上选择其中一种。
- OpenClash：安装在 OpenWrt 类系统中的代理管理插件。
- Mihomo：负责代理连接、DNS、规则匹配和流量转发的核心程序。
- FlClash：电脑或手机上的客户端前端，也可以调用 Mihomo。

OpenClash 与 FlClash 更像不同场景下的控制面；Mihomo 更像执行工作的发动机。普通路由器的 PPTP/VPN 表单不能直接接收 Clash 订阅。

## OpenWrt 衍生系统

- OpenWrt：上游基础项目，提供可写文件系统和软件包管理。
- ImmortalWrt：OpenWrt 分支，增加设备、软件包和面向国内用户的调整。
- iStoreOS：基于 OpenWrt，强调易用、应用商店以及轻量 NAS (Network Attached Storage，网络附加存储) 场景。
- QWRT：被不同设备厂商或固件作者使用的固件名称，没有统一、公开的逐字英文全称。
- Kwrt：kiddin9 维护的 OpenWrt 衍生固件名称；项目页面没有公布 `K` 的正式展开。

这些名称处在系统或固件层，通常是替代关系，不是先装 OpenWrt、再把 ImmortalWrt 或 iStoreOS 当作插件安装。

`WRT` 沿用自早期 WRT54G 和开放路由器固件的命名传统，常被理解为 Wireless Router（无线路由器）。但 QWRT 的 `Q` 和 Kwrt 的 `K` 没有经过项目方确认的标准展开，因此卡片明确区分“推测”和“确认事实”。

## U-Boot 与刷机边界

U-Boot 比系统固件更底层。系统固件损坏时，有些设备仍能通过 U-Boot 的恢复入口重新刷写；如果 U-Boot 本身损坏，设备可能无法启动，也可能无法进入原有恢复入口。

刷写 U-Boot 或系统固件前，应核对芯片、内存、存储类型、分区布局和准确硬件版本，并备份原厂分区与无线校准数据。`eMMC (embedded MultiMediaCard，嵌入式多媒体卡)` 与 NAND 等存储方案不能只按产品外壳名称混用镜像。

## 参考依据

- [OpenWrt：About the OpenWrt/LEDE Project](https://openwrt.org/about)
- [ImmortalWrt 官方仓库](https://github.com/immortalwrt/immortalwrt)
- [iStoreOS 官方仓库](https://github.com/istoreos/istoreos)
- [OpenClash 官方仓库](https://github.com/vernesong/OpenClash)
- [Mihomo 官方仓库](https://github.com/MetaCubeX/mihomo)
- [FlClash 官方仓库](https://github.com/chen08209/FlClash)
- [Kwrt 官方仓库](https://github.com/kiddin9/Kwrt)
- [Seeed Studio：QWRT based on OpenWrt](https://wiki.seeedstudio.com/H28K-install-system/)
- [U-Boot 官方项目](https://u-boot.org/)
- [Das U-Boot：Design Principles](https://docs.u-boot.org/en/latest/develop/designprinciples.html)
- [Wi-Fi Alliance](https://www.wi-fi.org/)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`。
- 版式：`3:4` 竖版、完全不透明浅米白背景、高对比标题、圆角信息块和少量图标。
- 已逐张检查标题、英文大小写、流程箭头、信息归属和隐私字段。
- 卡片采用通用机制说明，没有宣称某一具体设备一定支持某套固件、跨品牌 Mesh 或特定恢复方式。
- 剩余人工确认点：不同设备的 Mesh 兼容性、按钮操作、分区布局、恢复入口和第三方固件维护状态差异很大，实际操作仍需核对对应硬件版本的官方说明或可信项目文档。
