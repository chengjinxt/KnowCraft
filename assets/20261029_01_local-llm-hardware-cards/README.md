# 本地大模型参数、内存与电脑配置

## 白话结论

判断一台电脑能不能运行本地大模型，不能只看模型名称，也不能只看“激活参数”。最实用的判断顺序是：

1. 先看实际权重文件有多大。
2. 再看可用 `RAM (Random Access Memory，随机存取存储器/内存)`、`VRAM (Video Random Access Memory，显存)` 或 Apple 统一内存能否容纳权重和运行开销。
3. 确认推理软件有没有支持当前 `CPU (Central Processing Unit，中央处理器)`、`GPU (Graphics Processing Unit，图形处理器)` 和操作系统的加速后端。
4. 最后根据上下文长度、并发数量和预期速度判断是否“实用”。

能下载、能加载、能生成和能流畅使用，是四个不同层次。

## 卡片清单

1. `01-four-checks.png`：本地模型能不能跑，先看权重、容量、后端和速度。
2. `02-parameter-units.png`：解释 `B`、`T`、`A` 和 `MoE`。
3. `03-memory-per-billion.png`：按精度估算每十亿参数的理论权重容量。
4. `04-active-is-not-memory.png`：说明激活参数为什么不能直接当成显存需求。
5. `05-runtime-memory.png`：运行内存还包括 `KV Cache (Key-Value Cache，键值缓存)`、缓冲区和系统占用。
6. `06-quantization-sizes.png`：比较本次讨论的35B与31B量化文件大小。
7. `07-35b-hardware-levels.png`：35B模型在16GB、32GB、24GB显存与统一内存机器上的边界。
8. `08-os-comparison.png`：对比 Linux、Windows 和 macOS。
9. `09-existing-computers.png`：判断三类已讨论电脑的实际可用性。
10. `10-frontier-cluster-models.png`：说明五款前沿模型为什么属于集群级。
11. `11-buying-plan.png`：给出个人本地推理的采购优先级。

## 参数单位怎么读

- `1K = 10³`，一千。
- `1M = 10⁶`，一百万。
- `1B = 10⁹`，十亿。
- `1T = 10¹²`，一万亿。
- `A` 常表示 `Activated（激活）`。

例如：

```text
35B-A3B
```

表示模型总参数约350亿，每处理一个 `Token（文本单元）` 时约有30亿参数参与计算。

`B` 在这里是参数数量单位，不是 `Byte（字节）`。只有写成 `GB (Gigabyte，十亿字节)` 或 `GiB (Gibibyte，2³⁰字节)` 时，才是在描述存储或内存容量。`1 Byte = 8 bit`。

## 总参数与激活参数

`MoE (Mixture of Experts，专家混合)` 模型把部分网络拆成多个专家。每个 Token 只选择少量专家参与计算，因此激活参数可以远小于总参数。

白话上可以理解为：

- 总参数是整座图书馆保存了多少书。
- 激活参数是回答当前问题时取出了多少书。
- 书没有被取出，不代表可以从图书馆永久删除；下一个 Token 可能选择另一批专家。

因此：

- **加载容量主要由总参数和权重精度决定。**
- **单 Token 计算量和权重读取量更受激活参数影响。**
- 激活参数不是运行时“激活张量内存”的同义词。

## 权重容量怎么估算

理论公式：

```text
权重容量 ≈ 总参数量 × 每参数位数 ÷ 8
```

每1B参数的理论容量：

表中的 `FP (Floating Point，浮点数)`、`BF16 (Brain Floating Point 16，16位脑浮点格式)` 和 `INT (Integer，整数)` 表示不同的数字存储格式。

| 精度 | 含义 | 每1B参数 |
|---|---|---:|
| `FP32` | `32-bit Floating Point（32位浮点数）` | 4GB |
| `FP16/BF16` | 16位浮点数 | 2GB |
| `FP8/INT8` | 8位浮点数/整数 | 1GB |
| `INT4/FP4` | 4位整数/浮点数 | 0.5GB |
| 2-bit | 2位量化 | 0.25GB |

实际文件和运行占用通常更大，因为还可能包含量化比例因子、未量化层、词表、视觉编码器、对齐填充和框架元数据。部署时通常还要给运行时预留至少10%至30%的空间；长上下文和高并发可能需要更多。

例如 `Qwen3.8-2.4T-A95B` 如果全部按4位保存，理论权重约为：

```text
2.4T × 4 ÷ 8 = 1.2TB
```

95B激活参数在4位下对应约47.5GB的活跃权重数据，但完整模型仍要保存约1.2TB权重，不能用一张48GB显卡完整加载。

## 运行内存不只包含权重

推理时的容量预算应写成：

```text
运行容量 ≈ 模型权重
         + KV Cache
         + 中间激活张量
         + 工作缓冲区
         + 系统和推理框架
```

