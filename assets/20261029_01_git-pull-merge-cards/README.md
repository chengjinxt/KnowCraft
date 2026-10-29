# Git pull 为什么会生成 Merge Commit

## 白话结论

当本地分支和远端分支都向前产生了新提交，普通 `git pull` 不能只移动分支指针。如果当前策略要求合并，Git 就会创建一个 `Merge Commit（合并提交）`，把两条历史接到一起。

这种提交通常不是误操作产生的空提交，而是 `git pull` 在“本地和远端已经分叉”时选择了 `Merge（合并）`。它本身是合法历史；是否需要整理，取决于团队是否要求线性提交历史。

## 卡片清单

1. `01-why-pull-creates-merge.png`：说明本地和远端同时前进后，普通拉取为什么产生合并提交。
2. `02-two-parents-explained.png`：解释合并提交的两个父提交，以及日志窗口中文件列表的含义。
3. `03-linearize-unpushed-history.png`：给出尚未推送时保留备份并拉直历史的步骤。
4. `04-prevent-accidental-merge.png`：对比 `Fast-forward Only（仅快进）` 和 `Rebase（变基）` 两种预防策略。

## `git pull` 实际做了什么

可以把 `git pull` 理解为两段操作：

```text
git fetch
    +
merge / rebase / fast-forward
```

- `Fetch（获取）`：下载远端对象并更新远端跟踪分支，例如 `origin/main`。
- `Merge（合并）`：把远端历史合入当前分支；分支已经分叉时通常会创建合并提交。
- `Rebase（变基）`：把未推送的本地提交重新播放到远端最新提交之上，提交哈希会改变。
- `Fast-forward（快进）`：本地没有独立新提交时，只移动分支指针，不创建新提交。

典型触发关系如下：

```text
             L1---L2  本地新提交
            /       \
共同基准 B            M  合并提交
            \       /
             R1-----  远端新提交
```

如果有效配置为：

```bash
git config --get pull.rebase
# false
```

那么分叉后的普通 `git pull` 会走合并路径。合并提交信息中的远端地址和分支名通常由 Git 自动生成，不代表用户手工输入了一条同名提交。

检查配置来自哪个层级：

```bash
git config --show-origin --show-scope --get-regexp '^(pull\.|branch\..*\.rebase)'
```

仓库级、用户级和系统级配置可能同时存在，最终以优先级更高的配置为准。

## 为什么日志窗口像是“新增了一堆文件”

普通提交通常只有一个父提交；合并提交有两个父提交：

- `Parent 1（第一父提交）`：合并发生前，当前分支指向的本地顶点。
- `Parent 2（第二父提交）`：本次拉取并合入的远端顶点。

图形客户端必须选择一个比较基准。如果界面显示“与第 1 个父提交比较”，它列出的通常是另一条分支带进合并结果的文件。切换到第二父提交，看到的则是本地一侧带来的差异。

这不等于合并提交重新添加或复制了所有文件。文件列表描述的是“合并结果相对某个父提交有什么不同”。

命令行可以分别查看两个方向：

```bash
git show --no-patch --format='%H%n%P%n%s' <合并提交>
git diff <合并提交>^1 <合并提交>
git diff <合并提交>^2 <合并提交>
git show -m --stat <合并提交>
```

其中 `^1` 和 `^2` 分别表示第一父提交和第二父提交。仅凭某一个父提交方向的文件列表，不能判断合并是否产生了额外手工修改。

## 如何确认是哪个操作产生的

本地仍保留相关记录时，可以查看 `Reflog（Reference Log，引用日志）`：

```bash
git reflog --date=iso
```

常见记录包括：

```text
pull: Merge made by the 'ort' strategy.
pull --rebase (finish)
```

前者说明普通拉取最终执行了合并；后者说明拉取采用了变基。提交标题只能说明结果像一次拉取合并，reflog 才更接近本机实际执行过的动作。reflog 是本地记录，不会随普通推送共享给其他克隆。

## 尚未推送时如何拉直历史

以下流程适合合并提交仍只存在于本地，并且希望保留本地和远端两边内容的情况。

