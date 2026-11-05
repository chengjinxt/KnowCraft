# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 五张原创中文 Git 技术知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、但不熟悉 Git 内部存储和历史重写的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的归档箱、Git 对象、历史时间轴、本地电脑、远端服务器、忽略盾牌和构建产物图标；大字号、留白充足、手机端易读。
Composition: 顶部标题与副标题，中部按阅读顺序展示概念、原因、风险或操作边界，底部一句准确提醒；命令和规则使用深色等宽字体代码框。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、星号、斜杠、连字符、等号、加号、箭头、不等号和括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实仓库名、远端 URL、真实提交哈希、本机绝对路径、账号或凭据。
```

第 01 张使用已有公开卡片 `assets/20261029_01_git-pull-merge-cards/01-why-pull-creates-merge.png` 作为视觉风格参考，只继承配色、标题层级、圆角信息块、技术图标语言和留白。第 02 至 05 张使用第 01 张最终生成结果作为视觉风格参考，不复用其中的文字或信息结构。所有输入图片都只承担视觉风格参考作用，不是编辑目标。

## 01 Packfile 是什么

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 1 张
Input image: 参考图仅用于继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、少量橙色警示、扁平矢量技术图标、大字号和充足留白；不要复制参考图文字或具体布局。
Audience: 有基础电脑使用经验、但不熟悉 Git 内部存储的中文读者
Primary request: 解释 Git 的 .pack 文件是什么，以及为什么不能把它当成普通缓存。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部画一个大型压缩归档盒，内部整齐放置三类 Git 对象图标；下部放一条“压缩 + 差量存储”的机制条；底部橙色警示。阅读顺序自上而下，留白充足。
Text (verbatim), and do not add any other text:
Title: ".pack 文件是什么？"
Subtitle: "Packfile（Git 对象包文件）"
Badge: "它不是普通缓存"
Object 1: "Commit（提交）"
Object 2: "Tree（目录结构）"
Object 3: "Blob（文件内容）"
Mechanism: "压缩 + Delta（差量存储）"
Bottom reminder: "手删 .pack，Git 仓库可能损坏"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、空格、点号、加号和中文括号；不要把三个对象解释成独立文件；不要出现真实仓库名、URL、提交哈希、本机路径、账号、凭据、Logo、水印、二维码、页码或平台标识。
```

## 02 为什么 pack 会很大

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 2 张
Input image: 使用参考图只继承浅米白背景、深海军蓝标题、蓝色和青绿色圆角信息块、橙色提醒、扁平矢量技术图标、大字号与留白；不要复制参考图文字或布局。
Audience: 有基础电脑使用经验、但不熟悉 Git 历史存储的中文读者
Primary request: 解释 Git pack 为什么会被 Visual Studio 缓存和调试符号撑大。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部画一个仓库历史时间轴，多个提交依次把大型二进制文件放入存储箱；中下部用两个并列圆角块解释 .ipch 和 .pdb；底部橙色结论。留白充足。
Text (verbatim), and do not add any other text:
Title: "为什么能大到几 GB？"
Subtitle: "GB（Gigabyte，吉字节）"
Timeline: "提交 → 修改 → 再提交"
History line: "历史会保留旧版本"
Left block title: ".ipch"
Left block line: "IntelliSense 预编译头缓存"
Right block title: ".pdb"
Right block line: "Program Database（程序数据库）"
Mechanism: "二进制产物不易做 Delta（差量压缩）"
Bottom reminder: "当前已删除 ≠ Git 历史已消失"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、箭头、不等号和中文括号；让 .ipch 与 .pdb 明确属于大型构建或开发产物，不要暗示它们是 Git 必需文件；不要出现真实仓库名、URL、提交哈希、本机路径、账号、凭据、Logo、水印、二维码、页码或平台标识。
```

## 03 为什么不能直接删除

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 3 张
Input image: 使用参考图只继承浅米白背景、深海军蓝标题、蓝色和青绿色圆角信息块、橙色警示、扁平矢量技术图标、大字号与留白；不要复制参考图文字或布局。
Audience: 有基础电脑使用经验、但不熟悉 Git 对象数据库的中文读者
Primary request: 明确回答能否手工删除 .pack 和配套 .idx 文件，并解释风险。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部画一个三步风险链路，从删除文件图标指向对象缺失警告，再指向不可用的 Git 历史；下部单独放 .idx 说明；底部橙色安全边界。留白充足。
Text (verbatim), and do not add any other text:
Title: "能直接删除 .pack 吗？"
Subtitle: "不能！它是 Git 对象数据库的一部分"
Step 1: "手工删除"
Step 2: "Missing Object（对象缺失）"
Step 3: "历史、分支或当前提交可能不可用"
Index line: ".idx = Index（索引文件）"
Index note: "也不要单独删除"
Bottom reminder: "废弃仓库可整目录删除；在用仓库不要拆"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、等号、分号和中文括号；风险链路必须清楚，不能暗示删除后一定可恢复；不要出现真实仓库名、URL、提交哈希、本机路径、账号、凭据、Logo、水印、二维码、页码或平台标识。
```

