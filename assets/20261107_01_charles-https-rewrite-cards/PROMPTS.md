# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 五张原创中文 Charles HTTPS 调试知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、第一次使用 HTTPS 抓包和响应改写的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的客户端、代理服务器、证书、锁、设置、请求响应和检查图标；高对比、大字号、留白充足、手机端易读。
Composition: 顶部标题，中部按阅读顺序展示机制、步骤或排错关系，底部一句安全提醒；代码和配置值使用清晰等宽字体框。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、数字、尖括号、双引号、反斜杠、斜杠、星号、冒号、箭头和中文括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实域名、账号、接口、业务权益编号、证书指纹、Token、Cookie、本机绝对路径或可关联到个人和组织的标识。
```

第 01 张使用既有公开卡片 `assets/20261105_01_git-pack-cleanup-cards/01-packfile-basics.png` 作为视觉风格参考，只继承配色、标题层级、圆角信息块、技术图标语言和留白。第 02 至 05 张使用第 01 张最终成品作为视觉风格参考，不复用其中的文字或信息结构。所有输入图片都只承担视觉风格参考作用，不是编辑目标。

## 01 HTTPS 抓包的三道门

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 1 张
Input image: 只参考配色、标题层级、圆角信息块、扁平矢量技术图标和留白；不要复制参考图文字或具体布局。
Audience: 有基础电脑使用经验、第一次用 Charles 抓取 HTTPS 的中文读者
Primary request: 解释 Charles 能读取 HTTPS 流量必须同时满足的三项条件。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色和青绿色圆角信息块；少量橙色警示；高对比、大字号、手机端易读。
Composition: 顶部标题和两行缩写解释；中部三道门依次纵向连接，每道门配简洁图标；底部橙色提醒。留白充足。
Text (verbatim), and do not add any other text:
Title: "Charles 为什么抓不到 HTTPS？"
Definition 1: "HTTPS（安全超文本传输协议）"
Definition 2: "SSL Proxying（HTTPS 解密代理）"
Step 1: "① 流量经过 Charles 代理"
Step 1 note: "代理地址 + 端口必须正确"
Step 2: "② 目标主机启用 SSL Proxying"
Step 2 note: "只转发，不等于能解密"
Step 3: "③ 客户端信任 Charles 根证书"
Step 3 note: "否则会出现证书错误"
Bottom reminder: "三道门缺一道，都看不到完整正文"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、加号和中文括号；三道门关系必须清楚；不出现真实域名、账号、接口、证书指纹、Logo、水印、二维码、页码或平台标识。
```

为满足缩写首次出现时同时给出英文全称和中文解释的项目规则，第 01 张在最终成品前执行了一次定向文字修订：

```text
Use case: text-localization
Asset type: 对现有中文技术知识卡片做单点文字修订
Primary request: 只修改标题下方第一个浅蓝色释义条，把原文字“HTTPS（安全超文本传输协议）”替换为三行居中的准确文字：
第 1 行："HTTPS"
第 2 行："Hypertext Transfer Protocol Secure"
第 3 行："安全超文本传输协议"
Composition: 为三行文字适当增加这个浅蓝色释义条的高度或缩小该条内字号，仍保持清晰、居中、手机端可读。
Constraints: 除这一个浅蓝色释义条外，图片的标题、第二个蓝色释义条、三道门全部文字、图标、布局、颜色、尺寸、底部提醒必须保持不变；准确保留英文拼写和大小写；不要添加任何其他文字；无 Logo、水印、二维码、页码或平台标识。
```

