# Git 拉取中断与对象级分批补取

## 一、先说结论

`ssh -T` 成功而 `git pull --rebase` 仍报 `early EOF`、`index-pack failed`，并不矛盾：前者只证明 SSH（Secure Shell，安全外壳协议）认证可用，后者说明接收 Pack（对象包）时数据提前结束，`index-pack` 无法为不完整的对象包建立索引。

如果普通拉取反复在大对象包中途断开，可以使用 `Partial Clone（部分克隆）`能力：先拉取提交和目录结构，再把缺少的 Blob（文件内容对象）逐个补到本地。它不是“从某个字节继续”的断点续传，而是“已经成功的对象不再重下”的对象级续拉。

## 二、错误分别说明什么

### 1. `ssh -T` 成功

GitHub 返回“已成功认证，但不提供 shell”是正常结果。它能证明当前主机名、端口、私钥和账号认证链路可用，但不能证明长时间、大数据量的 Git 传输一定稳定。

### 2. `early EOF`

EOF（End of File，文件结束）比预期更早出现，表示 Git 还没收完当前响应，数据流就结束了。常见方向包括代理、VPN、TUN（虚拟网络适配器）、防火墙、无线网络抖动或远端连接被中间链路关闭。

### 3. `index-pack failed`

`git index-pack` 会读取 `.pack` 文件并建立 `.idx` 索引。上一步收到的 Pack 不完整时，索引自然无法完成；它通常是传输中断的后续结果，不等于本地提交历史已经损坏。

## 三、按层诊断

```powershell
ssh -T <GitHub主机别名>
git ls-remote origin refs/heads/main
git fsck --connectivity-only
git count-objects -vH
```

- `ssh -T` 成功：认证层基本正常。
- `git ls-remote` 成功或偶发失败：小请求可通，但链路可能不稳定。
- `git fsck --connectivity-only` 通过：检查时本地已有对象的连通性没有发现致命问题；进入部分克隆模式后，Promisor Remote（承诺远程仓库）明确承诺可补取的缺失对象不应简单当作损坏。
- `git count-objects -vH` 出现较大的 `size-pack`、`size-garbage` 或 `tmp_pack_*`：说明仓库对象较大，并可能留下失败传输的临时文件。

如果 DNS（Domain Name System，域名系统）把 GitHub 域名解析到 `198.18.0.0/15`，该地址段由 IANA（Internet Assigned Numbers Authority，互联网号码分配机构）保留用于基准测试。这通常意味着本机、网关或代理使用了 Fake-IP（虚拟 IP）映射；这是存在代理路径的线索，不等于地址本身就是故障原因。

## 四、为什么普通重试总要重传

Git 会把多个对象压入 Pack，再由客户端校验并建立索引。普通 `fetch` 没有“继续接收上次半个 Pack”的通用机制；当前响应中断后，未完成的 Pack 不能直接作为完整对象库使用。

`--depth=1` 只限制提交历史深度，不会把同一提交中的多个大 Blob 拆开，也可能把完整仓库变成 Shallow Clone（浅克隆），不适合拿来解决本问题。

## 五、先拉提交和目录结构

先保护当前分支：

```powershell
git branch backup/before-split-fetch
```

将 `origin` 标记为 Promisor Remote，并把默认过滤器设为不预取 Blob：

```powershell
git config remote.origin.promisor true
git config remote.origin.partialclonefilter blob:none
```

只拉取提交和目录结构：

```powershell
git -c protocol.version=2 fetch --filter=blob:none --no-tags origin main
```

`blob:none` 表示暂时不下载 Blob。服务器必须支持对象过滤；若服务器不支持，应停止并改用其支持的传输方式，不能假定过滤一定生效。

## 六、再逐个补取缺失对象

本项目提供脚本：

```powershell
.\solutions\fetch-missing-git-objects.ps1
```

脚本的核心流程是：

1. `git rev-list --objects --missing=print origin/main` 列出缺失对象。
2. `git cat-file -p <对象ID>` 触发 Promisor Remote 按对象补取。
3. 每个对象最多重试指定次数；成功对象保留在本地。
4. 网络再次中断时重新运行脚本，已经存在的对象会被跳过。

可调整重试次数和间隔：

```powershell
.\solutions\fetch-missing-git-objects.ps1 `
  -MaxRetries 20 `
  -RetryDelaySeconds 5
```

对象全部补齐后再执行：

```powershell
git rebase origin/main
```

注意：如果某个单独 Blob 本身很大，该对象的传输仍可能失败并从头重试。这个方案降低的是“一次失败重传整包”的成本，不提供单个 Blob 的字节级续传。

