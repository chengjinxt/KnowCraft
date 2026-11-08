# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文 Git 技术知识卡片，3:4竖版
Audience: 会使用 Git提交、但不熟悉历史重写与对象可达性的中文研发人员
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色安全警示；简化的提交节点、分支时间线、本地电脑、远端服务器、盾牌与回收箱图标；大字号、留白充足、手机端易读。
Composition: 顶部标题与短副标题，中部用时间线或分栏讲清机制，底部一句准确提醒；Git命令使用深色等宽字体代码框。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、连字符、尖括号、单引号、箭头和中文括号；不添加提示词之外的文字；无品牌Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实项目名、仓库地址、远端URL、本机绝对路径、账号、凭据或真实提交哈希。
```

第01张不使用输入图片。第02至04张使用第01张最终生成结果作为视觉风格参考，只继承配色、标题层级、圆角信息块、技术图标语言和留白，不复用其中的文字或信息结构。所有输入图片仅作视觉风格参考，不是编辑目标。

## 01 未推送的敏感提交能修吗

```text
Use case: scientific-educational
Asset type: 原创中文 Git技术知识卡片，3:4竖版，系列第1张
Primary request: 解释只有本地、从未推送的敏感提交可以在推送前重写为脱敏历史。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部画一台本地电脑，里面是一条 a1→a2→a3→a4 的提交时间线，a1带橙色警示，a4带绿色修正标记；右侧远端服务器与本地之间用断开的连接表示尚未推送；底部橙色边界提醒。
Text (verbatim), and do not add any other text:
Title: "未推送的敏感提交能修吗？"
Subtitle: "可以，但必须在 push 之前重写历史"
Timeline: "a1 → a2 → a3 → a4"
Label 1: "a1：误含敏感信息"
Label 2: "a4：完成脱敏"
Center: "Local Only（仅在本地）"
Remote: "远端尚未收到"
Bottom reminder: "先停止 push，再修正历史"
Constraints: 准确保留英文大小写、空格、冒号、箭头和中文括号；不能暗示已推送历史同样安全；不出现真实项目名、仓库地址、本机路径、账号、凭据或真实提交哈希。
```

## 02 fixup 与 autosquash

```text
Use case: scientific-educational
Asset type: 原创中文 Git技术知识卡片，3:4竖版，系列第2张
Input image: 使用参考图只继承浅米白背景、深海军蓝标题、蓝色和青绿色圆角信息块、橙色提醒、扁平矢量技术图标、大字号与留白；不要复制参考图文字或布局。
Primary request: 用两条命令和三步流程解释 fixup提交如何通过 autosquash折回 a1。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部两个深色等宽字体命令框；下部画三步流程：标记修正、移动到目标后、折入新提交；底部给出结果式。
Text (verbatim), and do not add any other text:
Title: "fixup 怎样折回 a1？"
Subtitle: "fixup（修正）+ autosquash（自动折叠）"
Command 1: "git commit --fixup=<a1>"
Command 2: "git rebase -i --autosquash <a1^>"
Step 1: "1 标记 a4 属于 a1"
Step 2: "2 自动移动到 a1 后"
Step 3: "3 合并内容并重放后续提交"
Result: "a1 + a4 → a1'"
Bottom reminder: "Git 创建新提交，不是原地修改"
Constraints: 两条命令必须完整显示且各占一行；准确保留英文小写、空格、双连字符、尖括号、插入符、加号、箭头和单引号；不出现真实哈希或凭据。
```

## 03 最终历史剩下什么

```text
Use case: scientific-educational
Asset type: 原创中文 Git技术知识卡片，3:4竖版，系列第3张
Input image: 使用参考图只继承浅米白背景、深海军蓝标题、蓝色和青绿色圆角信息块、橙色提醒、扁平矢量技术图标、大字号与留白；不要复制参考图文字或布局。
Primary request: 解释折叠后 a4不再独立，最终是 a1'→a2'→a3'，并说明后续哈希也会变化。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题；中部上下对照两条提交时间线，上方灰色旧历史，下方绿色新历史；用弯曲箭头展示 a2、a3被重放；下部一个父提交链说明框；底部蓝绿色结论。
Text (verbatim), and do not add any other text:
Title: "最终历史剩下什么？"
Old title: "重写前"
Old timeline: "a1 → a2 → a3 → a4"
New title: "重写后"
New timeline: "a1' → a2' → a3'"
Line 1: "a4 不再是独立提交"
Line 2: "父提交变了，后续提交也要 Replay（重放）"
Line 3: "所以 a1、a2、a3 的哈希都会改变"
Bottom reminder: "远端只会看到推送后的新历史"
Constraints: 准确保留箭头、单引号、顿号和中文括号；明确表现重放关系，不能暗示 a2、a3内容被丢弃；不出现真实哈希或凭据。
```

## 04 本机残留与已推送边界

```text
Use case: scientific-educational
Asset type: 原创中文 Git技术知识卡片，3:4竖版，系列第4张
Input image: 使用参考图只继承浅米白背景、深海军蓝标题、蓝色和青绿色圆角信息块、橙色警示、扁平矢量技术图标、大字号与留白；不要复制参考图文字或布局。
Primary request: 说明重写后旧对象可能暂留本机 Reflog和对象库；若已经推送，必须轮换凭据，历史重写不能抹掉他人副本。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题；中部左右两个圆角面板，左边是未推送场景与本机Reflog，右边是已推送场景与多个远端副本；右侧使用橙色高风险边框；底部一条安全动作链。
Text (verbatim), and do not add any other text:
Title: "旧提交真的消失了吗？"
Left title: "从未推送"
Left line 1: "分支历史已脱敏"
Left line 2: "旧对象可能暂留 Reflog（引用日志）"
Right title: "已经推送"
Right line 1: "远端、缓存、他人克隆可能已保存"
Right line 2: "强制推送也不能保证全部消失"
Action: "立即轮换凭据 → 清理远端历史 → 通知协作者"
Bottom reminder: "历史重写 ≠ 凭据轮换"
Constraints: 准确保留英文大小写、中文顿号、箭头、不等号和中文括号；左右风险等级必须清楚；不出现真实项目名、URL、路径、账号、凭据或提交哈希。
```

## 02 定向修订

首次生成的第02张在第3步把后续节点画成了未带单引号的 `a2`、`a3`，容易误导读者认为后续提交哈希不变，因此没有采用。最终图在原提示词基础上追加：

```text
第3步的时间线必须准确显示 "a1' → a2' → a3'"，a2和a3都必须带单引号；第3步只允许显示带单引号的 a1'、a2'、a3'。
```

## 01 画布方向修订

首次生成的第01张为4:3横版，不符合项目默认的3:4竖版，因此没有采用。最终图使用首次结果作视觉风格参考，并追加：

```text
严格3:4竖版，最终像素比例必须为宽1086、高1448；必须是明显的竖向手机卡片；禁止横向宽画布。
```

第03、04张均由对应基础提示词直接生成，没有执行局部修图或定向重生成。