先检查状态并获取远端最新信息：

```bash
git status --short
git fetch origin
```

在当前合并提交处建立备份分支：

```bash
git branch backup/before-cleanup
```

找到“合并前的本地顶点”，再让当前分支回到该位置：

```bash
git reset --keep <本地旧顶点>
```

最后把本地提交重放到最新远端分支之上：

```bash
git rebase origin/main
git log --graph --oneline --decorate -10
git status
```

`--keep` 会在工作区修改可能被覆盖时拒绝继续，比直接使用 `--hard` 更保守。仍应在操作前确认工作区状态，并保留备份分支。

变基会创建内容相近但哈希不同的新提交。确认历史和文件正确后，若远端没有包含原合并提交，通常可以正常快进推送：

```bash
git push origin main
```

检查远端分支是否包含该合并提交：

```bash
git fetch origin
git branch -r --contains <合并提交>
```

没有输出通常表示当前远端分支不包含它，但仍应结合远端页面和团队流程确认。

## 已经推送时怎么办

合并提交已经进入共享分支后，通常直接保留最稳妥。它准确记录了两条历史在哪里汇合，对代码内容没有天然危害。

如果团队明确要求改成线性历史，必须先确认没有协作者基于旧历史继续提交，然后才能在本地整理后使用：

```bash
git push --force-with-lease origin main
```

`--force-with-lease` 会在远端分支与本地预期不一致时拒绝覆盖，但它仍然属于重写共享历史，不能替代协作确认。

不要把以下命令当成“删除合并节点”的方法：

```bash
git revert -m 1 <合并提交>
```

它会创建一个新的反向提交，撤销从指定父提交看过去的合并内容；原合并提交仍然保留在历史中。

## 如何避免再次产生意外合并

### 策略一：只允许快进

```bash
git config --local pull.ff only
```

当本地和远端分叉时，普通拉取会停止，不会自动创建合并提交。此时可以明确执行：

```bash
git fetch origin
git rebase origin/main
```

这种方式最保守，适合希望每次分叉都由操作者确认的仓库。

### 策略二：让 `main` 拉取时自动变基

```bash
git config --local branch.main.rebase true
```

普通拉取会把当前 `main` 上未推送的本地提交重放到上游分支顶部，从而避免产生本次这种合并节点。变基可能发生冲突，也会改变本地提交哈希，因此不应对已经共享的提交随意使用。

两种策略按团队习惯选择一种。图形客户端中也可以先执行 `Fetch`，检查分支关系后再明确执行 `Rebase`；如果使用 Pull 窗口，应确认启用了对应的变基选项。

## 参考资料

- Git 官方文档：[git-pull](https://git-scm.com/docs/git-pull)
- Git 官方文档：[git-config](https://git-scm.com/docs/git-config)
- Git 官方文档：[git-rebase](https://git-scm.com/docs/git-rebase)
- Git 官方文档：[git-reflog](https://git-scm.com/docs/git-reflog)
- TortoiseGit 官方手册：[Pull and Fetch change](https://tortoisegit.org/docs/tortoisegit/tgit-dug-pull.html)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`，逐张生成；后续卡片使用前一张成品作为视觉风格参考。
- 保存目录：`assets/20261029_01_git-pull-merge-cards/`。
- 画布：3:4 竖版，浅米白背景，深海军蓝标题，蓝绿色圆角信息块，少量橙色提醒。
- 脱敏策略：不包含真实仓库名、远端 URL、真实提交哈希、本机路径、账号或凭据。
- 图片检查：4 张图片均为 `1086 × 1448` 的精确 3:4 画布；标题、中文释义、Git 命令、双短横线、点号、斜杠、尖括号和提交拓扑已逐张核对。
- 正文检查：`Content.md` 一级标题 13 个可见字符，正文按去除 Markdown 标记后的口径计算为 471 个可见字符。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 视频检查：单个 H.264 High Profile 视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长 16 秒。
- 技术边界：`reset`、`rebase` 和强制推送都可能改写可见历史；实际操作前必须确认目标提交、工作区状态、远端状态和协作范围。
