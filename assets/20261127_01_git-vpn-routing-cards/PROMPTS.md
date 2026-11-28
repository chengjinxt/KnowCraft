# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 十张原创中文 Git、代理、VPN 与安全网关知识卡片，严格 3:4 竖版
Audience: 有基础电脑使用经验、但不熟悉网络分层的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；钴蓝与青绿色圆角信息块；少量橙色重点；简洁代码仓库、终端、代理节点、网络隧道、路由、DNS 与盾牌图标；大字号、留白充足、手机端易读。
Composition: 顶部大标题与短副标题，中部使用纵向流程、对比面板或编号清单解释一个中心问题，底部放术语解释或一句准确结论。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、斜杠、连字符、尖括号和命令；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实企业网段、域名、仓库地址、节点名、订阅地址、本机绝对路径、账号、口令、Token、Cookie、证书或组织标识；需要表达内部目标时使用 <企业网段>、<Git主机> 等占位符。
```

第 01 张不使用视觉参考图。第 02 至 10 张使用第 01 张最终成品作为视觉风格参考，只继承配色、标题层级、圆角信息块、扁平矢量图标语言和留白，不复制其中的文字或信息结构。

## 01 拉代码，到底走谁

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第1张，严格3:4竖版手机信息图
Primary request: 用三个纵向层级解释拉取代码时 FlClash、OpenVPN 与安全网关各自处在哪一层：FlClash 是应用代理层，OpenVPN 是系统路由与隧道层，安全网关是端点安全策略层。强调它们不是互相猜测，而是在不同层按各自规则工作。
Audience: 有基础电脑使用经验、但不熟悉网络分层的中文读者。
Scene/backdrop: 完全不透明浅米白背景。
Style/medium: 清爽扁平矢量技术信息图；深海军蓝标题；钴蓝、青绿色圆角信息块；少量橙色重点；简洁代码仓库、网络节点、隧道、盾牌图标；大字号、留白充足、手机端易读。
Composition/framing: 顶部大标题与短副标题；中部三个纵向圆角信息块并用箭头连接；底部橙色结论条；严格3:4竖版。
Text (verbatim), and do not add any other text:
Title: "拉代码，到底走谁？"
Subtitle: "FlClash、OpenVPN 与安全网关分层协作"
Block 1 title: "FlClash"
Block 1 line: "按域名与规则选择代理节点"
Block 2 title: "OpenVPN"
Block 2 line: "按目标 IP 与路由表选择隧道"
Block 3 title: "安全网关"
Block 3 line: "按安全策略检查或限制行为"
Small explanation: "VPN = Virtual Private Network（虚拟专用网络）"
Bottom reminder: "它们不是互相猜，而是在不同层工作"
Constraints: 所有引号内文字必须逐字准确；准确保留 FlClash、OpenVPN、IP、VPN、Virtual Private Network 的英文大小写和空格；不要添加任何其他文字；不得出现真实域名、IP 地址、仓库地址、本机路径、账号、Token、Cookie、证书或组织标识；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版，禁止横版。
```

第 01 张基础图生成后，以该图为编辑目标执行了一次定向修订。生成器保持了半角括号视觉排版，最终采用修订输出；其他文字和结构未改变。

```text
Use case: text-localization
Input image: Image 1 is the edit target.
Primary request: 只修改图片中靠近底部的这一行英文释义，把半角括号改成全角中文括号，完整文字必须逐字变为："VPN = Virtual Private Network（虚拟专用网络）"
Constraints: change only this one line's parentheses; preserve all other Chinese and English text verbatim; preserve layout, typography, font sizes, icons, arrows, colors, gradients, spacing, 3:4 aspect ratio, and every other visual element unchanged; do not add or remove any other text; no watermark.
```

