# Everything 点击或滚动后卡住：UI Automation 与 lvm

## 白话结论

`lvm` 是 Everything 的 `List View Messages`（列表视图消息）设置。它管的不是文件索引，而是外部程序能否通过列表消息读取搜索结果。

- `lvm=1`：兼容屏幕阅读器、自动化测试和其他辅助工具读取结果列表。
- `lvm=0`：限制这类列表消息，可规避某些外部工具一次枚举大量结果时造成的界面卡死和内存上涨。

它不是“搜索开关”，不会删除 `Everything.db`，也不会让 Everything 停止建立索引。

## 本次问题如何定位

现场表现不是单纯“电脑慢”：

1. Everything 在点击或滚动结果列表后进入 `Not Responding（未响应）`。
2. 实时磁盘读写接近空闲，但进程私有内存持续上涨。
3. 系统事件记录为 `AppHangTransient`，说明界面消息一度无法及时处理。
4. 卡住当下抓到的主界面线程位于 `UIAutomationCore.dll`，调用链包含 `UiaReturnRawElementProvider` 和 ListView 消息处理。
5. 该轮请求结束后，主线程回到 `NtUserWaitMessage`，界面自行恢复。

这组证据说明：外部 `UI Automation（用户界面自动化）` 客户端读取搜索结果时，Everything 在主界面线程处理了过重的列表请求。它与 CPU 总占用、磁盘占用或索引数据库损坏不是同一类问题。

## 为什么点击一下就可能触发

Windows 的标准列表控件会向屏幕阅读器、自动化测试工具和桌面辅助程序暴露项目。搜索结果很多时，某些客户端可能尝试读取全部项目，而不只是当前可见的几行。

Everything 的结果列表由界面线程提供信息。如果外部请求规模过大，就可能出现：

```text
外部 UI Automation 客户端
        ↓
请求大量 ListView 项目
        ↓
Everything 主界面线程持续生成结果信息
        ↓
点击、滚动和重绘无法及时响应
        ↓
Windows 显示“未响应”，内存持续上涨
```

`lvm=0` 的作用，是阻止或限制这条 List View Messages 链路，而不是重建索引。

## 在哪里设置 lvm

### 方法一：搜索框命令

这是 Everything 1.4 和 1.5 都可以优先尝试的方法：

```text
/lvm=0
```

在 Everything 搜索框输入后按 `Enter`。成功时，状态栏会短暂显示 `lvm=0`。

恢复默认兼容行为时输入：

```text
/lvm=1
```

### 方法二：新版高级设置界面

在提供高级设置界面的版本中：

1. 打开“工具 → 选项 → 高级”。
2. 搜索 `lvm`。
3. 将值设为 `false`。
4. 确认后重新验证点击和滚动。

旧版界面不一定提供相同的“高级”页面，因此优先使用搜索框命令。

### 方法三：Everything.ini

常见配置位置是：

```text
%APPDATA%\Everything\Everything.ini
```

先彻底退出 Everything（包括托盘进程），再写入：

```ini
lvm=0
```

如果“将设置和数据保存在 `%APPDATA%\Everything`”未启用，`Everything.ini` 可能位于 `Everything.exe` 同目录。应先确认实际生效的配置文件，不要同时修改多个副本。

## lvm 与 allow_lvm 不要混淆

Everything 1.5 还提供 `allow_lvm` 策略项。官方资料将它描述为是否允许 `ListView Messages` 的程序目录级设置，通常只能放在 `Everything.exe` 同目录的 `Everything.ini` 中。

本次现场实际存在并生效的是用户配置 `lvm=0`。排查旧版 Everything 时，不要因为在新版文档里看到 `allow_lvm`，就直接把两个名称当成完全相同的配置项。

## 验证清单

修改后不要只确认“窗口能打开”，还要复现原操作：

1. 使用一个能产生较多结果的关键词搜索。
2. 单击结果列表中的项目。
3. 连续滚动列表。
4. 观察 `Responding` 是否保持为 `True`。
5. 观察私有内存是否稳定，而不是持续快速上涨。
6. 必要时向主窗口发送轻量消息或抓取线程栈，确认 UI 线程仍能处理消息。

本次修复后，搜索、单击及连续消息检测均保持响应，内存保持稳定，没有重现原来的持续增长。

## 仍然卡住怎么办

`lvm=0` 只针对 ListView/UI Automation 触发链。以下问题需要分别排查：

- 主线程卡在第三方 Shell Extension（资源管理器外壳扩展）中。
- 磁盘或索引数据库出现真实 I/O 阻塞。
- Everything 正在执行大规模排序、内容搜索或重建索引。
- 预览处理器、图标处理器或上下文菜单扩展卡住。
- 另一个版本缺陷或不同的 UI Automation 调用链。

若设置后仍卡住，应在卡住当下保存 `mini dump（小型转储）` 或线程栈。进程恢复后的栈只能说明当前状态，不能代替现场证据。

## 可访问性边界

Everything 开发者强调，ListView 消息对屏幕阅读器很重要。因此 `lvm=0` 是有取舍的规避方案：普通鼠标、键盘搜索和打开文件不受影响，但依赖完整结果列表的无障碍或自动化工具可能无法读取全部项目。

如果正在使用屏幕阅读器，应先验证核心操作是否仍可完成，再决定是否长期保留该设置。

## 图片清单

1. `01-everything-hang-clues.png`：点击即卡时应关注的现场证据。
2. `02-what-is-lvm.png`：`lvm=1`、风险与 `lvm=0` 的作用边界。
3. `03-set-lvm-zero.png`：搜索框、图形界面和配置文件三种入口。
4. `04-verify-everything-fix.png`：修复后的复现验证与残余风险。

## 生成方式与检查结果

- 四张图片使用生成式图片工具逐张生成，统一为 3:4 竖版浅色技术信息图。
- 第三张首次生成把三种设置入口都写成 1.4/1.5 完全通用，存在版本边界歧义，因此未采用；最终版明确搜索框命令通用，而高级设置界面属于新版入口。
- 已逐张检查 `Everything`、`UI Automation`、`UIAutomationCore.dll`、`ListView`、`lvm=0`、`/lvm=0`、`Responding=True`、`%APPDATA%\Everything\Everything.ini` 的大小写和符号。
- 卡片不包含真实用户名、盘符、PID、组织信息、内部路径或凭据。

## 技术风险

- 官方论坛中的 `lvm=0` 是针对特定 UI Automation/ListView 卡顿的规避方案，不代表所有 Everything 未响应问题的统一修复。
- Everything 版本、配置保存位置和高级设置页面可能不同，应以实际版本界面和生效配置为准。
- 手工修改 `Everything.ini` 前应退出程序并备份文件，避免退出时被旧配置覆盖。
- 若需要完整屏幕阅读器支持，应谨慎关闭 LVM，并进行实际可访问性验证。

## 参考资料

- voidtools 开发者建议：[Repeated “Not Responding” when searching or selecting results](https://www.voidtools.com/forum/viewtopic.php?p=84071)
- voidtools 现场讨论：[Everything suddenly hangs when clicking or scrolling](https://voidtools.com/forum/viewtopic.php?p=84008)
- voidtools 配置说明：[INI Settings](https://www.voidtools.com/forum/viewtopic.php?p=36924)
