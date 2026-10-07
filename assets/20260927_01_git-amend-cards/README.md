# 把未提交改动并入已有 Git 提交

## 当前仓库结论

检查目标仓库 `E:\gitcmic\pc_client` 后确认：

- 当前 `HEAD` 正是 `685b7fccf8536eaa957b92e00b5b47b612ca8ac6`。
- 当前分支 `V8.9.1_RemoveLocalScan` 相对远端为 `ahead 1`，目标提交尚未推送。
- `yunSync/include/websocket/WebSocketSessionDispatcher.h` 已暂存。
- 仓库里还有多项未跟踪文件，因此不要直接使用 `git add -A`。

这个场景首选 `Amend（修订提交）`：

```powershell
Set-Location 'E:\gitcmic\pc_client'
git diff --cached -- yunSync/include/websocket/WebSocketSessionDispatcher.h
git commit --amend --no-edit
git log -1 --oneline
git status --short --branch
```

`--no-edit` 表示沿用原提交说明。执行后仍只有一个提交，但提交内容改变，所以提交哈希也一定会改变；原来的 `685b7fcc...` 会被一个新哈希替代。

## 方法一：Amend

目标提交就是当前 `HEAD` 时，直接修订最简单。

```powershell
git add -- <目标文件>
git commit --amend --no-edit
```

如果还要修改提交说明：

```powershell
git commit --amend -m '新的提交说明'
```

## 方法二：Soft Reset 后重建

`Soft Reset（软重置）` 会移动 `HEAD`，但保留暂存区和工作区。它适合想把最近一次提交拆回后重新挑选内容的情况。

```powershell
git reset --soft 685b7fccf8536eaa957b92e00b5b47b612ca8ac6^
git add -- <目标文件>
git commit -C 685b7fccf8536eaa957b92e00b5b47b612ca8ac6
```

`-C` 会复用指定提交的提交说明和作者信息。当前场景也能这样做，但步骤比 `--amend` 多。

## 方法三：Fixup + Autosquash

`Fixup（修补提交）` 配合 `Autosquash（自动压缩）` 更适合目标提交不是当前 `HEAD`，或想先保留一个临时修补提交再统一整理历史的情况。

```powershell
git add -- <目标文件>
git commit --fixup=685b7fccf8536eaa957b92e00b5b47b612ca8ac6
git rebase -i --autosquash 685b7fccf8536eaa957b92e00b5b47b612ca8ac6^
```

保存 rebase 待办列表后，`fixup` 提交会消失，其改动进入目标提交。目标提交之后的提交也会被重写，并且可能发生冲突。

## 方法四：临时提交后手工 Squash

已经创建了第二个普通提交时，可以用交互式 rebase 手工压缩：

```powershell
git commit -m '临时提交'
git rebase -i HEAD~2
```

在编辑器中保留第一行为 `pick`，把第二行的 `pick` 改成 `fixup` 或 `squash`，保存退出。`fixup` 丢弃第二个提交说明，`squash` 允许合并两条提交说明。

## 推送与恢复

当前目标提交尚未推送，所以修订后正常推送即可。只有旧提交已经推送，并且团队允许改写远端历史时，才使用：

```powershell
git push --force-with-lease origin V8.9.1_RemoveLocalScan
```

`--force-with-lease` 会在远端分支已被他人更新时拒绝覆盖，比 `--force` 更安全。

发生误操作时，先找历史位置：

```powershell
git reflog
```

例如要回到改写前的上一个位置，同时保留当前内容在暂存区，可先核对 `reflog`，再执行：

```powershell
git reset --soft 'HEAD@{1}'
```

## 卡片生成说明

- 生成方式：Codex 内置 `imagegen`。
- 统一视觉提示：原创中文技术信息图、3:4 竖版、浅米白背景、深蓝高对比标题、圆角信息块、少量 Git 节点图标、命令使用等宽字体、无平台标识和水印、手机端可读。
- 卡片 01：当前仓库状态与首选答案。
- 卡片 02：`Amend（修订）` 的检查、执行和验证。
- 卡片 03：`Soft Reset（软重置）` 的三步重建流程。
- 卡片 04：`Fixup（修补提交） + Autosquash（自动压缩）` 的适用条件、命令和风险。
- 卡片 05：执行前后检查、已推送场景和 `git reflog` 恢复线索。

