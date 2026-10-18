# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文技术知识卡片，3:4 竖版，1086×1448
Style: 清爽扁平矢量技术信息图；完全不透明的浅米白背景；深海军蓝标题；蓝色和青绿色圆角信息块；少量橙色安全提醒；通用终端、网络、齿轮、盾牌和检查图标；大字号、留白充足、手机端易读。
Constraints: 所有命令必须完整单行呈现；英文大小写、连字符、斜杠、冒号、尖括号和占位符逐字准确；不使用品牌 Logo；无水印、二维码和页码。
Public-release redaction: 不出现真实项目地址、内部域名、仓库 URL、企业内网服务 IP、本机绝对路径、账号或凭据；使用 <内网域名>、<Windows热点IP>、<Windows用户名> 等占位符。192.168.137.1 仅作为 Windows 热点通用示例，并注明“以实际输出为准”。
```

后续卡片以上一张成品作为视觉风格参考，只继承色彩、圆角信息块、代码框、字体层级和图标语言，不复用上一张内容。

## 01 Windows 11 开通 OpenSSH Server

```text
Title: "Windows 11 开通 OpenSSH Server"
Subtitle: "SSH（Secure Shell，安全外壳协议）"
Lead: "让 Mac 可以安全连接 Windows"

Step 1:
"① 安装服务端"
"设置 → 系统 → 可选功能 → 查看功能"
"搜索并安装：OpenSSH Server"

Step 2:
"② 管理员 PowerShell 启动"
"Start-Service sshd"

Step 3:
"③ 设置开机自动启动"
"Set-Service -Name sshd -StartupType Automatic"

Step 4:
"④ 验证服务与防火墙"
"Get-Service sshd"
"Get-NetFirewallRule -Name OpenSSH-Server-In-TCP"
"看到 Running，且入站规则已启用"
"默认监听：TCP 22"

Bottom reminder:
"只开放给可信设备，不要关闭 Windows 防火墙"
```

## 02 Mac 建立 SSH 动态代理

```text
Title: "Mac 建立 SSH 动态代理"
Subtitle: "Dynamic Port Forwarding（动态端口转发）"
Prerequisite: "前提：Mac 已连接 Windows 热点"

Step 1:
"① 查询 Windows 热点地址"
"Get-NetIPAddress -AddressFamily IPv4"
"常见：192.168.137.1，以实际输出为准"

Step 2:
"② Mac 先测试 SSH 登录"
"ssh <Windows用户名>@<Windows热点IP>"
"首次连接：先核对主机指纹"

Step 3:
"③ 建立本地 SOCKS5 代理"
"ssh -N -D 127.0.0.1:1080 <Windows用户名>@<Windows热点IP>"
"-N：只转发，不执行远端命令"
"-D：创建动态 SOCKS 代理"

Connection chain:
"Mac 应用" → "127.0.0.1:1080" → "SSH 加密隧道" → "Windows sshd" → "内网服务"

Bottom reminder:
"只监听 127.0.0.1，不要开放成 *:1080"
```

## 03 Git 使用 socks5h

```text
Title: "让 Git 走 Windows SSH 隧道"
Subtitle: "socks5h：域名交给 Windows 解析"
Lead: "避免 Mac 在私有 DNS 阶段失败"

Step 1:
"① 保持 SSH 代理终端运行"
"本地代理：127.0.0.1:1080"

Step 2:
"② 先用 curl 验证"
"curl --proxy socks5h://127.0.0.1:1080 -I https://<内网域名>/"
"收到 HTTP 响应，说明代理链路已建立"

Step 3:
"③ Git 单次使用代理"
"git -c http.proxy=socks5h://127.0.0.1:1080 pull"
"优先单次测试，不污染其他仓库"

Optional config:
"可选：仅配置当前仓库"
"git config --local http.proxy socks5h://127.0.0.1:1080"

Cleanup:
"取消配置"
"git config --local --unset http.proxy"

Bottom reminder:
"不要先写 --global；SSH 隧道停止后代理也会失效"
```

## 04 OpenSSH 与 SOCKS 分层排查

```text
Title: "OpenSSH 与 SOCKS 分层排查"
Subtitle: "Troubleshooting（故障排查）"
Lead: "从近到远，一层一层确认"

Layer 1:
"① Windows：sshd 是否运行"
"Get-Service sshd"
"不是 Running：先启动服务"

Layer 2:
"② Mac：TCP 22 是否可达"
"nc -G 5 -vz <Windows热点IP> 22"
"失败：检查热点地址、服务和防火墙"

Layer 3:
"③ Mac：SOCKS 是否监听"
"lsof -nP -iTCP:1080 -sTCP:LISTEN"
"应只看到 127.0.0.1:1080"

Layer 4:
"④ 代理：内网目标是否响应"
"curl --proxy socks5h://127.0.0.1:1080 -I https://<内网域名>/"
"HTTP 有响应：网络链路已建立"

Stop:
"停止代理：在 ssh -N -D 终端按 Ctrl+C"

Bottom security note:
"可审计：Windows、OpenSSH、CMICSDP 和内网服务都可能留下日志"
"仅在获得组织授权时使用"
```
