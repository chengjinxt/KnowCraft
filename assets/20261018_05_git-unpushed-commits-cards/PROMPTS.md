# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 四张原创中文 Git 技术知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、刚开始使用 Git 命令行的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明的浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色提醒；简化的 Git 提交线、终端窗口和标签图标；大字号、留白充足、手机端易读。
Composition: 顶部标题，中部按阅读顺序排列 3 至 4 个信息块，底部一句准确提醒；命令使用深色等宽字体代码框。
Constraints: 所有引号内文字逐字呈现；命令完整单行显示；准确保留英文大小写、空格、短横线、点号、花括号、方括号、单引号和双引号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实仓库名、远端 URL、真实提交哈希、真实提交说明、本机绝对路径、账号或凭据。
```

后续卡片以上一张成品作为视觉风格参考，只继承色彩、圆角信息块、代码框、字体层级、提交线和图标语言，不复用上一张内容。

## 01 Git 哪些提交还没推送

```text
Title: "Git 哪些提交还没推送"
Subtitle: "先刷新远端，再看 ahead"

Step 1:
"① 刷新远端跟踪信息"
"git fetch --all --prune"
"不推送提交，不直接改动工作区"

Step 2:
"② 查看简短分支状态"
"git status -sb"

Terminal result:
"## main...origin/main [ahead 3]"

Meaning:
"ahead 3"
"本地 main 多 3 个提交"
"这 3 个提交尚未推送"

Small comparison:
"behind 2：远端多 2 个提交"

Bottom reminder:
"先 fetch，再判断，避免依据过期的远端状态"
```

## 02 只看本地未推送提交

```text
Title: "只看本地未推送提交"
Subtitle: "比较 Upstream（上游分支）与 HEAD"

Primary command:
"git log @{u}..HEAD --oneline"

Definitions:
"HEAD"
"当前本地位置"

"@{u}"
"当前分支的上游，例如 origin/main"

"A..B"
"只看存在于 B、不存在于 A 的提交"

Count command:
"git rev-list --left-right --count @{u}...HEAD"

Count result:
"0  3"
"左：上游独有 0 个"
"右：本地独有 3 个"

Bottom reminder:
"没有输出：当前没有待推送提交"
```

## 03 一条命令看提交图

```text
Title: "一条命令看提交图"
Subtitle: "同时看本地、远端跟踪分支与标签"

Primary command:
"git log --graph --oneline --decorate --all"

Git graph example, use a simple vertical commit line:
"a1b2c3d  (HEAD -> main)  新增使用说明"
"d4e5f6a  补充命令示例"
"7b8c9d0  优化文档结构"
"1a2b3c4  (origin/main)  更新资料"

Parameter blocks:
"--graph"
"显示分支与合并线"

"--oneline"
"每个提交只占一行"

"--decorate"
"标出 HEAD、分支与标签"

"--all"
"查看所有引用可到达的提交"

Bottom reminder:
"想看全局关系用 git lg，想看待推送用 git unpushed"
```

## 04 Git Alias 缩短长命令

```text
Title: "Git Alias 缩短长命令"
Subtitle: "Alias（别名）：为常用命令起短名字"

Section 1 title:
"① 配置一次"
Commands, each on one complete line:
"git config --global alias.lg 'log --graph --oneline --decorate --all'"
"git config --global alias.unpushed 'log --graph --oneline --decorate @{u}..HEAD'"
"git config --global alias.ss 'status -sb'"
"git config --global alias.la \"config --global --get-regexp '^alias[.]'\""

Section 2 title:
"② 以后这样用"
Shortcut mapping:
"git lg          完整提交图"
"git unpushed    待推送提交"
"git ss          分支简短状态"
"git la          查看全部别名"

Section 3 title:
"③ 删除别名"
"git config --global --unset alias.lg"

Bottom reminder:
"--global：对当前用户的所有仓库生效"
```
