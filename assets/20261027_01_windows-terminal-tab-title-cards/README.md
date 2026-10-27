# Windows Terminal 多窗格固定选项卡名称

## 白话结论

一个 Windows Terminal（Windows 终端）选项卡可以包含多个 Pane（窗格）。默认情况下，选项卡会显示当前聚焦窗格的标题。因此，只在第一个窗格上添加标题还不够；切换到其他窗格后，选项卡名称仍可能改变。

要让名称稳定，需要给初始窗格和每一个 `split-pane` 都传入相同的：

```text
--title "%TAB_TITLE%" --suppressApplicationTitle
```

`--title` 负责设置标题，`--suppressApplicationTitle` 负责阻止 Shell（命令行解释器）或前台程序发送新的 Application Title（应用标题）并覆盖它。

## 卡片清单

1. `01-why-tab-title-changes.png`：解释一个 Tab（选项卡）包含多个 Pane（窗格），以及标题为什么随焦点变化。
2. `02-title-and-suppress.png`：说明 `--title` 和 `--suppressApplicationTitle` 的分工。
3. `03-same-title-for-all-panes.png`：展示 4 个窗格共用同一标题变量和标题参数的写法。
4. `04-launcher-not-snapshot.png`：区分 BAT 启动脚本与会话快照，说明脚本能重建和不能保存的内容。

## 原脚本已经保存了什么

这类 BAT (Batch File，批处理文件) 脚本通常把多个 `wt` 子命令用分号连接：

- 第一个命令创建初始窗格；没有显式写 `new-tab` 时，`wt` 默认按新建选项卡处理。
- `split-pane` 在当前选项卡中拆分新窗格。
- `-d` 或 `--startingDirectory` 设置窗格的 Starting Directory（启动目录）。
- `move-focus` 移动当前焦点，决定下一次拆分作用于哪个窗格。
- `-V`、`-H` 控制拆分方向。

所以原脚本已经记录了“打开哪些目录”和“怎样拆成 4 个窗格”，但没有把选项卡标题作为启动参数保存下来。

## 为什么只设置一次不够

Windows Terminal 的选项卡包含多个窗格时，默认使用当前聚焦窗格的标题作为可见选项卡标题。每个窗格又可以接收来自 Shell 或前台程序的标题变化消息。

这会产生两层变化：

1. 切换焦点后，选项卡开始展示另一个窗格的标题。
2. 即使已经通过 `--title` 设置初始标题，Shell 或程序仍可能再次修改该窗格的标题。

因此，多窗格场景需要同时满足：

- 每个窗格都使用相同的 `--title`。
- 每个窗格都使用 `--suppressApplicationTitle`，避免应用覆盖。

## 可复用的脱敏模板

下面的示例保留 4 窗格布局，但使用公开发布占位符，不包含真实仓库路径：

```bat
@echo off
set "TAB_TITLE=dev"

wt --title "%TAB_TITLE%" --suppressApplicationTitle -d "<仓库目录>\client" cmd ^
 ; split-pane -V --title "%TAB_TITLE%" --suppressApplicationTitle -d "<仓库目录>\service" cmd ^
 ; move-focus left ^
 ; split-pane -H --title "%TAB_TITLE%" --suppressApplicationTitle -d "<仓库目录>\desktop" cmd ^
 ; move-focus right ^
 ; split-pane -H --title "%TAB_TITLE%" --suppressApplicationTitle -d "<仓库目录>\web" cmd
```

需要创建另一个用途的布局时，只要复制脚本并修改：

```bat
set "TAB_TITLE=test"
```

### 参数解释

- `set "TAB_TITLE=dev"`：把名称集中保存到一个环境变量中，避免在命令里重复写死。
- `--title "%TAB_TITLE%"`：为新建的窗格指定标题。
- `--suppressApplicationTitle`：把该窗格的 `suppressApplicationTitle` 行为覆盖为 `true`，忽略应用发送的标题变化消息。
- `cmd`：在窗格中启动 CMD (Command Prompt，命令提示符)。
- `^`：CMD 的续行符，必须是这一行最后一个字符，后面不能带空格。
- `;`：Windows Terminal 命令行内部的子命令分隔符。在 BAT / CMD 中可以直接使用；在 PowerShell 中需要额外转义。

