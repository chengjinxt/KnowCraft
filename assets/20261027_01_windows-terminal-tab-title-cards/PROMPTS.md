# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: infographic-diagram
Asset type: 原创中文技术知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、但不熟悉 Windows Terminal 多窗格标题机制的中文读者
Style/medium: 浅米白背景、深海军蓝标题、青绿与橙色强调、圆角信息块、简洁终端图标、等宽代码框、手机端大字号。
Composition: 顶部标题，中部按阅读顺序展示概念、参数、写法或边界，底部一句准确结论。
Constraints: 引号内文字逐字呈现；英文大小写、双短横线、百分号、下划线、双引号和参数拼写必须准确；无品牌 Logo、平台标识、水印、二维码和额外文案。
Public-release redaction: 不出现真实项目名、仓库 URL、本机绝对路径、账号、IP、凭据或可关联到个人与组织的标识。
```

用户提供的 Windows Terminal 截图仅用于理解“一个选项卡包含 4 个窗格”的问题背景，没有作为 ImageGen 输入图片，以避免真实目录进入公开发布素材。

## 01 终端标签名为什么会变

输入图片：无，新图生成。

```text
Use case: infographic-diagram
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: Explain why a Windows Terminal tab name may change when focus moves between panes.
Audience: 有基础电脑使用经验、但不熟悉 Windows Terminal 多窗格标题机制的中文读者
Style/medium: polished original flat vector technical infographic, warm off-white background, dark navy typography, teal and orange accents, rounded information cards, simple generic terminal-window and focus-arrow icons, high contrast, mobile-readable large text.
Composition/framing: top title; center diagram showing one Tab containing four Pane blocks with a focus highlight moving between panes; below it two short explanation cards; bottom conclusion banner.
Text (verbatim):
“终端标签名为什么会变？”
“Windows Terminal（Windows 终端）”
“Tab（选项卡）”
“Pane（窗格）”
“一个 Tab 可以包含多个 Pane”
“默认显示当前聚焦窗格的标题”
“切换窗格，标签名可能跟着变”
“只给第一个窗格命名，不够”
“固定标签名：每个窗格统一设置”
Constraints: Render every quoted line exactly once. Keep Windows Terminal, Tab, Pane capitalization exact. Clearly place “Tab（选项卡）” as the container label and “Pane（窗格）” as the child-block concept, never as separate peer objects. No Windows logo, no brand logo, no watermark, no QR code, no real path, no project name, no account, no IP, no extra prose. No tiny text.
```

## 02 固定标题的两个参数

输入图片：无，新图生成。

```text
Use case: infographic-diagram
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: Explain the two Windows Terminal command-line arguments that assign a pane title and prevent applications from overwriting it.
Audience: 有基础电脑使用经验、但不熟悉 Windows Terminal 命令行参数的中文读者
Style/medium: polished original flat vector technical infographic, warm off-white background, dark navy typography, teal and orange accents, rounded code cards, small lock and label icons, high contrast, mobile-readable large text.
Composition/framing: top title; two large stacked parameter cards; a compact cause explanation; bottom conclusion banner.
Text (verbatim):
“固定标题，只差两个参数”
“--title "dev"”
“给窗格设置标题”
“--suppressApplicationTitle”
“阻止应用改写标题”
“Shell（命令行解释器）”
“或程序可能主动更新标题”
“一个负责命名，一个负责防覆盖”
Constraints: Render every quoted line exactly once. The code strings must be monospaced and character-perfect: two hyphens before title, lowercase title, lowercase dev in straight double quotes, and exactly “--suppressApplicationTitle” with this capitalization. Do not split the long parameter across lines. No logos, no watermark, no QR code, no real path, no project name, no account, no IP, no extra prose. No tiny text.
```

## 03 每个窗格使用相同标题

输入图片：首版生成图作为编辑目标，用于保留既有布局、颜色和全部核心文字，只移除窗格内多余的路径提示符。

初始生成提示词：

```text
Use case: infographic-diagram
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: Show the reusable BAT pattern for keeping one Windows Terminal tab title unchanged across four panes.
Audience: 有基础电脑使用经验、会看简单 BAT 脚本的中文读者
Style/medium: polished original flat vector technical infographic, warm off-white background, dark navy typography, teal and orange accents, rounded code panel, four simple pane blocks with check marks, high contrast, mobile-readable large text.
Composition/framing: top title; first a small title-variable code strip; center 2x2 four-pane diagram labeled initial pane and three split panes; below it a shared-arguments code card pointing to all four panes; bottom conclusion banner.
Text (verbatim):
“多窗格：每个窗格都要设置”
“set "TAB_TITLE=dev"”
“TAB_TITLE（标题变量）”
“初始窗格”
“split-pane ①”
“split-pane ②”
“split-pane ③”
“--title "%TAB_TITLE%"”
“--suppressApplicationTitle”
“4 个窗格使用同一组标题参数”
“切换焦点，标签名仍保持一致”
Constraints: Render every quoted line exactly once. All code must be monospaced and character-perfect, including underscores, percent signs, straight double quotes, two leading hyphens, hyphens in split-pane, and capitalization of suppressApplicationTitle. Do not show any filesystem path. The four panes belong inside one tab; do not depict four separate tabs. No logos, no watermark, no QR code, no project name, no account, no IP, no extra prose. No tiny text.
```

定向修订提示词：

```text
Use case: precise-object-edit
Asset type: Chinese technical knowledge card
Primary request: In each of the four dark terminal panes, replace only the drive-letter path prompt shown in the draft and its adjacent rectangular cursor with a neutral terminal prompt symbol “>_”.
Constraints: Make exactly four replacements, one inside each pane. Change nothing else. Preserve every existing Chinese and English character elsewhere exactly, including “set "TAB_TITLE=dev"”, “TAB_TITLE（标题变量）”, all pane labels, “--title "%TAB_TITLE%"”, “--suppressApplicationTitle”, the two bottom conclusions, layout, colors, arrows, proportions, typography, and check marks. Do not add any path, logo, watermark, QR code, or extra text.
```

## 04 启动脚本不是会话快照

输入图片：无，新图生成。

```text
Use case: infographic-diagram
Asset type: 原创中文技术知识卡片，3:4 竖版
Primary request: Clarify what a Windows Terminal BAT launcher can reconstruct and what it does not save.
Audience: 有基础电脑使用经验、容易把启动脚本误解为会话快照的中文读者
Style/medium: polished original flat vector technical infographic, warm off-white background, dark navy typography, teal and orange accents, two-column rounded comparison cards, simple rebuild-arrow and snapshot icons, high contrast, mobile-readable large text.
Composition/framing: top title; subtitle defining BAT; center two-column comparison “能重建” versus “不会保存”; bottom explanation and conclusion banner.
Text (verbatim):
“脚本保存的不是会话快照”
“BAT (Batch File，批处理文件)”
“每次启动按规则重新创建”
“能重建”
“Layout（布局）”
“Starting Directory（启动目录）”
“Tab Title（选项卡标题）”
“不会保存”
“已输入的命令”
“正在运行的进程”
“终端滚动历史”
“记住规则，不等于冻结现场”
Constraints: Render every quoted line exactly once. Keep BAT, Batch File, Layout, Starting Directory, Tab Title capitalization exact. Put the three English/Chinese items only under “能重建”, and the three Chinese items only under “不会保存”. No logos, no watermark, no QR code, no real path, no project name, no account, no IP, no extra prose. No tiny text.
```
