# Charles HTTPS 抓包、证书安装与响应改写

## 白话结论

Charles 能读取 HTTPS（Hypertext Transfer Protocol Secure，安全超文本传输协议）正文，需要三项同时成立：

1. 目标应用的流量确实经过 Charles 代理。
2. 目标主机启用了 SSL Proxying（HTTPS 解密代理）。
3. 目标应用信任 Charles Root Certificate（Charles 根证书）。

缺少第一项，Charles 看不到请求；缺少第二项，通常只能看到 `CONNECT` 隧道或加密流量；缺少第三项，目标应用会报告证书不受信任。Rewrite（重写）只处理经过 Charles 的新请求和响应，不会倒改会话列表中的历史记录。

## Charles 为什么能看到 HTTPS 正文

Charles 作为中间代理，与客户端和服务器分别建立加密连接：

```text
客户端  ⇄  Charles  ⇄  服务器
```

客户端看到的是 Charles 为目标站点动态签发的证书，该证书由本机这套 Charles 安装生成的根证书签名；Charles 与真实服务器之间仍使用 HTTPS。只有客户端信任这张根证书，且目标主机被选入 SSL Proxying 范围，Charles 才能显示解密后的请求和响应正文。

这类机制也称 MITM（Man-in-the-Middle，中间人）代理。它适合调试自有或已授权系统，不应用于未授权流量。

## Windows 安装 Charles 根证书

在 Charles 中选择：

```text
Help > SSL Proxying > Install Charles Root Certificate
```

在证书导入向导中选择 `Trusted Root Certification Authorities（受信任的根证书颁发机构）`，不要只放入中间证书或个人证书存储区。

Windows 有两类常用证书存储范围：

- `Current User（当前用户）`：只对当前 Windows 用户生效，普通单用户调试通常足够。
- `Local Machine（本地计算机）`：对这台电脑上的所有用户生效，通常需要管理员权限，影响范围更大。

安装完成后应完全退出并重新启动目标应用，让它建立新连接。部分应用使用自己的证书库，或者启用了 Certificate Pinning（证书锁定）；此时即使 Windows 已信任根证书，也可能拒绝 Charles 动态证书。只能对自己控制的调试版本调整信任配置，不能绕过第三方应用的安全保护。

## 让流量进入 Charles

同一台电脑上的应用可把代理指向 Charles 的监听地址和端口。例如：

```text
127.0.0.1:8888
```

`8888` 只是 Charles 常见默认端口，应以 `Proxy Settings` 中的实际配置为准。若应用强制直连、绕过系统代理或使用了不受支持的网络栈，Charles 会完全看不到目标请求。

## 只对目标主机启用 SSL Proxying

优先只添加本次调试需要的主机：

```text
Proxy > SSL Proxying Settings
Host: <目标域名>
Port: 443
```

也可以在 Charles 的 Structure（结构）视图中右键目标主机，选择启用 SSL Proxying。添加后重新启动目标应用或建立新连接。通配符 `*` 会扩大解密范围并暴露更多敏感流量，只应在隔离测试环境中短时使用。

## 用 Rewrite 临时改写响应正文

打开：

```text
Tools > Rewrite
```

新建 Rewrite Set（重写规则集），并添加尽可能精确的 Location（匹配范围）：

```text
Protocol: https
Host: <目标域名>
Port: 443
Path: <目标接口路径>
```

再添加规则：

```text
Type: Body
Where: Response
Regex: 关闭
Match whole value: 关闭
Replace: All
```

示例把响应中的额度从 5120 MiB 改为 10240 MiB：

```json
"quotaMiB":5120
```

替换为：

```json
"quotaMiB":10240
```

Body（正文）规则区分大小写，且普通匹配按原始响应中的实际字符进行。格式化 JSON 视图可能改变空格和换行，规则不生效时应查看 `Response > Raw` 或 `Response > Text`，复制原始片段再配置。

## 怎样确认 Rewrite 已生效

1. 保存并启用 Rewrite Set。
2. 在目标应用中触发一条新的接口请求。
3. 在 Charles 中选择这条新记录。
4. 查看 `Response > Raw / Text`，确认目标值已经变化。
5. 同时观察目标应用是否按新响应执行预期的测试流程。

