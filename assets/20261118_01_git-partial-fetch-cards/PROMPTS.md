# 图片生成提示词

本目录 7 张最终图片均使用 `imagegen` 生成，原创中文技术知识卡片。未使用用户截图、真实仓库内容或他人作品作为输入。

## 统一视觉规范

- 用例：`infographic-diagram`。
- 原创中文社交媒体技术知识卡片，调用提示词要求严格 3:4 竖版；工具最终输出为 1086×1448。
- 浅米白纸张纹理背景、深海军蓝高对比标题、浅蓝圆角信息块、橙色重点和底部结论条，少量扁平终端、对象包、网络和文档图标。
- 手机端一眼读完；命令、配置项与英文术语使用清晰等宽字体。
- 每张只讲一个中心问题；箭头方向、对象归属和步骤编号必须准确。
- 只显示单卡提示词列出的文字，不出现真实地址、账号、平台模板、品牌标识、水印或“AI生成”字样。
- 下列每张卡的实际最终提示词由本统一视觉规范与对应单卡提示词共同组成。

## 01 `01-auth-vs-transfer.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 1 张，共 7 张
Primary request: 区分 SSH 认证成功与 Git 大对象包传输稳定
Composition/framing: 标题、上方绿色认证路径、下方橙红色传输中断路径、错误释义块、底部橙色结论条
Text (verbatim):
"SSH 认证成功，拉取仍会失败"
"SSH (Secure Shell，安全外壳协议)"
"ssh -T：密钥与账号认证通过"
"git pull：接收 Pack（对象包）时断线"
"early EOF：文件结束信号提前到来"
"index-pack failed：对象包不完整，无法建索引"
"认证成功 ≠ 大包传输稳定"
Constraints: SSH、Pack、early EOF、index-pack failed 大小写和连字符必须准确；用钥匙、终端、断线和对象包图标；只出现上述文字。
Avoid: 密集段落、过小字号、品牌标识、真实账号、乱码、额外英文。
```

## 02 `02-pack-no-resume.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 2 张，共 7 张，通用传输到 Git 对象机制的转场卡
Primary request: 解释普通 Git fetch 为什么不能续传半个 Pack
Composition/framing: 标题、上半部“通用网络传输”流程、箭头过渡到下半部“Git 对象传输”流程、底部橙色结论条
Text (verbatim):
"为什么重试总从头开始"
"通用网络传输"
"连接断开 → 当前响应结束"
"Git 对象传输"
"多个对象 → Pack（对象包）→ 索引"
"少一个字节，也不是完整 Pack"
"普通 fetch 不能续传半个 Pack"
Constraints: 用网络插头、三个小对象方块、封装后的对象包、索引清单图标；箭头严格从对象指向 Pack 再指向索引；只出现上述文字。
Avoid: 暗示单个对象永远不能重试、密集段落、过小字号、乱码、品牌标识。
```

## 03 `03-diagnose-layers.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 3 张，共 7 张
Primary request: 用三个命令判断认证层、网络链路和本地对象库
Composition/framing: 标题、三行编号诊断块、一个 Fake-IP 提醒小块、底部橙色结论条
Text (verbatim):
"三步定位失败层"
"1  ssh -T 成功 → 认证层正常"
"2  git ls-remote 偶发失败 → 链路在抖"
"3  git fsck --connectivity-only 通过 → 本地对象库可用"
"再看 DNS 是否返回 Fake-IP（虚拟 IP）"
"先查网络和代理，别先删仓库"
Constraints: DNS (Domain Name System，域名系统) 以小号释义放在 Fake-IP 提醒块内；命令使用等宽字体；编号、对勾和警告图标一一对应；只出现上述文字及 DNS 释义。
Avoid: 真实 IP、真实域名、账号、过小字号、乱码、品牌标识。
```

## 04 `04-partial-clone.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 4 张，共 7 张
Primary request: 解释 Partial Clone 如何先拉骨架再补文件内容
Composition/framing: 标题、Partial Clone 释义条、三个纵向步骤块、底部橙色结论条
Text (verbatim):
"先拉骨架，再补文件"
"Partial Clone（部分克隆）"
"1  配置 Promisor Remote（承诺远程仓库）"
"2  git fetch --filter=blob:none"
"blob:none：先不下载 Blob（文件内容对象）"
"3  提交 + 目录先到，文件内容稍后补"
"先把大传输拆成小元数据包"
Constraints: Partial Clone、Promisor Remote、blob:none、Blob 大小写和标点准确；用提交节点、目录树、空心文件和云端对象图标；步骤箭头自上而下；只出现上述文字。
Avoid: 暗示文件内容永久不下载、过小字号、乱码、品牌标识。
```

## 05 `05-object-retry.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 5 张，共 7 张
Primary request: 说明脚本如何列出缺失对象并逐个补取重试
Composition/framing: 标题、四步循环流程、右侧重试回环箭头、底部橙色结论条
Text (verbatim):
"缺失对象可以逐个补"
"1  git rev-list --missing=print"
"2  找到缺失的 Object ID（对象标识）"
"3  git cat-file -p <对象ID>"
"4  单个失败就重试，成功对象留在本地"
"重跑脚本：已经成功的对象不用重下"
"不是字节级续传，是对象级续拉"
Constraints: rev-list、--missing=print、Object ID、cat-file、<对象ID> 字符逐字准确；回环箭头只从失败返回步骤 3；成功箭头指向本地对象库；只出现上述文字。
Avoid: 把对象级续拉画成单文件断点续传、过小字号、乱码、品牌标识。
```

## 06 `06-restore-config.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 6 张，共 7 张
Primary request: 说明部分拉取配置何时保留、何时删除
Composition/framing: 标题、左右两列选择卡、下方两个命令框、底部橙色警告结论条
Text (verbatim):
"蓝色配置要还原吗"
"继续分层拉取：保留"
"恢复普通拉取：确认全库无缺失后删除"
"git config --unset-all remote.origin.promisor"
"git config --unset-all remote.origin.partialclonefilter"
"默认状态：这两个配置项都不存在"
"有缺失对象时，不要先还原"
Constraints: 两条 git config 命令必须逐字准确并各占独立等宽代码框；保留用蓝色对勾，删除用灰色清理图标，警告用橙色；只出现上述文字。
Avoid: 把 false 画成默认值、命令换行断词、过小字号、乱码、品牌标识。
```

## 07 `07-powershell-encoding.png`

```text
Use case: infographic-diagram
Asset type: 中文社交媒体技术知识卡片，第 7 张，共 7 张
Primary request: 解释 Windows PowerShell 5.1 为什么会把无 BOM 的中文 UTF-8 脚本读乱码
Composition/framing: 标题、错误路径与正确路径两条并列流程、BOM 释义块、底部橙色结论条
Text (verbatim):
"脚本乱码，不一定是语法错"
"Windows PowerShell 5.1"
"UTF-8 无 BOM → 可能按 ANSI 读取 → 中文乱码"
"乱码破坏引号 → ParserError"
"UTF-8 with BOM → 正确识别中文脚本"
"BOM (Byte Order Mark，字节顺序标记)"
"中文 .ps1：先检查编码"
Constraints: Windows PowerShell、UTF-8、BOM、ANSI、ParserError、Byte Order Mark、.ps1 大小写和标点准确；错误路径用红色，正确路径用绿色；只出现上述文字。
Avoid: 声称所有 PowerShell 版本都必须用 BOM、过小字号、乱码、品牌标识。
```

## 输入图片与修订记录

- 输入图片：无。
- `01-auth-vs-transfer.png`：无定向修订，初稿即为最终图。
- `02-pack-no-resume.png`：无定向修订，初稿即为最终图。
- `03-diagnose-layers.png`：无定向修订，初稿即为最终图。
- `04-partial-clone.png`：无定向修订，初稿即为最终图。
- `05-object-retry.png`：无定向修订，初稿即为最终图。
- `06-restore-config.png`：无定向修订，初稿即为最终图。
- `07-powershell-encoding.png`：无定向修订，初稿即为最终图。
