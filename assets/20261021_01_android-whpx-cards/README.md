# Android Emulator：虚拟化已启用却仍提示 WHPX 未开启

## 白话结论

任务管理器显示“虚拟化：已启用”，只说明 CPU 与固件提供的硬件虚拟化已经打开。Android Emulator 要使用 `WHPX (Windows Hypervisor Platform，Windows 虚拟机监控程序平台)`，还需要 Windows 在启动时加载 `Hypervisor（虚拟机监控程序）`，并启用 `Windows Hypervisor Platform` 可选功能。

## 五张卡片

1. `01-virtualization-enabled-but-whpx-disabled.png`：解释“底层开关已开”为什么不等于“上层平台可用”。
2. `02-three-virtualization-layers.png`：拆分硬件层、Windows 启动层与 WHPX 接口层。
3. `03-hypervisorlaunchtype-bcd.png`：说明 `hypervisorlaunchtype` 是 BCD 启动参数，不是服务名。
4. `04-enable-whpx-steps.png`：给出启用功能、修正启动参数与重启的顺序。
5. `05-verify-android-emulator-acceleration.png`：使用 `emulator -accel-check` 验证，并标注 2026 年的驱动迁移提醒。

## 技术要点

- `BCD (Boot Configuration Data，启动配置数据)` 保存 Windows 启动配置；`hypervisorlaunchtype Auto` 允许系统在启动时加载 Hypervisor，`Off` 则阻止加载。
- `hypervisorlaunchtype Auto` 只处理启动层，不代表 `Windows Hypervisor Platform` 可选功能已经安装。
- 在 PowerShell 中查询当前启动项时，应给 `{current}` 加引号：

  ```powershell
  bcdedit /enum "{current}"
  ```

- 只有在确认值为 `Off` 且确实需要 Windows Hypervisor 时，才使用管理员终端修改：

  ```powershell
  bcdedit /set hypervisorlaunchtype Auto
  ```

- 修改启动项或 Windows 可选功能后需要重启。
- Google 当前推荐 Windows 上的 Android Emulator 使用 WHPX；`AEHD (Android Emulator hypervisor driver，Android 模拟器虚拟机监控程序驱动)` 计划于 2026-12-31 停止支持。

## 参考依据

- [Android Developers：Configure hardware acceleration for the Android Emulator](https://developer.android.com/studio/run/emulator-acceleration)
- [Microsoft Learn：BCDEdit /set](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/bcdedit--set)
- [Microsoft Learn：Hyper-V host hardware requirements](https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/host-hardware-requirements)

## 卡片生成说明

- 生成方式：Codex 内置 `imagegen`，逐张生成；第 3 张因 PowerShell 的 `{current}` 引号要求进行了一次定向重做。
- 视觉规范：原创中文技术信息图、3:4 竖版、浅米白背景、深蓝高对比标题、圆角信息块、少量技术图标、无平台账号模板和水印。
- 检查结果：5 张图片均为 1086 × 1448；已逐张核对 `Intel VT-x`、`AMD-V`、`UEFI/BIOS`、`Hypervisor`、`WHPX`、`Windows Hypervisor Platform`、`BCD`、`hypervisorlaunchtype`、命令字符、英文大小写与文字归属。
- 技术边界：卡片解释的是截图所示故障的常见分层原因，不保证具体设备只存在这一处问题。WHPX 仍受 Windows 版本、CPU 的 EPT/UG 能力、系统更新、组织策略和第三方虚拟化软件版本影响。
- 安全提醒：`BCDEdit` 会修改启动配置，需要管理员权限。Microsoft 提醒某些启动项变更可能影响系统启动，并可能需要先处理 BitLocker 或 Secure Boot；实际修改前应确认设备策略与恢复密钥状态。
