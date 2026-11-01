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

## `less` 是什么

`less` 是 `Terminal Pager（终端分页器）`：它接收一段较长的文本，把内容分屏显示，并提供向前/向后滚动、搜索和退出等查看操作。它不是文本编辑器，不会修改正在查看的文件；也不是 CMD 或 PowerShell 的内置命令。

在 Git for Windows 中，`less` 通常随 Git 一起提供，并由 Git 在需要分页时自动启动，所以日常使用者很少直接输入 `less`。几个常用按键是：

- `Space`：下一页。
- `b`：上一页。
- `/关键词`：向后搜索。
- `n`：跳到下一个匹配项。
- `q`：退出分页器。

## CMD、PowerShell、Git、`less` 和终端的关系

CMD 与 PowerShell 都是 `Shell（命令解释器）`：负责理解你输入的命令并启动程序。Git 是被 Shell 启动的命令行程序；`less` 是 Git 可调用的分页器；`Terminal（终端）` 则负责把结果显示出来并接收键盘输入。典型流程是：

```text
用户输入 git diff
        ↓
CMD / PowerShell（Shell，命令解释器）
        ↓ 启动
Git（生成 diff）
        ↓ 交给
less（Pager，分页器）
        ↓ 呈现
Terminal（终端）
```

因此，在 CMD 和 PowerShell 中看到同一种 `<E8>` 现象并不矛盾：两个 Shell 可以启动同一套 Git，而 Git 又启动同一个 `less`。Shell 改了，真正解释输出字节的分页器不一定改变。

下面的命令会让 Git 绕过分页器，把差异直接写到终端：

```cmd
git --no-pager diff
```

如果这样显示正常，而普通 `git diff` 显示异常，就可以把排查重点放到 `less`。Git 还可以通过 `GIT_PAGER` 环境变量和 `core.pager` 配置选择分页器；默认选择通常是 `less`。

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

## 对 UTF-8 项目持久生效

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

预期环境变量值为 `utf-8`，UTF-8 中文差异正文应正常显示。这里的“持久”只表示以后新开的窗口仍采用 UTF-8 解释规则，不表示 `less` 可以自动识别所有文件编码。

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

## `less 551` 不是 `5.5.1`

Less 的发布号使用连续整数。命令输出中的：

```text
less 551
```

意思是 `Version 551（第 551 版）`，不是语义化版本 `5.5.1`。官方发布记录显示，551 版发布于 2019 年 6 月；相邻版本号也写成 530、551、561 等连续整数。

## `LESSCHARSET` 支持范围

在本次复现所用的 `less 551` 上逐项实测，以下名称可接受：

```text
ascii
iso8859
latin1
latin9
dos
ebcdic
IBM-1047
koi8-r
next
utf-8
windows
```

以下名称会直接报 `invalid charset name`：

```text
gbk
cp936
```

`GBK（汉字内码扩展规范）` 在 Windows 中常对应 `CP936 (Code Page 936，代码页 936)`。`windows` 模式不等于自动采用 GBK；不能用它替代明确的 GBK 转码。

还要注意，`LESSCHARSET` 的多数选项主要规定哪些字节算普通字符、控制字符或二进制字符。`utf-8` 是其中唯一支持多字节输入的模式。因此，设置 `LESSCHARSET=utf-8` 对当前 UTF-8 仓库是正确修复，但对真实的 GBK 文件并不是通用方案。

## 为什么不能自动识别所有编码

- 有 `BOM (Byte Order Mark，字节顺序标记)` 的文件可以根据标记明确判断部分 Unicode 编码。
- 没有 BOM 的传统编码只能依据字节分布和语言特征进行统计猜测；短文本或纯 ASCII 片段尤其容易误判。
- 同一串字节可能在多个编码中都合法，无法仅凭字节得到唯一答案。
- 一次 `git diff` 可能同时包含多个文件，甚至混合 UTF-8、GBK 和其他编码；合并后的单个输出流只能让 `less` 采用一套解释规则。

所以不存在一个能让 `less` 对所有编码百分之百自动识别的开关。可靠做法是让仓库声明编码，而不是让分页器猜。

### 首选：统一为 UTF-8

