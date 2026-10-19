# Git stash pop：安全中止、冲突与指定恢复

## 白话结论

`git stash pop` 不是强制覆盖。它会尝试把一条 `Stash（临时存储）` 应用到当前工作区，成功后再从 stash 列表移除该条目。

需要区分两种失败：

- `Abort（安全中止）`：Git 在正式合并前发现操作可能覆盖当前未保存的内容，于是停止。此时通常没有冲突标记，stash 仍然保留。
- `Conflict（合并冲突）`：Git 已进入合并阶段，但当前提交与 stash 在同一位置存在无法自动选择的改动。此时需要手工解决冲突；`pop` 不会自动删除该 stash。

所以，“没有出现冲突标记”不等于 stash 已成功恢复。先看命令输出，再用 `git status` 和 `git stash list` 验证。

## 卡片清单

1. `01-abort-vs-conflict.png`：区分安全中止与合并冲突。
2. `02-three-way-merge.png`：说明 stash 应用时三方合并的对象。
3. `03-safe-restore-workflow.png`：给出先检查、再应用、后删除的稳妥流程。
4. `04-select-stash-entry.png`：说明默认条目、指定条目和动态编号。
5. `05-include-untracked-files.png`：解释未跟踪文件为何默认不进入 stash。

## 为什么已有修改会拦截 pop

Git 官方文档对 `pop` 的前提描述是：工作目录必须与 `Index（暂存区）` 匹配。实际操作中，如果 stash 要写入的路径已经存在未提交修改，Git 可能先报出“本地修改会被覆盖”并整体中止。

这不是合并冲突。它是合并前的保护检查：当前 `Working Tree（工作区）` 内容还没有成为三方合并中可追踪的一方，Git 不会先覆盖它，再要求用户从冲突标记中找回来。

工作区存在与 stash 无关的改动时，操作不一定被拦截；但为了避免版本差异和边界行为，恢复 stash 前让相关路径保持干净最稳妥。

## stash 的三方合并

把 stash 应用到更新后的分支时，可以把核心关系理解为：

```text
创建 stash 时的基准提交
       /            \
当前 HEAD          stash 中的改动
       \            /
          三方合并
```

- `Base（基准）`：创建 stash 时所在的提交。
- `Current HEAD（当前提交）`：现在分支指向的提交，可能已经经过 `pull`。
- `Stashed Changes（stash 改动）`：当时保存的工作区与暂存区状态。

当前 HEAD 和 stash 修改同一区域时，可能产生真正的合并冲突。正常三方合并不会直接把当前 HEAD 整个替换成旧快照；但使用 `git restore --source=<stash>` 等按快照恢复文件的命令时，要明确自己选择了哪一版内容。

## 更稳妥的恢复流程

先确认工作区和 stash 列表：

```bash
git status --short
git stash list
git stash show -p 'stash@{1}'
```

如果相关文件已有重要修改，先提交或另存为一条有说明的 stash。注意：新建 stash 后，原有条目的编号会顺延，因此必须重新运行 `git stash list`。

首次恢复建议用 `apply`：

```bash
git stash apply 'stash@{1}'
git status
git diff
```

`apply` 只应用内容，不删除 stash，便于验证。确认文件、测试和构建结果都正确后，再删除对应条目：

```bash
git stash drop 'stash@{1}'
```

如果发生冲突：

```bash
git status
# 编辑冲突文件，保留正确内容
git add -- <冲突文件>
git stash drop 'stash@{1}'
```

先确认冲突已经解决且 stash 内容已完整恢复，再执行 `drop`。

## 指定弹出哪一条

不带参数时，默认操作最新一条：

```bash
git stash pop
# 等价于操作 stash@{0}
```

指定第二新的条目：

```bash
git stash pop 'stash@{1}'
```

常用命令：

```bash
git stash show -p 'stash@{1}'
git stash apply 'stash@{1}'
git stash drop 'stash@{1}'
```

`stash@{n}` 是 `Reflog（引用日志）` 顺序，不是永久编号。执行 `push`、`pop`、`drop` 后都可能重新编号，所以每次操作前都应重新查看 `git stash list`。命令中的 `stash@{1}` 建议加单引号，避免不同 Shell 对特殊字符产生额外解释。

## 未跟踪文件默认不会进入 stash

普通的 `git stash push` 默认保存已跟踪文件的修改，不包含 `Untracked File（未跟踪文件）`。要把未跟踪文件一起保存，使用：

```bash
git stash push -u -m '临时保存当前修改'
```

其中 `-u` 是 `--include-untracked` 的缩写。`-a` 或 `--all` 还会包含被忽略文件，可能把依赖、构建产物或大文件一起收进去，使用前应先检查 `git status --short`。

## 参考资料

- Git 官方文档：[git-stash](https://git-scm.com/docs/git-stash)
- Git 官方文档：[gitrevisions](https://git-scm.com/docs/gitrevisions)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`，逐张生成；后续卡片使用前一张成品作为视觉风格参考。
- 保存目录：`assets/20261019_01_git-stash-pop-cards/`。
- 画布：3:4 竖版，浅米白背景，深海军蓝标题，蓝绿色圆角信息块，少量橙色风险提示。
- 脱敏策略：不包含真实仓库名、分支名、提交哈希、本机路径、账号或凭据。
- 视频生成：macOS 未使用 Windows 可执行文件，改为调用仓库内同一生成器源码：`PYTHONPATH=card-video-generator/src python3 -m knowcraft_video assets/20261019_01_git-stash-pop-cards --overwrite`。
- 图片检查：5 张图片均为 1086 × 1448；标题、中文释义、Git 命令、单引号、`@` 和花括号已经逐张核对。
- 正文检查：`Content.md` 一级标题 16 个可见字符，正文按去除 Markdown 标记后的口径计算为 500 字。
- 视频检查：单个 H.264 High Profile 视频流，1080 × 1920、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长 20 秒。
- 生成器测试：`7 passed`。
- 技术边界：不同 Git 版本和当前索引状态可能影响具体报错文字；操作时应以 `git status`、`git stash list` 和命令输出为准。
