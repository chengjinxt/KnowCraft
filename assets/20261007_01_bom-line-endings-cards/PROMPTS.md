# BOM 与回车换行知识卡片

## 生成方式

- Codex 内置 `imagegen`
- Use case: `infographic-diagram`
- 画布：3:4 竖版
- 风格：原创中文技术信息图；浅米白背景；深蓝标题；青绿、橙色强调；圆角信息块；少量文件、字节、回车与 Git 图标；无平台标识、二维码和水印

## 01 文本文件的两套规则

标题：`文本文件，电脑其实只看字节`

核心内容：

- `Encoding（字符编码）`：决定“字符怎样变成字节”，例如 `UTF-8`；`BOM` 位于文件最前面。
- `Line Ending（行尾符）`：决定“换一行写成哪些控制字节”，常见 `CRLF` 与 `LF`。
- 两者相互独立：编码相同，行尾仍可能不同；行尾相同，BOM 仍可能不同。
- 结论：`文字看起来相同 ≠ 文件字节完全相同`。

## 02 BOM 是什么

标题：`BOM：文件开头的“编码签名”`

核心内容：

- `BOM (Byte Order Mark，字节顺序标记)` 位于文件最前面。
- `UTF-8 with BOM`：`EF BB BF + 正文`。
- `UTF-8 without BOM`：正文直接开始。
- UTF-8 本身没有大小端问题；UTF-8 的 BOM 主要作为编码签名或提示。
- 有些工具需要它，有些格式不希望有它；没有“永远更好”的选择，应跟随项目约定。

## 03 CR、LF 与 CRLF

标题：`按下 Enter，保存的不是一个图标`

核心内容：

- `CR (Carriage Return，回车)`：`\r`，十六进制 `0D`。
- `LF (Line Feed，换行)`：`\n`，十六进制 `0A`。
- Windows 常用 `CRLF = 0D 0A`。
- Linux 与现代 macOS 常用 `LF = 0A`。
- 编辑器都显示成“换行”，但底层字节并不相同。

## 04 附件中的真实原因

标题：`“文本相同，文件不匹配”到底差在哪？`

核心内容：

- `Git / HEAD`：`EF BB BF 23 ...`，即带 UTF-8 BOM。
- `工作副本`：`23 ...`，即不带 BOM 的 UTF-8。
- 两边 `CRLF` 行尾一致，解码后的正文也相同。
- 真正差异只有文件开头 3 个字节：`EF BB BF` 被删掉了。
- 结论：这次不是回车换行问题，而是 BOM 丢失。
- 检查命令：`Format-Hex .\taskProcessThreadBase.cpp | Select-Object -First 2`。

## 05 从根源解决

标题：`根治：把规则写进项目，不靠记忆`

核心内容：

1. 先决定项目规则：`UTF-8` 还是 `UTF-8 with BOM`；`LF` 还是 `CRLF`。
2. 用 `.editorconfig` 约束编辑器保存格式。针对附件中的规则，可写：

   ```ini
   [*.cpp]
   charset = utf-8-bom
   end_of_line = crlf
   ```

3. 用 `.gitattributes` 约束 Git 行尾：

   ```gitattributes
   *.cpp text eol=crlf
   ```

4. `.gitattributes` 的 `eol` 管行尾，不负责给 UTF-8 添加 BOM；BOM 仍需由编辑器规则或检查脚本保证。
5. 如果项目要求无 BOM + LF，就改为 `charset = utf-8` 与 `end_of_line = lf`；不要盲目全仓转换。

结论：`规则进仓库，保存时自动一致。`

## 06 UTF-8 没有大小端，为什么还有 BOM

标题：`UTF-8 没有大小端，为什么还有 BOM？`

核心内容：

- `BOM (Byte Order Mark，字节顺序标记)` 最初是为使用多字节代码单元的 Unicode 文本准备的。
- UTF-16 / UTF-32 的一个代码单元需要拆成多个字节；不同机器可能采用 `Big-endian（大端）` 或 `Little-endian（小端）`。
- 把 `U+FEFF` 放在开头后，UTF-16 的大端 BOM 是 `FE FF`，小端 BOM 是 `FF FE`；UTF-32 的大端 BOM 是 `00 00 FE FF`，小端 BOM 是 `FF FE 00 00`。BOM 用来识别已有字节序，不是命令文件切换字节序。
- UTF-8 的代码单元就是一个字节，因此大小端不适用；`U+FEFF` 在 UTF-8 中编码为 `EF BB BF`，这里只能作为可选的“UTF-8 编码签名”。
- 应使用：格式、协议、旧工具或项目明确要求；无外部编码标记的纯文本需要编码提示。
- 通常不使用：格式明确禁止，例如网络传输的 JSON；文件要求第一个字节就是语法，例如以 `#!` 开头的 Unix 脚本；编码已由可靠元数据声明且工具不需要 BOM。
- 结论：`UTF-16 / UTF-32：BOM 可识别字节序；UTF-8：BOM 只是可选签名。`

## 技术参考

- Unicode Consortium: [UTF-8, UTF-16, UTF-32 & BOM](https://www.unicode.org/faq/utf_bom.html)
- Unicode Consortium: [Unicode in XML and other Markup Languages](https://www.unicode.org/reports/tr20/tr20-7.html)
- RFC Editor: [RFC 3629 — UTF-8](https://www.rfc-editor.org/rfc/rfc3629)
- RFC Editor: [RFC 8259 — JSON](https://www.rfc-editor.org/rfc/rfc8259)
- Microsoft Learn: [Encodings and line endings](https://learn.microsoft.com/en-us/visualstudio/ide/encodings-and-line-breaks)
- Git: [gitattributes Documentation](https://git-scm.com/docs/gitattributes)
- EditorConfig: [Specification](https://spec.editorconfig.org/)
