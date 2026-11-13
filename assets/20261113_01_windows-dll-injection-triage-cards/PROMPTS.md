# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文 Windows 技术知识卡片，3:4 竖版
Audience: 有基础 Windows 使用经验、但不熟悉调用栈、DLL 注入和内核驱动排查的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅灰蓝背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的文件夹窗口、事件日志、调用栈、DLL、调试器、驱动芯片和检查清单图标；大字号、留白充足、手机端易读。
Composition: 顶部标题和短副标题，中部使用流程、分层或清单讲清证据关系，底部一句准确提醒。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、下划线、星号、箭头、等号、斜杠和中文标点；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实软件名、服务名、驱动名、组织名、项目地址、仓库 URL、内网 IP、本机绝对路径、账号、凭据或可关联到具体组织的标识。
```

第 01 张不使用输入图片。第 02 张使用第 01 张最终图作视觉风格参考；第 03 张使用第 02 张最终图作视觉风格参考。参考图只用于配色、标题层级、圆角信息块、图标语言和留白，不是编辑目标。第 04 张最终版不使用输入图片。

## 01 Explorer 为什么反复卡死

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第1张，严格3:4竖版手机信息图
Primary request: 解释打开 Explorer 后反复无响应、自动重启时，先判断是 AppHang（应用假死）而不是直接归因于 CPU 不足。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅灰蓝背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；Windows 文件夹窗口、暂停符号、事件日志、仪表盘图标；大字号、留白充足、手机端易读。
Composition: 顶部标题与副标题；中部上下两个圆角面板，先列“表面现象”，再列“关键证据”；底部一句结论。
Text (verbatim), and do not add any other text:
Title: "Explorer 为什么反复卡死？"
Subtitle: "卡在 DLL 加载器，不等于 CPU 不够"
Panel 1 title: "表面现象"
Panel 1 line: "打开窗口 → 无响应 → 自动重启"
Panel 2 title: "关键证据"
Panel 2 line 1: "AppHangB1"
Panel 2 line 2: "Responding = False"
Panel 2 line 3: "不要只看累计 CPU"
Bottom reminder: "先分清：崩溃、假死，还是资源饱和"
Constraints: 所有文字逐字呈现；准确保留 Explorer、DLL、CPU、AppHangB1、Responding、等号、箭头和中文标点；禁止添加Logo、水印、二维码、页码或平台标识；不出现真实软件名、服务名、驱动名、项目名、路径、IP、账号或组织标识；必须是明显3:4竖版，不能横版。
```

