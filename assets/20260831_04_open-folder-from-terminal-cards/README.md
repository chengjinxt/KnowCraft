# 在终端中打开文件夹知识卡片

本目录包含一张横屏命令速查卡：

- `01-open-folder-from-terminal.png`

## 先理解点号

`.` 表示 `Current Directory（当前目录）`。因此，命令后面的 `.` 可以理解为“请打开我现在所在的文件夹”。

`..` 表示上一级目录，例如 `open ..` 或 `xdg-open ..` 会尝试打开当前目录的父目录。

## Windows

文件管理器是 `File Explorer（文件资源管理器）`。

PowerShell 和 CMD 中打开当前目录：

```powershell
explorer .
```

打开指定目录：

```powershell
explorer "D:\My Project"
```

在 WSL 中打开当前 Linux 路径对应的 Windows 资源管理器位置：

```bash
explorer.exe .
```

## macOS

文件管理器是 `Finder（访达）`，终端中用于打开项目的命令是 `open`。

打开当前目录：

```bash
open .
```

打开指定目录：

```bash
open "/Users/me/My Project"
```

`open` 会把文件夹交给 Finder；如果传入的是文件，则通常交给该文件类型的默认应用。

## Linux

多数带图形桌面的 Linux 可以使用 `xdg-open`，它会调用系统默认的 `File Manager（文件管理器）`。

打开当前目录：

```bash
xdg-open .
```

打开指定目录：

```bash
xdg-open "/home/me/My Project"
```

GNOME 等环境也可能支持：

```bash
gio open .
```

不同桌面环境还可能直接使用 `nautilus`、`dolphin` 或 `thunar`，但 `xdg-open` 更适合作为通用写法。

## 通用规则

- 路径中包含空格时，用双引号包住整个路径。
- Windows 路径通常使用反斜杠 `\`；macOS 和 Linux 路径使用正斜杠 `/`。
- 打开文件管理器不会改变终端的当前目录；切换终端目录需要使用 `cd`。
- 查看当前路径：PowerShell 使用 `Get-Location`，CMD 使用 `cd`，macOS/Linux 使用 `pwd`。
- `xdg-open`、`gio open` 等命令依赖图形桌面和显示会话。纯 SSH、无桌面服务器或容器中通常无法弹出文件管理器。
- 如果目标路径不存在、当前用户无权访问或缺少对应文件管理器，命令会失败。

## 一眼记住

```text
Windows：explorer .
macOS：  open .
Linux： xdg-open .
```

## 生成与检查

- 生成方式：Codex 内置 `imagegen`。
- 提示词结构：三系统对比栏 + 当前目录说明 + 通用规则 + WSL/SSH 边界。
- 已人工检查命令大小写、双引号、Windows 反斜杠、macOS/Linux 正斜杠和中英文术语。
