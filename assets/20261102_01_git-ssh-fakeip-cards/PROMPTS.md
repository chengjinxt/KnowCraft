# 图片生成提示词

本目录 10 张最终图片均使用 Codex 内置 `imagegen` 生成。用户提供的终端与 MetaCubeXD 截图仅用于诊断和确定知识内容，没有作为图片生成输入，避免真实路径、账号、局域网地址、节点名称和仓库信息进入公开卡片。

## 统一视觉规范

- 用例：`infographic-diagram`。
- 原创中文社交媒体技术知识卡片，严格 3:4 竖版，目标构图 1080×1440。
- 浅米白背景、轻微纸张纹理、深蓝高对比标题、浅蓝圆角信息块、橙色重点、少量扁平网络与终端图标。
- 手机端一眼读完；命令、域名、端口、字段名与日志使用清晰等宽字体。
- 每张卡只讲一个中心问题；流程箭头和文字归属必须准确。
- 不出现真实 IP、路径、用户名、仓库名、远程地址、节点名、订阅信息、平台模板、品牌标识或水印。
- 下列每张卡的实际最终提示词由本统一视觉规范与对应单卡提示词共同组成。

## 01 `01-failure-layer.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 1 张，共 10 张
Primary request: 解释 Git SSH 拉取突然失败时，为什么不能立刻判断为私钥或仓库权限问题
Composition/framing: 标题、错误现象、判断依据、底部结论四层结构
Text (verbatim):
"Git 拉取失败，先别怪密钥"
"现象"
"Connection closed"
"port 22"
"判断依据"
"连接在身份认证前被关闭"
"私钥还没开始验证"
"先查网络链路和端口"
"不是看到 fatal 就等于没权限"
Constraints: Connection closed、port 22、fatal 使用清晰等宽字体；信息归属明确；只出现上述文字。
Avoid: 密集段落、过小字号、乱码、额外英文、写实人物、品牌标识。
```

## 02 `02-fake-ip-principle.png`

输入图片用途：`01-failure-layer.png` 仅作为同系列配色、圆角信息块、字体层级和纸张质感参考，不复制其中内容。

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 2 张，共 10 张
Primary request: 用白话解释 Fake-IP 的工作原理
Composition/framing: 中心用三段纵向流程
Text (verbatim):
"Fake-IP：给域名一个内部代号"
"DNS"
"Domain Name System"
"域名系统"
"1  查询 github.com"
"2  返回 198.18.x.x（示例）"
"3  连接时还原成 github.com"
"不是 GitHub 的真实地址"
"Mihomo 用映射表找回原域名"
"规则仍能按域名匹配"
Constraints: 把 198.18.x.x 明确标为示例；三段流程箭头关系准确；不能把 Fake-IP 画成真实服务器；只出现上述文字。
```

## 03 `03-gateway-source.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考。

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 3 张，共 10 张
Primary request: 解释为什么 Windows 上的 FlClash 已退出，github.com 仍可能解析成 Fake-IP
Composition/framing: 上方排除本机，中间显示网关证据，底部结论
Text (verbatim):
"FlClash 退出，Fake-IP 为何还在？"
"本机排查"
"无 TUN 网卡"
"无代理端口监听"
"Windows DNS 缓存为空"
"关键证据"
"nslookup github.com <网关IP>"
"网关仍返回 198.18.x.x（示例）"
"不是本机残留"
"是 OpenWrt 网关仍在做 DNS 劫持"
Constraints: 使用明确的“电脑 → 网关”关系，不能暗示 OpenWrt 缓存了 FlClash；只出现上述文字。
```

## 04 `04-dns-proxy-toggle.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考。

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 4 张，共 10 张
Primary request: 解释 OpenClash 页面里“DNS 代理：停用”不等于 DNS 服务或 Fake-IP 被关闭
Composition/framing: 上方误读，中间真实含义，底部仍然生效的功能
Text (verbatim):
"“DNS 代理：停用”≠ DNS 关闭"
"这个开关实际控制"
"respect-rules"
"DNS 查询是否遵循代理规则"
"停用后"
"Fake-IP DNS 仍在运行"
"DNS 劫持仍可生效"
"TUN 仍可接管连接"
"看开关名称，更要看它控制的字段"
Constraints: respect-rules 的释义必须归属于该字段；不能把“停用”画成关闭整个 OpenClash；只出现上述文字。
```

## 05 `05-proxy-chain.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考。

