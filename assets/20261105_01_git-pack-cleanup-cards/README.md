# Git pack 文件为什么很大，能不能删除

## 白话结论

`.git/objects/pack/*.pack` 不是可以随手清理的缓存，而是 Git 对象数据库的核心组成部分。它把 Commit（提交）、Tree（目录结构）和 Blob（文件内容）等对象压缩并打包保存；配套的 `.idx` 是 Index（索引文件），帮助 Git 快速定位包内对象。

手工删除 `.pack` 或 `.idx` 可能让提交、分支、标签甚至当前版本需要的对象变成 Missing Object（对象缺失），最终导致仓库损坏。只有整个克隆已经确认废弃时，才应该删除整个仓库目录，而不是拆掉 `.git` 内部文件。

## 卡片清单

1. `01-packfile-basics.png`：解释 Packfile（Git 对象包文件）保存什么，以及压缩和 Delta（差量存储）的作用。
2. `02-why-pack-grows.png`：说明历史中的 `.ipch`、`.pdb` 等大型二进制产物为什么会持续占空间。
3. `03-do-not-delete-pack.png`：说明为什么不能手工删除 `.pack` 和 `.idx`。
4. `04-local-filter-repo.png`：区分只在本地执行 `git filter-repo` 时，本地历史和远端仓库的变化。
5. `05-prevent-pack-bloat.png`：说明 `.gitignore` 的作用边界，以及怎样避免构建产物再次进入历史。

## Packfile 到底保存什么

Git 通常把仓库数据表示为几类对象：

- Commit（提交）：记录一次提交的元数据，并指向对应的目录树和父提交。
- Tree（目录结构）：记录目录中的文件名、子目录和对象引用。
- Blob（文件内容）：保存文件内容，不直接保存文件名。
- Tag（标签对象）：附注标签使用的对象类型，不是每个标签都单独产生此类对象。

松散对象较多时，Git 会通过克隆、获取、维护或重新打包，把对象集中写入 `.pack`。普通对象数据会压缩保存；相似对象还可能使用 Delta（差量存储），只记录相对基础对象的变化。`.idx` 保存对象名和包内偏移等索引信息。

因此，`.pack` 文件名虽然看起来像缓存文件，内容实际上可能覆盖仓库的大部分历史。一个仓库只有一个大型 pack 时，手工删除它尤其容易让大量对象同时丢失。

## 为什么删除了文件，pack 仍然很大

从当前工作目录删除文件，只会影响后续提交，不会自动删除旧提交中的 Blob。只要仍有本地分支、标签、远端跟踪引用或其他引用能到达那些旧提交，对应对象就仍然是 Git 历史的一部分。

Visual Studio 常见的大型开发或构建产物包括：

- `.vs/`：解决方案级缓存和用户环境数据目录。
- `.ipch`：IntelliSense 使用的预编译头缓存。预编译头可加快智能感知处理，但会占用较大的每解决方案磁盘缓存。
- `.pdb`：Program Database（程序数据库），保存调试信息。Microsoft 文档说明链接器生成的 PDB 文件可能非常大。

这些文件通常是二进制数据。多次提交不同版本时，Git 的 Delta 压缩未必能像处理文本那样高效，历史体积会快速增长。是否忽略 `.pdb` 取决于项目是否有意把调试符号纳入版本管理或发布流程，不能一概而论。

## 能不能只在本地重写而不推送

可以。`git filter-repo` 修改的是当前本地仓库；只要不执行强制推送，远端仓库和其他协作者的克隆都不会改变。

但是，本地过滤会重写匹配范围内的提交：

- 被影响的提交哈希会改变。
- 本地分支和标签会指向新的历史。
- 原有提交签名不能继续证明新提交。
- 工具通常会重新打包并清理不可达对象，使本地 pack 变小。
- `git filter-repo` 默认会移除 `origin`，降低误推回原共享仓库的风险。

如果以后重新添加原远端并获取原来的完整历史，旧对象可能再次下载回来。本地过滤副本更适合作为独立归档或实验副本，不适合一边保留重写历史、一边继续与未重写的共享历史混用。

## 两种本地省空间方案

### 方案一：只需要最新代码

优先新建 Shallow Clone（浅克隆）：

```powershell
git clone --depth 1 --single-branch <仓库地址> <新目录>
```

这种方式不改写服务器历史，也不需要处理过滤规则。确认新目录能正常构建，并备份旧仓库中的未提交修改、本地分支和未推送提交后，再决定是否删除旧克隆。

浅克隆只减少下载的历史深度；当前版本仍在跟踪的大文件仍然必须下载。以后执行取消浅克隆或获取完整历史的操作，仓库也会重新变大。

### 方案二：保留历史，但去掉指定产物

先在一个全新克隆或可丢弃的备份副本中分析：

```powershell
git filter-repo --analyze
git count-objects -vH
```

