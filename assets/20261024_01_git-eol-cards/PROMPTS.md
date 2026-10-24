# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: infographic-diagram
Asset type: 原创中文技术知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、但不熟悉 Git 行尾机制的中文读者
Style/medium: 浅米白背景、深海军蓝标题、青绿与橙色强调、圆角信息块、简洁文件与终端图标、手机端大字号。
Composition: 顶部标题，中部按阅读顺序展示概念或流程，底部一句准确结论。
Constraints: 引号内文字逐字呈现；英文大小写、斜杠、反斜杠、短横线和命令必须准确；无品牌 Logo、平台标识、水印、二维码和额外文案。
Public-release redaction: 不出现真实项目名、仓库 URL、本机绝对路径、账号、IP、凭据或可关联到个人与组织的标识。
```

## 01 先认识 LF 与 CRLF

输入图片：无，新图生成。

```text
Use case: infographic-diagram
Asset type: Chinese social-media knowledge card, 3:4 vertical
Primary request: Explain the basic byte-level meaning of LF, CR, and CRLF before the later Git cards.
Style/medium: original polished flat vector technical infographic, warm off-white background, dark navy typography, teal and orange accents, rounded code cards, simple keyboard Enter key and byte icons, clean mobile-readable layout.
Composition/framing: top title; three stacked comparison rows for LF, CR, and CRLF; a small platform-use comparison near the bottom; final conclusion banner.
Text (verbatim):
“先认识 LF 与 CRLF”
“LF (Line Feed，换行)”
“\n”
“十六进制 0A”
“CR (Carriage Return，回车)”
“\r”
“十六进制 0D”
“CRLF (Carriage Return + Line Feed，回车+换行)”
“\r\n”
“十六进制 0D 0A”
“Linux / 现代 macOS 常用 LF”
“Windows 文本常用 CRLF”
“看起来都是换行，底层字节可以不同”
Constraints: Every quoted line must appear exactly once and be spelled exactly. Keep LF, CR, CRLF, Line Feed, Carriage Return, Linux, macOS, Windows and byte values in Latin letters exactly. No logos, brand marks, real paths, project names, IPs, accounts, QR codes, watermarks, or extra prose. Large readable text; no tiny paragraphs.
```

## 02 仓库与工作区分两层

输入图片：初稿作为编辑目标，仅用于保留既有布局、颜色和文字并替换违规图标。

初始生成提示词：

```text
Use case: infographic-diagram
Asset type: Chinese social-media knowledge card, 3:4 vertical
Primary request: Explain why a cross-platform Git project can use different line endings in the repository and local working tree without conflict.
Style/medium: original polished flat vector infographic, light warm off-white background, dark navy title, teal and orange accents, rounded information blocks, subtle paper and code-file icons, generous spacing, high contrast, mobile-readable.
Composition/framing: top title; center two-layer diagram with a Git repository cylinder/card at top and Windows/macOS working folders below, connected by arrows; bottom conclusion banner.
Text (verbatim):
“跨平台换行：分清两层”
“Git 仓库 / Index（暂存区）”
“统一保存 LF”
“Windows 工作区”
“可检出为 CRLF”
“macOS / Linux 工作区”
“通常检出为 LF”
“Git 在提交与检出时按规则转换”
“代码内容不变，行尾表示可不同”
“关键：仓库统一，工作区按需”
Constraints: Simplified Chinese only except the exact English technical terms above. Every quoted line must appear exactly once and be spelled exactly. Show LF as \n and CRLF as \r\n in small visual labels. No real repository names, paths, IPs, accounts, logos, QR codes, watermarks, or tiny paragraphs. Do not add any other explanatory text.
```

定向修订提示词：

```text
Use case: precise-object-edit
Asset type: Chinese social-media knowledge card
Primary request: Remove only the Windows logo shown on the laptop screen inside the orange “Windows 工作区” panel. Replace that logo with a neutral, original dark navy terminal prompt symbol “>_” centered on the laptop screen.
Constraints: Change only that laptop-screen icon. Preserve every existing Chinese and English text character exactly, preserve all layout, colors, arrows, line-ending labels, proportions, typography, and other illustrations unchanged. Do not introduce any brand logo, watermark, QR code, extra text, or spelling change.
```

## 03 `i/lf、w/crlf` 怎么读

输入图片：无，新图生成。

```text
Use case: infographic-diagram
Asset type: Chinese social-media knowledge card, 3:4 vertical
Primary request: Explain the exact meaning of Git command output “i/lf  w/crlf”.
Style/medium: original polished flat vector technical infographic, warm off-white background, dark navy typography, teal and orange accents, rounded cards, simple file and magnifier icons, clean mobile-readable layout.
Composition/framing: top title; a large monospace code strip in the center; two clearly separated explanation panels under it; a short reading formula and conclusion at bottom.
Text (verbatim):
“i/lf、w/crlf 到底怎么看？”
“git ls-files --eol”
“i/lf    w/crlf    attr/”
“i = Index（暂存区）”
“Git 准备提交的内容使用 LF”
“w = Working Tree（工作区）”
“磁盘上的文件使用 CRLF”
“读法：仓库侧 LF，本地文件 CRLF”
“这不等于文件内容冲突”
“还可能看到：mixed、-text、none”
Constraints: Every quoted line must appear exactly once and be spelled exactly. Keep i, w, Index, Working Tree, LF, CRLF, mixed, -text, none in Latin letters exactly. Clearly connect the i panel to i/lf and the w panel to w/crlf. No logos, brand marks, real paths, project names, IPs, accounts, QR codes, watermarks, or extra prose. Large readable text; no tiny paragraphs.
```

## 04 把行尾规则写进仓库

输入图片：无，新图生成。

```text
Use case: infographic-diagram
Asset type: Chinese social-media knowledge card, 3:4 vertical
Primary request: Teach how to make cross-platform line-ending behavior a repository rule with .gitattributes instead of relying only on each developer's Git configuration.
Style/medium: original polished flat vector technical infographic, warm light background, dark navy title, teal and orange accents, rounded code blocks, check marks and document icons, clean and highly readable on a phone.
Composition/framing: top title; middle “recommended rules” code block; below it three short explanation cards; bottom verification command and conclusion.
Text (verbatim):
“跨平台项目：把行尾规则写进仓库”
“.gitattributes”
“* text=auto”
“*.sh  text eol=lf”
“*.bat text eol=crlf”
“文本提交时规范为 LF”
“Shell 脚本工作区保持 LF”
“批处理脚本工作区使用 CRLF”
“检查：git ls-files --eol”
“规则进仓库，不靠每台电脑的记忆”
“注意：首次启用先审查 git add --renormalize .”
Constraints: Every quoted line must appear exactly once and be spelled exactly. English abbreviation expansions are not needed on this card. Format code lines in a real monospace code block. No logos, brand marks, real paths, project names, IPs, accounts, QR codes, watermarks, or extra prose. Large readable text, no tiny paragraphs.
```
