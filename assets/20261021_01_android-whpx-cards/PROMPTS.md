# Android Emulator WHPX 知识卡提示词

## 补档说明

- 这组图片早于 `PROMPTS.md` 强制归档规则，原始逐字提示词未随图片保存，不能可靠还原。
- 以下内容依据最终成品与 `README.md` 中可核实的生成记录整理为“复现提示词”，用于说明最终图片的视觉和文案要求，不冒充当时的原始输入。
- 可核实记录只说明 5 张图片由 Codex 内置 `imagegen` 逐张生成，未注明使用外部输入图片。本次补档没有调用生成式图片工具，也没有把现有图片作为编辑输入。
- `README.md` 明确记录第 3 张曾因 PowerShell 中 `"{current}"` 的引号要求定向重做；该修订目的单独记录在文末。

## 统一视觉规范

- 原创中文技术信息图，3:4 竖版，浅米白方格纸背景，深海军蓝高对比标题。
- 采用蓝色、紫色、绿色、黄色和珊瑚红作状态区分；使用圆角信息块、粗描边、柔和阴影和少量扁平技术图标。
- 一张卡只讲一个中心问题，标题醒目，正文使用简体中文，英文术语、缩写和命令保持原样。
- 所有关键文字直接绘制在图片中，保证手机端可读；不出现平台标识、水印、真实账号、地址、路径、凭据或组织标识。
- 系列内保持同一套排版、配色、图标质感与信息层级。

## 01-virtualization-enabled-but-whpx-disabled.png

> 生成一张 3:4 竖版中文知识卡，标题写“虚拟化已启用，为什么还报错？”。副标题写“任务管理器只证明了第一层”。主体按从上到下的三层链路展示：第一层“Intel VT-x（英特尔硬件虚拟化扩展）”，绿色状态“已启用”，配 CPU 图标；第二层“Hypervisor（虚拟机监控程序）”，红色状态“可能未在启动时加载”，配 Windows 笔记本图标；第三层“WHPX (Windows Hypervisor Platform，Windows 虚拟机监控程序平台)”，红色状态“仍可能不可用”，配 Android 窗口图标。层间使用向下箭头。底部黄色结论条写“底层开关 ≠ 上层平台可用”。使用浅米白方格纸背景、深海军蓝标题、蓝紫圆角信息块和醒目的红绿状态色。

## 02-three-virtualization-layers.png

> 延续同系列 3:4 竖版视觉，标题写“三层开关，缺一层都可能报错”。主体按顺序展示三个圆角大模块：1.“硬件层”，标注“Intel VT-x / AMD-V”和“CPU 与 UEFI/BIOS 提供虚拟化能力”，配 CPU 与 UEFI/BIOS 图标；2.“启动层”，标注“Hypervisor（虚拟机监控程序）”和“由 Windows 启动配置决定是否加载”，配设置面板图标；3.“接口层”，标注“WHPX (Windows Hypervisor Platform，Windows 虚拟机监控程序平台)”和“让 Android Emulator 使用 Windows 的虚拟化能力”，配 Android 显示器和 WHPX 标签。三个模块用向下箭头连接。底部蓝色结论条写“任务管理器只覆盖第 1 层”。

## 03-hypervisorlaunchtype-bcd.png

> 延续同系列 3:4 竖版视觉，标题分两行写“hypervisorlaunchtype”“不是服务名”。说明文字写“它是 BCD (Boot Configuration Data，启动配置数据) 里的启动参数”，中部用 BCD 文件指向 Windows 显示器。下方左右对比：绿色 `Auto` 表示“允许 Windows 启动时加载 Hypervisor”，红色 `Off` 表示“阻止 Hypervisor 在启动时加载”。再放两个终端命令块：查看区标题“查看（管理员 CMD / PowerShell）”，命令必须逐字写成 `bcdedit /enum "{current}"`；设置区标题“设置（仅确认 Off 时）”，命令必须逐字写成 `bcdedit /set hypervisorlaunchtype Auto`。底部黄色提醒条写“改完必须重启”和“Auto ≠ 已安装 WHPX”。命令、引号、花括号、英文大小写必须准确。

## 04-enable-whpx-steps.png

> 延续同系列 3:4 竖版视觉，标题写“正确修复顺序”。主体按 1 到 4 排列：1.“打开‘启用或关闭 Windows 功能’”，配 Windows 搜索框；2.“勾选 Windows Hypervisor Platform”，配可选功能列表和已勾选框；3.“若启动项为 Off，再用管理员终端设置”，终端命令必须逐字写成 `bcdedit /set hypervisorlaunchtype Auto`；4.“重启 Windows”，随后“重启后再打开 Android Studio”，用箭头连接重启电脑与 Android Studio。底部浅紫提示条写“不用先安装完整的 Hyper-V”。步骤编号、状态词 `Off`、`Auto` 和命令大小写必须准确。

## 05-verify-android-emulator-acceleration.png

> 延续同系列 3:4 竖版视觉，标题写“别只看警告消失，要验证”。副标题写“在 Android SDK 的 emulator 目录运行”。主体终端窗口逐字显示 `emulator -accel-check`。绿色成功区写“看到这句才算可用”，并显示 `WHPX(...) is installed and usable.`。黄色排查区标题写“仍失败再查”，分三栏写“Windows 版本与更新”“CPU 是否支持 EPT / UG”“第三方虚拟化软件是否过旧”，分别配 Windows、CPU 和虚拟机图标。底部蓝色提醒区写“2026 提醒”，列出“Google 官方推荐 WHPX”和“AEHD 将于 2026-12-31 停止支持”。英文缩写、命令、日期和标点必须准确。

## 可核实的定向修订

### 第 3 张：PowerShell 当前启动项引号

> 保持第 3 张其余版式和文案不变，只修正“查看”命令。PowerShell 中当前启动项标识必须用双引号包住，最终命令逐字显示为 `bcdedit /enum "{current}"`。不要漏掉双引号、花括号或把 `current` 改成其他文字。