旧记录不会被 Rewrite 倒改，因此不能用保存规则之前的响应判断是否成功。

## 常见故障速查

| 表现 | 常见原因 | 检查方向 |
|---|---|---|
| Charles 完全没有目标请求 | 应用没有走代理，或主动绕过系统代理 | 核对代理地址、端口和应用自身代理配置 |
| 只能看到 `CONNECT`，没有明文正文 | 目标主机未启用 SSL Proxying | 把目标域名和 `443` 加入 SSL Proxying 范围 |
| 页面打不开或提示证书错误 | 根证书放错存储区、未受信任，或目标进程仍在使用旧连接 | 导入受信任根证书存储区，彻底重启应用 |
| Windows 已信任仍报错 | 应用使用独立证书库或 Certificate Pinning | 仅在自有调试版本中配置其证书信任 |
| Rewrite 不生效 | Location、Request/Response 方向、大小写、空格或字段顺序不匹配 | 从 Raw/Text 复制原始片段，缩小规则后逐步验证 |
| 新值在 Charles 中出现，但业务仍失败 | 服务端会再次校验，或应用还有其他约束 | 把改写只当客户端流程测试，不当真实权益或权限 |

## 安全收尾

- 只抓取自有或已授权系统的流量。
- Location 只覆盖必要的主机和路径。
- 不导出或提交包含 Token、Cookie、账号和真实业务响应的会话文件。
- 测试完成后关闭 Rewrite 和不再需要的 SSL Proxying 范围。
- 不再使用 Charles HTTPS 解密时，从相应证书存储区删除 Charles 根证书，并重启相关应用。

## 版本与适用边界

- 本卡片整理于 2026-11-07，适用于 Charles 4.x/5.x 的通用工作流；不同版本的菜单文字可能略有差异。
- Windows 的 `Current User` 与 `Local Machine` 是证书可见范围，不代表所有应用都使用 Windows 系统证书库。
- Rewrite 只能修改经过 Charles 的流量，不能改变服务端真实数据，也不能替代服务端权限校验。

## 参考资料

- Charles 官方：[SSL Proxying](https://www.charlesproxy.com/documentation/proxying/ssl-proxying/)
- Charles 官方：[SSL Certificates](https://www.charlesproxy.com/documentation/using-charles/ssl-certificates/)
- Charles 官方：[Rewrite Tool](https://www.charlesproxy.com/documentation/tools/rewrite/)
- Microsoft Learn：[Certificate Stores](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/certificate-stores)

## 图片清单

1. `01-three-prerequisites.png`：HTTPS 明文抓包的三项前提。
2. `02-root-certificate.png`：根证书原理、证书存储范围与安全边界。
3. `03-target-host-ssl-proxying.png`：代理入口和目标主机 SSL Proxying。
4. `04-rewrite-response-body.png`：响应正文 Rewrite 的最小配置。
5. `05-verify-and-cleanup.png`：生效验证、故障速查和安全收尾。

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`，以项目既有公开卡片作为视觉风格参考，逐张生成 5 张原创卡片。
- 保存目录：`assets/20261107_01_charles-https-rewrite-cards/`。
- 画布：3:4 竖版，浅米白背景，深海军蓝标题，蓝色与青绿色圆角信息块，少量橙色提醒。
- 脱敏策略：使用 `<目标域名>`、`<目标接口路径>` 和通用 `quotaMiB` 示例，不包含现场域名、账号、业务权益编号、证书指纹、Token 或 Cookie。
- 图片检查：5 张图片均为 `1086 × 1448` 的精确 3:4 画布；逐张核对 HTTPS、SSL Proxying、Charles Root Certificate、Trusted Root Certification Authorities、Location、Response、Regex、JSON 字段和中英文释义。
- 正文检查：`Content.md` 一级标题为 16 个可见字符，正文按去除 Markdown 标记后的口径计算为 429 个可见字符。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 视频检查：单个 H.264 High Profile 视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长 20 秒。
- 技术风险：根证书会扩大本机信任范围；应用可能使用独立证书库或证书锁定；Rewrite 只能用于客户端流程测试，不能代表真实服务端权限已改变。
