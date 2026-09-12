#  微软商店（Microsoft Store）打不开 连接问题知识卡片

## 卡片顺序

1. `01-connection-symptom.png`：出现“需要联网或刷新”时，不要只盯着系统更新和 DNS。
2. `02-internet-options-and-tls.png`：解释“IE 设置太旧”实际指向 `Internet Options（Internet 选项）`中的安全连接配置。
3. `03-enable-modern-tls.png`：搜索 `Internet Options`，进入 `Advanced（高级）`并检查现代 TLS 协议。
4. `04-check-proxy-settings.png`：进入 `Connections（连接）`→ `LAN Settings（局域网设置）`，排查错误的 `Proxy Server（代理服务器）`配置。
5. `05-store-error-0x80072efd.png`：安装应用时若同时出现 `0x80072EFD`，检查 Microsoft Store 下载链路、WinHTTP 代理和网络组件。

## 核心知识

- Microsoft Store 提示“需要联网或刷新”，不等于电脑的物理网络一定断开；安全协议或代理配置异常也可能使应用无法建立连接。
- `Internet Options（Internet 选项）`是 Windows 的网络与安全设置入口之一。这里所说的“IE 设置”并不是让用户重新使用 Internet Explorer。
- `TLS (Transport Layer Security，传输层安全协议)`用于保护客户端和服务器之间的通信。
- Windows 10 重点检查 `Use TLS 1.2（使用 TLS 1.2）`；Windows 11 如果显示 `Use TLS 1.3（使用 TLS 1.3）`，也应保持启用。
- 不建议为解决问题而重新启用 `SSL 3.0`、`TLS 1.0` 或 `TLS 1.1` 等旧协议。
- 只有在没有主动使用代理时，才取消勾选“代理服务器”。正在使用公司代理、调试代理或 VPN 时，应先核对配置，不要盲目关闭。
- `0x80072EFD` 的低位错误码为 `12029`，对应 `Cannot Connect（无法连接到服务器）`；它描述连接失败，不专门表示连接超时。
- 安装阶段出现该错误时，应优先排查 Microsoft Store 下载链路，不要先把问题归咎于尚未完成安装的目标应用。
- 在管理员 PowerShell 中用 `netsh winhttp show proxy` 查看 WinHTTP 代理；直连通常显示 `Direct access (no proxy server).`。
- 仅当发现非预期代理时，才执行 `netsh winhttp reset proxy`。公司受管代理或主动配置的代理不能直接重置。
- `ipconfig /flushdns` 用于刷新 DNS 解析器缓存；`netsh winsock reset` 用于重置 Winsock 目录，执行后重启 Windows 再尝试安装。

## 来源与修订说明

内容基于以下本地资料整理：

- `E:\成进学堂\00007 Windows操作系统\参考资料\Microsoft Store 微软应用商战\微软商店 Microsoft store 打不开.md`
- `E:\成进学堂\00007 Windows操作系统\参考资料\Microsoft Store 微软应用商战\Windows 应用商店(Microsoft store)打不开？95% 解决方法-兼容 Win10、Win11.docx`

说明：

- 原文标题中的“95%”属于经验性表述，不作为经过验证的统计数据使用。
- 原资料中的 `TSL` 拼写已统一更正为 `TLS`。
- 本机缺少 LibreOffice，无法按 Word 页面完整渲染 DOCX；已通过结构化读取正文，并检查文档内的 4 张操作截图。
- 前 4 张卡片覆盖 TLS 与 Internet 代理检查；第 5 张根据用户提供的安装失败截图，补充 `0x80072EFD`、WinHTTP 代理与网络组件重置流程。

## 官方参考

- [Protocols in TLS/SSL (Schannel SSP)](https://learn.microsoft.com/en-us/windows/win32/secauthn/protocols-in-tls-ssl--schannel-ssp-)
- [Use a proxy server in Windows](https://support.microsoft.com/en-gb/windows/use-a-proxy-server-in-windows-03096c53-0554-4ffe-b6ab-8b1deee8dae1)
- [Microsoft Store doesn't open](https://support.microsoft.com/en-US/accounts-billing/microsoft-store-doesn-t-open)
- [Error Messages (WinHTTP)](https://learn.microsoft.com/en-us/windows/win32/winhttp/error-messages)
- [Netsh.exe commands for WinHTTP](https://learn.microsoft.com/en-us/windows/win32/winhttp/netsh-exe-commands)
- [`ipconfig` command](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/ipconfig)
- [`netsh winsock` command](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh-winsock)

## 生成说明

- 生成方式：Codex 内置 `imagegen`。
- 画面规格：3:4 竖版、暖白网格背景、蓝绿主色、圆角信息块、适合手机阅读。
- Prompt set：故障现象判断、`Internet Options` 与 TLS 的关系、现代 TLS 勾选步骤、代理服务器检查、`0x80072EFD` 与 WinHTTP 修复流程。
- 视觉参考：项目既有 ACL 卡片的配色与版式语言；未复制平台标识、官方商标或截图。
- 检查结果：5 张图片均无系列页码角标；中英文技术术语、TLS 版本、错误码、命令和操作路径已逐张核对。
