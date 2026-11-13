# Windows Explorer DLL 注入卡死排查

## 白话结论

Explorer（文件资源管理器）反复卡死、自动重启时，不能只盯着 CPU、内存或磁盘。第三方安全、同步、输入法、显卡或外壳组件可能把 DLL 注入 Explorer；一旦注入模块在加载、卸载或互斥锁上卡住，微软系统组件也会跟着等待，看起来像是 WMI、WAM、CloudStore 或 Taskbar 出了问题。

如果确认故障来自一个已经不再需要的安全接入客户端，使用它的官方卸载器完整卸载通常是最合适的处理。但“卸载完成”必须包含服务、内核驱动、全局注入项和已加载模块的验收，不能只看主程序是否从应用列表消失。

## 本次案例抽象出的证据链

公开版只保留通用技术特征，现场软件名、服务名、驱动名、本机路径和组织信息均已脱敏。

1. WER（Windows Error Reporting，Windows 错误报告）连续产生 `AppHangB1`，Explorer 的 `Responding` 为 `False`，说明是应用假死，不是普通启动慢。
2. 明确打开本地目录可以成功，而桌面壳或默认入口会挂住，问题被缩小到 Shell（桌面壳）、命名空间、缩略图或注入组件。
3. 暂停常见第三方外壳扩展后仍能复现，说明不能把所有问题都归因于右键菜单或同步盘扩展。
4. CDB（Console Debugger，控制台调试器）调用栈先显示 WMI（Windows Management Instrumentation，Windows 管理规范）、WAM（Web Account Manager，Web 账户管理器）、CloudStore 和 Taskbar 等系统模块互相等待。
5. 继续检查所有线程，发现异常第三方 DLL 卡在互斥锁和 `LdrLoadDll` / `LdrUnloadDll`（DLL 加载与卸载）链路上。微软模块是堵点，不是最初起点。
6. 在测试 GUI 程序加载 `<注入DLL>` 的瞬间断下，返回地址落在堆内存而非正常模块代码中，符合远程或内核注入的特征。
7. 枚举运行驱动后，最终定位到一个 `SYSTEM_START`（系统初始化阶段启动）的第三方注入驱动。停止主程序或关闭 `AppInit_DLLs` 都不足以移除已经驻留的注入链。
8. 禁用或卸载完整组件、清理注入配置，并在所有改动完成后安排一次重启；重启后确认驱动未运行、Explorer 不再加载相关 DLL，才算真正切断根因。

## 为什么容易误判

### `Get-Process CPU` 不是实时 CPU

PowerShell 的 `Get-Process` 中 `CPU` 是进程启动以来累计消耗的 CPU 秒数。数值很大只能说明历史消耗高，不能证明此刻仍在占用。

实时判断应使用短时间采样，或对两次累计值做差：

```powershell
$before = (Get-Process -Id <PID>).CPU
Start-Sleep -Seconds 5
$after = (Get-Process -Id <PID>).CPU
$cpuPercent = (($after - $before) / 5 / [Environment]::ProcessorCount) * 100
```

### 调用栈顶部不一定是根因

当主线程显示在 `WMI`、`WAM`、`CloudStore`、`Taskbar.dll` 或 `combase.dll` 中等待，只能证明这些代码正在被堵。排查时要继续寻找：

- 第一个异常第三方模块；
- 长时间持有互斥锁的线程；
- 正在执行 `LdrLoadDll` 或 `LdrUnloadDll` 的线程；
- 从堆内存、匿名内存或未知地址发起的 DLL 加载；
- 在系统初始化阶段启动的第三方驱动。

### WMI 查询本身可能制造噪声

频繁调用 `Get-CimInstance Win32_Process` 或 WMI 性能类，会让 `Winmgmt` / `WmiPrvSE.exe` 暂时升高。应先用低开销进程采样，只有在已经锁定少数 PID 或驱动时才做一次针对性 CIM（Common Information Model，通用信息模型）查询。

## 建议排查流程

### 1. 先确认是否为 AppHang

```powershell
Get-WinEvent -FilterHashtable @{
  LogName   = 'Application'
  StartTime = (Get-Date).AddMinutes(-30)
  Id        = 1000, 1001, 1002
} | Where-Object {
  $_.Message -match '(?i)explorer\.exe'
}
```

`1002` 常见于 Application Hang（应用挂起），`1001` 可包含 WER 报告路径和 `AppHangB1` 签名。没有事件并不绝对代表没有假死，但有匹配事件时应优先保留现场，而不是立刻反复重启 Explorer。

### 2. 检查 Explorer 当前状态

```powershell
Get-Process explorer | Select-Object Id, StartTime, Responding, Handles, @{N='Threads';E={$_.Threads.Count}}, @{N='PrivateMB';E={[math]::Round($_.PrivateMemorySize64 / 1MB, 1)}}
```

多个 Explorer 进程不一定异常；启用“在单独的进程中打开文件夹窗口”后，桌面壳和文件夹窗口会隔离。重点看进程是否持续不响应，以及线程、句柄是否快速增长。

### 3. 用 CDB 查看模块和调用栈

先附加到挂住的 Explorer，查看所有线程：

```powershell
& '<CDB路径>\cdb.exe' -pv -p <ExplorerPID> -c '~* kb 35; q'
```

- `lm`（List Loaded Modules，列出已加载模块）用于确认进程里有哪些 DLL。
- `k` / `kb`（Display Stack Backtrace，显示调用栈回溯）用于查看当前线程在等待什么。

只验证某类注入模块是否存在：

```text
lm m *<注入模块关键字>*
```

### 4. 在 DLL 加载瞬间断下

若需要确认是谁加载了异常 DLL，可用一个系统 GUI 测试程序观察加载事件：

