# Windows、Linux 与 macOS 端口占用排查卡片

本目录包含四张原创竖版知识卡片：

- `01-windows-port-process.png`：使用 PowerShell 从 TCP/UDP 端口找到 PID 和进程，并结束对应进程。
- `02-linux-port-process.png`：使用 `ss`、`ps` 和 `kill` 排查 Linux 监听端口。
- `03-macos-port-process.png`：使用 `lsof`、`ps` 和 `kill` 排查 macOS 端口占用。
- `04-windows-cmd-port-process.png`：使用 Windows CMD 的 `netstat`、`tasklist` 和 `taskkill` 排查并结束端口占用进程。

## 通用思路

```text
Port（端口）→ Socket（套接字）→ PID（进程标识符）→ Process（进程）
```

先查出哪个进程拥有目标监听套接字，再核对进程名、用户和命令行，最后决定是否结束。不要看到 PID 后立即强制终止，因为端口可能属于数据库、容器、系统服务或其他重要程序。

卡片统一使用 `8080` 作为示例端口。实际使用时替换为需要排查的端口号。

## Windows：PowerShell

### 1. 查 TCP 监听端口

```powershell
$port = 8080
$connections = Get-NetTCPConnection -LocalPort $port -State Listen
$processIds = $connections.OwningProcess | Sort-Object -Unique
```

`OwningProcess（占用进程）` 属性保存拥有该 TCP 连接的 PID。这里使用 `$processIds`，不要使用 `$pid`：PowerShell 变量名不区分大小写，而 `$PID` 是当前 PowerShell 进程的自动变量。

### 2. 核对连接和进程

```powershell
$connections
Get-Process -Id $processIds
```

### 3. 结束进程

```powershell
Stop-Process -Id $processIds
```

如果目标不是当前用户拥有的进程，管理员 PowerShell 可能要求确认。`-Force` 的含义是跳过确认：

```powershell
Stop-Process -Id $processIds -Force
```

`Stop-Process` 使用进程终止机制，并不保证应用有机会像收到 `SIGTERM` 那样进行正常清理；`-Force` 也不是 Windows 版 `SIGKILL`，它主要用于取消确认提示。

### UDP

UDP 没有 TCP 的 `Listen` 状态，可以查询绑定的 UDP Endpoint：

```powershell
$udpEndpoints = Get-NetUDPEndpoint -LocalPort $port
$udpProcessIds = $udpEndpoints.OwningProcess | Sort-Object -Unique
$udpEndpoints
Get-Process -Id $udpProcessIds
```

## Windows：CMD（命令提示符）

`CMD (Command Prompt，命令提示符)` 可以通过系统自带的 `netstat`、`tasklist` 和 `taskkill` 完成相同排查。

### 1. 查 TCP 监听端口

```cmd
netstat -ano -p tcp | findstr ":8080" | findstr LISTENING
```

- `-a`：显示活动连接及正在监听的 TCP/UDP 端口。
- `-n`：直接显示数字形式的地址和端口。
- `-o`：显示拥有连接的 `PID (Process Identifier，进程标识符)`。
- `-p tcp`：只显示 TCP。

重点查看 `Local Address（本地地址）`、`State（状态）` 和最右侧 PID。`findstr` 只是文本筛选，可能把 `80800` 等文本也匹配出来，因此必须确认 `Local Address` 中的端口正好是 `8080`。

### 2. 用 PID 核对进程

```cmd
tasklist /FI "PID eq 12345"
```

把 `12345` 替换为上一步查到的 PID。确认进程名称符合预期后再继续。

### 3. 结束进程

先尝试普通结束：

```cmd
taskkill /PID 12345
```

如果进程仍不退出，再考虑强制结束：

```cmd
taskkill /F /PID 12345
```

`/F (Force，强制结束)` 会强制终止目标进程；`/T` 还会结束该进程启动的子进程，使用前要确认影响范围。系统进程或其他用户的进程通常需要在管理员 CMD 中操作。

### UDP

```cmd
netstat -ano -p udp | findstr ":8080"
```

UDP 没有 TCP 的 `LISTENING（监听中）` 状态列。找到 PID 后，仍使用 `tasklist` 核对，并在确认无误后决定是否执行 `taskkill`。

结束进程后重新运行查询命令；目标端口记录消失，才表示这次占用已释放。

## Linux：ss、ps 与 kill

