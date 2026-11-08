# 未推送敏感提交的 Git 历史修正

## 白话结论

可以在“从未推送”的前提下，把后来的脱敏修改折回最早的敏感提交。Git并不是在原地修改旧提交，而是创建一条内容正确的新历史，再让当前分支指向新历史。

假设本地历史是：

```text
a1（误含敏感信息） → a2 → a3 → a4（删除敏感信息）
```

把 `a4` 作为 `a1` 的 fixup（修正提交）折叠后，最终分支历史是：

```text
a1'（a1 与 a4 的合并结果，已脱敏） → a2' → a3'
```

`a4` 不再作为独立提交出现。`a1'`、`a2'`、`a3'` 都是新提交，因此哈希通常全部改变。

## 为什么后续提交也会变

Git Commit（提交）对象包含本次内容、作者与时间、提交说明，以及父提交哈希。`a1` 变成 `a1'` 后，`a2` 原来记录的父提交已经不对，Git必须把 `a2` 的改动重新应用到 `a1'` 上，生成 `a2'`；`a3` 同理变成 `a3'`。

这叫 Replay（重放），不是简单修改一个文件名或指针。

## 常用操作方式

先在工作区完成脱敏修改并检查差异，然后创建 fixup提交：

```powershell
git add <已脱敏的文件>
git commit --fixup=<a1>
```

`--fixup=<a1>` 会生成一个带 `fixup!` 标记的提交，告诉后续 rebase（变基）它应该折入哪个目标提交。

再从目标提交的父提交开始执行交互式变基：

```powershell
git rebase -i --autosquash <a1^>
```

`--autosquash` 会把 `fixup!` 提交自动移动到目标提交后面，并把动作改为 `fixup`。保存后，Git生成脱敏的新提交，并重放后续提交。如果 `a1` 是根提交，应使用适合根提交的 `--root` 方式，不能照抄 `<a1^>`。

## 远端为什么“像从未发生过”

`git push` 发送的是当前引用能够到达、远端还没有的对象。如果旧的 `a1` 从未推送，而分支在推送前已经指向 `a1' → a2' → a3'`，普通远端只会收到新历史。

因此从远端分支和正常克隆视角看，敏感版本没有作为该分支历史出现。这依赖两个前提：

1. 旧提交从未推送到任何远端、代码评审系统或镜像。
2. 旧对象没有通过补丁、压缩包、日志、聊天或其他渠道离开本机。

## 旧提交在本机是否立即消失

不一定。分支不再引用旧提交后，旧对象通常会变成 Unreachable Object（不可达对象），但可能暂时存在于：

- Reflog（引用日志）；
- `.git/objects` 或 Packfile（对象包文件）；
- 备份、IDE缓存或其他本地引用。

Git会按过期策略清理不可达对象。历史重写的首要目标是阻止旧对象被推送，不应把它误解为立刻从磁盘每个位置安全擦除。

## 如果已经推送

已推送时，远端和其他克隆可能已经拥有旧对象。即使强制推送重写后的分支，也不能保证旧提交从所有缓存、镜像、Fork或他人电脑中消失。

正确处置顺序是：

1. 立即轮换或吊销 Token、密码、Client Secret、私钥等凭据；
2. 停止继续传播；
3. 按代码托管平台流程清理远端历史；
4. 通知协作者重新同步或重新克隆；
5. 检查 CI日志、制品、镜像和聊天记录等旁路。

历史重写不是凭据轮换的替代品。

## 操作前后的检查

操作前确认目标提交确实未推送：

```powershell
git status --short --branch
git log --oneline --decorate --graph -20
git log --oneline <远端分支>..HEAD
```

操作后检查新历史、敏感关键字和差异：

```powershell
git log --oneline --decorate --graph -20
git show <a1'>
git diff --check <远端分支>...HEAD
git grep -n <需清理的关键字> HEAD
```

不要在命令行参数中直接放真实密钥，因为命令历史和进程信息也可能留下副本。扫描时优先使用关键字、前缀或专用 Secret Scanner（密钥扫描器）。

## 卡片清单

1. `01-can-unpushed-secret-be-fixed.png`：未推送敏感提交为什么可以修正。
2. `02-fixup-autosquash-flow.png`：fixup 与 autosquash 的实际动作。
3. `03-resulting-history.png`：新历史为什么只剩三条、后续哈希为什么改变。
4. `04-reflog-and-pushed-boundary.png`：本机旧对象、Reflog 和已推送场景的安全边界。

## 参考资料

- Git官方文档：[git commit](https://git-scm.com/docs/git-commit)
- Git官方文档：[git rebase](https://git-scm.com/docs/git-rebase)
- Git官方文档：[git reflog](https://git-scm.com/docs/git-reflog)
- Git官方文档：[git gc](https://git-scm.com/docs/git-gc)

## 生成与检查说明

- 生成方式：Codex内置 `imagegen`，逐张生成4张原创中文知识卡片。
- 画布：3:4竖版，浅米白背景，深海军蓝标题，蓝色与青绿色圆角信息块，少量橙色安全提醒。
- 脱敏策略：不出现真实项目名、仓库地址、本机路径、账号、凭据或真实提交哈希。
- 图片检查：4张图片均为 `1086 × 1448` 的精确3:4画布；第1张重生成修正画布方向，第2张重生成确保 `a2'`、`a3'` 的哈希变化表达准确。
- 正文检查：`Content.md` 一级标题为10个可见字符，正文按去除 Markdown标记后的口径为302个可见字符。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 视频检查：单个 H.264 High Profile视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长16秒。
- 技术边界：卡片只讨论未推送提交；已推送凭据必须优先轮换，不能只依赖历史重写。
