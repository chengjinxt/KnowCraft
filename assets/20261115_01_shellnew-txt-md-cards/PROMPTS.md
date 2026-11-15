# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文 Windows 技术知识卡片，严格3:4竖版
Audience: 有基础 Windows 使用经验、但不熟悉文件类型注册和 ShellNew 的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；简化的文件、注册表、编辑器、备份和刷新图标；大字号、留白充足、手机端一眼能读完。
Constraints: 所有指定文字逐字呈现；准确保留英文大小写、句点、加号、箭头、括号和中文标点；不添加 Logo、水印、二维码、页码或平台标识。
Public-release redaction: 不出现真实安装路径、账号、IP、仓库、组织信息或凭据；应用安装位置只在说明文档中使用占位符。
```

四张最终图片均不使用输入图片。系列一致性通过重复使用同一视觉规范、配色、标题层级、圆角模块和图标语言实现。

## 01 右键“新建”为何会消失

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第1张，严格3:4竖版手机信息图
Primary request: 解释右键“新建”中的 TXT 或 Markdown 项为何会消失，准确说明扩展名、ProgID 和 ShellNew 三层关系。
Style/medium: 清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的文件、注册表层级和齿轮图标；大字号、留白充足、手机端一眼能读完。
Composition: 顶部标题和短副标题；中部恰好三个纵向圆角模块，用向下箭头连接；底部一句结论。不要放代码截图。
Text (verbatim), and do not add any other text:
Title: "右键“新建”为何会消失？"
Subtitle: "它不只看默认打开软件"
Block 1 title: "文件扩展名"
Block 1 line: ".txt / .md"
Block 2 title: "ProgID"
Block 2 line: "Programmatic Identifier（程序标识符）"
Block 2 note: "决定类型名称和打开命令"
Block 3 title: "ShellNew（新建菜单配置）"
Block 3 line: "NullFile（创建空文件）"
Bottom reminder: "三层缺一，“新建”就可能不显示"
Constraints: 所有文字逐字呈现；准确保留 ProgID、Programmatic Identifier、ShellNew、NullFile、.txt、.md、斜杠、英文大小写、中文括号和引号；不添加 Logo、水印、二维码、页码或平台标识；不出现真实路径、账号、IP、仓库或组织信息；必须是明显的3:4竖版，不能横版。
```

## 02 TXT 恢复链路

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第2张，严格3:4竖版手机信息图
Primary request: 说明如何恢复右键“新建”中的 TXT 文档，同时保持 Notepad++ 为默认打开程序。
Style/medium: 与系列第1张一致的清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；文件、注册表、Notepad++风格代码编辑器图标（不要使用品牌Logo）；大字号、留白充足、手机端易读。
Composition: 顶部标题和短副标题；中部恰好三个纵向步骤卡，用数字1、2、3和箭头连接；底部一句结论。
Text (verbatim), and do not add any other text:
Title: "TXT：这样恢复"
Subtitle: "默认仍用 Notepad++ 打开"
Step 1 title: "1 关联文件类型"
Step 1 line: ".txt → NotepadPlusPlus.txt"
Step 1 note: "建立 ProgID 关联"
Step 2 title: "2 补回新建配置"
Step 2 line: "ShellNew → NullFile"
Step 2 note: "允许创建空白 TXT"
Step 3 title: "3 指向打开命令"
Step 3 line: "open → Notepad++"
Step 3 note: "双击仍用指定编辑器"
Bottom reminder: "默认打开与右键新建，要分别检查"
Constraints: 所有文字逐字呈现；准确保留 TXT、Notepad++、.txt、NotepadPlusPlus.txt、ProgID、ShellNew、NullFile、open、句点、加号、箭头和中文标点；不要绘制任何真实品牌Logo；不添加水印、二维码、页码或平台标识；不出现真实安装路径、账号、IP、仓库或组织信息；必须为3:4竖版。
```

## 03 Markdown 恢复链路

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第3张，严格3:4竖版手机信息图
Primary request: 说明如何恢复右键“新建”中的 Markdown 文档，同时保持 Typora 为默认打开程序。
Style/medium: 与前两张一致的清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；Markdown 文件、注册表、简洁写作编辑器图标（不要使用品牌Logo）；大字号、留白充足、手机端易读。
Composition: 顶部标题和短副标题；中部恰好三个纵向步骤卡，用数字1、2、3和箭头连接；底部一句结论。
Text (verbatim), and do not add any other text:
Title: "MD：这样恢复"
Subtitle: "默认仍用 Typora 打开"
Step 1 title: "1 关联文件类型"
Step 1 line: ".md → Typora.md"
Step 1 note: "建立 ProgID 关联"
Step 2 title: "2 补回新建配置"
Step 2 line: "ShellNew → NullFile"
Step 2 note: "允许创建空白 MD"
Step 3 title: "3 写好类型名称"
Step 3 line: "Markdown 文档"
Step 3 note: "菜单显示名来自 ProgID"
Bottom reminder: "打开命令继续指向 Typora"
Constraints: 所有文字逐字呈现；准确保留 MD、Typora、Markdown、.md、Typora.md、ProgID、ShellNew、NullFile、句点、箭头和中文标点；不要绘制任何真实品牌Logo；不添加水印、二维码、页码或平台标识；不出现真实安装路径、账号、IP、仓库或组织信息；必须为3:4竖版。
```

## 04 刷新与现场验收

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第4张最终版，严格3:4竖版手机信息图
Primary request: 精确呈现本机右键“新建”菜单的刷新与验收，不把15项写成所有Windows的统一上限。
Style/medium: 与前三张一致的清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；备份箱、刷新箭头、菜单清单和对勾图标；大字号、留白充足、手机端易读。
Composition: 顶部标题和短副标题；中部恰好三个纵向圆角模块；第1模块是备份，第2模块是刷新，第3模块是本机证据；底部绿色成功结论。不要显示真实桌面截图。
Text (verbatim), and do not add, repeat, paraphrase, explain, or duplicate any other text:
Title: "写对了仍不显示？"
Subtitle: "Explorer（文件资源管理器）也要刷新"
Block 1 title: "1 先备份"
Block 1 line: "导出相关注册表项"
Block 2 title: "2 再刷新"
Block 2 line: "关闭并重开 Explorer"
Block 3 title: "3 本机现场（非通用上限）"
Block 3 line 1: "原菜单已有 15 个文件类型项"
Block 3 line 2: "移除闲置 Regsnap Document"
Bottom reminder: "TXT + Markdown 最终同时出现"
Constraints: 画面中只能出现以上九段文字，任何图标内都不要加字；准确保留 Explorer、15、Regsnap Document、TXT、Markdown、加号、数字和中文括号；禁止添加解释气泡、额外标签、菜单模拟文字、Logo、水印、二维码、页码或平台标识；不出现真实安装路径、账号、IP、仓库或组织信息；必须为3:4竖版。
```

## 第 04 张定向重生成说明

第一次生成额外加入了“这是本机的实际验收结果，不代表所有 Windows 的统一结论”气泡，虽与技术边界一致，但违反“只出现指定文字”的版式要求，因此未采用。最终版把边界压缩进 `3 本机现场（非通用上限）`，并增加“任何图标内都不要加字、禁止额外气泡”的逐字约束后整张重生成。
