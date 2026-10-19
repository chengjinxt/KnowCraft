# Git stash pop 避坑

## 安全中止与冲突

`git stash pop` 不会强制覆盖。同一文件已有修改时，Git 可能在合并前 `Abort（安全中止）`，且没有冲突标记；合并后两边改动重叠，才是 `Conflict（合并冲突）`。

三方是 `Base（基准）`、当前 `HEAD` 和 stash 改动；脏工作区不是自动的第四方。

## 更稳的恢复方式

```bash
git status --short
git stash list
git stash show -p 'stash@{1}'
git stash apply 'stash@{1}'
```

`apply` 保留条目；验证后再执行：

```bash
git stash drop 'stash@{1}'
```

## 指定条目

`git stash pop` 默认操作 `stash@{0}`；指定第二新条目：

```bash
git stash pop 'stash@{1}'
```

编号随 `push`、`pop`、`drop` 变化，操作前先看列表。

## 新文件为什么没保存

普通 stash 不含 `Untracked File（未跟踪文件）`。一起保存时使用：

```bash
git stash push -u -m '临时保存当前修改'
```

`-u` 包含未跟踪文件；`-a` 还包含忽略文件，使用前检查范围。
