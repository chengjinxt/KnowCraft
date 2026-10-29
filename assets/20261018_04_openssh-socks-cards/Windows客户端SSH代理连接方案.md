# Windows 客户端 SSH SOCKS5 代理连接方案

> **场景**：本机 Windows 无法直接访问内网 Git 服务，通过 SSH 连接跳板机 `192.168.40.64`，在本地建立 SOCKS5 代理，让 `git pull` 经由跳板机完成。

## 环境概览

| 项目 | 值 |
|------|-----|
| 本机系统 | Windows（当前机器） |
| 跳板机 IP | `192.168.40.64` |
| 跳板机 SSH 端口 | `22` |
| 跳板机登录方式 | 用户名 + 密码（`administrator`） |
| 本地 SOCKS5 监听 | `127.0.0.1:1080` |
| 目标 Git 仓库目录 | `D:\code\codehub\pc_client_h5` |
| 目标 Git Remote | `https://codehub-devops.cidc-rp-2215.4c-beta.cmecloud.cn/...` |
| 使用的 SSH 客户端 | `C:\Program Files\Git\usr\bin\ssh.exe`（Git 内置） |

## 数据流

```
本机 git pull
  → 127.0.0.1:1080（本地 SOCKS5）
  → SSH 加密隧道
  → 192.168.40.64 sshd
  → codehub-devops.cidc-rp-2215.4c-beta.cmecloud.cn（内网 Git 服务）
```

> [!NOTE]
> `socks5h` 中的 **h** 表示 hostname 由代理端（跳板机）解析，本机不需要能解析内网域名。

---

## 快速上手（两步走）

### 第一步：启动 SOCKS5 代理

**方式 A：双击脚本（最简单）**

