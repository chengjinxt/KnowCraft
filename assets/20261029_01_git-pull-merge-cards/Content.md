# Git pull 意外合并

## 这种提交从哪来

`git pull` 会先 `Fetch（获取）`，再整合远端历史。当本地和远端都出现新提交，而拉取策略是 `pull.rebase=false` 时，Git 会执行 `Merge（合并）`，自动生成 `Merge Commit（合并提交）`。

合并提交有两个父提交。日志窗口若显示“与第 1 个父提交比较”，文件列表展示的是另一条分支带来的相对差异，不代表文件被重复提交。

## 未推送时拉直历史

先确认工作区干净，再备份并变基：

```bash
git fetch origin
git branch backup/before-cleanup
git reset --keep <本地旧顶点>
git rebase origin/main
```

这会改变本地提交哈希。合并提交已经推送到共享分支时，先和协作者确认，不要直接强制推送。

## 避免再次出现

严格阻止分叉时自动合并：

```bash
git config --local pull.ff only
```

或者让当前仓库的 `main` 自动 `Rebase（变基）`：

```bash
git config --local branch.main.rebase true
```

两种策略选一种；图形客户端中也应在 `Fetch` 后明确选择 `Rebase`。
