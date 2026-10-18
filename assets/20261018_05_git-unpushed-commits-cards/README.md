# 查看 Git 本地未推送提交

## 白话结论

想知道本地有哪些提交还没推送，先用 `git fetch --all --prune` 刷新远端跟踪信息，再用 `git status -sb` 看当前分支领先或落后多少。

只查看尚未推送的提交，使用：

```bash
git log @{u}..HEAD --oneline
```

想看包含本地分支、远端跟踪分支和标签的完整提交图，使用：

```bash
git log --graph --oneline --decorate --all
```

命令太长时，可以用 `Git Alias（Git 别名）` 保存常用写法，以后通过 `git lg`、`git unpushed`、`git ss` 和 `git la` 快速调用。

## 卡片清单

1. `01-check-ahead-status.png`：刷新远端信息，并通过 `[ahead 3]` 判断本地有 3 个提交尚未推送。
2. `02-list-unpushed-commits.png`：解释 `HEAD`、`@{u}`、`A..B` 和左右计数。
3. `03-read-git-log-graph.png`：展示完整提交图，并解释 `--graph`、`--oneline`、`--decorate`、`--all`。
4. `04-create-git-aliases.png`：为常用长命令设置、查看和删除 Git 别名。

## 先刷新，再判断

```bash
git fetch --all --prune
git status -sb
```

`git fetch` 会更新 `Remote-tracking Branch（远端跟踪分支）`，不会把本地提交推送出去，也不会直接改动工作区文件。

状态示例：

```text
## main...origin/main [ahead 3]
```

`ahead 3` 表示本地 `main` 比上游 `origin/main` 多 3 个提交；`behind 2` 则表示远端有 2 个提交尚未进入本地当前分支。

## 只看尚未推送的提交

```bash
git log @{u}..HEAD --oneline
```

- `HEAD`：当前检出位置，通常指向当前本地分支的最新提交。
- `@{u}`：当前分支配置的 `Upstream（上游分支）`，例如 `origin/main`。
- `A..B`：显示能从 `B` 找到、但不能从 `A` 找到的提交。
- 没有输出：当前分支没有尚未推送到上游的新提交。

查看领先和落后的数量：

```bash
git rev-list --left-right --count @{u}...HEAD
```

输出 `0 3` 时，左侧 `0` 表示上游独有 0 个提交，右侧 `3` 表示本地独有 3 个提交。这里使用的是三个点 `...`，用于比较两侧各自独有的提交。

如果当前分支没有配置上游，`@{u}` 会报错。可以明确写出远端跟踪分支，例如：

```bash
git log origin/main..HEAD --oneline
```

## 看完整提交图

```bash
git log --graph --oneline --decorate --all
```

- `--graph`：使用字符线条显示分支、合并关系。
- `--oneline`：每个提交只显示短哈希和一行提交说明。
- `--decorate`：显示 `HEAD`、本地分支、远端跟踪分支和标签名称。
- `--all`：显示所有引用能够到达的提交，而不只查看当前分支。

## 设置 Git 别名

```bash
git config --global alias.lg 'log --graph --oneline --decorate --all'
git config --global alias.unpushed 'log --graph --oneline --decorate @{u}..HEAD'
git config --global alias.ss 'status -sb'
git config --global alias.la "config --global --get-regexp '^alias[.]'"
```

以后直接使用：

```bash
git lg
git unpushed
git ss
git la
```

删除某个别名：

```bash
git config --global --unset alias.lg
```

`--global` 表示别名写入当前用户的全局 Git 配置，对该用户的所有仓库生效。

## 卡片生成说明

- 生成方式：Codex 内置 `imagegen`，逐张生成；后续卡片以前一张成品作为视觉风格参考。
- 保存目录：`assets/20261018_05_git-unpushed-commits-cards/`。
- 画布：3:4 竖版，最终统一为 1086 × 1448。
- 视觉规范：原创中文技术信息图、浅米白不透明背景、深海军蓝标题、蓝绿色圆角信息块、少量橙色提醒、等宽命令框和简化 Git 提交线。
- 脱敏策略：不使用真实仓库名、提交哈希、提交说明、远端地址、账号或本机路径；提交示意统一使用通用内容。
- 技术边界：`@{u}` 依赖当前分支已配置上游；`git fetch` 只刷新远端跟踪信息，实际结果仍以执行时的仓库状态为准。
