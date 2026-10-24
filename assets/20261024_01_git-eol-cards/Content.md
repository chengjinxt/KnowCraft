# Git 跨平台换行规则

## 先看底层

`LF (Line Feed，换行)` 是 `\n`，十六进制为 `0A`；`CR (Carriage Return，回车)` 是 `\r`，十六进制为 `0D`；`CRLF (Carriage Return + Line Feed，回车+换行)` 是 `\r\n`，即 `0D 0A`。

## `i/lf、w/crlf` 怎么读

运行：

```bash
git ls-files --eol
```

`i` 是 `Index（暂存区）`，`i/lf` 表示 Git 准备提交的内容使用 LF；`w` 是 `Working Tree（工作区）`，`w/crlf` 表示磁盘文件使用 CRLF。两者不同不等于代码冲突，可能只是 Git 在提交和检出时转换了行尾。

## 跨平台项目怎么定规则

仓库通常统一保存 LF；Windows 工作区可用 CRLF，macOS / Linux 通常用 LF。不要只依赖每台电脑的 `core.autocrlf`，建议提交 `.gitattributes`：

```gitattributes
* text=auto
*.sh  text eol=lf
*.bat text eol=crlf
```

首次启用前先保持工作区干净，再运行 `git add --renormalize .`，并逐项审查差异后提交。