分析报告默认位于 `.git/filter-repo/analysis/`。应先查看目录、扩展名和路径大小报告，确认历史中真实出现过的路径；重命名过的目录需要把旧路径和新路径都纳入过滤条件。

下面只是通用示例，表示从所有历史中删除任意层级的 `.vs/` 目录，以及 `.ipch`、`.pdb` 文件：

```powershell
git filter-repo `
  --path-regex '(^|.*/)\.vs/' `
  --path-regex '(?i)^.*\.(ipch|pdb)$' `
  --invert-paths `
  --dry-run
```

先检查 dry run（试运行）结果。确认规则正确后，在全新克隆中去掉 `--dry-run` 执行实际重写。若项目需要保留 `.pdb`，应从表达式中删除 `pdb`，不能照抄示例。

执行完成后检查：

```powershell
git fsck --full
git count-objects -vH
git log --oneline --all -20
git status
```

`git filter-repo` 默认要求干净的全新克隆；除非已经理解后果并有可恢复备份，不要为了绕过保护而直接对唯一工作副本使用 `--force`。重打包过程中可能暂时同时存在新旧对象，开始前应预留足够磁盘空间。

## `.gitignore` 只能防止以后误提交

可以按项目需要加入：

```gitignore
.vs/
*.ipch

# 仅当项目不需要在 Git 中保存调试符号时启用
*.pdb
```

Git 官方文档明确说明：`.gitignore` 只影响未跟踪文件，已经跟踪的文件不会自动停止跟踪。现有文件要先通过评审确认，再从 Git 索引中取消跟踪并提交；历史对象是否清理则是另一个问题。

构建结果和调试符号如果需要长期保存，更适合进入 Artifact Repository（制品库）或专门的发布系统，并配置保留周期、访问权限和版本关联，而不是反复提交进普通源码历史。

## 常见误区

- “`.pack` 很大，所以它是缓存”：错误。Packfile 保存的是 Git 的主要仓库数据。
- “当前版本已删掉，大对象就消失了”：错误。旧提交仍可达时，对象仍在历史中。
- “运行 `git gc` 就能清掉所有历史大文件”：错误。Garbage Collection（垃圾回收）不会删除仍被引用的历史对象。
- “加上 `.gitignore` 就能缩小已有 pack”：错误。忽略规则不重写历史。
- “本地过滤会自动影响远端”：错误。不推送时，远端不变。
- “本地过滤后还能无缝继续拉取旧远端历史”：不准确。两套提交哈希已经不同，重新获取原历史可能让大对象回来。

## 参考资料

- Git 官方文档：[gitformat-pack](https://git-scm.com/docs/gitformat-pack)
- Git 官方文档：[pack-format](https://git-scm.com/docs/pack-format)
- Git 官方文档：[gitignore](https://git-scm.com/docs/gitignore)
- Git 官方文档：[git-gc](https://git-scm.com/docs/git-gc)
- `git-filter-repo` 官方仓库：[README](https://github.com/newren/git-filter-repo)
- `git-filter-repo` 官方手册：[Documentation/git-filter-repo.txt](https://github.com/newren/git-filter-repo/blob/main/Documentation/git-filter-repo.txt)
- Microsoft Learn：[Configure IntelliSense Options for C and C++](https://learn.microsoft.com/en-us/visualstudio/ide/configure-languages-c-cpp-intellisense?view=visualstudio)
- Microsoft Learn：[/PDB (Use Program Database)](https://learn.microsoft.com/en-us/cpp/build/reference/pdb-use-program-database?view=msvc-170)
- GitHub 官方模板：[VisualStudio.gitignore](https://github.com/github/gitignore/blob/main/VisualStudio.gitignore)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`，使用一张既有公开知识卡片作为视觉风格参考，逐张生成 5 张原创卡片。
- 保存目录：`assets/20261105_01_git-pack-cleanup-cards/`。
- 画布：3:4 竖版，浅米白背景，深海军蓝标题，蓝色和青绿色圆角信息块，少量橙色提醒。
- 脱敏策略：不包含真实仓库名、远端 URL、提交哈希、本机绝对路径、账号或凭据。
- 图片检查：5 张图片均为 `1086 × 1448` 的精确 3:4 画布；逐张核对 `.pack`、`.idx`、`.ipch`、`.pdb`、`.gitignore`、`git filter-repo`、英文大小写和信息归属。
- 正文检查：`Content.md` 一级标题为 13 个可见字符，正文按去除 Markdown 标记后的口径计算为 431 个可见字符。
- 视频生成：使用仓库内 `card-video-generator/dist/knowcraft-video.exe` 生成 `shorts.mp4`。
- 视频检查：单个 H.264 High Profile 视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、TV range，无音轨，总时长 20 秒。
- 技术边界：历史过滤会改写提交哈希；路径过滤不会自动追踪重命名；`.pdb` 是否保留取决于项目的调试和发布流程；实际清理前必须备份本地工作并审核过滤报告。