## 02 先看 Git 用什么协议

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第2张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 说明拉取同一个 Git 仓库时，SSH 与 HTTPS 两种远程地址可能走不同网络路径。SSH 通常交给 OpenSSH 和系统路由，除非配置 ProxyCommand；HTTPS 是否经过代理主要看 Git 的 http.proxy 等配置。
Composition/framing: 顶部大标题与短副标题；中部上下两个对比面板，分别使用终端钥匙与浏览器锁图标；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "先看 Git 用什么协议"
Subtitle: "同一仓库，URL 不同，网络路径也可能不同"
Panel 1 title: "SSH"
Panel 1 line 1: "Secure Shell（安全外壳协议）"
Panel 1 line 2: "通常直接交给系统路由"
Panel 2 title: "HTTPS"
Panel 2 line 1: "Hypertext Transfer Protocol Secure"
Panel 2 line 2: "超文本传输安全协议"
Panel 2 line 3: "是否走代理取决于 Git 配置"
Bottom reminder: "SSH 看 ProxyCommand；HTTPS 看 http.proxy"
Constraints: 所有引号内文字必须逐字准确；准确保留 Git、URL、SSH、Secure Shell、HTTPS、Hypertext Transfer Protocol Secure、ProxyCommand、http.proxy 的英文大小写、点号和空格；不要添加任何其他文字；不得出现真实域名、IP 地址、仓库地址、本机路径、账号或凭据；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 03 FlClash 怎么选地区

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第3张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 用三步流程解释 FlClash 选择出口地区的逻辑：流量先匹配域名或应用规则，再进入代理组，最后由代理组里选中的具体节点决定公开出口地区。强调系统代理只影响主动遵循代理设置的程序，TUN 模式能透明接管更多流量。
Composition/framing: 顶部大标题与短副标题；中部三个纵向圆角流程块并用箭头连接，图标依次为规则清单、分组节点、地球定位；底部一行术语解释和橙色结论条。
Text (verbatim), and do not add any other text:
Title: "FlClash 怎么选地区？"
Subtitle: "前提：流量真的进入代理"
Block 1 title: "规则匹配"
Block 1 line: "按域名或应用分类"
Block 2 title: "代理组"
Block 2 line: "为不同业务选择出口"
Block 3 title: "具体节点"
Block 3 line: "最终决定公开出口地区"
Small explanation: "TUN = Tunnel（三层虚拟网卡模式）"
Bottom reminder: "系统代理不等于全局接管；TUN 能接管更多流量"
Constraints: 所有引号内文字必须逐字准确；准确保留 FlClash、TUN、Tunnel 的英文大小写和空格；不要添加任何其他文字；不得出现真实节点名、地区线路名、域名、IP 地址、订阅地址、账号或凭据；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 04 代理选出口，路由选网卡

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第4张，严格3:4竖版手机信息图；这是一张“应用代理规则转到系统路由”的转场卡
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 清楚区分两个连续步骤：代理负责选择逻辑出口与节点，Windows 路由负责为真实网络连接选择物理网卡或 VPN 隧道。即使流量先进入 FlClash，FlClash 到代理节点的连接仍要服从 Windows 路由。
Composition/framing: 顶部大标题与短副标题；中部三个纵向流程块并用箭头连接，图标依次为应用窗口、代理节点、Windows 路由分叉到 WLAN 与 OpenVPN；底部术语解释和橙色结论条。
Text (verbatim), and do not add any other text:
Title: "代理选出口，路由选网卡"
Subtitle: "这是两个连续步骤"
Block 1 title: "应用"
Block 1 line: "可选：交给 FlClash"
Block 2 title: "FlClash"
Block 2 line: "建立到代理节点的真实连接"
Block 3 title: "Windows 路由"
Block 3 line: "再选择 WLAN 或 OpenVPN"
Small explanation: "WLAN = Wireless Local Area Network（无线局域网）"
Bottom reminder: "代理节点连接本身，也要服从系统路由"
Constraints: 所有引号内文字必须逐字准确；准确保留 FlClash、Windows、WLAN、Wireless Local Area Network、OpenVPN 的英文大小写和空格；不要添加任何其他文字；不得出现真实域名、IP 地址、节点名、本机路径、账号或凭据；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 05 OpenVPN 怎么分流

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第5张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 用两个路由示例解释 OpenVPN 的分流：匹配更具体企业网段的目标进入 OpenVPN 隧道，其他公网目标使用默认网络。说明 Windows 先比较前缀长度，同样长时才比较 Metric。
Composition/framing: 顶部大标题与短副标题；中部从一个目标 IP 图标分叉成上下两个圆角面板：企业网段指向 OpenVPN 隧道，默认路由指向普通网络；底部术语解释和橙色结论条。
Text (verbatim), and do not add any other text:
Title: "OpenVPN 怎么分流？"
Subtitle: "系统只认目标 IP 与路由前缀"
Panel 1 title: "<企业网段>/24"
Panel 1 line: "走 OpenVPN 隧道"
Panel 2 title: "0.0.0.0/0"
Panel 2 line: "走默认网络"
Small explanation: "IP = Internet Protocol（网际协议）"
Bottom reminder: "最长前缀优先；同长度再比较 Metric（跃点值）"
Constraints: 所有引号内文字必须逐字准确；准确保留 OpenVPN、IP、Internet Protocol、<企业网段>/24、0.0.0.0/0、Metric 的英文大小写、尖括号、斜杠和点号；不要添加任何其他文字；不得出现真实企业网段、VPN 地址、域名、IP 地址、本机路径、账号或凭据；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 06 DNS 与数据路径

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第6张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释 DNS 查询路径与真实数据连接路径可以不同：域名解析可能通过 VPN DNS，拿到目标 IP 后，Windows 仍会重新查路由表，真实连接可能从默认网络发出。
Composition/framing: 顶部大标题与短副标题；中部三个纵向流程块并用箭头连接，图标依次为域名放大镜、IP 地址卡片、路由分叉到默认网络；底部术语解释和橙色结论条。
Text (verbatim), and do not add any other text:
Title: "DNS 和数据可能走两条路"
Subtitle: "解析走 VPN，不代表连接也走 VPN"
Block 1 title: "域名解析"
Block 1 line: "DNS 查询可经 VPN"
Block 2 title: "得到目标 IP"
Block 2 line: "再交给 Windows 查路由"
Block 3 title: "真实连接"
Block 3 line: "可能仍从默认网络发出"
Small explanation: "DNS = Domain Name System（域名系统）"
Bottom reminder: "排查时分开问：谁解析？谁承载连接？"
Constraints: 所有引号内文字必须逐字准确；准确保留 DNS、Domain Name System、VPN、IP、Windows 的英文大小写和空格；不要添加任何其他文字；不得出现真实 DNS 地址、域名、IP 地址、VPN 地址、本机路径、账号或凭据；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 07 安全网关不只是 VPN

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第7张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释安全网关不只是一条 VPN 隧道，它还可能在端点进程与安全策略层工作，包括识别应用并执行策略、限制复制打印或外传、过滤或限制网络访问。强调是否真正参与当前流量，要看驱动、服务和策略是否实际启用。
Composition/framing: 顶部大标题与短副标题；中部三个纵向圆角信息块，图标依次为进程窗口与放大镜、文档盾牌、网络过滤器；底部术语解释和橙色结论条。
Text (verbatim), and do not add any other text:
Title: "安全网关不只是 VPN"
Subtitle: "它可能工作在进程与安全策略层"
Block 1 title: "进程检查"
Block 1 line: "识别应用并执行策略"
Block 2 title: "数据控制"
Block 2 line: "限制复制、打印或外传"
Block 3 title: "网络策略"
Block 3 line: "过滤或限制访问"
Small explanation: "SDP = Software-Defined Perimeter（软件定义边界）"
Bottom reminder: "是否参与当前流量，要看驱动、服务和策略是否启用"
Constraints: 所有引号内文字必须逐字准确；准确保留 VPN、SDP、Software-Defined Perimeter 的英文大小写、连字符和空格；不要添加任何其他文字；不出现真实产品名、厂商名、驱动名、进程名、域名、IP 地址、组织名称、本机路径、账号或凭据；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 08 Git 拉取路径排查清单

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第8张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 给出排查 Git 拉取路径的五步清单：先看远程地址是 SSH 还是 HTTPS，再看 Git 或 SSH 代理配置，再确认 FlClash 使用系统代理还是 TUN，然后检查 Windows 路由，最后核对 VPN 目标网段与 DNS。强调“VPN 已连接”不能证明这次 Git 流量经过它。
Composition/framing: 顶部大标题与短副标题；中部五个紧凑但清晰的编号圆角清单条，每条包含短标题和命令或检查项；底部橙色结论条；保证手机端可读。
Text (verbatim), and do not add any other text:
Title: "Git 拉取路径排查清单"
Subtitle: "按顺序确认，不靠猜"
Row 1 title: "1  看远程地址"
Row 1 line: "git remote -v"
Row 2 title: "2  看代理配置"
Row 2 line: "http.proxy / ProxyCommand"
Row 3 title: "3  看 FlClash"
Row 3 line: "系统代理还是 TUN"
Row 4 title: "4  看系统路由"
Row 4 line: "route print -4"
Row 5 title: "5  看 VPN"
Row 5 line: "目标网段与 DNS"
Bottom reminder: "VPN 已连接，不等于这次 Git 流量经过它"
Constraints: 所有引号内文字必须逐字准确；准确保留 Git、git remote -v、http.proxy / ProxyCommand、FlClash、TUN、route print -4、VPN、DNS 的英文大小写、点号、斜杠、连字符和空格；不要添加任何其他文字；不出现真实远程地址、域名、IP 地址、仓库路径、账号或凭据；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 09 路由正确，为什么还超时

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第9张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释“本机路由已经正确指向 OpenVPN，但 TCP 连接仍然超时”的含义：路由只证明流量从本机进入了 VPN 隧道，不证明 VPN 服务端已把流量转发到内网服务器，也不证明回包能够返回。强调阻断点已缩小到隧道之后。
Composition/framing: 顶部大标题与短副标题；中部三个纵向圆角流程块并用箭头连接，图标依次为路由表勾选、VPN 隧道、服务器超时；底部一行术语解释和橙色结论条。
Text (verbatim), and do not add any other text:
Title: "路由正确，为什么还超时？"
Subtitle: "流量进了 VPN，不代表已经到达服务器"
Block 1 title: "本机路由"
Block 1 line: "目标已指向 VPN 隧道"
Block 2 title: "TCP 测试"
Block 2 line: "连接仍然超时"
Block 3 title: "阻断位置"
Block 3 line: "已经缩小到隧道之后"
Small explanation: "TCP = Transmission Control Protocol（传输控制协议）"
Bottom reminder: "路由只决定从哪发；通不通还要看转发、权限与回程"
Constraints: 所有引号内文字必须逐字准确；准确保留 OpenVPN、VPN、TCP、Transmission Control Protocol 的英文大小写和空格；不要添加任何其他文字；不得出现真实企业网段、VPN 地址、服务器 IP、接口号、网关、本机路径、账号、凭据或组织标识；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