双击运行 [`start-socks-proxy.bat`](file:///d:/PerSourceCodeStore/github/chengjinxt/tmp/start-socks-proxy.bat)，按提示输入跳板机密码，**保持窗口开着不要关**。

**方式 B：手动在命令行执行**

打开任意终端（cmd / PowerShell / Git Bash），执行：

```bash
"C:\Program Files\Git\usr\bin\ssh.exe" -N -D 127.0.0.1:1080 administrator@192.168.40.64
```

- `-N`：不执行远端命令，只建立转发隧道
- `-D 127.0.0.1:1080`：在本机 1080 端口监听 SOCKS5，仅本机可用
- 输入密码后终端挂起——这是正常状态，说明隧道已建立

---

### 第二步：执行 git pull

**方式 A：双击脚本（最简单）**

双击运行 [`git-pull-via-proxy.bat`](file:///d:/PerSourceCodeStore/github/chengjinxt/tmp/git-pull-via-proxy.bat)

**方式 B：手动命令（单次临时使用）**

```bash
cd D:\code\codehub\pc_client_h5

git -c http.proxy=socks5h://127.0.0.1:1080 -c http.sslBackend=openssl -c http.sslVerify=false pull
```

**方式 C：配置仓库级代理（长期使用）**

在仓库目录下执行一次，之后 `git pull` 直接用（需保持代理隧道运行）：

```bash
cd D:\code\codehub\pc_client_h5

git config --local http.proxy socks5h://127.0.0.1:1080
git config --local http.sslBackend openssl
git config --local http.sslVerify false
```

之后直接 `git pull` 即可。

取消仓库级代理：

```bash
git config --local --unset http.proxy
git config --local --unset http.sslBackend
git config --local --unset http.sslVerify
```

---

## 为什么需要 `http.sslBackend=openssl`？

本机 git 默认使用 `schannel`（Windows 系统 TLS）：

```
http.sslbackend=schannel
```

`schannel` 依赖 Windows 证书信任链，当内网 Git 服务使用私有 CA 颁发的证书时会报：

```
schannel: failed to receive handshake, SSL/TLS connection failed
```

切换到 `openssl` 后，TLS 由跳板机侧完成，本机绕过 schannel 限制。`http.sslVerify=false` 在确认是内网受信服务的前提下使用，可避免证书验证问题。

> [!WARNING]
> `http.sslVerify=false` 会跳过 TLS 证书校验，仅对受信内网服务使用，不要配置到 `--global`。

---

## 验证代理是否正常

代理启动后，在新终端运行以下命令验证链路：

```bash
# curl（Git Bash 中运行）
curl --proxy socks5h://127.0.0.1:1080 -I https://codehub-devops.cidc-rp-2215.4c-beta.cmecloud.cn/

# PowerShell 验证本地 1080 端口在监听
netstat -ano | Select-String ":1080"
```

收到 HTTP 状态码（如 `HTTP/2 200` 或 `HTTP/2 302`）即说明代理链路完整。

---

## 停止代理

在运行 `ssh -N -D` 的终端按 `Ctrl+C`，或直接关闭窗口。

---

## 分层排查

### 1. 确认跳板机 SSH 可达

```powershell
Test-NetConnection -ComputerName 192.168.40.64 -Port 22
```

`TcpTestSucceeded: True` 才能继续。

### 2. 测试 SSH 登录

```bash
"C:\Program Files\Git\usr\bin\ssh.exe" administrator@192.168.40.64
```

首次连接需输入 `yes` 接受主机指纹，确认能登录后再运行代理命令。

### 3. 检查本地 1080 端口监听

```powershell
netstat -ano | Select-String ":1080"
```

期望看到 `127.0.0.1:1080` 处于 LISTENING 状态。

### 4. 测试代理访问目标

```bash
# Git Bash 中
curl -v --proxy socks5h://127.0.0.1:1080 https://codehub-devops.cidc-rp-2215.4c-beta.cmecloud.cn/
```

- 收到 HTTP 响应 → 代理链路正常
- `Connection refused` at 1080 → SSH 隧道未建立，检查第一步
- `Could not resolve host` → 检查是否用了 `socks5h`（不是 `socks5`）

### 5. 常见 git pull 错误

| 错误信息 | 原因 | 解决 |
|---------|------|------|
| `schannel: failed to receive handshake` | sslBackend 为 schannel，证书不信任 | 加 `-c http.sslBackend=openssl -c http.sslVerify=false` |
| `Connection refused 127.0.0.1:1080` | SOCKS5 代理未启动 | 先运行第一步建立隧道 |
| `Could not resolve proxy` | proxy 写错了 | 确认格式 `socks5h://127.0.0.1:1080` |
| `Permission denied` on SSH | 密码错误或用户名错误 | 检查 `administrator` 和密码 |
| `Connection timed out` on SSH | 跳板机防火墙或网络问题 | 先 `Test-NetConnection 192.168.40.64 22` |

---

## 进阶：使用公钥免密登录（可选）

每次启动代理都要输入密码比较麻烦，可以配置 SSH 公钥认证：

```bash
# Git Bash 中生成密钥（如果没有）
ssh-keygen -t ed25519 -C "local-to-jumper" -f ~/.ssh/id_ed25519_jumper

# 把公钥上传到跳板机（需要一次密码）
ssh-copy-id -i ~/.ssh/id_ed25519_jumper.pub administrator@192.168.40.64
# 如果 ssh-copy-id 不可用，手动操作：
cat ~/.ssh/id_ed25519_jumper.pub | "C:\Program Files\Git\usr\bin\ssh.exe" administrator@192.168.40.64 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

然后在 `~/.ssh/config`（`C:\Users\Administrator\.ssh\config`）中添加：

```
Host jumper-40.64
    HostName 192.168.40.64
    User administrator
    IdentityFile ~/.ssh/id_ed25519_jumper
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

之后启动代理只需：

```bash
"C:\Program Files\Git\usr\bin\ssh.exe" -N -D 127.0.0.1:1080 jumper-40.64
```

---

## 附：辅助脚本说明

| 文件 | 说明 |
|------|------|
| [`start-socks-proxy.bat`](file:///d:/PerSourceCodeStore/github/chengjinxt/tmp/start-socks-proxy.bat) | 启动 SSH SOCKS5 代理隧道，双击运行并输入密码 |
| [`git-pull-via-proxy.bat`](file:///d:/PerSourceCodeStore/github/chengjinxt/tmp/git-pull-via-proxy.bat) | 通过代理执行 git pull，需先运行代理脚本 |

> [!IMPORTANT]
> 两个窗口需同时保持：一个运行代理（`start-socks-proxy.bat`），另一个执行 `git pull`。

---

## 安全说明

- SSH 隧道本身是加密的，数据在传输过程中受保护。
- SOCKS5 代理绑定在 `127.0.0.1`，仅本机可用，不向局域网开放。
- `http.sslVerify=false` 仅配置在仓库级别（`--local`），不影响其他仓库。
- 仅在组织和网络管理员授权的情况下使用此方案。