### 1. 查 TCP 监听端口

```bash
sudo ss -ltnp 'sport = :8080'
```

- `-l`：只显示监听套接字。
- `-t`：显示 TCP。
- `-n`：以数字显示地址和端口，不解析服务名。
- `-p`：显示使用套接字的进程。
- `sport`：匹配 Source Port（源端口），对监听套接字即本地端口。

UDP：

```bash
sudo ss -lunp 'sport = :8080'
```

### 2. 核对 PID

```bash
ps -fp 12345
```

### 3. 先发 SIGTERM

```bash
kill -TERM 12345
```

`SIGTERM (Signal Terminate，请求终止信号)` 允许进程捕获信号并尝试保存状态、关闭连接和清理资源。

### 4. 确认仍不退出，再发 SIGKILL

```bash
kill -KILL 12345
```

`SIGKILL (Signal Kill，强制终止信号)` 不能被进程捕获或忽略，进程没有机会自行清理，因此只应作为最后手段。结束其他用户的进程时可能需要 `sudo kill ...`。

## macOS：lsof、ps 与 kill

`lsof (List Open Files，列出已打开文件)` 可以列出进程打开的网络套接字。

### 1. 查 TCP 监听端口

```bash
sudo lsof -nP -iTCP:8080 -sTCP:LISTEN
```

- `-n`：不解析主机名。
- `-P`：不把端口号转换成服务名。
- `-iTCP:8080`：筛选 TCP 端口 8080。
- `-sTCP:LISTEN`：只保留 TCP 监听套接字。

UDP：

```bash
sudo lsof -nP -iUDP:8080
```

只输出 PID：

```bash
lsof -tiTCP:8080 -sTCP:LISTEN
```

### 2. 核对并结束

```bash
ps -p 12345 -o pid,user,comm,args
kill -TERM 12345
```

确认进程拒绝退出后，才考虑：

```bash
sudo kill -KILL 12345
```

## 常见误区

- `TCP (Transmission Control Protocol，传输控制协议)` 有连接状态；`UDP (User Datagram Protocol，用户数据报协议)` 没有 TCP 式的 `LISTEN` 状态。
- 同一端口可能因为 IPv4/IPv6、多个本地地址或端口复用显示多条记录，应核对所有 PID。
- 结束进程后重新运行查询命令。TCP 的 `TIME-WAIT` 连接短时间仍可能出现，但它不是监听进程，通常不需要继续杀进程。
- 如果进程由 Windows Service、`systemd`、Docker、Kubernetes 或 macOS `launchd` 管理，管理器可能立即重新拉起它。此时应优先通过对应的服务或容器管理命令停止工作负载。
- 查看其他用户或系统进程通常需要管理员权限或 `sudo`。
- 强制结束进程可能造成未保存数据丢失、文件损坏或依赖服务异常。

## 参考依据

- [Microsoft Learn：Get-NetTCPConnection](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-nettcpconnection)
- [Microsoft Learn：Get-NetUDPEndpoint](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netudpendpoint)
- [Microsoft Learn：Stop-Process](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/stop-process)
- [Microsoft Learn：netstat](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netstat)
- [Microsoft Learn：tasklist](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tasklist)
- [Microsoft Learn：taskkill](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/taskkill)
- [iproute2 官方 ss 手册](https://github.com/iproute2/iproute2/blob/main/man/man8/ss.8)
- [Linux kill(1) 手册](https://man7.org/linux/man-pages/man1/kill.1.html)
- [lsof 官方教程](https://github.com/lsof-org/lsof/blob/master/docs/tutorial.md)

## 生成与检查

- 生成方式：Codex 内置 `imagegen`。
- 版式：`3:4` 竖版、浅色不透明背景、高对比标题、圆角步骤块。
- 完整最终提示词保存在 `PROMPTS.md`。
- 已逐张检查命令中的大小写、美元符号、冒号、单引号、连字符、管道符和参数。
- Windows 与 macOS 首稿因命令视觉断行及透明边缘被弃用，没有写入本目录；最终版本已改为完整单行命令和不透明背景。
- 本机为 Windows 环境：PowerShell 命令进行了语法级复查；CMD 的 `netstat` 监听查询及 `tasklist /FI` 过滤已做只读实测，没有实际执行 `taskkill`；Linux/macOS 命令依据各工具官方手册静态核对，未在对应操作系统上实际结束进程。
