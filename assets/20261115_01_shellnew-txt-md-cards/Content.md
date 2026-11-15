# 修复右键新建TXT和MD

## 为什么会消失

右键“新建”不只看默认打开软件。扩展名要关联到 `ProgID`（程序标识符），还要有 `ShellNew`（新建菜单配置）和 `NullFile`（创建空文件）；缺一项，菜单就可能不显示。

## 本次怎么修

- TXT：把 `.txt` 关联到 `NotepadPlusPlus.txt`，补回 `ShellNew\NullFile`，打开命令继续指向 Notepad++。
- MD：把 `.md` 关联到 `Typora.md`，补回 `ShellNew\NullFile`，显示名设为“Markdown 文档”，打开命令继续指向 Typora。

## 写对仍不显示

先备份注册表，再关闭并重开 Explorer（文件资源管理器）。本机原菜单已有 15 个文件类型项；移除闲置的 `Regsnap Document` 新建项后，TXT 和 Markdown 最终同时出现。这是本机现场结果，不代表所有 Windows 的统一上限。
