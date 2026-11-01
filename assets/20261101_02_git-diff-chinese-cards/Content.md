# git diff 中文乱码修复

在 CMD 或 PowerShell 里运行 `git diff`，中文变成 `<E8><83>...`，通常不是文件坏了，而是 `less（终端分页器）` 没按 `UTF-8 (Unicode Transformation Format–8-bit，Unicode 八位转换格式)` 解释字节。

先修当前窗口：

```cmd
set LESSCHARSET=utf-8
```

```powershell
$env:LESSCHARSET = 'utf-8'
```

再运行 `git diff`。要对以后新开的 CMD 和 PowerShell 持久生效，执行：

```cmd
setx LESSCHARSET utf-8
```

然后关闭旧窗口，打开新窗口验证。

别混淆：`chcp 65001` 改控制台代码页；`core.quotePath=false` 只影响中文路径显示；`git --no-pager diff` 可绕过 `less` 做诊断。正文出现 `<E8>` 时，先查 `LESSCHARSET`。若绕过分页器仍乱码，再检查文件实际编码和终端设置。