初次生成提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 5 张，共 10 张
Primary request: 教读者从 MetaCubeXD 连接记录读懂 Git SSH 的完整代理链
Composition/framing: 中间用六步纵向链路，底部列出三项观察点
Text (verbatim):
"一条连接，读懂完整代理链"
"电脑"
"OpenClash TUN"
"Fake-IP 映射"
"Rule / Match"
"代理节点"
"GitHub"
"Metacubexd 重点看"
"主机 / 端口"
"规则 / 链路"
"流向 / 流量"
"显示 github.com:22：域名已成功还原"
Constraints: 流程顺序必须是电脑 → OpenClash TUN → Fake-IP 映射 → Rule / Match → 代理节点 → GitHub；不能把代理节点画成 GitHub。
```

定向修订提示词：

```text
只把底部蓝色标签中的“Metacubexd 重点看”改为“MetaCubeXD 重点看”。只修改这一处英文大小写；必须逐字写成 MetaCubeXD，其中 M、C、X、D 为大写；其他所有文字、数字、图标、箭头、配色、尺寸、构图和留白完全不变。
```

## 06 `06-ssh-log-layer.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考。

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 6 张，共 10 张
Primary request: 教读者根据 SSH 详细日志判断失败发生在身份认证之前
Composition/framing: 上方缩写解释，中间日志时间线，底部结论
Text (verbatim):
"SSH 日志：失败发生在哪一层？"
"SSH"
"Secure Shell"
"安全外壳协议"
"1  Connection established"
"2  Local version string"
"3  kex_exchange_identification"
"4  Connection closed"
"没收到服务端 SSH 标识"
"还没进入公钥认证"
"此时先查端口、路由和代理出口"
Constraints: SSH 同时展示 Secure Shell 和安全外壳协议；四条日志保持完整拼写和正确顺序；不能把该错误归因于私钥。
```

## 07 `07-system-proxy-vs-tun.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考。

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 7 张，共 10 张
Primary request: 对比 Windows 系统代理与 TUN 对 SSH 流量的影响
Composition/framing: 上方标题，中间左右对比，底部补充路由器场景
Text (verbatim):
"系统代理和 TUN 不是一回事"
"System Proxy（系统代理）"
"应用主动读取代理设置"
"OpenSSH 默认不会自动跟随"
"TUN（网络层虚拟隧道接口）"
"在网络层透明接管 IP 流量"
"SSH 无需单独认识代理"
"路由器 TUN 仍能接管"
"即使 Windows 上的 FlClash 已退出"
"先问：谁在接管流量？"
Constraints: System Proxy 归属“应用主动读取”，TUN 归属“网络层透明接管”；不能宣称所有应用都读取系统代理。
```

## 08 `08-port-comparison.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考。

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 8 张，共 10 张
Primary request: 用同一代理节点的 22 与 443 端口对照实验定位故障
Composition/framing: 左右对照，同一规则和代理链，底部结论
Text (verbatim):
"同一节点：443 通，22 不通"
"同一规则 / 同一代理链"
"github.com:22"
"Connection closed"
"ssh.github.com:443"
"双向流量"
"SSH 握手成功"
"变量只剩目标端口"
"TCP"
"Transmission Control Protocol"
"传输控制协议"
"最可能：节点或上游限制 TCP 22"
"清 DNS 缓存不会打开端口"
Constraints: 左侧 22 用红色失败，右侧 443 用绿色成功；TCP 同时展示英文全称和中文解释；不能把 443 画成直连。
```

## 09 `09-cache-boundary.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考。

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 9 张，共 10 张
Primary request: 解释清理 Fake-IP 与 DNS 缓存能解决什么、不能解决什么
Composition/framing: 上方三步循环，中间适用与不适用对比，底部结论
Text (verbatim):
"清 Fake-IP 缓存能解决什么？"
"1  映射表清空"
"2  再次查询域名"
"3  重新分配 198.18.x.x（示例）"
"适合"
"映射异常"
"DNS 缓存过期"
"不适合"
"代理节点限制 TCP 22"
"Fake-IP 模式仍开，就会再次生成"
"清缓存不会打开被限制的端口"
Constraints: 把前三步画成循环但阅读顺序清晰；适合使用绿色标记，不适合使用橙红警告；不能暗示清缓存会关闭 Fake-IP 模式。
```

## 10 `10-ssh-443-fix.png`

输入图片用途：`01-failure-layer.png` 仅作为系列风格参考；初稿作为后续定向修订的编辑目标。

初次生成提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 10 张，共 10 张
Primary request: 展示通过 SSH 配置把 GitHub SSH 从 22 端口切换到官方 443 入口的方法，并说明这不等于直连
Composition/framing: 上方结论，中间大号 SSH 配置代码块，下面验证命令，底部边界提醒
Text (verbatim):
"SSH 改走 443，仓库地址不用改"
"~/.ssh/config"
"Host github-work"
"    HostName ssh.github.com"
"    Port 443"
"    User git"
"保留原来的 IdentityFile"
"验证"
"ssh -T git@github-work"
"git pull --rebase"
"443 仍按 OpenClash 规则走代理"
"改端口不等于直连"
"首次连接先核对官方主机密钥指纹"
Constraints: 代码块保持大小写、点号、斜杠、波浪号、缩进和端口数字准确；github-work 是公开示例别名；不能出现真实 IdentityFile 路径、真实账号或仓库名。
```

定向修订提示词：

```text
只修改卡片上半部分右侧服务器上的 GitHub 猫形标识，把该标识替换为原创的通用代码仓库图标：一个简洁的白色代码分支符号，不能像任何现有品牌标志。只修改这个图标；保留服务器、黄色钥匙、443 圆点、所有文字、代码、字体、配色、尺寸、构图、留白和其他图标完全不变。
```
