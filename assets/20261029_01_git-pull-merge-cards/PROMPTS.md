# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文 Git 技术知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、但不熟悉 Git 提交拓扑和拉取策略的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；简化的 Git 分支线、提交节点、终端窗口和图形客户端图标；大字号、留白充足、手机端易读。
Composition: 顶部标题与副标题，中部按阅读顺序展示拓扑、对比或操作步骤，底部一句准确提醒；命令使用深色等宽字体代码框。
Constraints: 所有引号内文字逐字呈现；命令完整单行显示；准确保留英文大小写、空格、点号、斜杠、双短横线、等号、尖括号和数字；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实仓库名、远端 URL、真实提交哈希、本机绝对路径、账号或凭据。
```

第 01 张使用已有公开卡片 `assets/20261019_01_git-stash-pop-cards/01-abort-vs-conflict.png` 作为视觉风格参考，只继承配色、标题层级、圆角信息块、代码框、Git 图标语言和留白。第 02 至 04 张分别使用上一张最终成品作为视觉风格参考，不复用上一张文字或信息结构。用户提供的日志截图仅用于分析事实，没有作为生成输入，避免带入真实仓库和提交标识。

## 01 普通 pull 为什么产生合并提交

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 1 张
Input image: use the referenced existing public card only as a visual style reference for palette, typography hierarchy, rounded information blocks, terminal code box, Git branch icon language, and generous spacing. Do not copy its text or layout.
Audience: 有基础电脑使用经验、但不熟悉 Git 提交拓扑的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝大标题；蓝色、青绿色圆角信息块；少量橙色提醒；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题，中部为一个清楚的 Git 分叉后再合并拓扑图，下部为配置代码框，底部一句结论。留白充足。
Text (verbatim), and do not add any other text:
Title: "Merge 提交从哪来？"
Subtitle: "git pull = Fetch（获取）+ Merge（合并）"
Diagram start label: "共同基准"
Left branch label: "本地有新提交"
Right branch label: "远端有新提交"
Merge node label: "Merge Commit（合并提交）"
Small block title: "当前拉取策略"
Code: "pull.rebase=false"
Bottom reminder: "两边都前进，普通 pull 就会合并"
Constraints: exactly preserve all Chinese, English capitalization, spaces, period, equals sign, and parentheses; code must be complete on one line in a dark monospace box; clearly draw one common base splitting into local and remote paths and joining at the Merge Commit node; no real repository name, URL, commit hash, username, machine path, account, credentials, logo, watermark, QR code, page number, or platform branding.
```

## 02 两个父提交与相对差异

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 2 张
Input image: use the referenced first card only as a visual style reference for palette, title weight, rounded information blocks, Git graph language, and generous spacing. Do not copy its text or topology.
Audience: 有基础电脑使用经验、但不熟悉 Git 合并提交的中文读者
Style/medium: 与参考图一致的清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝大标题；蓝色、青绿色圆角信息块；少量橙色重点；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部清楚画出 Merge Commit 位于顶部、向下连接两个父提交的 Y 形关系；中下部放一个类似日志窗口的浅蓝提示条；底部给出准确结论。
Text (verbatim), and do not add any other text:
Title: "为什么像新增了一堆文件？"
Subtitle: "Merge Commit（合并提交）有两个父提交"
Top node: "Merge Commit"
Left node title: "Parent 1（第一父提交）"
Left node line: "合并前的本地顶点"
Right node title: "Parent 2（第二父提交）"
Right node line: "拉取到的远端顶点"
UI strip: "与第 1 个父提交比较"
Arrow result: "显示另一条分支带来的差异"
Bottom reminder: "文件列表是相对差异，不是重复提交"
Constraints: exactly preserve all Chinese, English capitalization, spaces, number 1, and parentheses; clearly show one merge node with exactly two parent nodes; do not imply that files are duplicated; no terminal commands needed; no real repository name, URL, commit hash, username, machine path, account, credentials, logo, watermark, QR code, page number, or platform branding.
```

## 03 未推送时安全拉直历史

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 3 张
Input image: use the referenced card only as a visual style reference for palette, title hierarchy, rounded step blocks, dark terminal code boxes, and generous spacing. Do not copy its text or diagram.
Audience: 有基础电脑使用经验、但不熟悉 Git 历史改写的中文读者
Style/medium: 与参考图一致的清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝大标题；蓝色、青绿色步骤块；少量橙色警示；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部按从上到下的阅读顺序排列四个清晰步骤，每步含短标题与一条完整命令；用箭头串联；底部放橙色边界提醒。命令全部使用深色等宽字体代码框并保持单行。
Text (verbatim), and do not add any other text:
Title: "未推送：怎样安全拉直？"
Subtitle: "Linear History（线性历史）"
Step 1 title: "① 获取最新远端"
Step 1 code: "git fetch origin"
Step 2 title: "② 先留备份分支"
Step 2 code: "git branch backup/before-cleanup"
Step 3 title: "③ 回到本地旧顶点"
Step 3 code: "git reset --keep <本地旧顶点>"
Step 4 title: "④ 重放到远端顶部"
Step 4 code: "git rebase origin/main"
Bottom reminder: "会改写本地提交哈希；已推送先协作确认"
Constraints: exactly preserve all Chinese, English capitalization, spaces, slash, double hyphens, angle brackets, semicolon, circled numbers, and parentheses; every command must appear once, complete, and on one line; use a generic branch timeline icon but no real identifiers; no real repository name, URL, commit hash, username, machine path, account, credentials, logo, watermark, QR code, page number, or platform branding.
```

## 04 预防意外合并

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 4 张
Input image: use the referenced card only as a visual style reference for palette, title hierarchy, rounded comparison blocks, dark terminal code boxes, and generous spacing. Do not copy its text or step layout.
Audience: 有基础电脑使用经验、但不熟悉 Git 拉取策略的中文读者
Style/medium: 与参考图一致的清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝大标题；蓝色、青绿色对比块；少量橙色提醒；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部左右两个等宽策略块，各自包含英文术语、中文解释、完整命令和一句行为说明；下部放图形客户端建议；底部一句选择原则。命令使用深色等宽字体代码框并保持单行。
Text (verbatim), and do not add any other text:
Title: "怎样避免意外 Merge？"
Subtitle: "二选一，先定拉取策略"
Left block title: "Fast-forward Only（仅快进）"
Left code: "git config --local pull.ff only"
Left line: "分叉时停止，不自动合并"
Right block title: "Rebase（变基）"
Right code: "git config --local branch.main.rebase true"
Right line: "把未推送提交重放到远端顶部"
Client note title: "图形客户端"
Client note: "Fetch 后明确选择 Rebase"
Bottom reminder: "拒绝意外合并，或明确变基"
Constraints: exactly preserve all Chinese, English capitalization, spaces, hyphen, double hyphens, periods, and parentheses; every command must appear once, complete, and on one line; visually distinguish the strict stop strategy from the automatic rebase strategy; no real repository name, URL, commit hash, username, machine path, account, credentials, product logo, watermark, QR code, page number, or platform branding.
```

本次生成结果一次通过，没有对最终图片执行局部修图或定向重生成，因此没有额外修订提示词。