## 02 根证书与 Windows 存储范围

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 2 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示、扁平矢量图标、大字号和留白；不要复制文字或具体布局。
Audience: Windows 上使用 Charles 调试 HTTPS 的中文读者
Primary request: 解释 Charles 根证书的作用、Windows 证书存储位置和安全边界。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题；中部用“客户端 ↔ Charles ↔ 服务器”链路解释动态站点证书；下部两个并列信息块解释当前用户与本地计算机；底部橙色安全提醒。
Text (verbatim), and do not add any other text:
Title: "为什么必须安装根证书？"
Flow: "客户端 ↔ Charles ↔ 服务器"
Mechanism 1: "Charles 动态签发站点证书"
Mechanism 2: "由 Charles Root Certificate 签名"
Store title: "Trusted Root Certification Authorities"
Store note: "受信任的根证书颁发机构"
Left block: "Current User（当前用户）"
Left note: "只影响当前用户"
Right block: "Local Machine（本地计算机）"
Right note: "影响这台电脑的所有用户"
Restart note: "安装后重启目标应用，建立新连接"
Bottom reminder: "仅在自有或已授权测试机安装；测试后删除"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、双向箭头、分号和中文括号；明确表达 Charles 处于中间代理位置；不出现真实域名、账号、接口、证书指纹、Logo、水印、二维码、页码或平台标识。
```

第 02 张第一次生成时仅发生连接失败，没有产出图片；随后用完全相同的提示词重试成功，没有定向修订内容。

## 03 只解密目标主机

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 3 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示、扁平矢量图标、大字号和留白；不要复制文字或具体布局。
Audience: 使用 Charles 定位 HTTPS 接口的中文读者
Primary request: 展示怎样让应用流量进入 Charles，并只对目标主机启用 SSL Proxying。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题；中部依次展示代理设置、Charles 中的目标主机配置、重新建立连接；用清晰箭头连接；底部橙色提醒。
Text (verbatim), and do not add any other text:
Title: "只解密目标主机"
Step 1: "① 让应用流量经过代理"
Example: "示例：127.0.0.1:8888"
Example note: "以 Charles 实际端口为准"
Step 2: "② 启用 SSL Proxying"
Menu: "Proxy > SSL Proxying Settings"
Location: "<目标域名>:443"
Alternative: "也可右键目标主机启用"
Step 3: "③ 重启目标应用或建立新连接"
Scope title: "为什么不建议直接填 *"
Scope note: "范围越大，暴露的敏感流量越多"
Bottom reminder: "只添加本次调试所需的主机"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、尖括号、冒号、大于号、星号和中文括号；不要把 127.0.0.1:8888 表述为固定值；不出现真实域名、账号、接口、证书指纹、Logo、水印、二维码、页码或平台标识。
```

## 04 临时改写响应值

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 4 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示、扁平矢量图标、大字号和留白；不要复制文字或具体布局。
Audience: 需要用 Charles Rewrite 临时改写测试响应的中文读者
Primary request: 展示一条最小、精确的响应正文 Rewrite 规则。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读；JSON 使用清晰等宽字体代码框。
Composition: 顶部标题和工具入口；中部左侧是 Location 四字段，右侧是 Rule 四字段；下部用前后对比代码框表现数值改写；底部橙色提醒。
Text (verbatim), and do not add any other text:
Title: "临时改写响应值"
Tool: "Tools > Rewrite"
Location title: "Location（匹配范围）"
Location 1: "Protocol：https"
Location 2: "Host：<目标域名>"
Location 3: "Port：443"
Location 4: "Path：<目标接口路径>"
Rule title: "Rule（改写规则）"
Rule 1: "Type：Body"
Rule 2: "Where：Response（响应）"
Rule 3: "Regex：关闭"
Rule 4: "Replace：All"
Before label: "Match"
Before code: "\"quotaMiB\":5120"
After label: "Replace"
After code: "\"quotaMiB\":10240"
Bottom reminder: "按原始响应逐字匹配；Body 区分大小写"
Constraints: 所有引号内文字逐字呈现；代码框中必须准确显示双引号、冒号和数字，不显示反斜杠；准确保留英文大小写、尖括号、大于号、全角冒号和中文括号；不要出现真实域名、账号、接口、业务权益编号、证书指纹、Logo、水印、二维码、页码或平台标识。
```

## 05 验证、排错与安全收尾

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 5 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示、扁平矢量图标、大字号和留白；不要复制文字或具体布局。
Audience: 需要确认 Charles Rewrite 是否生效并排查失败原因的中文读者
Primary request: 展示正确验证顺序、四类常见失败表现和测试后的安全收尾。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；高对比、大字号、手机端易读。
Composition: 顶部标题；上半部三步验证流程；中部四格故障速查；底部橙色安全收尾提醒。
Text (verbatim), and do not add any other text:
Title: "Rewrite 生效了吗？"
Step 1: "① 触发一条新请求"
Step 2: "② 打开 Response > Raw / Text"
Step 3: "③ 确认 5120 → 10240"
History note: "旧记录不会被倒改"
Problem 1: "没有请求"
Cause 1: "应用未走代理"
Problem 2: "只有 CONNECT"
Cause 2: "未启用 SSL Proxying"
Problem 3: "证书错误"
Cause 3: "根证书未受信或应用未重启"
Problem 4: "规则没生效"
Cause 4: "检查 Location、Where、大小写和空格"
Cleanup 1: "关闭 Rewrite"
Cleanup 2: "移除不再需要的根证书"
Bottom reminder: "仅测试自有或已授权系统，不改真实生产数据"
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、大于号、斜杠、箭头、英文逗号和中文顿号；四类问题与原因必须一一对应；不出现真实域名、账号、接口、业务权益编号、证书指纹、Logo、水印、二维码、页码或平台标识。
```

除第 01 张记录的缩写释义修订外，其余最终图片均由对应基础提示词直接生成，没有执行局部修图或定向重生成。
