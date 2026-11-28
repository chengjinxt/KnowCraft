# Conda 与 uv 环境

## 环境里装了什么

含 Python 的 Conda 环境把解释器和依赖放在一起。uv 的多个虚拟环境可以共用同一套 Python，第三方依赖各自安装。切换已有环境无需重装。

## uv 怎么找 Python

uv 会从管理目录、当前终端的 `PATH`（可执行文件搜索路径）和 Windows 注册表等位置查找。激活 Conda 环境通常会把它加入 `PATH`。找不到匹配的 Python 时，只有 uv 提供该版本且允许下载，才会尝试下载。

## 同版本为什么出现两条

命令行启动器和安装目录可能指向同一套 Python。如果 uv 没找到 Conda 已有的版本，又下载了同版本，才会出现两套独立安装。

## 怎样确保复用

用 `--python` 指定 Conda 环境里 `python.exe` 的完整路径。用 `--no-python-downloads` 禁止自动下载。Python 2.7 不受 uv 支持，已有 2.7 环境可以继续用 Conda。