## 02 微软 DLL 不一定是元凶

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第2张，严格3:4竖版手机信息图
Input image: 使用最近一张图片仅作为系列视觉风格参考，继承浅灰蓝背景、深海军蓝标题、蓝色和青绿色圆角信息块、少量橙色警示、扁平矢量技术图标、大字号与留白；不要复制其文字或信息结构。
Primary request: 解释调用栈里的微软系统模块可能只是被堵住的位置，真正起点可能是第三方注入 DLL。
Style/medium: 清爽扁平矢量技术信息图；完全不透明背景；高对比；手机端易读。
Composition: 顶部标题与副标题；中部用三层纵向因果链，每层一个圆角模块与图标，自上而下由“表层”到“底层”；用箭头连接；底部一句排障原则。
Text (verbatim), and do not add any other text:
Title: "微软 DLL 不一定是元凶"
Subtitle: "调用栈显示堵点，不一定显示起点"
Layer 1 title: "表层：系统组件被堵"
Layer 1 line: "WMI / WAM / CloudStore"
Layer 2 title: "中层：加载器互相等待"
Layer 2 line: "LdrLoadDll / LdrUnloadDll"
Layer 3 title: "底层：第三方注入卡锁"
Layer 3 line: "注入 DLL → 互斥锁 → 全局假死"
Bottom reminder: "沿调用栈向下找第一个异常第三方模块"
Constraints: 所有文字逐字呈现；准确保留 DLL、WMI、WAM、CloudStore、LdrLoadDll、LdrUnloadDll、斜杠和箭头；三层关系必须明确，不能暗示微软系统模块本身一定有故障；不添加Logo、水印、二维码、页码或平台标识；不出现真实软件名、服务名、驱动名、路径、IP、账号或组织标识；必须为3:4竖版。
```

## 03 怎样抓到隐藏注入器

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第3张，严格3:4竖版手机信息图
Input image: 使用最近一张图片仅作为系列视觉风格参考，继承浅灰蓝背景、深海军蓝标题、蓝色和青绿色圆角信息块、少量橙色警示、扁平矢量技术图标、大字号与留白；不要复制其文字或信息结构。
Primary request: 用四步流程说明如何从 Explorer 假死定位到隐藏的内核注入驱动。
Style/medium: 清爽扁平矢量技术信息图；完全不透明背景；高对比；手机端易读。
Composition: 顶部标题与副标题；中部纵向四步流程，每步有编号、简洁图标和一句话；步骤之间用向下箭头；底部橙色证据提示。
Text (verbatim), and do not add any other text:
Title: "怎样抓到隐藏注入器？"
Subtitle: "不要猜，用证据一层层缩小范围"
Step 1 title: "1 先看 WER"
Step 1 line: "确认 AppHang（应用假死）"
Step 2 title: "2 再用 CDB"
Step 2 line: "lm 查模块，kb 看调用栈"
Step 3 title: "3 抓加载瞬间"
Step 3 line: "在注入 DLL 加载时断下"
Step 4 title: "4 查运行驱动"
Step 4 line: "定位 SYSTEM_START 注入驱动"
Bottom reminder: "堆内存 → LdrLoadDll：警惕远程或内核注入"
Constraints: 所有文字逐字呈现；准确保留 WER、AppHang、CDB、lm、kb、DLL、SYSTEM_START、LdrLoadDll、下划线、逗号、冒号、箭头和中文括号；WER 表示 Windows Error Reporting（Windows 错误报告），CDB 表示 Console Debugger（控制台调试器），通过图标辅助表达但不要额外加字；不添加Logo、水印、二维码、页码或平台标识；不出现真实软件名、服务名、驱动名、路径、IP、账号或组织标识；必须为3:4竖版。
```

## 04 卸载前后怎么验收

最终图使用以下提示词，不使用输入图片：

```text
Use case: scientific-educational
Asset type: 原创中文 Windows 技术知识卡片，系列第4张最终版，严格3:4竖版手机信息图
Primary request: 说明卸载旧安全接入客户端后的完整验收清单。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅灰蓝背景；深海军蓝标题；蓝色、青绿色圆角清单；少量橙色提醒；大字号、留白充足。
Composition: 顶部标题与短副标题；中部恰好五条水平清单，每条只出现一次文字，左侧编号和单个图标，右侧一行文字；禁止在面板标题或其他位置重复清单文字；底部一句提醒。
Text (verbatim), and do not add or duplicate any other text:
Title: "卸载前后怎么验收？"
Subtitle: "只删主程序，不代表注入链已经消失"
Row 1: "1 使用官方卸载器"
Row 2: "2 检查服务、驱动与 AppInit_DLLs"
Row 3: "3 集中改完，再计划一次重启"
Row 4: "4 lm m *Agent*：结果应为空"
Row 5: "5 Explorer 持续响应，无新增 AppHang"
Bottom reminder: "主程序、内核驱动、注入项必须一起消失"
Constraints: 每条清单文字只能出现一次，不能复制到面板标题；必须准确拼写 "AppInit_DLLs"，其中 AppInit 为大写 A 和 I，DLLs 为大写 DLL 加小写 s，中间只有一个下划线；必须准确显示 "lm m *Agent*"；第3项明确只计划一次重启；准确保留 Explorer、AppHang、星号、冒号、逗号和中文标点；不添加Logo、水印、二维码、页码或平台标识；不出现真实软件名、服务名、驱动名、路径、IP、账号或组织标识；必须为3:4竖版。
```

## 04 定向重生成说明

第 04 张第一次生成把第 2 至 5 项同时放在面板标题和正文中，造成重复；`AppInit_DLLs` 的字形也不够清晰，因此没有采用。最终版改为“每项只出现一次的水平清单”，并逐字约束 `AppInit_DLLs` 与 `lm m *Agent*` 的拼写。最终图为整张重生成，不是局部编辑。