## 10 内网能通，VPN 不通

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，系列第10张，严格3:4竖版手机信息图
Input image: Image 1 仅作为视觉风格参考；继承浅米白背景、深海军蓝标题、钴蓝与青绿色圆角信息块、少量橙色重点、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 用对照实验解释：公司内网测试机可以连接同一 SSH 服务器，而 VPN 客户端连接同一目标超时，说明目标主机和 SSH 服务基本正常，排查重点应从目标服务转向 VPN 服务端转发、访问控制和回程路由。不要把“基本正常”写成绝对结论。
Composition/framing: 顶部大标题与短副标题；中部上下两个对比面板，上方是内网测试机通过绿色连线成功连接服务器，下方是 VPN 客户端通过隧道连接服务器但出现橙色超时标记；其下一个小型结论块；底部一行术语解释和橙色结论条。
Text (verbatim), and do not add any other text:
Title: "内网能通，VPN 不通"
Subtitle: "对照实验能快速缩小排查范围"
Panel 1 title: "内网测试机"
Panel 1 line: "SSH 连接成功"
Panel 2 title: "VPN 客户端"
Panel 2 line: "同一目标连接超时"
Conclusion title: "初步结论"
Conclusion line: "目标主机与 SSH 服务基本正常"
Small explanation: "SSH = Secure Shell（安全外壳协议）"
Bottom reminder: "重点检查 VPN 转发、访问控制与回程路由"
Constraints: 所有引号内文字必须逐字准确；准确保留 VPN、SSH、Secure Shell 的英文大小写和空格；“基本正常”不得改成绝对正常；不要添加任何其他文字；不得出现真实企业网段、VPN 地址、服务器 IP、端口、接口号、网关、本机路径、账号、凭据或组织标识；无品牌 Logo、水印、二维码、页码或平台标识；严格3:4竖版。
```

除第 01 张记录的括号定向修订外，其余最终图片均由对应基础提示词直接生成；第 02 至 10 张只使用第 01 张作为视觉风格参考，没有执行局部修图或文字重生成。
