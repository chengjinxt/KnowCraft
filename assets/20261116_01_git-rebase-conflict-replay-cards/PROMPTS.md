# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文 Git 技术知识卡片，严格 3:4 竖版
Audience: 会使用 Git，但不熟悉 Rebase 重放与冲突复发条件的中文研发人员
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；简洁提交节点、分支线、文件和冲突闪电图标；大字号、留白充足、手机端易读。
Composition: 顶部标题与短副标题，中部用提交拓扑或流程讲清机制，底部一句准确结论。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、中文括号、箭头、斜杠、双短横线和单引号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实项目名、仓库地址、远端 URL、本机绝对路径、账号、凭据或真实提交哈希。
```

第 01 张不使用输入图片。第 02 至 04 张使用第 01 张最终成品作为视觉风格参考，只继承配色、标题层级、圆角信息块、技术图标语言和留白，不复制其中的文字或信息结构。

## 01 Rebase 冲突会再来吗

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，系列第1张，严格3:4竖版手机卡片
Primary request: 回答“Rebase 冲突解决后，还会不会再次冲突”，强调取决于远端是否新增提交以及是否改到同一片代码。
Scene/backdrop: 完全不透明浅米白背景。
Style/medium: 清爽扁平矢量技术信息图，深海军蓝标题，蓝色与青绿色圆角信息块，少量橙色提醒；简洁提交节点、分支线和冲突闪电图标；大字号、留白充足、手机端易读。
Composition/framing: 顶部大标题和短副标题；中部上下两个圆角面板展示“不会自动复发”和“可能再次发生”；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "Rebase 冲突解决后，还会再来吗？"
Subtitle: "关键看新的远端变化"
Panel 1 title: "不会自动复发"
Panel 1 line: "已解决结果会写进新提交 A'"
Panel 2 title: "仍可能再冲突"
Panel 2 line: "远端新增 R，并改到同一片代码"
Term: "Rebase（变基）"
Term 2: "Conflict（冲突）"
Bottom reminder: "解决的是这一次冲突，不是永久免疫"
Constraints: 所有引号内文字必须逐字准确；准确保留英文大小写、中文括号和 A' 的单引号；不出现提示词之外的文字；无品牌Logo、水印、二维码、页码和平台标识；不出现真实项目名、仓库地址、远端URL、本机路径、账号、凭据或真实提交哈希；严格竖版，禁止横版。
```

## 02 Git 重放了什么

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，系列第2张，严格3:4竖版手机卡片
Input image: 仅把参考图作为视觉风格参考，继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色提醒、扁平矢量提交节点、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释 Rebase（变基）不是把旧提交原地搬走，而是读取本地提交 A 的改动，在远端新基准 R 后重新应用，生成新提交 A'。
Style/medium: 清爽扁平矢量技术信息图，完全不透明浅米白背景，高对比、手机端易读。
Composition/framing: 顶部标题和短副标题；中部三步纵向流程，分别配提交卡片、补丁纸张和新提交节点；下部用一条清晰时间线显示 B → R → A'；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "Git 到底重放了什么？"
Subtitle: "Replay（重放）的是提交改动"
Step 1: "1 读取本地提交 A 的改动"
Step 2: "2 在新基准 R 后重新应用"
Step 3: "3 生成新提交 A'"
Timeline: "B → R → A'"
Bottom reminder: "内容可以相同，提交哈希会改变"
Constraints: 所有引号内文字必须逐字准确；准确保留英文大小写、中文括号、箭头和 A' 的单引号；不添加其他文字；无品牌Logo、水印、二维码、页码和平台标识；不出现真实项目名、仓库地址、远端URL、本机路径、账号、凭据或真实提交哈希；严格竖版，禁止横版。
```

## 03 什么时候通常不会再冲突

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，系列第3张，严格3:4竖版手机卡片
Input image: 仅把参考图作为视觉风格参考，继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色提醒、扁平矢量提交节点、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释两种通常不会再次发生 Rebase 冲突的情况：远端没有变化；或者本地提交已经 push 且本地没有新的独有提交，此时只需 Fast-forward（快进）。
Style/medium: 清爽扁平矢量技术信息图，完全不透明浅米白背景，高对比、手机端易读。
Composition/framing: 顶部标题和短副标题；中部左右或上下两个大圆角面板；第一个面板是远端不变并显示 Already up to date；第二个面板是本地提交已经到达远端，再用直线箭头表示 Fast-forward；底部蓝绿色结论条。
Text (verbatim), and do not add any other text:
Title: "什么时候通常不会再冲突？"
Subtitle: "没有本地提交需要重放"
Panel 1 title: "远端没有变化"
Panel 1 line: "再次 pull --rebase"
Panel 1 result: "Already up to date"
Panel 2 title: "本地提交已经 push"
Panel 2 line: "之后没有新的本地提交"
Panel 2 result: "Fast-forward（快进）"
Bottom reminder: "没有本地独有提交，就没有内容需要重放"
Constraints: 所有引号内文字必须逐字准确；准确保留英文大小写、中文括号和命令中的两个短横线；不添加其他文字；无品牌Logo、水印、二维码、页码和平台标识；不出现真实项目名、仓库地址、远端URL、本机路径、账号、凭据或真实提交哈希；严格竖版，禁止横版。
```

## 04 什么时候可能再次冲突

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，系列第4张，严格3:4竖版手机卡片
Input image: 仅把参考图作为视觉风格参考，继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色提醒、扁平矢量提交节点、大字号和充足留白；不要复制参考图文字或信息结构。
Primary request: 解释远端出现新提交 R、本地仍有未推送提交 A，并且两者修改同一区域时，pull --rebase 会重放 A 并可能再次产生冲突。
Style/medium: 清爽扁平矢量技术信息图，完全不透明浅米白背景，高对比、手机端易读。
Composition/framing: 顶部标题和短副标题；中部用三段纵向流程，先展示远端 R 与本地 A 分叉，再展示 git pull --rebase，最后用两条线在同一文件图标处相撞并标注 Conflict；下部给出安全操作链；底部橙色结论条。
Text (verbatim), and do not add any other text:
Title: "什么时候可能再次冲突？"
Subtitle: "新变化碰到同一片代码"
Step 1: "远端新增 R"
Step 2: "本地仍有未推送 A"
Step 3: "R 与 A 修改同一区域"
Command: "git pull --rebase"
Result: "A 重放为 A'"
Conflict: "Conflict（冲突）"
Action: "先 fetch → 看 ahead / behind → 再 rebase"
Bottom reminder: "上次结果会保留，新变化仍可能冲突"
Constraints: 所有引号内文字必须逐字准确；准确保留英文大小写、中文括号、箭头、斜杠、命令中的两个短横线和 A' 的单引号；不添加其他文字；无品牌Logo、水印、二维码、页码和平台标识；不出现真实项目名、仓库地址、远端URL、本机路径、账号、凭据或真实提交哈希；严格竖版，禁止横版。
```

四张最终图片均由对应基础提示词直接生成，没有执行局部修图或定向重生成。
