# git diff 中文乱码修复

`less` 是 Terminal Pager（终端分页器），不是 CMD 或 PowerShell 的内置命令。它分屏显示长文本，可滚动、搜索，按 `q` 退出，不改文件。

输入 `git diff` 后，Shell（命令解释器）启动 Git；Git 生成差异并交给 `less`；`less` 呈现在 Terminal（终端）。两种 Shell 可共用 Git 和 `less`，所以会一起乱码。`git --no-pager diff` 可绕过分页器诊断。

中文变成 `<E8>...`，通常是 `less` 没按 `UTF-8 (Unicode Transformation Format–8-bit，Unicode 八位转换格式)` 解释。CMD 用 `set LESSCHARSET=utf-8`，PowerShell 用 `$env:LESSCHARSET='utf-8'`；确认项目为 UTF-8，再用 `setx LESSCHARSET utf-8` 持久设置。

`less 551` 是第 551 版，不是 `5.5.1`。`LESSCHARSET` 不自动识别编码。应统一 UTF-8，或用 `.gitattributes` 按路径声明。