`KV Cache (Key-Value Cache，键值缓存)` 保存已经处理过的上下文信息。它通常随着上下文 Token 数和并发请求数增加；具体占用还取决于层数、KV头、头维度、缓存精度和注意力结构。

本次提到的前沿模型大量采用 `MLA (Multi-head Latent Attention，多头潜在注意力)`、线性注意力或稀疏注意力，不能只用一个通用公式准确推算缓存。最终应以模型配置、推理框架启动日志和实测峰值为准。

## 本次讨论的量化文件

### Qwen3.6-35B-A3B

- 总参数：约35B。
- 激活参数：约3B。
- `IQ2_M` 文件：约11.7GB。
- 视觉投影 `mmproj`：约899MB。
- 原生支持较长上下文，但消费级机器不应直接把最大上下文当作日常配置。

`A3B` 主要降低每 Token 的计算量，不会把35B权重变成3B文件。

### Gemma 4 31B

- 31B稠密模型，所有主要权重都参与每层计算。
- `Q3_K_M` 文件：约15.3GB。
- `Q4_K_M` 文件：约18.7GB。

低位量化可以降低容量，但通常也会降低模型质量。能装下时，优先选择质量更稳的较高量化，而不是无条件选择最小文件。

## 35B模型的机器边界

### 16GB内存

- 11.7GB权重只给系统、缓存和缓冲区留下很少空间。
- 可以在纯文本、短上下文、关闭其他程序的条件下实验。
- 使用视觉投影或长上下文时容易内存不足或频繁交换。

### 32GB内存

- 是这款11.7GB `IQ2_M` 比较稳妥的容量下限。
- CPU推理能否流畅，仍取决于核心性能和内存带宽。
- 加内存通常先解决“加载不下”，不会让旧四核CPU突然变快。

### 24GB显存加64GB内存

- 适合RTX 3090一类显卡完整或大比例卸载35B低量化/4位模型。
- 系统内存给模型、缓存、工具和其他应用留有余量。
- 长上下文、视觉输入和并发仍需实测。

### Apple 统一内存

- 48GB或64GB统一内存更适合长期运行35B模型。
- `Metal（Apple图形计算接口）` 可以让CPU和GPU共享统一内存。
- 内存购买后不能升级，应按未来模型和上下文需求预留。

## Linux、Windows与macOS

### Linux

- 适合长期服务、多GPU和容器化部署。
- NVIDIA常用 `CUDA (Compute Unified Device Architecture，统一计算设备架构)`。
- AMD常用 `ROCm (Radeon Open Compute，AMD开放计算平台)` 或 Vulkan。
- 驱动和命令行维护要求相对较高。

### Windows

- 适合桌面聊天和图形界面工具，例如LM Studio类应用。
- NVIDIA CUDA生态成熟，普通用户上手方便。
- 多卡服务、复杂容器和部分AMD计算后端通常不如Linux省心。

### macOS

- Apple Silicon通过统一内存和Metal运行本地模型，噪音低、配置简单。
- 主要看统一内存容量和芯片档位。
- 不适合依赖CUDA的软件，内存也无法后续扩展。

## 三类已讨论电脑的判断

### MacBook Air M2 / 16GB / 1TB

- SSD容量足以保存11.7GB模型。
- 16GB统一内存处在极限边缘。
- 可以尝试纯文本、2K至4K上下文；不适合视觉、长上下文和持续重负载。
- 无风扇设计在长时间运行时还会受到散热限制。

### 旧四核台式机 / 16GB / 集成显卡

- 权重与系统争抢内存，集成显卡不能提供足够显存。
- CPU和内存带宽较弱，生成速度不实用。
- 硬盘剩余空间够，只能说明模型文件放得下。

### 飞腾FT-2000/4信创台式机

- 64位ARM架构理论上可以编译CPU版 `llama.cpp`。
- 16GB只能小上下文尝试11.7GB模型。
- 升级32GB可改善加载稳定性；升级64GB可以容纳更多缓存，但不会解决四核CPU慢的问题。
- 商品只写“4GB独显”不能证明支持CUDA、Vulkan计算或 `llama.cpp` GPU后端；必须先确认显卡型号和驱动。
- 如果是为本地大模型新购，不建议选择该平台。

在银河麒麟中可以先查看：

```bash
uname -m
free -h
lscpu
lspci -nnk | grep -EA3 'VGA|3D|Display'
```

检查内存插槽：

```bash
sudo dmidecode -t 16
sudo dmidecode -t 17
```

## 前沿模型为什么是集群级

| 模型 | 总参数 | 激活参数 | 权重/部署级别 |
|---|---:|---:|---:|
| Kimi K3 | 2.8T | 104B | 原生 `MXFP4 (Microscaling FP4，微缩放4位浮点格式)` 约1.56TB |
| Qwen3.8-Max | 2.4T | 95B | `W4A8 (Weight 4-bit/Activation 8-bit，4位权重/8位激活)` 约1.21 `TiB (Tebibyte，2⁴⁰字节)` |
| GLM-5.3 | 753B | 约40B | FP8约0.75TB |
| DeepSeek V4 Pro | 1.6T | 49B | 混合精度约0.87至0.96TB |
| DeepSeek V4.1 Flash | 552B | 输入8B、输出16B | 实际检查点约511GB |

