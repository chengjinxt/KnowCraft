# 固定终端选项卡名称

## 为什么名称会变

Windows Terminal（Windows 终端）的一个 Tab（选项卡）可以包含多个 Pane（窗格）。选项卡默认显示当前聚焦窗格的标题，所以只给第一个窗格命名，切换焦点后名称仍可能变化。

## 两个关键参数

`--title "dev"` 给窗格设置标题；`--suppressApplicationTitle` 阻止 Shell（命令行解释器）或程序改写标题。多窗格脚本必须给初始窗格和每个 `split-pane` 都传入这两个参数。

```bat
set "TAB_TITLE=dev"
wt --title "%TAB_TITLE%" --suppressApplicationTitle ... ^
 ; split-pane --title "%TAB_TITLE%" --suppressApplicationTitle ...
```

## 它保存了什么

BAT (Batch File，批处理文件) 保存的是重建规则：布局、启动目录和选项卡标题。它不会保存已输入的命令、正在运行的进程或终端滚动历史。
