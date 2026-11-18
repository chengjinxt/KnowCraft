# Git 拉取中断如何分批续拉

## 先判断失败层
`ssh -T` 成功只说明 SSH（Secure Shell，安全外壳协议）认证通过。若 `git pull` 随后出现 `early EOF`、`index-pack failed`，更像是 Pack（对象包）传到一半断开。

## 为什么总从头开始
普通 `fetch` 不能续传半个 Pack。连接中断后，本次不完整对象包无法建立索引。

## 先拉骨架
把 `origin` 设为 Promisor Remote（承诺远程仓库），再运行：

`git fetch --filter=blob:none --no-tags origin main`

`blob:none` 会先跳过 Blob（文件内容对象），只拉提交和目录结构。

## 再逐个补对象
脚本先用 `git rev-list --missing=print` 找缺失对象，再用 `git cat-file` 逐个补取并重试。成功对象会保留，重跑时不用重下。

## 配置与编码
仍需分层拉取就保留配置；确认全库无缺失后再还原。Windows PowerShell 5.1 运行含中文的 `.ps1` 时，建议保存为带 BOM（Byte Order Mark，字节顺序标记）的 UTF-8。
