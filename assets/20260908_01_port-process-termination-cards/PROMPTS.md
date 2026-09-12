# 最终生成提示词

## 01 Windows

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 重新制作 Windows 按端口查进程并结束进程的知识卡片。必须使用完全不透明、铺满整张画布的浅米白背景，不允许透明区域、棋盘格、黑色空洞或边缘噪点。所有代码必须保持可直接执行的一行命令，不得把同一条命令拆到下一行。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，Windows 蓝与青绿色强调，圆角步骤卡，清晰等宽字体代码块，通用窗口网格、终端和放大镜图标；不用品牌 Logo。
Composition/framing: 顶部标题和术语，中部三个纵向大步骤，底部 UDP 补充与安全提醒；留白充足，字号适合手机。
Text (verbatim):
"Windows：端口 8080 被谁占了？"
"PowerShell 精确查 PID，再结束进程"
"Port（端口）→ PID（Process Identifier，进程标识符）→ Process（进程）"
"① 查找 TCP 监听进程"
"$port = 8080"
"$connections = Get-NetTCPConnection -LocalPort $port -State Listen"
"$processIds = $connections.OwningProcess | Sort-Object -Unique"
"② 核对连接和进程名"
"$connections"
"Get-Process -Id $processIds"
"③ 确认无误后结束"
"Stop-Process -Id $processIds"
"不询问确认："
"Stop-Process -Id $processIds -Force"
"-Force：跳过确认；不是“温和退出”"
"UDP 怎么查？"
"Get-NetUDPEndpoint -LocalPort $port"
"TCP（Transmission Control Protocol，传输控制协议）"
"UDP（User Datagram Protocol，用户数据报协议）"
"安全提醒"
"先核对进程名，再执行停止命令。"
"查看其他用户或系统进程时，需管理员权限。"
"不要把变量命名为 $pid：$PID 是 PowerShell 自动变量。"
Constraints: 每段双引号内的代码必须逐字、单行呈现，不能在命令内部换行；美元符号、大小写、连字符、管道符和参数完全正确；整张图背景必须100%不透明且纯净；不要添加多余命令；不用品牌 Logo；无水印；无页码；无“1/3”角标。
Avoid: 透明背景、棋盘格、黑色背景、黑色空洞、边缘噪点、乱码、代码换行、错误参数、密集小字。
```

## 02 Linux

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创、简单易懂的 Linux 按监听端口查进程并结束进程的知识卡片。
Scene/backdrop: 浅米白背景，极淡灰色命令行网格纹理。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，橙色和青绿色强调，圆角步骤卡，等宽字体代码块，少量终端、Socket、信号波形图标。
Composition/framing: 顶部标题和术语，中部四步纵向流程，底部验证与安全提醒；留白充足，适合手机阅读。
Text (verbatim):
"Linux：按监听端口锁定进程"
"ss 找 Socket，ps 核对，kill 发 Signal"
"Socket（套接字）｜PID（Process Identifier，进程标识符）｜Signal（信号）"
"① 查 TCP 监听端口"
"sudo ss -ltnp 'sport = :8080'"
"-l 监听｜-t TCP｜-n 数字显示｜-p 进程"
"UDP："
"sudo ss -lunp 'sport = :8080'"
"② 用 PID 核对进程"
"ps -fp 12345"
"③ 先请求正常退出"
"kill -TERM 12345"
"SIGTERM（请求正常终止）"
"④ 仍不退出，再强制结束"
"kill -KILL 12345"
"SIGKILL（强制终止，进程无法自行清理）"
"验证端口是否释放"
"sudo ss -ltnp 'sport = :8080'"
"TCP（Transmission Control Protocol，传输控制协议）"
"UDP（User Datagram Protocol，用户数据报协议）"
"安全提醒"
"先 TERM，确认仍存在再 KILL。"
"查看或结束其他用户进程通常需要 sudo。"
"服务、Docker 或 systemd 可能自动重新拉起进程。"
Constraints: 所有文字逐字准确；代码使用清晰等宽字体；单引号、冒号、连字符、参数必须完全正确；TERM 与 KILL 的视觉层级明确；不要使用 Linux 品牌 Logo；不放水印；不放页码或“2/3”角标。
Avoid: 把 SIGTERM 写成强制终止、把 SIGKILL 写成可清理退出、密集小字、深色大背景、拟真截图、装饰性乱码。
```

