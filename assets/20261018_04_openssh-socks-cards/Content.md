# Windows OpenSSH代理指南

## 它能解决什么问题

Windows 本机能访问内网，不代表热点下的 Mac 也能直接访问。企业安全客户端可能只接管 Windows 本机进程。

OpenSSH Server 可以让 Mac 通过 SSH（Secure Shell，安全外壳协议）连接 Windows，再用 Dynamic Port Forwarding（动态端口转发）建立本地 SOCKS5 代理，由 Windows 的 `sshd` 发起目标连接。

## Windows 开通服务

在“设置 → 系统 → 可选功能 → 查看功能”中安装 OpenSSH Server，然后使用管理员 PowerShell 执行：

```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
Get-Service sshd
Get-NetFirewallRule -Name OpenSSH-Server-In-TCP
```

确认状态为 `Running`，保留防火墙，只允许可信设备访问 TCP 22。

## Mac 建立代理

Mac 连接 Windows 热点后，先测试 SSH：

```bash
ssh <Windows用户名>@<Windows热点IP>
```

核对主机指纹并登录，再建立代理：

```bash
ssh -N -D 127.0.0.1:1080 <Windows用户名>@<Windows热点IP>
```

`-N` 表示只转发，`-D` 表示创建动态代理。绑定 `127.0.0.1` 可避免向局域网开放代理。

## 让 Git 使用代理

先验证目标是否响应：

```bash
curl --proxy socks5h://127.0.0.1:1080 -I https://<内网域名>/
```

再让单次 Git 命令使用代理：

```bash
git -c http.proxy=socks5h://127.0.0.1:1080 pull
```

`socks5h` 会把域名交给 Windows 解析，可避开 Mac 无法使用私有 DNS 的问题。优先单次配置，不要先设置全局代理。

## 排查与安全

失败时依次检查：`sshd` 是否运行、TCP 22 是否可达、本地是否监听 `127.0.0.1:1080`、代理是否收到 HTTP 响应。停止代理时，在 `ssh -N -D` 终端按 `Ctrl+C`。

这种方式可能被 Windows、OpenSSH、企业安全客户端和内网服务记录。它不是隐藏访问的方法，只能在获得组织授权后使用。
