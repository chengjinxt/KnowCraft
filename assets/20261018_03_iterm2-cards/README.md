# iTerm2：分屏、保存与恢复工作台

## 白话结论

iTerm2 可以把一个终端窗口拆成多个 `Pane（窗格）`，并通过 `Window Arrangement（窗口排列）` 保存窗口、标签页和分屏结构。下次启动时可以自动重建这套工作台，但普通 Arrangement 不等于让原来的进程继续运行；长任务或远程会话需要结合 `tmux (Terminal Multiplexer，终端复用器)`。

## 卡片清单

1. `01-iterm2-split-pane-shortcuts.png`：常用分屏、切换与临时放大快捷键。
2. `02-save-window-arrangement.png`：保存和手动恢复 Window Arrangement。
3. `03-open-default-window-arrangement.png`：设置默认排列并在启动时自动打开。
4. `04-arrangement-vs-tmux.png`：区分布局恢复与进程持久化。

## 技术要点

- `Pane（窗格）`：一个 Tab 内的独立终端会话。默认快捷键 `⌘ D` 创建左右分屏，`⇧ ⌘ D` 创建上下分屏。
- `⌘ ⌥ ← ↑ → ↓` 在分屏之间移动焦点；`⇧ ⌘ Enter` 临时放大当前 Pane，再次按下恢复全部 Pane。
- `Window → Arrangements → Save Window Arrangement` 保存窗口位置、Tab、Pane 和分屏结构；通过 `Restore Window Arrangement` 手动恢复。
- 在 `Settings → Arrangements` 中将目标排列设为 Default，再到 `Settings → General → Startup`，把 `Window restoration policy` 设置为 `Open Default Window Arrangement`，即可在启动时自动恢复。
- 旧版 iTerm2 的菜单层级可能没有 `Arrangements` 子菜单，启动选项也可能显示为 `Open saved window arrangement`。
- iTerm2 快捷键可以在 `Settings → Keys` 或 Profile 的 Keys 设置中重新映射，因此卡片展示的是默认快捷键。
- `tmux` 可以让会话在 tmux 服务和主机仍在运行时继续存在，并支持断开后重连；它不能让进程跨主机重启继续运行。

## 卡片生成说明

- 生成方式：Codex 内置 `imagegen`，逐张生成，并以上一张成品作为后续卡片的视觉风格参考。
- 保存目录：`assets/20261018_03_iterm2-cards/`。
- 画布：1086 × 1448，3:4 竖版。
- 视觉规范：原创中文技术信息图、浅米白背景、深蓝高对比标题、蓝绿圆角信息块、少量橙色强调、通用终端和设置图标，无平台标识、二维码和水印。
- 检查结果：已逐张核对中文标题、快捷键符号、`iTerm2`、`Pane`、`Tab`、`Profile`、`Window Arrangement`、`Default`、`tmux`、`Terminal Multiplexer` 及菜单路径；四张图片尺寸一致，信息归属和流程关系清晰。
- 人工确认风险：不同 iTerm2 版本或自定义快捷键可能造成菜单名称和按键不同；正式发布前建议在目标版本上再次对照界面。

## 参考依据

- iTerm2 Highlights for New Users：https://iterm2.com/documentation-highlights.html
- iTerm2 Menu Items：https://iterm2.com/documentation-menu-items.html
- iTerm2 General Preferences：https://iterm2.com/documentation-preferences-general.html
- iTerm2 Session Restoration：https://iterm2.com/documentation-restoration.html
