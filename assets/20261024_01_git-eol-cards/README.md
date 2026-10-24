# Git 跨平台换行与 `i/lf、w/crlf`

## 白话结论

跨平台项目可以让 Git 仓库统一保存 `LF`，同时允许 Windows 工作区检出为 `CRLF`、macOS / Linux 工作区保持 `LF`。这不是同一文件发生冲突，而是 Git 把“准备提交的内容”和“磁盘上的工作文件”分成两层管理。

`git ls-files --eol` 输出中的 `i` 是 `Index（暂存区）`，`w` 是 `Working Tree（工作区）`。因此：

```text
i/lf    w/crlf    attr/
```

表示暂存区内容使用 LF，当前工作区文件使用 CRLF；`attr/` 后为空，表示该路径没有显示出已应用的 `text` / `eol` 属性规则，实际转换可能继续受 `core.autocrlf` 或 `core.eol` 影响。

## 卡片清单

1. `01-lf-crlf-basics.png`：解释 LF、CR 与 CRLF 的英文全称、控制字符和十六进制字节。
2. `02-repository-worktree-eol.png`：说明仓库 / Index 与不同平台工作区可以使用不同的行尾形式。
3. `03-index-worktree-eol.png`：逐项解释 `i/lf、w/crlf、attr/` 的读取方式。
4. `04-gitattributes-policy.png`：用 `.gitattributes` 把跨平台行尾规则写进仓库。

## LF、CR 与 CRLF

- `LF (Line Feed，换行)`：控制字符 `\n`，十六进制字节 `0A`。
- `CR (Carriage Return，回车)`：控制字符 `\r`，十六进制字节 `0D`。
- `CRLF (Carriage Return + Line Feed，回车+换行)`：控制字符组合 `\r\n`，十六进制字节 `0D 0A`。

Linux 与现代 macOS 文本通常使用 LF；Windows 文本常见 CRLF。编辑器都会把它们显示成“换到下一行”，但底层字节不同。

## `git ls-files --eol` 怎么读

```bash
git ls-files --eol
```

Git 的输出格式是：

```text
i/<eolinfo>    w/<eolinfo>    attr/<eolattr>    <file>
```

- `i`：`Index（暂存区）`，也就是下一次提交会读取的内容层。
- `w`：`Working Tree（工作区）`，也就是磁盘上正在编辑的文件。
- `attr`：当前路径实际应用的 Git 属性，例如 `text eol=lf` 或 `text eol=crlf`。
- `lf`：识别为 LF 行尾。
- `crlf`：识别为 CRLF 行尾。
- `mixed`：同一文件混用了不同形式的行尾，需要检查。
- `-text`：Git 将该内容视为非文本，不进行文本行尾转换。
- `none`：内容没有可识别的行尾。

`i/lf、w/crlf` 只说明两个层次当前识别到的行尾不同，并不直接表示文件内容冲突或损坏。

## 为什么跨平台仍然能正常协作

Git 可以在文本文件进入 Index 时把行尾规范为 LF，并在检出到工作区时依据 `.gitattributes`、`core.autocrlf`、`core.eol` 与平台配置决定是否转换为 CRLF。

常见结果是：

- Git 仓库 / Index：统一 LF，减少无意义的整文件差异。
- Windows 工作区：可以是 CRLF，兼容偏好 Windows 行尾的工具。
- macOS / Linux 工作区：通常是 LF，适合 Unix 工具链和 Shell 脚本。

是否转换由规则决定，不应简单理解成“Windows 文件永远必须是 CRLF”或“所有工作区都必须与仓库字节完全相同”。

## 推荐把规则写进项目

最小规则示例：

```gitattributes
* text=auto
*.sh  text eol=lf
*.bat text eol=crlf
*.cmd text eol=crlf
```

- `* text=auto`：让 Git 自动识别文本文件，并在进入 Index 时规范行尾。
- `eol=lf`：指定该类型文件在工作区也使用 LF。
- `eol=crlf`：指定该类型文件在工作区使用 CRLF。
- 二进制文件可显式标记为 `-text`，避免误转换，例如 `*.png -text`。

如果团队希望 TypeScript、JavaScript、JSON、Markdown 等源码在所有平台的工作区都保持 LF，可以继续按扩展名增加 `text eol=lf`。如果希望 Windows 工作区使用 CRLF，则只设置 `text`，让工作区行尾由 Git 配置决定。

## 首次启用时不要盲目全仓转换

从干净工作区开始，加入 `.gitattributes` 后可运行：

```bash
git add --renormalize .
git status
git diff --cached --check
git diff --cached
```

逐项确认变化只来自预期的文本行尾规范化，再提交。若二进制文件或特殊编码文件出现在差异中，应先补充属性规则，不要直接提交大范围改写。

行尾和编码是两个不同问题：`.gitattributes` 的 `eol` 管理行尾，不会自动决定 UTF-8 是否带 `BOM (Byte Order Mark，字节顺序标记)`。

## 卡片生成说明

- 生成方式：Codex 内置 `imagegen`，4 张原创中文技术信息图。
- 保存目录：`assets/20261024_01_git-eol-cards/`。
- 画布：3:4 竖版，浅米白背景、深海军蓝标题、青绿与橙色强调、圆角信息块和等宽代码框。
- 定向修订：第 2 张初稿误用了 Windows 品牌图形，最终版仅将其替换为原创终端符号，其他版式与文字保持不变。
- 脱敏检查：未包含真实项目名、仓库地址、绝对路径、账号、IP、凭据、二维码或水印。
- 技术风险：不同 Git 版本、全局配置和既有历史内容可能影响实际结果；执行 `git add --renormalize .` 前必须保持工作区干净并审查全部暂存差异。

## 参考资料

- Git 官方文档：[git-ls-files — `--eol`](https://git-scm.com/docs/git-ls-files)
- Git 官方文档：[gitattributes — `text` 与 `eol`](https://git-scm.com/docs/gitattributes)
- Git 官方文档：[Git FAQ — 行尾与属性建议](https://git-scm.com/docs/gitfaq)