```powershell
& '<CDB路径>\cdb.exe' -c 'sxe ld:<注入DLL>; g; kb 40; q' "$env:SystemRoot\System32\charmap.exe"
```

`sxe ld:<注入DLL>` 会在指定 DLL 加载时中断。若 `LdrLoadDll` 的返回地址位于堆内存或匿名内存，需要进一步排查远程线程、APC（Asynchronous Procedure Call，异步过程调用）或内核注入；单凭这一点不能直接断言恶意行为。

### 5. 查运行中的系统驱动

```powershell
Get-CimInstance Win32_SystemDriver -Filter "State='Running'" |
  Select-Object Name, DisplayName, State, StartMode, PathName
```

重点关注：

- `StartMode` 为 `Boot` 或 `System` 的非微软驱动；
- 文件版本信息与故障客户端有关，但服务名看起来无关的驱动；
- 安装目录中包含 `Inject`、`Hook`、`Protect` 等功能提示的驱动；
- 主程序已经退出，但驱动仍在运行的情况。

### 6. 检查 AppInit 全局注入项

```powershell
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows' -Name LoadAppInit_DLLs, AppInit_DLLs

Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Windows' -Name LoadAppInit_DLLs, AppInit_DLLs
```

`AppInit_DLLs` 可以让自定义 DLL 进入交互式应用进程并 Hook（挂钩）API。Microsoft 明确指出，即使是合法 AppInit DLL，也可能意外造成死锁和性能问题，因此不推荐使用这种机制。

## 可以直接卸载安全接入客户端吗

可以，前提是：

1. 已确认不再依赖它访问公司网络、受控文件或业务系统；
2. 符合所在组织的终端安全与合规要求；
3. 使用“设置 → 应用”或厂商官方卸载器，不直接删除安装目录和 DLL；
4. 卸载前保存必要的账号、网络和恢复信息；
5. 所有改动集中完成后只安排一次重启，不用每改一项就重启。

如果仍需使用该客户端，应优先升级到支持当前 Windows 版本的新版本，或让维护方修复注入模块。长期关闭安全组件可能影响网络访问、数据防泄漏或合规审计。

## 卸载后的完整验收

### 服务和驱动

```powershell
Get-Service <安全客户端服务>,<注入驱动服务> -ErrorAction SilentlyContinue

Get-CimInstance Win32_SystemDriver |
  Where-Object {
    $_.Name -match '<客户端或驱动关键字>' -or
    $_.PathName -match '<客户端安装目录关键字>'
  } |
  Select-Object Name, State, StartMode, PathName
```

理想结果是对应服务和驱动已不存在；如果厂商卸载器保留了驱动，也至少应为 `Stopped` 且不是 `Boot`、`System` 或 `Auto` 启动。

### 注册表注入项

检查 64 位和 32 位 `AppInit_DLLs`，确认不再指向已卸载客户端。修改注册表前必须导出备份，不要删除其他软件共用的值。

### Explorer 模块

```text
lm m *<注入模块关键字>*
```

结果应为空。随后实际打开常用本地目录，观察 Explorer 是否持续响应，并确认没有新增 `AppHang`、应用崩溃或缩略图 DCOM（Distributed Component Object Model，分布式组件对象模型）超时。

### 业务功能

确认代理、VPN、同步盘、受控网络、打印和公司认证是否仍符合预期。卸载一个安全接入客户端不应被误解为可以关闭所有安全或网络工具。

## 卡片清单

1. `01-explorer-apphang-vs-cpu.png`：先区分 AppHang、崩溃与资源饱和。
2. `02-system-modules-vs-injection-root-cause.png`：系统模块可能只是堵点，第三方注入才是起点。
3. `03-find-hidden-injector.png`：WER、CDB、加载断点和驱动清单的证据链。
4. `04-uninstall-verification-checklist.png`：官方卸载后的完整验收清单。

## 参考资料

- Microsoft Learn：[AppInit DLLs and Secure Boot](https://learn.microsoft.com/en-us/windows/win32/dlls/secure-boot-and-appinit-dlls)
- Microsoft Learn：[Get Started with WinDbg User-Mode Debugger](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/getting-started-with-windbg)
- Microsoft Learn：[k, kb, kc, kd, kp, kP, kv (Display Stack Backtrace)](https://learn.microsoft.com/en-us/windows-hardware/drivers/debuggercmds/k--kb--kc--kd--kp--kp--kv--display-stack-backtrace-)
- Microsoft Learn：[Win32_SystemDriver class](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-systemdriver)
- Microsoft Learn：[Specifying Driver Load Order](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/specifying-driver-load-order)
- Microsoft Learn：[Windows AppHang diagnostic events](https://learn.microsoft.com/en-us/windows/privacy/basic-level-windows-diagnostic-events-and-fields-1809#hang-reporting-events)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`，逐张生成 4 张原创中文知识卡片。
- 画布：4 张均为 `1086 × 1448`，精确 3:4 竖版。
- 视觉：浅灰蓝背景、深海军蓝标题、蓝色和青绿色圆角信息块、少量橙色风险提醒。
- 脱敏：未出现真实客户端名、服务名、驱动名、组织名、项目地址、内网 IP、本机绝对路径、账号或凭据。
- 图片检查：第 1 至 3 张文字、缩写、因果关系与画布方向正确；第 4 张首次生成存在重复行且 `AppInit_DLLs` 字形易混淆，已整张重生成，最终版每项只出现一次。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 视频检查：单个 H.264 High Profile 视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长 16 秒。
- 技术风险：调用栈和堆内存返回地址只能证明加载行为异常，不能单独证明恶意；禁用或卸载安全客户端前必须确认业务依赖与组织合规要求。
