# `git diff` 中文显示修复

这套卡片解释一种常见现象：在 Windows 的 CMD 或 PowerShell 中运行 `git diff`，中文正文被显示为 `<E8><83>...`。结论是：文件通常没有损坏，问题出在 Git 调用的 `less（终端分页器）` 没有按 `UTF-8 (Unicode Transformation Format–8-bit，Unicode 八位转换格式)` 解释输入字节。

## 本次环境结论与修改

- 原文件字节符合 UTF-8；例如“中”编码为十六进制字节 `E4 B8 AD`。
- 复现场景使用 Git for Windows `2.26.1.windows.1`，其内置分页器为 `less 551`。
- CMD 当前代码页为 `936`，但 CMD 和 PowerShell 都出现相同的 `<E8>` 展开形式，说明共同环节是 Git 的分页器，而不是某一个外壳单独损坏。
- 已把当前 Windows 用户的环境变量 `LESSCHARSET` 持久设为 `utf-8`。关闭现有 CMD / PowerShell 窗口并重新打开后生效。
- 没有修改文件编码，也没有设置 `core.quotePath=false`；后者只影响路径名的引用与转义，不负责正文显示。

## 为什么会显示成 `<E8>`

Git 先生成差异文本，再把较长输出交给 `less` 分页显示。旧版 `less` 如果没有从环境中识别出 UTF-8，会把高位字节视为不可打印内容，并按 `<十六进制字节>` 形式展开。

以“中”为例：

```text
字符：中
UTF-8 字节：E4 B8 AD
错误展开：<E4><B8><AD>
```

所以它更像“同一串字节被解释错了”，而不是文件内容被 Git 改坏了。

## 临时修复

只修当前 CMD 窗口：

```cmd
set LESSCHARSET=utf-8
git diff
```

只修当前 PowerShell 窗口：

```powershell
$env:LESSCHARSET = 'utf-8'
git diff
```

## 永久修复

在 CMD 或 PowerShell 中执行一次：

```cmd
setx LESSCHARSET utf-8
```

`setx` 默认写入当前用户环境变量。已有进程不会自动获得新值，所以要关闭现有 CMD / PowerShell，再打开新窗口验证：

```cmd
echo %LESSCHARSET%
git diff
```

PowerShell 可这样检查：

```powershell
$env:LESSCHARSET
git diff
```

预期环境变量值为 `utf-8`，中文差异正文应正常显示。

## 四个设置的边界

| 设置或命令 | 管什么 | 什么时候用 |
| --- | --- | --- |
| `LESSCHARSET=utf-8` | 告诉 `less` 按 UTF-8 解释输入 | 正文被展开成 `<E8>` 时优先检查 |
| `chcp 65001` | 把当前 Windows 控制台代码页切为 UTF-8 | 其他命令仍有传统代码页乱码时辅助排查 |
| `core.quotePath=false` | 让 Git 路径输出不再把高位字节当成“特殊字符”转义 | 中文文件名被显示为反斜杠八进制序列时使用 |
| `git --no-pager diff` | 绕过分页器直接输出差异 | 判断问题是否来自 `less` |

`chcp 65001` 不是 Git 配置，也不是这次 `<E8>` 展开的首选修复。若只有中文文件名被写成 `\xxx` 形式，可另行设置：

```cmd
git config --global core.quotePath false
```

## 升级建议与适用边界

- 较新的 `less` 已改进 Windows 下的 UTF-8 默认行为；升级 Git for Windows 可以减少旧版分页器的字符集问题，但升级前仍应确认团队工具链兼容性。
- `LESSCHARSET=utf-8` 适合仓库文本本身就是 UTF-8 的常见开发环境。如果文件实际采用 GBK 等传统编码，应先确认文件编码，不能靠强制 UTF-8 掩盖问题。
- 若 `git --no-pager diff` 仍显示乱码，就继续检查文件实际编码、终端字体、控制台代码页和 Git 输出编码；不要只改 `core.quotePath`。

## 卡片清单

1. `01-why-less.png`：文件未损坏，问题在 `less` 的字符集判断。
2. `02-byte-example.png`：“中”的 UTF-8 字节与错误展开示例。
3. `03-current-window.png`：CMD 与 PowerShell 当前窗口的临时修复。
4. `04-persistent-fix.png`：使用 `setx` 持久设置当前用户变量。
5. `05-setting-boundaries.png`：区分 `LESSCHARSET`、`chcp`、`core.quotePath` 与 `--no-pager`。

## 生成方式与检查结果

- 图片由 Codex 内置 `imagegen` 生成，采用原创 3:4 中文技术信息图；附件截图只用于诊断，没有作为生成输入，避免公开本机路径和仓库信息。
- 第 1 张首次生成把“分页器”误写，定向修订未生效后已整张重生成；错误版本未纳入项目。
- 已逐张检查标题、中文、`UTF-8`、`LESSCHARSET`、`setx`、PowerShell 的 `$env:` 写法、`core.quotePath` 与 `git --no-pager diff`。
- `shorts.mp4` 由仓库自带 `card-video-generator` 按图片自然顺序生成，每张 4 秒，无音轨。

## 参考资料

- [less FAQ：Non-English characters](https://www.greenwoodsoftware.com/less/faq.html)
- [Git `core.quotePath` 配置说明](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corequotePath)
- [Microsoft Learn：`chcp`](https://learn.microsoft.com/windows-server/administration/windows-commands/chcp)
- [Microsoft Learn：Console Code Pages](https://learn.microsoft.com/windows/console/console-code-pages)

## 仍需人工确认的风险

- 修改在新启动的 CMD / PowerShell 中生效；交付前仍建议由用户在自己的可见终端重新运行一次 `git diff`，确认终端宿主和字体没有额外兼容问题。
- 卡片中的“永久”是指持久写入当前 Windows 用户环境变量，不是写入系统级环境变量，也不会追溯更新已经运行的进程。