Git 官方建议文本优先存储为 UTF-8。这样仓库、代码审查工具、网页界面和终端使用同一套编码，问题最少。

### 必须保留 GBK：按路径声明

若某个目录必须在工作区保持 GBK，可在 `.gitattributes` 中声明：

```gitattributes
legacy/** text working-tree-encoding=GBK eol=crlf
```

再对对应路径执行一次：

```cmd
git add --renormalize -- legacy/
```

Git 会在内部保存 UTF-8，并在检出工作区时转回 GBK。使用前必须确认团队所有 Git 客户端都支持 `working-tree-encoding`。

如果只想改善差异阅读、不改变文件存储，可给已知 GBK 路径配置 `textconv（文本转换）`，先用 `iconv` 转成 UTF-8 再交给 Git 比较。自动探测工具最多只能提供启发式结果，不能替代路径级编码约定。

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
6. `06-less-version.png`：说明 `less 551` 是第 551 版，不是 `5.5.1`。
7. `07-lesscharset-limits.png`：列出常用支持项，并明确 GBK / CP936 不受支持。
8. `08-auto-detection.png`：解释编码自动检测的固有限制与可靠做法。
9. `09-what-is-less.png`：说明 `less` 是终端分页器，而不是 Shell 内置命令或编辑器。
10. `10-command-flow.png`：展示 CMD / PowerShell、Git、`less` 与终端的调用关系。

## 生成方式与检查结果

- 图片由 Codex 内置 `imagegen` 生成，采用原创 3:4 中文技术信息图；附件截图只用于诊断，没有作为生成输入，避免公开本机路径和仓库信息。
- 第 1 张首次生成把“分页器”误写，定向修订未生效后已整张重生成；错误版本未纳入项目。
- 第 7 张初稿用绿色对勾标记“GBK 仍需转换”，视觉关系可能误导；最终版已改为橙色警告图标。
- 第 8 张初稿插图出现错误字节 `E6 96 X7`，定向修订未生效后已整张重生成；最终版不再使用具体字节示意。
- 第 9、10 张首次生成即通过逐字与关系检查；流程卡把 Shell、Git、`less` 和 Terminal 分为四个对象，并单独画出 `--no-pager` 旁路。
- 已逐张检查标题、中文、版本号、发布日期、`UTF-8`、`LESSCHARSET`、GBK、CP936、BOM、`.gitattributes`、`setx`、PowerShell 的 `$env:` 写法、`core.quotePath`、`git --no-pager diff`、Shell 与 Terminal 的对象归属。
- `shorts.mp4` 由仓库自带 `card-video-generator` 按 `01` 到 `10` 十张最终卡片的自然顺序生成，每张 4 秒，共 40 秒，无音轨；原始终端截图不进入视频。

## 参考资料

- [less FAQ：Non-English characters](https://www.greenwoodsoftware.com/less/faq.html)
- [less FAQ：What is less?](https://www.greenwoodsoftware.com/less/faq.html#what-is-less)
- [Less version 551 发布说明](https://greenwoodsoftware.com/less/news.551.html)
- [Git `core.pager` 配置说明](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corepager)
- [Git `--no-pager` 与 `GIT_PAGER` 说明](https://git-scm.com/docs/git)
- [Git `core.quotePath` 配置说明](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corequotePath)
- [Git `working-tree-encoding` 与 `textconv` 说明](https://git-scm.com/docs/gitattributes)
- [Git FAQ：文本编码建议](https://git-scm.com/docs/gitfaq)
- [Microsoft Learn：`chcp`](https://learn.microsoft.com/windows-server/administration/windows-commands/chcp)
- [Microsoft Learn：Console Code Pages](https://learn.microsoft.com/windows/console/console-code-pages)

## 仍需人工确认的风险

- 修改在新启动的 CMD / PowerShell 中生效；交付前仍建议由用户在自己的可见终端重新运行一次 `git diff`，确认终端宿主和字体没有额外兼容问题。
- 卡片中的“永久”是指持久写入当前 Windows 用户环境变量，不是写入系统级环境变量，也不会追溯更新已经运行的进程；它也不是任意编码自动检测器。
- `.gitattributes` 的 `working-tree-encoding` 会影响添加和检出，启用前必须确认文件实际编码并核对团队客户端兼容性。