这些容量还没有加上KV Cache、运行缓冲区和并发余量。即使激活参数只有8B或16B，完整权重仍然要驻留在GPU显存、系统内存或高速分布式存储中。

可用部署通常是8至16张H200、B200、B300或同级数据中心加速卡，并配合Linux、TB级系统内存、`NVMe (Non-Volatile Memory Express，非易失性内存主机控制器接口规范)` 存储和高速卡间/节点间网络。个人使用应优先选择官方 `API (Application Programming Interface，应用程序编程接口)`，而不是为这些模型采购家用电脑。

## 采购建议

### 35B模型性价比优先

- 二手 `RTX 3090 24GB`。
- `64GB DDR4 (Double Data Rate 4，第四代双倍数据率)` 系统内存。
- 现代6核至8核CPU。
- 1TB至2TB `NVMe SSD (Solid-State Drive，固态硬盘)`。
- 850W至1000W可靠电源，并检查机箱长度与散热。

二手显卡应现场检查型号、显存压力测试、持续负载温度、花屏、驱动重置和电源接口，不要脱离平台付款。

### 全新显卡

- 16GB显存适合中小模型和35B低量化/部分卸载。
- 35B较高量化通常更希望有24GB以上显存。
- 不要只看显卡名称；先看显存容量、后端支持和整机内存。

### Mac

- 48GB统一内存适合35B日常使用。
- 64GB更适合较高量化、视觉输入、长上下文和多应用并行。
- 如果只为运行一个11.7GB模型，没必要直接购买最高端Mac Studio。

价格波动较大，采购前应重新核对官方自营、品牌旗舰店、保修和二手成交价。此前聊天中的市场价格只能作为当时参考，不应当作长期固定报价。

## 查看一台电脑是否能跑

建议记录以下信息：

- 模型文件准确大小和量化等级。
- 可用而非标称的系统内存。
- GPU型号、显存和加速后端。
- CPU核心数、单核性能和内存通道。
- 计划使用的上下文长度和并发数。
- 推理软件版本与模型架构支持情况。

Windows可以查看：

```powershell
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
Get-CimInstance Win32_ComputerSystem | Select-Object TotalPhysicalMemory
Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM
Get-Volume | Select-Object DriveLetter, SizeRemaining, Size
```

Linux可以查看：

```bash
lscpu
free -h
lspci | grep -Ei 'VGA|3D|Display'
df -h
```

macOS可以在“关于本机”查看芯片和统一内存，并使用：

```bash
system_profiler SPHardwareDataType SPDisplaysDataType
```

## 参考资料

- [Qwen3.6-35B-A3B 官方模型](https://huggingface.co/Qwen/Qwen3.6-35B-A3B)
- [HauhauCS Qwen3.6-35B-A3B GGUF](https://huggingface.co/HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive)
- [Gemma 4 31B](https://huggingface.co/google/gemma-4-31B)
- [Kimi K3 官方模型卡](https://huggingface.co/moonshotai/Kimi-K3)
- [Qwen3.8-2.4T-A95B 官方模型卡](https://huggingface.co/Qwen/Qwen3.8-2.4T-A95B)
- [GLM-5.3 官方模型卡](https://huggingface.co/zai-org/GLM-5.3)
- [DeepSeek V4 官方说明](https://deepseek.com/en/news/v4-preview/)
- [DeepSeek V4.1 Flash 官方说明](https://www.deepseek.com/en/news/deepseek-v4-1-flash/)
- [飞腾FT-2000/4官方规格](https://www.phytium.com.cn/homepage/production/6/)
- [llama.cpp构建说明](https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md)
- [llama.cpp服务器参数](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md)

## 生成方式与检查说明

- 生成方式：使用Codex内置 `imagegen`，逐张生成原创中文技术信息图。
- 画布：11张图片均为 `1086 × 1448`、3:4竖版；采用浅色不透明背景、高对比标题、圆角信息块和少量芯片/内存/书本/服务器图标。
- 脱敏：卡片和文档不包含真实仓库地址、内部网络、账号、密钥、本机路径或其他身份标识。
- 检查重点：参数数量、单位大小写、公式、模型名称、容量数字、操作系统边界和每张卡的信息归属。
- 视频：`shorts.mp4` 由项目卡片视频生成器按图片自然顺序生成，每张4秒，共44秒、无音轨。
- 视频验收：单个H.264视频流，`1080 × 1920`、30 fps、`yuv420p`、BT.709、`color_range=tv`，总时长44秒。
- 仍需人工确认的风险：社区量化文件、推理框架和硬件支持会持续变化；市场价格也会波动，采购前应重新核对。