## 它不是会话快照

BAT 脚本保存的是“怎样重新创建终端”的规则，包括：

- Layout（布局）。
- Starting Directory（启动目录）。
- Tab Title（选项卡标题）。
- 使用哪个 Shell 或执行什么启动命令。

它不会自动保存：

- 已输入的命令。
- 当前正在运行的进程。
- 环境中尚未写回磁盘的状态。
- 终端滚动历史。
- 在 Windows Terminal 界面中临时手工修改、但没有写回 BAT 的名称。

关闭后再次执行脚本，是按相同规则重新创建，不是恢复原来的运行现场。

## 常见问题

### 添加 `--title` 后仍会变名

检查每个 `split-pane` 是否也添加了 `--title`，并确认同时使用了 `--suppressApplicationTitle`。只修改初始窗格，切换焦点后仍会显示其他窗格的标题。

### 脚本运行到一半或参数被截断

检查续行符 `^` 后面是否存在空格。为了排除续行问题，也可以先把整条 `wt` 命令写成一行测试。

### 脚本打开到已有窗口而不是新窗口

Windows Terminal 的 `windowingBehavior` 设置会影响默认行为。如果必须每次创建独立窗口，可以明确使用 `wt -w new ...`；这属于窗口复用策略，与标题参数是两个不同问题。

### 想让所有终端配置都固定标题

可以在 Windows Terminal Profile（配置文件）的 `settings.json` 中设置 `tabTitle` 和 `suppressApplicationTitle`。不过这会影响使用该 Profile 的其他终端。仅针对这两个启动脚本时，把参数写在 BAT 中更精确。

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`，4 张原创中文技术信息图。
- 保存目录：`assets/20261027_01_windows-terminal-tab-title-cards/`。
- 画布：3:4 竖版，浅米白背景、深海军蓝标题、青绿与橙色强调、圆角信息块和等宽代码框。
- 定向修订：第 3 张首版窗格中出现了带盘符的路径提示符；最终版仅将 4 处提示符替换为中性的 `>_`，其余信息保持不变。
- 脱敏检查：卡片、文档和提示词均未包含真实仓库地址、本机绝对路径、账号、IP、凭据、二维码或组织标识。
- 信息归属检查：Tab 是容器、Pane 是其中的窗格；`--title` 与 `--suppressApplicationTitle` 的作用未被排成同级对象以外的错误关系。
- Shorts 视频：4 张卡片，每张 4 秒，共 16 秒；无音轨，画面完整居中且未裁切卡片正文。
- 视频规格复核：H.264、`1080 × 1920`、30 fps、`yuv420p`、BT.709、`color_range=tv`。

## 适用边界与人工确认项

- 本文依据当前 Windows Terminal 命令行参数。旧版本可能不支持全部参数；遇到无法识别的参数时先运行 `wt --help` 并升级 Windows Terminal。
- `--suppressApplicationTitle` 会忽略程序主动更新标题的请求。如果平时依赖 PowerShell、Git 工具或其他程序把状态写进标题栏，不应在通用 Profile 中全局开启。
- `wt` 的窗口复用行为还受用户设置影响；本文只固定选项卡/窗格标题，不替用户决定是否复用现有窗口。
- 图片中的命令用于讲解核心模式，最终使用时仍需把占位符换成实际目录，并在本机测试布局方向和焦点移动顺序。

## 参考资料

- Microsoft Learn：[Windows Terminal command line arguments](https://learn.microsoft.com/en-us/windows/terminal/command-line-arguments)
- Microsoft Learn：[Configure Windows Terminal tab titles](https://learn.microsoft.com/en-us/windows/terminal/tutorials/tab-title)
- Microsoft Learn：[Windows Terminal advanced profile settings](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/profile-advanced)
