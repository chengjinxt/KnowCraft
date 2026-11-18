# Android 模拟器WHPX 未开启问题排查

## 三层都要打开

任务管理器显示“虚拟化：已启用”，只证明硬件层已打开。Android Emulator（Android 模拟器）使用 WHPX (Windows Hypervisor Platform，Windows 虚拟机监控程序平台) 时，还需要 Windows 加载 Hypervisor（虚拟机监控程序），并安装 WHPX 可选功能。

## 按顺序修复

1. 在“启用或关闭 Windows 功能”中勾选同名功能。
2. 用管理员 PowerShell 查看 BCD (Boot Configuration Data，启动配置数据)：

```powershell
bcdedit /enum "{current}"
```

仅当结果为 `Off` 时设置：

```powershell
bcdedit /set hypervisorlaunchtype Auto
```

3. 重启 Windows。

## 验证结果

在 Android SDK 的 `emulator` 目录运行：

```powershell
emulator -accel-check
```

看到 `WHPX(...) is installed and usable.` 才算可用。失败再查 Windows 更新、CPU 能力和第三方软件兼容性。AEHD (Android Emulator hypervisor driver，Android 模拟器虚拟机监控程序驱动) 将于 2026-12-31 停止支持。
