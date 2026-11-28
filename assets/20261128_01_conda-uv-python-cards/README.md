# Conda 与 uv 的 Python 环境

创建环境时，先分清 Python 本身和第三方依赖装在哪里。切换已有环境只改变当前使用的解释器和依赖路径。

## Python 和依赖分别放在哪里

- **Conda 环境**指定 Python 后，解释器和依赖都安装到环境目录中。安装可以复用 Conda 的包缓存。
- **uv 虚拟环境（Virtual Environment）**基于已有的 Python 安装创建。多个环境可共用解释器和标准库，每个环境有独立的第三方包目录 `site-packages`。默认不会继承基础环境中安装的第三方包。
- Windows 下查看 `.venv\pyvenv.cfg` 的 `home` 可以确认虚拟环境实际依赖哪套 Python。若基础安装被移走，已有环境中的 `python.exe` 不会自动改用另一个同版本解释器。

## uv 怎么发现 Conda 的 Python

`conda env list` 显示 Conda 已知的环境。uv 根据命令和配置查找 Python，来源包括 uv 管理目录、终端的 `PATH`（可执行文件搜索路径）和 Windows 注册表（Registry）。uv 不会遍历 Conda 的环境清单。未激活的环境若已在 `PATH` 或注册表等发现范围内，仍可能被找到。

`conda activate` 会把目标环境的目录加入当前终端的 `PATH`。激活后可先确认查找结果。若存在多个匹配解释器，uv 默认倾向使用自己管理的版本，给出完整路径可以选定特定解释器（Interpreter）。

```cmd
conda activate example311
uv python list --only-installed
uv python find 3.11
```

`example311` 是示例环境名。版本号 `3.11` 可以匹配多个补丁版本，`3.11.11` 则是对该补丁版本的精确请求。

## 同版本多条记录的两种情况

- **一套安装有多个入口。** 在 Windows 的测试中，uv 安装的 `python3.14.exe` 是命令行启动器（Launcher）。它通过带 `3.14` 的目录联接（Junction）进入带 `3.14.3` 的真实安装目录。指定 `--python 3.14` 创建的虚拟环境引用目录联接，指定 `--python 3.14.3` 创建的环境引用具体补丁版本目录。二者当前运行的是同一套 Python。只移除命令行启动器会使直接输入 `python3.14` 的入口失效。使用上述两种版本请求创建的环境依赖对应的基础路径。
- **同版本存在两套独立安装。** 如果 uv 没找到 Conda 已有的解释器，而且该版本在当前 uv 的下载清单中、自动下载也允许，uv 可以把同版本另外装进自己的管理目录。这时两个目录各有独立的 Python 运行时。

## 复用、禁止下载和旧版本

在项目目录中运行下列命令，把占位符替换为已有 Conda 环境的绝对目录。完整路径可指定解释器，无需先激活 Conda。

```cmd
uv --no-python-downloads venv --python "<Conda环境目录>\python.exe" .venv
```

- `venv` 创建虚拟环境（Virtual Environment），`.venv` 是输出目录。
- `--python` 指定版本请求或解释器路径。指向完整路径可以绕开按版本查找时的歧义。
- `--no-python-downloads` 关闭 Python 运行时的自动下载。它不影响后续主动安装项目依赖时访问包索引。
- uv 0.10.11 离线实测能用 Conda 的 Python 3.11.11 建立虚拟环境。Conda 原环境的 PySide6 未出现在新虚拟环境中。若需要直接使用原环境已装好的依赖，激活并运行原 Conda 环境。
- Python 2.7.18 的版本请求会被 uv 0.10.11 拒绝，直接传入该解释器路径也无法创建虚拟环境。已有的 2.7 环境仍可用 `conda activate <旧环境名>` 启用。

## 图片与视频

| 文件 | 内容 |
| --- | --- |
| [01-environment-model.png](01-environment-model.png) | Conda 和 uv 分别怎样组织 Python 与依赖 |
| [02-python-discovery.png](02-python-discovery.png) | Python 的查找范围与下载条件 |
| [03-same-version-two-installs.png](03-same-version-two-installs.png) | 同一安装的多个入口与同版本的独立安装 |
| [04-reuse-without-download.png](04-reuse-without-download.png) | 指定解释器、禁止下载和 Python 2.7 边界 |
| [shorts.mp4](shorts.mp4) | 四张卡，每张 4 秒 |

使用内置 ImageGen 生成四张卡，第三、四张替换了局部图标。逐张检查中文、英文、命令参数、图标归属和箭头方向。生成及修订提示词见 [PROMPTS.md](PROMPTS.md)，发布正文见 [Content.md](Content.md)。

四张图片均为 `1086 × 1448`（3:4）。视频抽帧检查通过，四张完整卡面按顺序播放。使用 `ffprobe` 确认视频为 `1080 × 1920`、H.264、30 fps、`yuv420p`、BT.709 有限范围，总长 16 秒，只有一个视频流。

复用其他 Conda 环境时，以当前 `uv python find` 和 `pyvenv.cfg` 的结果为准。若应用依赖 Conda 激活脚本设置的动态库搜索路径，还需在目标机器上核对这些依赖能否加载。本次验证覆盖解释器启动和 Python 包隔离。

## 参考资料

- [Conda 24.11 环境管理与激活](https://docs.conda.io/projects/conda/en/24.11.x/user-guide/tasks/manage-environments.html#activating-an-environment)
- [uv 的 Python 发现、安装与版本目录](https://docs.astral.sh/uv/concepts/python-versions/)
- [uv 的命令行参考](https://docs.astral.sh/uv/reference/cli/#uv-venv)
- [Python 虚拟环境文档](https://docs.python.org/3/library/venv.html)
