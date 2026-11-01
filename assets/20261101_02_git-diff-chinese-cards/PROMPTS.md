# 图片生成提示词

## 统一视觉规范

- 用例：`infographic-diagram`。
- 原创中文社交媒体技术知识卡片，严格 3:4 竖版，目标构图 1080×1440。
- 浅米白背景、轻微纸张纹理、深蓝高对比标题、浅蓝圆角信息块、橙色重点、少量终端与文件图标。
- 手机端一眼读完；命令与十六进制字节使用清晰等宽字体。
- 不出现平台标识、水印、真实路径、用户名、仓库名、网址或任何可关联个人与组织的标识。
- 用户提供的两张终端截图只用于诊断，不作为图片生成输入，防止其中的本机路径和仓库信息进入公开卡片。

## 01 `01-why-less.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 1 张，共 5 张，重新生成最终版
Primary request: 解释为什么 git diff 的中文会显示成 <E8><83> 这种形式
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 原创现代中文技术信息图，扁平矢量风，深蓝标题，浅蓝圆角信息块，橙色重点，少量终端窗口与分页器图标
Composition/framing: 严格 3:4 竖版，1080×1440 构图；手机端一眼读完；从上到下清晰层级；留足边距
Text (verbatim):
"git diff 中文为何变成 <E8>？"
"文件没坏，是 less 没认出 UTF-8"
"UTF-8"
"Unicode Transformation Format–8-bit"
"Unicode 八位转换格式"
"1  Git 生成 diff"
"2  less（终端分页器）逐页显示"
"3  字符集判断错误，字节被展开"
"CMD 和 PowerShell 都可能中招"
Constraints: 所有文字必须逐字准确，只出现上述文字；命令与 <E8> 使用清晰等宽字体；中文字号大且易读；用三步纵向流程箭头；不要把“分页器”写错；不要出现任何真实路径、用户名、仓库名、网址、品牌标识或水印；不要模仿任何平台模板
Avoid: 密集段落、过小字号、英文拼写错误、乱码、额外文字、写实人物、截屏风格
```

定向修订记录：首次生成把“分页器”误写为“分员器”；曾要求只修这一处，但修订没有生效，因此放弃错误版本并使用上面的最终提示词整张重生成。

## 02 `02-byte-example.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 2 张，共 5 张
Primary request: 用一个准确的字节示例解释 <E8> 不是中文编码本身，而是 UTF-8 字节被分页器当成不可打印字符逐个展开
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 原创现代中文技术信息图，扁平矢量风，深蓝标题，浅蓝圆角信息块，橙色重点，终端与字节方块图标
Composition/framing: 严格 3:4 竖版，1080×1440 构图；手机端可读；中心用大号横向流程图
Text (verbatim):
"这些 <E4><B8><AD> 是什么？"
"“中” 的 UTF-8 字节"
"中"
"E4"
"B8"
"AD"
"文件里的字节"
"less 误判字符集"
"<E4><B8><AD>"
"字节没变，解释方式错了"
"Encoding（字符编码）"
Constraints: 所有文字必须逐字准确，只出现上述文字；把“中 → E4 B8 AD → <E4><B8><AD>”画成清晰三段流程；英文与十六进制使用等宽字体；中文字号大；不要出现真实路径、用户名、仓库名、网址、品牌标识或水印；不要模仿任何平台模板
Avoid: 密集段落、额外文字、乱码、错误字节、把 E4 B8 AD 改成其他内容、写实人物
```

## 03 `03-current-window.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 3 张，共 5 张
Primary request: 展示 CMD 和 PowerShell 当前窗口修复 git diff 中文显示的命令
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 原创现代中文技术信息图，扁平矢量风，深蓝标题，浅蓝圆角信息块，橙色重点；左右两个终端面板
Composition/framing: 严格 3:4 竖版，1080×1440 构图；手机端可读；上方标题，中间左右对比，底部提醒
Text (verbatim):
"先修当前窗口"
"LESSCHARSET"
"less 字符集"
"CMD"
"set LESSCHARSET=utf-8"
"git diff"
"PowerShell"
"$env:LESSCHARSET = 'utf-8'"
"git diff"
"只对当前窗口有效"
Constraints: 所有文字必须逐字准确，只出现上述文字；命令必须使用清晰等宽字体且单行完整显示；左右终端面板等宽；用绿色对勾表示修复后中文可读；不要出现真实路径、用户名、仓库名、网址、品牌标识或水印；不要模仿任何平台模板
Avoid: 命令换行、漏掉美元符号、漏掉单引号、把 utf-8 写错、额外文字、乱码、写实人物
```

## 04 `04-persistent-fix.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 4 张，共 5 张
Primary request: 展示 Windows 当前用户永久设置 less UTF-8 字符集的方法
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 原创现代中文技术信息图，扁平矢量风，深蓝标题，浅蓝圆角步骤块，橙色重点，少量终端与重开窗口图标
Composition/framing: 严格 3:4 竖版，1080×1440 构图；手机端可读；大号命令块加三步流程
Text (verbatim):
"一条命令永久修复"
"setx LESSCHARSET utf-8"
"1  运行一次"
"2  关闭 CMD 和 PowerShell"
"3  打开新窗口，再运行 git diff"
"已有窗口不会自动更新"
"当前 Windows 用户生效"
Constraints: 所有文字必须逐字准确，只出现上述文字；setx 命令必须单行完整显示并使用等宽字体；三步用清晰数字与箭头；不要出现管理员权限要求，因为 setx 默认写当前用户变量；不要出现真实路径、用户名、仓库名、网址、品牌标识或水印；不要模仿任何平台模板
Avoid: 把 setx 写成 set、漏掉 utf-8、命令换行、额外命令、密集段落、乱码、写实人物
```

## 05 `05-setting-boundaries.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 5 张，共 5 张
Primary request: 区分 git diff 中文显示问题中四个常被混淆的设置
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 原创现代中文技术信息图，扁平矢量风，深蓝标题，四个浅蓝圆角信息块，橙色重点，少量终端、文件名、诊断图标
Composition/framing: 严格 3:4 竖版，1080×1440 构图；手机端可读；四行对照清晰分隔
Text (verbatim):
"别把四个设置混在一起"
"LESSCHARSET=utf-8"
"让 less 按 UTF-8 解释正文"
"chcp 65001"
"把控制台代码页切到 UTF-8"
"core.quotePath=false"
"只影响中文路径显示"
"git --no-pager diff"
"绕过 less，快速定位问题"
"正文出现 <E8>：先查 LESSCHARSET"
Constraints: 所有文字必须逐字准确，只出现上述文字；四个命令使用清晰等宽字体；每行一个命令加一句作用，不能串错；底部结论用橙色高亮；不要出现真实路径、用户名、仓库名、网址、品牌标识或水印；不要模仿任何平台模板
Avoid: 把 core.quotePath 说成修正文、把 chcp 说成 Git 配置、命令拼写错误、额外文字、密集段落、乱码、写实人物
```

## 06 `06-less-version.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 6 张，共 8 张
Primary request: 解释 less 551 的版本号含义，明确它不是 5.5.1
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 与同系列一致的原创现代中文技术信息图，扁平矢量风，深蓝标题，浅蓝圆角信息块，橙色重点，少量版本标签和时间轴图标
Composition/framing: 严格 3:4 竖版；手机端一眼读完；上方问题，中间大号对比，底部结论
Text (verbatim):
"less 551 是 5.5.1 吗？"
"不是"
"less 551"
"= Version 551"
"≠ Version 5.5.1"
"Less 使用连续整数版本号"
"530 → 551 → 561"
"551 发布于 2019 年 6 月"
"把它读作“第 551 版”"
Constraints: 所有文字必须逐字准确，只出现上述文字；突出等号和不等号；less、Version 与数字使用清晰等宽字体；不得把 551 拆成 5.5.1；不要出现真实路径、用户名、仓库名、网址、平台标识或水印
Avoid: 额外版本号、错误日期、密集段落、过小字号、乱码、写实人物
```

## 07 `07-lesscharset-limits.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 7 张，共 8 张
Primary request: 解释 LESSCHARSET 不是自动识别器，并说明 less 551 不支持 GBK 或 CP936
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 与同系列一致的原创现代中文技术信息图，扁平矢量风，深蓝标题，浅蓝圆角信息块，橙色重点，绿色对勾和红色叉号
Composition/framing: 严格 3:4 竖版；手机端一眼读完；上方结论，中间支持与不支持对比，底部提醒
Text (verbatim):
"LESSCHARSET 能自动识别吗？"
"不能：它是固定解释规则"
"less 551 接受"
"utf-8"
"latin1"
"iso8859"
"dos"
"windows"
"不接受"
"GBK（汉字内码扩展规范）"
"CP936（Code Page 936，代码页 936）"
"utf-8 是唯一多字节模式"
"GBK 文件仍需单独转换"
Constraints: 所有文字必须逐字准确，只出现上述文字；支持项配绿色对勾，不支持项配红色叉号；命令名和编码名使用等宽字体；不能把 windows 解释成 GBK；不要出现真实路径、用户名、仓库名、网址、平台标识或水印
Avoid: 错把 GBK 或 CP936 列为支持、额外编码名、密集段落、过小字号、乱码、写实人物
```

定向修订提示词：

```text
只修改底部第二行“GBK 文件仍需单独转换”左侧的绿色对勾，把它改成橙色三角警告图标，图标内是白色感叹号。只改该图标，其他文字、图标、颜色、布局和尺寸保持不变。
```

## 08 `08-auto-detection.png`

最终提示词：

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 8 张，共 8 张，重新生成最终版
Primary request: 解释为什么 less 或 git diff 不能百分之百自动识别任意编码，并给出可靠做法
Scene/backdrop: 浅米白背景，轻微纸张纹理
Style/medium: 与同系列一致的原创现代中文技术信息图，扁平矢量风，深蓝标题，浅蓝圆角信息块，橙色重点；文件图标只能使用空白横线和问号，不得出现任何十六进制字节
Composition/framing: 严格 3:4 竖版；手机端一眼读完；上方结论，中间三段原因，底部两条可靠方案
Text (verbatim):
"任何编码都能自动识别吗？"
"不能 100% 可靠"
"BOM"
"Byte Order Mark，字节顺序标记"
"有 BOM：可明确判断"
"无 BOM：只能统计猜测"
"同一串字节可能对应多种编码"
"一次 git diff 还能混合多种编码"
"可靠做法"
"统一使用 UTF-8"
"或用 .gitattributes 按路径声明"
"别让 less 猜，让仓库声明"
Constraints: 所有文字必须逐字准确，只出现上述文字；BOM 第一次出现必须同时给出英文全称和中文解释；UTF-8、git diff、less、.gitattributes 使用清晰等宽字体；用问号与分流图表达“只能猜测”；所有插图里禁止出现任何额外字母、数字、十六进制字节或伪代码；不要出现真实路径、用户名、仓库名、网址、平台标识或水印
Avoid: 宣称可百分之百检测、E4、B8、AD、E6、96、87、X7、额外工具名、密集段落、过小字号、乱码、写实人物
```

修订记录：初稿插图出现错误字节 `E6 96 X7`；定向文字修订没有生效，因此放弃该版本，改用上述最终提示词整张重生成，并禁止插图加入具体字节。
