# Git 本地提交与别名

## 哪些提交还没推送

先刷新远端跟踪信息，再查看当前分支状态：

```bash
git fetch --all --prune
git status -sb
```

看到 `## main...origin/main [ahead 3]`，表示本地 `main` 比上游多 3 个提交，也就是还有 3 个提交尚未推送。`git fetch` 不会推送提交，也不会直接改动工作区文件。

只列出尚未推送的提交：

```bash
git log @{u}..HEAD --oneline
```

`HEAD` 是当前本地位置；`@{u}` 是当前分支的 `Upstream（上游分支）`；`A..B` 表示只看存在于 `B`、但不存在于 `A` 的提交。没有输出，通常表示没有待推送提交。

查看两边各有多少独有提交：

```bash
git rev-list --left-right --count @{u}...HEAD
```

结果 `0 3` 表示上游独有 0 个，本地独有 3 个。

## 看完整提交图

```bash
git log --graph --oneline --decorate --all
```

`--graph` 显示分支线；`--oneline` 每个提交只占一行；`--decorate` 标出 `HEAD`、分支和标签；`--all` 查看所有引用能够到达的提交。

## 把长命令变短

通过 `Git Alias（Git 别名）` 保存常用命令：

```bash
git config --global alias.lg 'log --graph --oneline --decorate --all'
git config --global alias.unpushed 'log --graph --oneline --decorate @{u}..HEAD'
git config --global alias.ss 'status -sb'
git config --global alias.la "config --global --get-regexp '^alias[.]'"
```

以后输入 `git lg`、`git unpushed`、`git ss`、`git la` 即可。删除别名可执行 `git config --global --unset alias.lg`。
