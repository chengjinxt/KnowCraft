# Windows OpenSSH Server 与 SSH SOCKS 中转

## 白话结论

Windows 11 安装并启动 `OpenSSH Server（OpenSSH 服务端）` 后，Mac 可以通过 `SSH（Secure Shell，安全外壳协议）` 连接 Windows，并用 `Dynamic Port Forwarding（动态端口转发）` 在 Mac 本地建立 SOCKS5 代理。

当 Windows 本机可以访问某个已授权的内网服务，而 Windows 移动热点不能直接转发该访问能力时，这条链路可让 Mac 应用把连接交给 Windows 本机的 `sshd` 进程发起。使用 `socks5h` 时，域名也交给 Windows 解析，适合 Mac 无法直接使用企业私有 DNS 的情况。

这是一种可审计的应用层中转方式，不是隐藏访问来源或绕过企业安全策略的手段。仅在组织和网络管理员明确授权时使用。

## 卡片清单

1. `01-enable-openssh-server.png`：Windows 11 安装、启动和验证 OpenSSH Server。
2. `02-create-ssh-socks-proxy.png`：Mac 连接 Windows，并建立本地 SSH 动态 SOCKS5 代理。
3. `03-use-git-through-socks5h.png`：用 `curl` 验证代理，让 Git 单次或仓库级使用 `socks5h`。
4. `04-troubleshoot-openssh-socks.png`：从 `sshd`、TCP 22、本地 SOCKS 到内网目标分层排查。

## 适用前提

- Windows 11 已连接可用网络，且 Windows 本机能够访问目标服务。
- Mac 已连接 Windows 移动热点，或能通过其他受信网络访问 Windows。
- Windows 和 Mac 均属于获准参与联调的设备。
- 使用 SSH 中转符合组织的零信任、终端准入和日志审计政策。

## 开通 OpenSSH Server

Windows 图形界面路径：

```text
设置 → 系统 → 可选功能 → 查看功能
```

搜索并安装 `OpenSSH Server`，随后在管理员 PowerShell 中执行：

```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
Get-Service sshd
Get-NetFirewallRule -Name OpenSSH-Server-In-TCP
```

预期结果：

- `sshd` 状态为 `Running`。
- OpenSSH Server 的 TCP 22 入站规则存在且已启用。
- 防火墙只允许可信设备访问，不要为了排障直接关闭 Windows 防火墙。

## 建立 SSH 动态 SOCKS 代理

Windows 查询热点或目标网卡地址：

```powershell
Get-NetIPAddress -AddressFamily IPv4
```

Windows 移动热点常见网关示例为 `192.168.137.1`，但必须以实际输出为准。

Mac 先测试 SSH 登录：

```bash
ssh <Windows用户名>@<Windows热点IP>
```

首次连接应核对 Windows SSH 主机指纹。确认登录正常后，在 Mac 建立本地代理：

```bash
ssh -N -D 127.0.0.1:1080 <Windows用户名>@<Windows热点IP>
```

- `-N`：不执行远端命令，只建立转发。
- `-D`：创建动态 SOCKS 代理。
- `127.0.0.1:1080`：只允许 Mac 本机使用代理，不向局域网开放。

数据流：

```text
Mac 应用
  → 127.0.0.1:1080
  → SSH 加密隧道
  → Windows sshd
  → 已授权的内网服务
```

## 让 Git 使用 socks5h

先验证完整代理链路：

```bash
curl --proxy socks5h://127.0.0.1:1080 -I https://<内网域名>/
```

`socks5h` 中的 `h` 表示 hostname 由代理端解析。目标域名会交给 Windows 处理，避免 Mac 在私有 DNS 阶段提前失败。

Git 单次使用代理：

```bash
git -c http.proxy=socks5h://127.0.0.1:1080 pull
```

确认长期需要且已经获批时，可以只配置当前仓库：

```bash
git config --local http.proxy socks5h://127.0.0.1:1080
```

取消仓库级代理：

```bash
git config --local --unset http.proxy
```

不建议直接使用 `--global`，否则所有仓库都会依赖该代理；SSH 隧道停止后，其他仓库也可能出现连接失败。

## 分层排查

### 1. Windows sshd

```powershell
Get-Service sshd
```

若不是 `Running`，先启动服务并检查 Windows 事件日志。

### 2. Mac 到 TCP 22

```bash
nc -G 5 -vz <Windows热点IP> 22
```

失败时检查热点地址、`sshd` 状态和 Windows 防火墙，不要先改 Git 配置。

### 3. Mac 本地 SOCKS 监听

```bash
lsof -nP -iTCP:1080 -sTCP:LISTEN
```

预期只看到 `127.0.0.1:1080`。如果显示 `*:1080`，说明代理被开放到其他接口，应停止并重新绑定回环地址。

### 4. 代理访问目标

```bash
curl --proxy socks5h://127.0.0.1:1080 -I https://<内网域名>/
```

- 收到 HTTP 状态码：网络代理链路已经建立，后续问题通常属于身份、权限或应用层。
- 解析失败：确认使用的是 `socks5h`，不是 `socks5`。
- 连接超时：检查 Windows 本机是否仍能访问目标，以及安全客户端是否允许 `sshd` 进程访问。

停止代理时，在运行 `ssh -N -D` 的终端按 `Ctrl+C`。

## 安全与审计边界

- Windows OpenSSH 可能记录登录用户、时间、来源地址和认证结果。
- Windows Firewall 与 `WFP（Windows Filtering Platform，Windows 过滤平台）` 可以记录进程、连接方向、源/目标地址和端口。
- 企业零信任客户端可能记录 Windows 用户、设备、会话、目标应用和流量元数据。
- 目标服务仍可能记录账号、仓库、操作时间和服务端看到的出口信息。
- 代理连接成功不代表不可审计，也不代表组织已授权该使用方式。

## 卡片生成说明

- 生成方式：Codex 内置 `imagegen`，逐张生成；后续卡片以前一张成品作为视觉风格参考。
- 保存目录：`assets/20261018_04_openssh-socks-cards/`。
- 画布：1086 × 1448，3:4 竖版。
- 视觉规范：原创中文技术信息图、浅米白不透明背景、深海军蓝标题、蓝绿圆角信息块、少量橙色提醒、通用终端和网络图标。
- 脱敏检查：没有真实项目域名、仓库 URL、企业内网服务 IP、本机绝对路径、账号或凭据；仅保留 `192.168.137.1` 作为明确标注的 Windows 热点通用示例。
- 检查结果：已逐张核对 OpenSSH、SSH、SOCKS5、`socks5h`、`sshd`、PowerShell 命令、macOS 命令、Git 参数、占位符、监听地址和卡片尺寸。
- 人工确认风险：OpenSSH 安装入口、Windows 防火墙策略、身份认证方式和企业安全客户端策略可能因系统版本或组织配置而不同；正式发布前应在目标环境复核。

## 参考依据

- [Microsoft Support：Use your Windows device as a mobile hotspot](https://support.microsoft.com/en-us/windows/experience/connectivity-networking/use-your-windows-device-as-a-mobile-hotspot)
- [Microsoft Learn：Get started with OpenSSH Server for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?pivots=windows-11)
- [Microsoft Learn：OpenSSH Server Configuration for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh-server-configuration)
- [Microsoft Learn：Windows Filtering Platform auditing and logging](https://learn.microsoft.com/en-us/windows/win32/fwp/auditing-and-logging)
