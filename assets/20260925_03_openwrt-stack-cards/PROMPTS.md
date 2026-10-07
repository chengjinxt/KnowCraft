# ImageGen 最终提示词

以下 7 张卡片均使用 Codex 内置 `imagegen` 生成，分类为 `scientific-educational`。共同要求：原创中文信息图、`3:4` 竖版、完全不透明浅米白背景、深海军蓝高对比标题、圆角信息块、手机端易读；不使用真实品牌 Logo、真实设备型号、IP、MAC、SSID、密码、账号、订阅、二维码、水印或页码。

## 01 — Mesh 为什么需要多个节点

```text
Primary request: 解释 Mesh 组网为什么需要多个兼容节点，以及只有一个路由器时能做什么。

Text (verbatim):
"Mesh 组网：一个路由器够吗？"
"Mesh (网状网络)"
"多个兼容节点协同提供同一个家庭 Wi-Fi 网络"
"一个路由器"
"可以正常上网和发 Wi-Fi"
"但没有其他节点可协同，因此不构成多节点 Mesh"
"两个或更多兼容节点"
"主节点连接上级网络"
"子节点放在不同房间"
"节点之间自动选择回程路径，并帮助终端漫游"
"组网前提"
"① 节点必须支持彼此兼容的 Mesh 方案"
"② 先完成主节点配置，再添加子节点"
"③ 子节点仍需放在能收到较好信号的位置"
"无线回程"
"通过 Wi-Fi 连接节点，布置方便但会占用无线资源"
"有线回程"
"通过网线连接节点，通常更稳定、性能更好"
"一句话：一台路由器能覆盖一个点；多个兼容节点才组成 Mesh。"

Constraints: 不要暗示所有不同品牌设备都能自动互联；不要说 Mesh 能无限扩大覆盖。
```

## 02 — Mesh 与 WPS

```text
Primary request: 对比 Mesh 与 WPS，说明二者名字都可能出现在同一个按钮上，但用途完全不同。

Text (verbatim):
"Mesh / WPS：同一个按钮，两种用途"
"Mesh"
"Mesh Networking（网状网络）"
"用途：让多个兼容路由节点长期协同覆盖"
"对象：主节点与子节点"
"结果：形成统一 Wi-Fi 网络，并支持节点间漫游"
"WPS"
"Wi-Fi Protected Setup（Wi-Fi 保护设置）"
"用途：简化设备加入 Wi-Fi 的配对过程"
"对象：路由器与手机、打印机等终端"
"结果：短时间开启配对，不负责长期组网"
"为什么共用按钮？"
"短按、长按或不同状态下，设备可以触发不同功能"
"具体操作必须以设备说明书为准"
"容易误解"
"WPS 不是 Mesh"
"按下 WPS 不会自动增加覆盖范围"
"Mesh 节点配对也不等于普通终端的 WPS 配对"
"一句话：Mesh 管“多个路由节点协同”，WPS 管“终端快速加入 Wi-Fi”。"

Constraints: 不要把 WPS 扩写错误；不要暗示 WPS 是加密协议本身。
```

## 03 — 路由器软件层级

```text
Primary request: 用自上而下的层级图解释 U-Boot、OpenWrt 类系统、OpenClash 与 Mihomo 不在同一层。

Text (verbatim):
"这些名字，其实不在同一层"
"先分清层级，才不会把固件、插件和核心混在一起"
"① 启动层"
"U-Boot (Universal Boot Loader，通用引导加载程序)"
"初始化硬件、加载系统、提供恢复入口"
"② 系统层"
"OpenWrt / ImmortalWrt / iStoreOS / QWRT / Kwrt"
"路由器操作系统或固件，通常只选一个"
"③ 管理层"
"OpenClash"
"安装在 OpenWrt 类系统中的代理管理插件"
"④ 核心层"
"Mihomo"
"真正执行代理连接、DNS 和分流规则"
"通电 → U-Boot → 路由系统 → OpenClash → Mihomo → 代理节点"
"一句话：引导程序启动系统，系统承载插件，插件管理核心。"

Constraints: 箭头方向不能颠倒；不要把 OpenClash 画成操作系统；不要把 Mihomo 画成硬件。
```

## 04 — OpenWrt 衍生系统

