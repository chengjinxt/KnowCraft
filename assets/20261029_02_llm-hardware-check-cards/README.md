# 本地大模型电脑信息采集脚本

## 先说结论

判断一台电脑能不能运行本地大模型，不能只看“电脑型号”或“内存多少”。至少要同时知道处理器、内存、图形处理器、加速后端、磁盘、交换空间和推理工具情况，还要补充准备运行的模型文件与上下文需求。

本目录提供三个只读采集脚本：

- `collect-windows.ps1`：Windows PowerShell脚本。
- `collect-macos.sh`：macOS Bash脚本。
- `collect-linux.sh`：Linux Bash脚本。

三个脚本都生成 `LLM_HARDWARE_REPORT_V1` 文本报告。报告采用“分节 + `名称=值`”格式，便于人阅读，也方便后续交给脚本或大模型分析。

## 为什么要采集这些信息

| 信息 | 管什么 | 为什么重要 |
|---|---|---|
| `CPU (Central Processing Unit，中央处理器)` / 芯片 | 指令执行、CPU推理和部分卸载 | 决定没有GPU加速时的速度，也影响模型加载和数据准备 |
| 架构与指令集 | x86-64、`ARM64（64位ARM架构）`、`AVX2 (Advanced Vector Extensions 2，第二代高级向量扩展)`、`NEON（ARM向量指令集）` 等能力 | 决定推理程序能否运行以及是否能使用优化内核 |
| `RAM (Random Access Memory，随机存取存储器/内存)` | 保存权重、缓存、程序和系统数据 | 决定模型能否加载，以及是否需要慢速交换空间 |
| 内存插槽与上限 | 后续扩容空间 | 能判断“加内存是否可行”，但固件报告不等于厂商最终支持值 |
| `GPU (Graphics Processing Unit，图形处理器)` 与 `VRAM (Video Random Access Memory，显存)` | 加速矩阵计算、保存卸载到GPU的权重和缓存 | 往往是本地推理速度与可用量化等级的关键限制 |
| 驱动与加速后端 | CUDA、ROCm、Metal、Vulkan等运行接口 | 有显卡不代表推理软件一定能调用它 |
| 磁盘容量与类型 | 保存模型文件并影响首次加载 | “硬盘放得下”不代表运行内存够，但空间不足一定无法下载或解压模型 |
| Page File（页面文件）/ Swap（交换空间） | 内存不足时把部分数据放到磁盘 | 可以降低直接崩溃概率，但不能代替真正的内存和显存，速度通常明显更慢 |
| 推理工具版本 | Ollama、llama.cpp等运行环境 | 模型架构较新时，旧版本可能无法识别或缺少后端支持 |

常见加速后端：

- `CUDA (Compute Unified Device Architecture，统一计算设备架构)`：常用于NVIDIA显卡。
- `ROCm (Radeon Open Compute，AMD开放计算平台)`：常用于受支持的AMD显卡。
- `Metal（Apple图形计算接口）`：macOS与Apple Silicon常用。
- `Vulkan（跨平台图形与计算接口）`：部分Windows和Linux推理程序可以使用。

## 隐私边界

脚本故意不采集以下信息：

- 主机名、当前用户名和注册用户。
- 设备序列号、硬盘序列号和GPU唯一标识。
- IP地址、MAC地址、Wi-Fi名称和网络配置。
- 正在运行的进程、文档路径、浏览器数据和环境变量。

报告仍会包含电脑厂商、产品型号、内存条型号、GPU型号和驱动版本。这些是判断兼容性与升级空间所必需的硬件信息。对外公开报告前，仍建议人工浏览一遍。

## Windows运行方法