## 03 macOS

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 重新制作 macOS 按端口查进程并结束进程的知识卡片。必须使用完全不透明、铺满整张画布的浅米白背景，不允许透明区域、棋盘格、黑色空洞或边缘噪点。每条 lsof 和 ps 命令必须在一个代码框内完整单行呈现，不得拆行。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，靛蓝与青绿色强调，圆角步骤卡，清晰等宽字体代码块，通用终端、文件、放大镜和信号图标；不用 Apple Logo。
Composition/framing: 顶部标题与 lsof 解释，中部四步纵向流程，底部只输出 PID 技巧、术语与安全提醒；留白充足，适合手机。
Text (verbatim):
"macOS：用 lsof 查端口占用"
"lsof = List Open Files（列出已打开文件）"
"Port（端口）→ PID（Process Identifier，进程标识符）→ Process（进程）"
"① 查 TCP 监听进程"
"sudo lsof -nP -iTCP:8080 -sTCP:LISTEN"
"重点看：COMMAND｜PID｜USER｜NAME"
"UDP："
"sudo lsof -nP -iUDP:8080"
"② 用 PID 核对进程"
"ps -p 12345 -o pid,user,comm,args"
"③ 先请求正常退出"
"kill -TERM 12345"
"SIGTERM（请求正常终止）"
"④ 仍不退出，再强制结束"
"sudo kill -KILL 12345"
"SIGKILL（强制终止）"
"只输出 PID"
"lsof -tiTCP:8080 -sTCP:LISTEN"
"TCP（Transmission Control Protocol，传输控制协议）"
"UDP（User Datagram Protocol，用户数据报协议）"
"安全提醒"
"不要直接把未知 PID 交给 kill。"
"系统服务或 launchd 任务可能自动重启。"
"若端口仍显示，等几秒后重新查询。"
Constraints: 每段双引号内的代码逐字、单行呈现；lsof 全部为小写，TCP、UDP、LISTEN、TERM、KILL 大小写准确，冒号与连字符准确；整张图背景100%不透明且纯净；不用品牌 Logo；无水印；无页码；无“3/3”角标。
Avoid: 透明背景、棋盘格、黑色背景、黑色空洞、边缘噪点、代码换行、乱码、把 SIGTERM 与 SIGKILL 画反。
```

## 04 Windows CMD

```text
Use case: scientific-educational
Asset type: 中文技术知识卡片，3:4 竖版
Primary request: 制作一张原创、简单易懂的 Windows CMD 按端口查进程并结束进程知识卡片。使用完全不透明、铺满整张画布的浅米白背景。每条 CMD 命令必须在一个代码框内完整单行呈现，不能拆行。
Style/medium: 清爽扁平矢量信息图，深海军蓝标题，Windows 蓝与青绿色强调，强制结束步骤用少量橙红色，圆角步骤卡，清晰等宽字体代码块，通用命令提示符窗口、端口、放大镜和进程图标；不用品牌 Logo。
Composition/framing: 顶部大标题与 CMD 双语解释；中部四个紧凑纵向步骤；底部 UDP 补充、术语与安全提醒。层级清晰、留白充足、手机端易读。把主流程画成 Port → LISTENING → PID → Process。
Text (verbatim):
"Windows CMD：端口 8080 被谁占了？"
"CMD（Command Prompt，命令提示符）"
"Port（端口）→ LISTENING（监听中）→ PID（进程标识符）→ Process（进程）"
"① 查找 TCP 监听端口"
"netstat -ano -p tcp | findstr ":8080" | findstr LISTENING"
"看结果：Local Address｜State｜最右侧 PID"
"② 用 PID 核对进程"
"tasklist /FI "PID eq 12345""
"③ 确认无误后尝试结束"
"taskkill /PID 12345"
"④ 仍不退出，再强制结束"
"taskkill /F /PID 12345"
"/F（Force，强制结束）"
"UDP 怎么查？"
"netstat -ano -p udp | findstr ":8080""
"UDP 没有 LISTENING 状态列"
"重新执行第①步，确认端口记录消失"
"TCP（Transmission Control Protocol，传输控制协议）"
"UDP（User Datagram Protocol，用户数据报协议）"
"安全提醒"
"findstr 是文本匹配：请确认 Local Address 的端口正好是 8080。"
"先核对进程名，再执行 taskkill。"
"系统或其他用户进程需使用管理员 CMD。"
"谨慎使用 /T：它会同时结束子进程。"
Constraints: 所有文字逐字准确；每条命令必须完整单行，不在管道符处换行；双引号、冒号、大小写、连字符、斜杠、管道符和参数必须准确；强调 PID 位于 netstat 输出最右侧；不要添加未要求的命令；完全不透明背景；无水印；无页码；无“4/4”角标。
Avoid: 透明背景、棋盘格、黑色大背景、黑色空洞、边缘噪点、代码断行、错误引号、乱码、密集小字、拟真截图。
```
