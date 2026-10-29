# ImageGen 提示词记录

## 输入图片用途

本知识点未使用输入图片，也不引用上一组卡片作为风格来源。

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 一张原创中文电脑硬件采集知识卡片，3:4竖版
Audience: 有基础电脑使用经验、需要把电脑配置带回进一步分析的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明的浅米白背景；深海军蓝标题；蓝紫色圆角信息块；少量青绿色强调；简化的处理器、内存、显卡、硬盘、终端和报告文件图标；大字号、充足留白、手机端易读。
Composition: 顶部高对比标题与一句结论；中部六个双列信息块；下部三个操作系统脚本入口；底部一条隐私与补充资料提醒。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、点号、斜杠和连字符；不添加提示词之外的文字；无品牌Logo、水印、二维码、平台标识、真实账号、网络地址、本机路径或凭据。
```

## 01 跑模型前电脑要查什么

```text
Primary request: 用一张卡说明判断电脑能否运行本地大模型时需要采集哪些硬件信息，并给出三个系统的脚本入口。

Text (verbatim):
“跑模型前，电脑要查什么？”
“不是只报型号，而是采集6组关键数据”
“① 处理器”
“型号 · 架构 · 核心/线程”
“② 内存”
“总量 · 可用量 · 插槽/上限”
“③ 图形处理器”
“型号 · 显存/统一内存”
“④ 加速后端”
“驱动 · 计算接口是否可用”
“⑤ 存储”
“硬盘类型 · 容量 · 剩余空间”
“⑥ 运行环境”
“页面文件/交换空间 · 推理工具版本”
“Windows　collect-windows.ps1”
“macOS　./collect-macos.sh”
“Linux　./collect-linux.sh”
“不采集：主机名、用户名、序列号、网络地址、进程列表”
“报告还要附：模型文件名 · 文件大小 · 上下文 · 图片输入 · 并发数”

Composition/framing: 标题置顶；六个信息块以两列三行排列，每块只配一个简化图标；三个系统脚本入口做成三段等宽终端标签；隐私提醒用浅橙色细条，底部补充资料用深蓝横条。
Constraints: 3:4竖版；不绘制任何操作系统或厂商品牌Logo，只用文字区分系统；所有脚本文件名必须逐字准确；无水印、二维码或额外小字。
```

## 定向修订提示词

### 01 去除多余缩写

```text
change only the hard-drive icon inside the “⑤ 存储” block. Remove the letters “SSD” from the drive and leave it as a plain dark-gray drive icon with the same size, position, screws, connector and shading. change only those three letters; keep every other word, number, punctuation mark, icon, layout, color, size and spacing exactly unchanged. Do not add any new text, logo, watermark or symbol.
```

说明：初稿在硬盘图标上自行添加了 `SSD`，不属于提示词要求，也会增加一个未解释缩写。最终图仅删除这三个字母，其他内容不变。