在脚本所在目录打开PowerShell，运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\collect-windows.ps1
```

也可以指定输出文件：

```powershell
.\collect-windows.ps1 -OutputPath .\my-windows-report.txt
```

脚本主要通过 `Get-CimInstance` 读取 `Win32_OperatingSystem`、`Win32_ComputerSystem`、`Win32_Processor`、`Win32_PhysicalMemory`、`Win32_VideoController` 等信息。它不会修改系统配置。

Windows PowerShell 5.1对“不带BOM的UTF-8脚本”兼容性较差。为避免中文系统名称或报告占位符出现乱码，Windows脚本自身只使用ASCII占位符，并把报告明确写成带 `BOM (Byte Order Mark，字节顺序标记)` 的UTF-8。生成后可直接用Windows记事本、PowerShell或其他常见编辑器打开。

注意：`Win32_VideoController.AdapterRAM` 在部分设备上不准确，尤其可能无法正确表示4 `GiB (Gibibyte，2³⁰字节)` 以上显存。装有NVIDIA驱动时，脚本会优先额外调用 `nvidia-smi` 获取显卡名称、显存和驱动版本。

## macOS运行方法

在“终端”进入脚本所在目录：

```bash
chmod +x ./collect-macos.sh
./collect-macos.sh
```

指定输出文件：

```bash
./collect-macos.sh ./my-macos-report.txt
```

脚本使用 `sw_vers`、`sysctl`、`system_profiler`、`diskutil` 和 `df`。它只从 `system_profiler` 输出中筛选芯片、GPU核心、显存和Metal支持，不读取序列号。

Apple Silicon使用 Unified Memory（统一内存），CPU和GPU共享同一内存池。因此报告里的“统一/系统内存”不能再与独立显卡显存简单相加。

## Linux运行方法

在终端进入脚本所在目录：

```bash
chmod +x ./collect-linux.sh
./collect-linux.sh
```

指定输出文件：

```bash
./collect-linux.sh ./my-linux-report.txt
```

脚本使用 `/etc/os-release`、`uname`、`lscpu`、`/proc/meminfo`、`lspci`、`lsblk` 和 `df`，并在工具存在时读取 `nvidia-smi`、`rocminfo` 或 `vulkaninfo` 的有限字段。

普通用户运行时不会自动调用 `sudo`。如果确实需要内存插槽和固件最大容量，可以人工确认后使用：

```bash
sudo ./collect-linux.sh ./my-linux-report.txt
```

脚本只从 `dmidecode` 中筛选内存容量、插槽、类型和速度，不采集序列号。服务器、虚拟机和容器里的固件信息可能缺失或不准确。

## 报告还缺什么

硬件报告不能替你猜出准备运行哪个模型。交回报告时，还应填写每份报告末尾的 `[manual_inputs_needed]`：

- 完整模型文件名，例如量化等级和分片编号。
- 实际模型文件大小，而不是下载页面上的近似参数量。
- 计划上下文长度，例如4K、8K或32K Token（词元）。
- 是否使用图片、音频等多模态输入。
- 同时运行多少个会话或请求。

如果已经安装推理工具，还应说明准备使用CPU推理、GPU全卸载、GPU部分卸载还是远程 `API (Application Programming Interface，应用程序编程接口)`。

## 拿回报告后怎么看

分析顺序建议固定为：

1. **兼容性**：操作系统、CPU架构和推理程序是否支持该模型。
2. **容量**：权重文件、`KV Cache (Key-Value Cache，键值缓存)`、中间缓冲区和系统占用能否放入显存、统一内存或RAM。
3. **后端**：CUDA、ROCm、Metal或Vulkan是否真的可用，不能只看“有独显”。
4. **速度**：CPU核心性能、内存带宽、GPU计算能力和权重卸载比例是否达到可接受速度。
5. **上下文与并发**：上下文越长、并发越高，缓存占用通常越大。
6. **升级路径**：确认内存插槽、电源、散热和主板/固件支持后，再判断加内存或换显卡是否值得。

最终应分别回答三个问题：能不能加载、预计有多快、能稳定使用多长上下文。不要只给一个“能跑/不能跑”的结论。

## 已知限制

- 脚本只负责采集，不运行模型压力测试，也不测真实 Token/s（每秒词元数）。
- 操作系统接口报告的“最大内存”可能与主板厂商实际支持列表不同。
- 集成GPU、虚拟GPU和共享显存的数值可能被驱动或操作系统简化。
- `nvidia-smi` 报告的是驱动可见的显存；部分显存可能被驱动、显示或 `ECC (Error-Correcting Code，错误校验码)` 占用。
- macOS脚本不能直接测出统一内存带宽；后续需要根据芯片型号核对。
- Linux容器看到的CPU、内存和GPU可能受 `cgroup (control group，控制组)` 或设备映射限制。
- 没找到某个命令只表示工具未安装或不在 `PATH (Path Environment Variable，路径环境变量)`，不一定表示硬件不支持。

## 文件清单

- `01-hardware-checklist.png`：硬件采集知识卡片。
- `collect-windows.ps1`：Windows采集脚本。
- `collect-macos.sh`：macOS采集脚本。
- `collect-linux.sh`：Linux采集脚本。
- `Content.md`：可直接发布的精简正文。
- `PROMPTS.md`：最终卡片的生成提示词。
- `shorts.mp4`：由知识卡片生成的9:16无音轨视频。

## 参考资料

- [Microsoft Learn：Get-CimInstance](https://learn.microsoft.com/powershell/module/cimcmdlets/get-ciminstance)
- [Microsoft Learn：Win32_VideoController](https://learn.microsoft.com/windows/win32/cimwin32prov/win32-videocontroller)
- [Apple Developer：通过sysctl读取硬件能力](https://developer.apple.com/documentation/apple-silicon/addressing-architectural-differences-in-your-macos-code)
- [Linux man-pages：lscpu](https://man7.org/linux/man-pages/man1/lscpu.1.html)
- [Linux man-pages：/proc/meminfo](https://man7.org/linux/man-pages/man5/proc_meminfo.5.html)
- [NVIDIA：nvidia-smi](https://docs.nvidia.com/deploy/nvidia-smi/)

## 生成与检查说明

- 卡片使用Codex内置 `imagegen` 生成；详细提示词记录在 `PROMPTS.md`。
- 三个脚本只执行只读查询并写出报告，不修改驱动、页面文件、交换空间或其他系统设置。
- Windows脚本已在Windows环境实际执行并生成完整报告；macOS和Linux脚本已通过Bash语法检查，并在Windows Git Bash中完成缺失命令容错冒烟测试。跨系统硬件枚举仍需在真实设备上复核。
- Windows脚本的编码修订已在Windows PowerShell 5.1环境复测：报告以带BOM的UTF-8写出，系统返回的中文字段与ASCII手工填写占位符均可正确读取。
- 最终卡片为 `1086 × 1448`、3:4；`shorts.mp4` 为4秒、单个H.264视频流、`1080 × 1920`、30 fps、`yuv420p`、BT.709、`color_range=tv`，无音轨。
- 卡片和文档按公开发布内容脱敏，不包含真实设备报告、本机路径、账号或网络信息。
- 仍需人工确认：不同系统版本、厂商驱动和精简发行版可能缺少个别命令；脚本会尽量记录 `not_found`，但不能替代目标设备实测。
