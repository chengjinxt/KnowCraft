# Everything点击就卡怎么修

## 先看真正卡在哪里

Everything 搜索正常，但一点击或滚动就“未响应”，同时内存持续上涨、磁盘并不忙。若线程栈落在 `UIAutomationCore.dll` 和 `ListView`，通常是外部 `UI Automation`（用户界面自动化）工具正在拉取大量结果。

## lvm 是什么

`lvm` 指 `List View Messages`（列表视图消息）。`lvm=1` 允许屏幕阅读器和自动化工具读取结果列表；结果特别多时，外部工具可能一次枚举全部项目。`lvm=0` 会限制这类读取，但不会关闭索引，也不会删除数据库。

## 怎么设置

在 Everything 搜索框输入 `/lvm=0` 并按 `Enter`。新版还可在“工具 → 选项 → 高级”中搜索 `lvm`，设为 `false`。手工改配置时，先退出 Everything，再在 `Everything.ini` 中写入 `lvm=0`。

## 怎么验收

重新搜索大量结果，连续单击、滚动并观察响应和内存。若仍卡住，应在现场抓取 `mini dump` 或线程栈，不能把所有卡顿都归因于 `lvm`。