## 04 只在本地执行 filter-repo

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 4 张
Input image: 使用参考图只继承浅米白背景、深海军蓝标题、蓝色和青绿色圆角信息块、橙色提醒、扁平矢量技术图标、大字号与留白；不要复制参考图文字或布局。
Audience: 有基础电脑使用经验、准备只在本地清理 Git 历史的中文读者
Primary request: 解释 git filter-repo 只在本地执行且不推送时，本地和远端分别会发生什么。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部左右两个等宽圆角面板，左边表示本地电脑，右边表示远端服务器；两个面板之间画一道清楚的“不推送”断开线；下部橙色提醒；底部给出安全做法。留白充足。
Text (verbatim), and do not add any other text:
Title: "只在本地瘦身，可以吗？"
Subtitle: "可以，但 Local History（本地历史）会重写"
Left title: "本地"
Left tool: "git filter-repo"
Left line 1: "提交哈希改变"
Left line 2: "重新生成较小的 pack"
Center label: "不执行 push"
Right title: "远端"
Right line 1: "共享仓库不变化"
Right line 2: "其他人不受影响"
Risk: "重新获取旧历史，大对象可能回来"
Bottom reminder: "先在新克隆或备份副本中验证"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、空格、连字符和中文括号；明确表达“不推送则远端不变”，不能暗示本地重写会自动影响服务器；不要出现真实仓库名、URL、提交哈希值、本机路径、账号、凭据、Logo、水印、二维码、页码或平台标识。
```

## 05 防止再次膨胀

```text
Use case: scientific-educational
Asset type: 原创中文 Git 技术知识卡片，3:4 竖版，系列第 5 张
Input image: 使用参考图只继承浅米白背景、深海军蓝标题、蓝色和青绿色圆角信息块、橙色提醒、扁平矢量技术图标、大字号与留白；不要复制参考图文字或布局。
Audience: 有基础电脑使用经验、希望预防 Git 仓库再次膨胀的中文读者
Primary request: 说明 .gitignore 的作用边界、常见忽略规则和历史清理的关系。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题与副标题；中部画一个 .gitignore 盾牌，旁边纵向排列三个深色等宽字体规则框；下部用两个步骤块区分“当前已跟踪”和“历史仍很大”；底部橙色结论。留白充足。
Text (verbatim), and do not add any other text:
Title: "怎样避免再次膨胀？"
Subtitle: ".gitignore 只防止以后误提交"
Rule 1: ".vs/"
Rule 2: "*.ipch"
Rule 3: "*.pdb（按项目需要）"
Step 1: "已跟踪：先取消跟踪"
Step 2: "历史仍大：再用 git filter-repo"
Bottom reminder: "构建产物应放 Artifact Repository（制品库）"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、星号、斜杠、连字符、中文冒号和中文括号；三个规则必须完整显示且各占一行；不要暗示所有项目都必须忽略 .pdb；不要出现真实仓库名、URL、提交哈希、本机路径、账号、凭据、Logo、水印、二维码、页码或平台标识。
```

本次 5 张最终图片均由基础提示词直接生成，没有执行局部修图或定向重生成，因此没有额外修订提示词。
