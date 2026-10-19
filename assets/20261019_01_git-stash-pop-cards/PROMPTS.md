# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 五张原创中文 Git 技术知识卡片，3:4 竖版
Audience: 有基础电脑使用经验、但不熟悉 Git 底层机制的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明的浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的 Git 分支线、终端窗口、盾牌和文件图标；大字号、留白充足、手机端易读。
Composition: 顶部标题，中部按阅读顺序排列 3 至 4 个信息块，底部一句准确提醒；命令使用深色等宽字体代码框。
Constraints: 所有引号内文字逐字呈现；命令完整单行显示；准确保留英文大小写、空格、短横线、`@`、花括号、数字、单引号；不添加提示词之外的文字；无品牌 Logo、水印、二维码、页码和平台标识。
Public-release redaction: 不出现真实仓库名、远端 URL、真实提交哈希、真实分支名、本机绝对路径、账号或凭据。
```

第 01 张无输入图片。第 02 至 05 张分别使用上一张最终成品作为视觉风格参考，仅继承配色、圆角信息块、代码框、字体层级和图标语言，不复用上一张文字或信息结构。

## 01 安全中止不等于冲突

```text
Title: "stash pop 为何会停？"
Subtitle: "Abort（安全中止）≠ Conflict（合并冲突）"

Left block title: "安全中止"
Lines:
"合并前停止"
"保护当前未提交修改"
"没有冲突标记"
Icon: shield protecting a file before a merge gate.

Right block title: "合并冲突"
Lines:
"已经进入三方合并"
"两边改动重叠"
"需要手工解决"
Icon: two Git branches meeting with an orange conflict symbol.

Bottom reminder:
"先看命令输出：Aborting 还是 CONFLICT"
```

## 02 stash 在合并哪三方

```text
Title: "stash 在合并哪三方？"
Subtitle: "Three-way Merge（三方合并）"

Create a clear triangle diagram with three labeled nodes pointing to a central merge node.

Top node:
"Base（基准提交）"
"创建 stash 时的提交"

Bottom-left node:
"Current HEAD（当前提交）"
"可能已经 pull 更新"

Bottom-right node:
"Stashed Changes（stash 改动）"
"当时保存的修改"

Center node:
"三方合并"

Orange bottom note:
"脏工作区不是自动加入的第四方"
```

## 03 更稳的 stash 恢复流程

```text
Title: "更稳的 stash 恢复流程"
Subtitle: "先检查，再应用，验证后删除"

Step 1 title: "① 看现场"
Commands, each on one complete line:
"git status --short"
"git stash list"

Step 2 title: "② 看目标内容"
Command:
"git stash show -p 'stash@{1}'"

Step 3 title: "③ 先 apply"
Command:
"git stash apply 'stash@{1}'"
Small line:
"Apply（应用）：保留 stash 条目"

Step 4 title: "④ 验证后再 drop"
Command:
"git stash drop 'stash@{1}'"

Bottom reminder:
"相关文件已有修改？先单独保存"
```

## 04 指定弹出哪一条 stash

```text
Title: "指定弹出哪一条 stash"
Subtitle: "默认最新，也可以明确选择"

Block 1 title: "默认最新"
Commands:
"git stash pop"
"= stash@{0}"

Block 2 title: "指定第二新"
Command:
"git stash pop 'stash@{1}'"

Block 3 title: "只应用，不删除"
Command:
"git stash apply 'stash@{1}'"

Orange warning:
"push / pop / drop 后，编号会变化"

Bottom reminder:
"每次操作前先运行 git stash list"
```

## 05 新文件为何没进 stash

```text
Title: "新文件为何没进 stash？"
Subtitle: "Untracked File（未跟踪文件）默认不保存"

Comparison block 1 title: "普通 stash"
Command:
"git stash push"
Line:
"保存已跟踪文件的修改"

Comparison block 2 title: "连新文件一起保存"
Command:
"git stash push -u -m '临时保存当前修改'"
Line:
"-u = --include-untracked"

Small warning block:
"-a 还会包含被忽略文件"
"可能带入依赖和构建产物"

Bottom reminder:
"先用 git status --short 检查范围"
```
