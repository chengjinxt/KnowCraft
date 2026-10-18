# ImageGen 与排版记录

本组卡片采用“无文字底图 + 确定性文字排版”的流程。原因是本主题包含大量精确文本，例如 `192.168.2.0/24`、`SRC-IP-CIDR`、`\\192.168.100.2:1445\`，直接让图片模型生成完整中文卡片容易出现错字、断字或反斜杠错误。

## ImageGen 底图提示词

```text
Use case: scientific-educational
Asset type: reusable background template for Chinese networking knowledge cards
Primary request: Create a 3:4 vertical infographic background template with no words, no letters, no numbers, no logo, no watermark. Warm off-white opaque background, deep navy and teal network-themed accents, several clean rounded white information panels, subtle router/computer/connection line icon motifs without labels, modern Chinese social-media educational card style, high contrast, spacious mobile-readable layout.
Composition/framing: title area at top left left mostly blank; 3 to 4 rounded content blocks below; small footer area blank; no text anywhere.
Constraints: absolutely no readable text, no fake characters, no QR code, no brand mark, no watermark, no numbers.
```

## 卡片文本要点

### 01 — B 路由器模式怎么选？

```text
标题：B 路由器模式怎么选？
副标题：结论：想隔离并单独控制流量，用路由模式；想同网段互访，用 AP / 桥接。
核心术语：
Router（路由器）
AP / 桥接 Access Point（无线接入点）
中继 / Mesh / 旁路由
结论：跑 Mihomo 的设备最好是默认网关；AP 模式通常拦不到下级设备流量。
```

### 02 — OpenClash 直连规则看方向

```text
标题：OpenClash 直连规则看方向
副标题：IP-CIDR 管“去哪里”，SRC-IP-CIDR 管“谁发出”。
规则：
IP-CIDR,192.168.2.0/24,DIRECT,no-resolve
SRC-IP-CIDR,192.168.100.2/32,DIRECT
结论：DIRECT 只负责“不走代理”，不负责打通路由器防火墙。
```

### 03 — 路由类型为什么选 unicast？

```text
标题：路由类型为什么选 unicast？
副标题：家用静态路由的本质是“去某个网段，走某个网关”。
核心术语：
unicast（单播）
local / broadcast / multicast
unreachable / prohibit / blackhole
anycast / throw
结论：目标 192.168.2.0/24，网关 192.168.100.2，类型 unicast。
```

### 04 — 192.168.2.0/24 怎么读？

```text
标题：192.168.2.0/24 怎么读？
副标题：CIDR (Classless Inter-Domain Routing，无类别域间路由) 是网段范围的简写。
核心术语：
/24 = 255.255.255.0
192.168.2.28/32
192.168.0.0/16
0.0.0.0/0
结论：静态路由里写 192.168.2.0/24，意思是“去整个 B 网段都交给下一跳”。
```

### 05 — 静态路由只解决“往哪走”

```text
标题：静态路由只解决“往哪走”
副标题：能打开 B 后台，不等于能访问 B 后面的电脑。
示例：
192.168.2.0/24 → 192.168.100.2
三道门：
A 的路由表
B 的防火墙
目标电脑
结论：路由表、路由器防火墙、电脑防火墙，是跨网段互访的三道门。
```

### 06 — 3389 通，445 不通说明什么？

```text
标题：3389 通，445 不通说明什么？
副标题：端口转发可能已生效，但 SMB 文件共享还卡在 TCP 445。
核心术语：
RDP (Remote Desktop Protocol，远程桌面协议)
SMB (Server Message Block，服务器消息块协议)
\\192.168.100.2:1445\
结论：要用共享目录，外部端口通常必须是 445；否则可改用 WebDAV、SFTP 或 HTTP 文件服务。
```
