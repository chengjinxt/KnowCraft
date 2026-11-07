# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 六张原创中文 SSL 证书验证与 Nginx 部署知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、第一次申请 SSL 证书并在 Windows 服务器上配置 Nginx 的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的服务器、证书、放大镜、盾牌、扳手和代码块图标；高对比、大字号、留白充足、手机端易读。
Composition: 顶部标题与释义条，中部按阅读顺序展示机制、步骤、对比或排错关系，底部一句橙色提醒；代码与配置值使用等宽字体框。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、数字、尖括号、下划线、分号、冒号、箭头和中文括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实域名、IP、账号、token 值、证书指纹、本机绝对路径或可关联个人和组织的标识；配置示例统一使用 <证书文件>、<私钥文件>、<静态目录>、<站点域名> 占位符。
```

第 01 张使用既有公开卡片 `assets/20261107_01_charles-https-rewrite-cards/01-three-prerequisites.png` 作为视觉风格参考，只继承配色、标题层级、圆角信息块、技术图标语言和留白。第 02 至 06 张使用第 01 张最终成品作为视觉风格参考，不复用其中的文字或信息结构。所有输入图片只承担视觉风格参考作用，不是编辑目标。

统一后期处理（确定性本地处理，非生成式）：所有生成图右下角存在平台水印，使用 PIL 以背景色覆盖移除；生成画布 1024×1536 两侧逐行扩展至 1152×1536（精确 3:4）；第 05 张额外清除底部提示词泄漏文字；第 02 张条带右下角按顶部圆角轮廓做几何重绘修复。

## 01 证书“验证中”在等什么

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 1 张
Input image: 只参考配色、标题层级、圆角信息块、扁平矢量技术图标和留白；不要复制参考图文字或具体布局。
Audience: 有基础电脑使用经验、第一次申请 SSL 证书并配置网站的中文读者
Primary request: 解释申请 SSL 证书时状态卡在“验证中”，CA 到底在等什么。
Style/medium: 清爽扁平矢量技术信息图；完全不透明浅米白背景；深海军蓝标题；蓝色和青绿色圆角信息块；少量橙色警示；高对比、大字号、手机端易读。
Composition: 顶部标题；标题下两个浅蓝色释义条；中部三个步骤块纵向排列，配图标与右侧浅色说明块；底部橙色提醒条。
Text (verbatim), and do not add any other text:
Title: “证书卡在“验证中”，在等什么？”
Definition 1: “DV（Domain Validation，域名验证）”
Definition 2: “CA（Certificate Authority，证书颁发机构）”
Step 1: “① 申请人在 DNS 添加 TXT 验证记录”
Step 1 note: “主机名形如 _dnsauth”
Step 2: “② CA 反复查询 DNS 验证记录”
Step 2 note: “查不到就一直等待”
Step 3: “③ 记录匹配后签发证书”
Step 3 note: “状态变为已签发”
Bottom reminder: “记录查不到，证书就永远签不下来”
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、下划线、数字和中文括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识；不出现真实域名、IP、账号或可关联个人的标识。
```

第 01 张首次生成带右下角平台水印，先用一次定向修订提示词尝试移除（未生效），最终以 PIL 背景色覆盖方式移除，文字与布局逐字核对无误。

## 02 换了 DNS 服务商，记录要跟着搬家

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 2 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示条、扁平矢量图标、大字号和留白；不要复制参考图文字或具体布局。
Audience: 把网站域名从一个 DNS 服务商迁移到另一个的中文读者
Primary request: 解释更换 DNS 服务商后，证书验证记录为什么必须在新服务商重新添加。
Composition: 顶部标题；一个浅蓝色释义条；蓝色横向流程条“旧服务商记录失效 → 新服务商重建记录”；三个圆角信息块说明原因与做法；底部橙色提醒条。
Text (verbatim), and do not add any other text:
Title: “换了 DNS 服务商，记录要跟着搬家”
Definition 1: “NS（Name Server，域名服务器）”
Definition 2: “DNS（Domain Name System，域名解析系统）”
Flow left: “旧服务商记录失效”
Flow arrow: “→”
Flow right: “新服务商重建记录”
Step 1: “公网查询以权威 NS 为准”
Step 1 note: “NS 指向谁，就查谁家的记录”
Step 2: “NS 切换后，旧平台记录不再生效”
Step 2 note: “只删旧记录不够，必须重新添加”
Step 3: “在新服务商照原值添加 TXT 记录”
Step 3 note: “主机名与记录值逐字一致”
Bottom reminder: “NS 在谁家，记录就加在谁家”
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、箭头和中文括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识；不出现真实域名、IP、账号或可关联个人的标识。
```

第 02 张一次生成通过文字核对；水印经 PIL 覆盖移除。修复水印时条带右下圆角被误切，随后按条带顶部圆角轮廓做几何重绘恢复（确定性本地处理）。

## 03 验证卡住，先分清是谁的问题

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 3 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示条、扁平矢量图标、大字号和留白；不要复制参考图文字或具体布局。
Audience: 遇到证书验证长时间卡住的中文读者
Primary request: 给出验证记录卡住的定位方法：先用多路 DNS 查询确认记录生效，再区分是记录问题还是审核问题。
Composition: 顶部标题；一个浅蓝色释义条；三个步骤块纵向排列，配放大镜、服务器和齿轮图标与右侧浅色说明块；第三步下加绿色结论条；底部橙色提醒条。
Text (verbatim), and do not add any other text:
Title: “验证卡住，先分清是谁的问题”
Definition 1: “TXT（Text Record，文本记录）”
Definition 2: “权威 NS：域名的官方答案服务器”
Step 1: “① 用公共 DNS 查验证记录”
Step 1 note: “多个解析器结果应一致”
Step 2: “② 直接查询权威 NS”
Step 2 note: “确认源头上记录存在”
Step 3: “③ 记录全网生效仍卡住”
Step 3 note: “问题在审核侧：催审或重新申请”
Conclusion: “记录没问题 → 不要再改 DNS”
Bottom reminder: “改记录前先确认 token 没有重新生成”
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、箭头和中文括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识；不出现真实域名、IP、账号或可关联个人的标识。
```