## 七、蓝色配置什么时候还原

这两项默认都不存在：

```text
remote.origin.promisor
remote.origin.partialclonefilter
```

如果以后仍要使用分层拉取，就保留它们。若希望恢复普通完整拉取，必须先确认所有本地引用都没有缺失对象，再运行：

```powershell
.\solutions\fetch-missing-git-objects.ps1 -RestoreDefaultConfig
```

脚本检查通过后才会执行等价操作：

```powershell
git config --unset-all remote.origin.promisor
git config --unset-all remote.origin.partialclonefilter
```

有缺失对象时提前删除配置，会让 Git 失去自动补取对象所需的 Promisor Remote 信息。

## 八、PowerShell 脚本为什么会乱码

PowerShell 7 默认使用不带 BOM 的 UTF-8；Windows PowerShell 5.1 在读取没有 BOM、且包含中文等非 ASCII 字符的脚本时，可能按当前 ANSI 代码页解释。中文会变成乱码，乱码还可能破坏引号，最终表现为看似无关的 `ParserError`。

兼容 Windows PowerShell 5.1 的直接做法是把含中文的 `.ps1` 保存为 `UTF-8 with BOM`。BOM（Byte Order Mark，字节顺序标记）位于文件开头，用来提示读取方使用的 Unicode 编码。

## 九、长期边界

- 部分克隆需要远端在线；访问缺失对象时仍要连接 Promisor Remote。
- 按对象动态补取会增加连接和认证次数，适合网络容易中断但单次小传输较稳定的情况。
- 仓库长期存放大量 `.mp4`、高分辨率图片等二进制文件时，可评估 Git LFS（Git Large File Storage，Git 大文件存储）。迁移既有历史会改写提交，不能未经评估直接执行。
- Git 客户端版本不是本次断线的直接根因，但旧版的部分克隆实现和错误处理较早；条件允许时仍建议升级后再处理大型仓库。

## 十、卡片清单

1. `01-auth-vs-transfer.png`：认证成功不等于大包传输稳定。
2. `02-pack-no-resume.png`：普通拉取为什么不能续传半个 Pack。
3. `03-diagnose-layers.png`：三步判断认证、链路和本地对象库。
4. `04-partial-clone.png`：先拉提交和目录结构。
5. `05-object-retry.png`：缺失对象逐个补取与重试。
6. `06-restore-config.png`：何时保留或还原 Promisor 配置。
7. `07-powershell-encoding.png`：Windows PowerShell 5.1 的 UTF-8 BOM 边界。

## 十一、生成方式与检查结果

- 图片使用 OpenAI `imagegen` 生成，统一为原创 3:4 中文知识卡片。
- 7 张最终图片实际尺寸均为 `1086 × 1448`，比例为 3:4。
- 未使用用户截图、真实仓库地址、账号、密钥、本机路径或其他可识别信息作为图片输入。
- 已逐张检查标题、命令、英文大小写、箭头归属和底部结论；定向修订记录见 `PROMPTS.md`。
- `shorts.mp4` 使用项目自带 `knowcraft-video.exe` 生成，默认每张 4 秒，无音轨。
- FFmpeg 编码完成后，生成器在 Windows 上因瞬时文件锁未能把临时文件改名为 `shorts.mp4`；确认没有残留生成进程并用 `ffprobe` 验证临时文件完整后，在同一知识目录内完成改名。
- 最终视频已验证为单路 H.264、`1080 × 1920`、30 fps、`yuv420p`、BT.709、`color_range=tv`、无音频流，总时长 28 秒，与 7 张卡片每张 4 秒一致。

## 十二、参考资料

- [GitHub Docs：测试 SSH 连接](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection)
- [Git：fetch 的 `--filter` 选项](https://git-scm.com/docs/fetch-options)
- [Git：Partial Clone 设计与 Promisor Remote](https://git-scm.com/docs/partial-clone)
- [Git：`git index-pack`](https://git-scm.com/docs/git-index-pack.html)
- [Microsoft Learn：PowerShell 字符编码](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_character_encoding)
- [IANA：IPv4 Special-Purpose Address Space](https://www.iana.org/assignments/iana-ipv4-special-registry)

## 十三、仍需人工确认的技术风险

- 不同 Git 服务端对过滤协议的支持程度不同，应以实际输出为准。
- 代理、网关和 Fake-IP 的具体实现因环境而异，不能仅凭保留地址断定是哪一个软件。
- 图片中的命令用于说明流程，实际执行前仍需确认分支名、远程名和本地工作区状态。
