# git diff 中文乱码修复

`git diff` 中文变成 `<E8><83>...`，通常不是文件坏了，而是 `less（终端分页器）` 没按 `UTF-8 (Unicode Transformation Format–8-bit，Unicode 八位转换格式)` 解释字节。

当前 CMD 运行 `set LESSCHARSET=utf-8`；PowerShell 运行 `$env:LESSCHARSET='utf-8'`。确认项目是 UTF-8 后，可运行 `setx LESSCHARSET utf-8`，关闭旧窗口再重开。

`less 551` 是第 551 版，不是 `5.5.1`。它不接受 `GBK（汉字内码扩展规范）` 或 `CP936 (Code Page 936，代码页 936)`；`utf-8` 是唯一多字节模式。

`LESSCHARSET` 是固定规则，不会自动检测。无 `BOM (Byte Order Mark，字节顺序标记)` 的编码只能猜，一次 diff 还可能混合多种编码。可靠做法是统一 UTF-8，或用 `.gitattributes` 按路径声明。`chcp 65001` 改代码页，`core.quotePath=false` 只管路径。