第 03 张一次生成通过文字核对；水印经 PIL 覆盖移除。

## 04 证书下载格式，按服务器选

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 4 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示条、扁平矢量图标、大字号和留白；不要复制参考图文字或具体布局。
Audience: 刚签发证书、第一次在服务器上部署的中文读者
Primary request: 用对比表说明常见服务器类型对应的证书文件格式。
Composition: 顶部标题；一个浅蓝色释义条；四行两列圆角对比表，Nginx 行高亮；表格下方浅绿色说明条；底部橙色提醒条。
Text (verbatim), and do not add any other text:
Title: “证书下载格式，按服务器选”
Definition 1: “PEM（Privacy-Enhanced Mail，文本编码证书格式）”
Table header left: “服务器类型”
Table header right: “证书文件”
Row 1 left: “Nginx（适用大部分场景）”
Row 1 right: “pem + key”
Row 2 left: “Apache”
Row 2 right: “crt + key”
Row 3 left: “Tomcat”
Row 3 right: “jks 或 pfx”
Row 4 left: “IIS”
Row 4 right: “pfx”
Note: “pem 与 crt 内容相同，二选一即可”
Bottom reminder: “key 是私钥，只留在服务器上”
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、加号和中文括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识；不出现真实域名、IP、账号或可关联个人的标识。
```

第 04 张一次生成通过文字核对；水印经 PIL 覆盖移除。

## 05 Nginx 静态站 HTTPS 最小配置

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 5 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示条、扁平矢量图标、大字号和留白；不要复制参考图文字或具体布局。
Audience: 在 Windows 服务器上第一次用 Nginx 托管静态网站的中文读者
Primary request: 给出 Nginx 托管静态网站的 HTTPS 最小配置。
Composition: 顶部标题；一个浅蓝色释义条；深色圆角代码块逐行展示五条配置，等宽字体浅色文字；代码块下两个浅绿色说明条；底部橙色提醒条。
Text (verbatim), and do not add any other text:
Title: “Nginx 静态站 HTTPS 最小配置”
Definition 1: “Nginx（轻量级 Web 服务器）”
Code line 1: “listen 443 ssl;”
Code line 2: “ssl_certificate <证书文件>;”
Code line 3: “ssl_certificate_key <私钥文件>;”
Code line 4: “root <静态目录>;”
Code line 5: “index index.html;”
Note 1: “80 端口统一 301 跳转到 HTTPS”
Note 2: “纯静态站不需要 proxy_pass”
Bottom reminder: “先 nginx -t 测试，通过后再 reload”
Constraints: 所有引号内文字逐字呈现；准确保留英文小写、分号、尖括号和下划线；代码行逐字排列不换行错位；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识；不出现真实域名、IP、账号或可关联个人的标识。
```

第 05 张第一次生成代码第 5 行误写为 `index.htnl`，两次定向文字修订提示词均未生效；带 `Special attention` 强调后整卡重生成成功，但重生成图把强调语泄漏为底部多余文字，属于提示词泄漏，用 PIL 清除底部泄漏文字与水印后通过逐字核对。共消耗 4 次生成（1 首次 + 2 修订 + 1 重生成）。

## 06 Nginx 高频报错，对症下药

```text
Use case: scientific-educational
Asset type: 原创中文技术知识卡片，3:4 竖版，系列第 6 张
Input image: 只继承浅米白背景、深海军蓝标题、蓝色与青绿色圆角信息块、橙色警示条、扁平矢量图标、大字号和留白；不要复制参考图文字或具体布局。
Audience: 在 Windows 服务器上排查 Nginx 启动报错的中文读者
Primary request: 用三个报错卡片给出 Nginx 在 Windows 上的高频报错与对应解法。
Composition: 顶部标题；一个浅蓝色释义条；三个横向报错卡片纵向排列，上半部深色等宽字体报错片段、下半部浅绿色解法条，配扳手和电脑图标；底部橙色提醒条。
Text (verbatim), and do not add any other text:
Title: “Nginx 高频报错，对症下药”
Definition 1: “PID（Process ID，进程编号）”
Error 1: “No such file or directory”
Fix 1: “证书路径不对，逐字核对文件位置”
Error 2: “logs Access is denied”
Fix 2: “权限不足，用管理员身份运行”
Error 3: “nginx.pid 找不到”
Fix 3: “服务没在运行就执行了停止，忽略”
Bottom reminder: “test is successful 才算配置通过”
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、空格、点号和中文括号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识；不出现真实域名、IP、账号或可关联个人的标识。
```

第 06 张第一次生成出现两处问题：Fix 1 误写为“证书或文间路径写错”、扳手图标旁有孤立字母 j。一次定向文字修订只删掉了字母 j，文字未生效；带措辞调整（Fix 1 改为“证书路径不对，逐字核对文件位置”）后整卡重生成成功，文字全部正确。共消耗 3 次生成（1 首次 + 1 修订 + 1 重生成）。最终卡片文案与 `Content.md`、`README.md` 保持一致。