```text
Primary request: 对比 OpenWrt、ImmortalWrt、iStoreOS、QWRT 与 Kwrt 的定位，强调它们都属于系统或固件层，通常是替代关系。

Text (verbatim):
"OpenWrt 家族，怎么分？"
"它们都在“系统 / 固件层”，通常是替代关系"
"OpenWrt"
"上游基础"
"开放、可扩展，提供软件包管理"
"ImmortalWrt"
"OpenWrt 分支"
"增加设备、软件包与面向国内用户的调整"
"iStoreOS"
"基于 OpenWrt"
"强调易用、应用商店和轻量 NAS"
"NAS (Network Attached Storage，网络附加存储)"
"QWRT / Kwrt"
"第三方 OpenWrt 衍生固件"
"来源、支持范围和维护方式取决于制作者"
"不是层层安装"
"通常不会先装 OpenWrt，再把 ImmortalWrt 或 iStoreOS 当插件安装"
"选择前核对"
"准确型号｜硬件版本｜存储类型｜恢复方式"
"一句话：先选一套适配硬件的系统，再在系统里安装所需插件。"

Constraints: 不要宣称所有设备都支持这些系统；不要把 iStoreOS 画成普通应用商店插件。
```

## 05 — OpenClash、Mihomo 与 FlClash

```text
Primary request: 解释 OpenClash、Mihomo 与 FlClash 的分工和调用关系，区分路由器方案与本机方案。

Text (verbatim):
"OpenClash、Mihomo、FlClash 是什么关系？"
"同一个代理核心，可以有不同前端"
"OpenClash"
"路由器端管理插件"
"运行在 OpenWrt 类系统中"
"管理订阅、规则、策略组和核心进程"
"Mihomo"
"代理核心 / 发动机"
"负责连接代理服务器、DNS、规则匹配和流量转发"
"DNS (Domain Name System，域名系统)"
"FlClash"
"电脑 / 手机客户端"
"提供桌面或移动端界面，也可以调用 Mihomo"
"路由器方案"
"OpenClash → Mihomo → 处理经过路由器的设备流量"
"本机方案"
"FlClash → Mihomo → 主要处理本机流量"
"注意"
"路由器的 PPTP / VPN 表单不能直接填写 Clash 订阅"
"一句话：OpenClash 和 FlClash 负责管理，Mihomo 负责真正执行代理。"

Constraints: 不要把三者画成三个独立代理协议；不要显示真实订阅或节点。
```

## 06 — QWRT 与 Kwrt 命名

```text
Primary request: 解释 QWRT 与 Kwrt 看起来像缩写，但没有公开统一的逐字英文全称；说明 WRT 的历史命名与识别固件来源的方法。

Text (verbatim):
"QWRT 与 Kwrt：不是标准英文缩写"
"更准确地说，它们是项目名 / 固件品牌名"
"WRT"
"沿用自早期 WRT54G 与开放路由器固件的命名传统"
"常被理解为 Wireless Router（无线路由器）"
"QWRT"
"没有公开统一的逐字全称"
"Q 的含义不能想当然写成 Qualcomm 或 Quick"
"不同厂商或作者可能使用同名固件"
"Kwrt"
"kiddin9 维护的 OpenWrt 衍生固件名"
"项目页没有给出 K 的正式展开"
"推测 K 与作者或品牌有关，但不是确认事实"
"认固件，不要只看名字"
"下载来源｜项目仓库｜适配设备｜维护者｜校验值"
"一句话：没有官方全称，就把它当项目名，不要硬拆字母。"

Constraints: 不要给 Q 或 K 编造全称；明确“推测”不是确认事实。
```

## 07 — U-Boot 刷机边界

```text
Primary request: 解释 U-Boot 为什么比普通系统固件更底层、刷错风险更高，以及刷机前必须核对的硬件信息。

Text (verbatim):
"为什么 U-Boot 最不能刷错？"
"它比系统固件更底层"
"U-Boot"
"初始化硬件并加载 Linux 内核"
"System Firmware（系统固件）"
"OpenWrt 等路由器操作系统"
"Packages（软件包）"
"OpenClash 等插件"
"启动关系"
"通电 → U-Boot → Linux 内核 → 系统 → 插件"
"系统刷坏"
"有时还能通过 U-Boot 的恢复入口重新刷写"
"U-Boot 刷坏"
"设备可能无法启动，也可能无法进入原有恢复入口"
"必须严格匹配"
"芯片｜内存｜存储类型｜分区布局｜准确硬件版本"
"eMMC (embedded MultiMediaCard，嵌入式多媒体卡)"
"NAND：常见闪存类型"
"刷机前"
"备份原厂分区与校准数据"
"确认恢复方式和适配说明"
"一句话：系统固件是“房间”，U-Boot 更像“地基和入口”；地基不能拿别的型号替换。"

Constraints: 不要承诺一定能救砖；不要给出具体刷机命令。
```
