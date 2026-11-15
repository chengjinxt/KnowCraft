# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文 Windows 技术知识卡片，严格3:4竖版
Audience: 有基础 Windows 使用经验、但不熟悉 UI Automation、ListView 和 Everything 高级设置的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；简化的搜索窗口、列表、线程、齿轮、配置文件、内存折线和对勾图标；大字号、留白充足、手机端一眼能读完。
Constraints: 所有指定文字逐字呈现；准确保留英文大小写、空格、等号、斜杠、反斜杠、百分号、箭头、括号和中文标点；不添加 Logo、水印、二维码、页码或平台标识。
Public-release redaction: 不出现真实用户名、盘符、账号、IP、仓库、组织、PID、凭据或内部路径；配置位置只使用通用环境变量。
```

四张最终图片均不使用输入图片。系列一致性通过重复使用同一视觉规范、配色、标题层级、圆角模块和图标语言实现。

## 01 Everything 点击即卡的线索

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第1张，严格3:4竖版手机信息图
Primary request: 解释 Everything 点击或滚动后“未响应”的现场诊断线索，强调 UI Automation 和 ListView 消息链路。
Style/medium: 清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的搜索窗口、线程、列表和放大镜图标；大字号、留白充足、手机端一眼能读完。
Composition: 顶部标题和短副标题；中部恰好三个纵向圆角模块；底部一句结论。不要绘制真实软件截图。
Text (verbatim), and do not add any other text:
Title: "Everything 一点就卡？"
Subtitle: "先看 UI Automation，不要只盯 CPU"
Block 1 title: "现场特征"
Block 1 line 1: "点击或滚动后“未响应”"
Block 1 line 2: "内存上涨，磁盘并不忙"
Block 2 title: "主线程在哪"
Block 2 line 1: "UIAutomationCore.dll"
Block 2 line 2: "正在处理 ListView 消息"
Block 3 title: "高概率链路"
Block 3 line: "外部自动化工具 → 大量结果 → UI 线程被占满"
Bottom reminder: "抓卡住当下的线程栈，才能定根因"
Constraints: 所有文字逐字呈现；准确保留 Everything、UI Automation、CPU、UIAutomationCore.dll、ListView、UI、.dll、箭头和中文引号；禁止添加 Logo、水印、二维码、页码、平台标识或额外说明；不出现真实路径、账号、IP、仓库、组织或进程编号；必须是明显的3:4竖版，不能横版。
```

## 02 lvm 的含义与取舍

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第2张，严格3:4竖版手机信息图
Primary request: 用白话解释 Everything 的 lvm 设置是什么、开启和关闭各有什么作用。
Style/medium: 与系列第1张一致的清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的列表、眼睛、屏幕阅读器和盾牌图标；大字号、留白充足、手机端一眼能读完。
Composition: 顶部标题和短副标题；中部恰好三个纵向圆角模块，依次展示 lvm=1、风险、lvm=0；底部一句结论。
Text (verbatim), and do not add any other text:
Title: "lvm 到底是什么？"
Subtitle: "List View Messages（列表视图消息）"
Block 1 title: "lvm=1（默认兼容）"
Block 1 line 1: "允许外部工具读取结果列表"
Block 1 line 2: "利于屏幕阅读器和自动化工具"
Block 2 title: "结果太多时的风险"
Block 2 line: "外部工具可能一次拉取全部项目"
Block 3 title: "lvm=0（限制访问）"
Block 3 line 1: "阻止这类列表消息"
Block 3 line 2: "降低界面卡死风险"
Bottom reminder: "它不是索引开关，也不会删除数据库"
Constraints: 所有文字逐字呈现；准确保留 lvm、List View Messages、lvm=1、lvm=0、等号、数字、空格、英文大小写和中文括号；禁止添加 Logo、水印、二维码、页码、平台标识或额外说明；不出现真实路径、账号、IP、仓库或组织信息；必须是明显的3:4竖版，不能横版。
```

## 03 lvm 的设置位置（最终版）

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第3张最终版，严格3:4竖版手机信息图
Primary request: 准确说明 Everything 的 lvm 设置在哪里修改，明确搜索框命令适用于1.4/1.5，而高级设置界面存在版本差异。
Style/medium: 与系列前两张一致的清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；简化的搜索框、齿轮、配置文件和回车键图标；大字号、留白充足、手机端易读。
Composition: 顶部标题和短副标题；中部恰好三个纵向步骤卡，用数字1、2、3连接；底部一句边界提醒。不要画真实软件截图。
Text (verbatim), and do not add any other text:
Title: "在哪里设置 lvm？"
Subtitle: "Everything 1.4 / 1.5 优先用搜索框"
Step 1 title: "1 通用方法"
Step 1 line: "/lvm=0"
Step 1 note: "在搜索框输入并按 Enter"
Step 2 title: "2 新版图形界面"
Step 2 line: "工具 → 选项 → 高级"
Step 2 note: "搜索 lvm，设为 false"
Step 3 title: "3 配置文件"
Step 3 line: "%APPDATA%\Everything\Everything.ini"
Step 3 note: "退出后写入 lvm=0"
Bottom reminder: "配置位置会受“保存设置”选项影响"
Constraints: 所有文字逐字呈现；准确保留 lvm、Everything、1.4、1.5、/lvm=0、Enter、false、%APPDATA%\Everything\Everything.ini、百分号、反斜杠、句点、箭头和中文引号；配置路径必须显示为单个反斜杠，不能改成斜杠；禁止添加 Logo、水印、二维码、页码、平台标识或额外说明；不出现真实用户名、盘符、账号、IP、仓库或组织信息；必须为3:4竖版。
```

## 04 修复后的验证

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第4张，严格3:4竖版手机信息图
Primary request: 说明关闭 Everything 的 lvm 后如何验证修复，并提示无障碍和自动化读取边界。
Style/medium: 与系列前三张一致的清爽扁平矢量技术信息图；完全不透明暖白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；简化的搜索列表、鼠标、内存折线、对勾和线程栈图标；大字号、留白充足、手机端易读。
Composition: 顶部标题和短副标题；中部三个纵向验收步骤；随后绿色成功模块和橙色排错模块；底部一条边界提醒。
Text (verbatim), and do not add any other text:
Title: "改完如何验收？"
Subtitle: "别只看窗口重新打开了"
Step 1: "1 搜索大量结果"
Step 2: "2 单击并滚动列表"
Step 3: "3 连续观察响应和内存"
Success title: "修复有效"
Success line 1: "Responding=True"
Success line 2: "内存不再持续上涨"
Warning title: "仍然卡？"
Warning line: "抓 mini dump 或线程栈"
Bottom reminder: "lvm=0 会限制外部无障碍和自动化工具读取完整结果"
Constraints: 所有文字逐字呈现；准确保留 Responding=True、lvm=0、mini dump、等号、数字和英文大小写；禁止添加 Logo、水印、二维码、页码、平台标识或额外说明；不出现真实路径、账号、IP、仓库、组织、PID 或具体内存数值；必须为3:4竖版。
```

## 第 03 张定向重生成说明

第一次生成把“搜索框命令、图形界面、配置文件”三种入口统称为 Everything 1.4 / 1.5 都完全相同，可能让旧版用户误以为一定存在“高级”设置页，因此未采用。最终版把 `/lvm=0` 标为 1.4 / 1.5 通用优先方法，并把图形入口明确写成“新版图形界面”。
