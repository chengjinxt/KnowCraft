# ImageGen 提示词记录

## 输入图片用途

用户提供的截图只用于确定需要覆盖的模型名称：`Kimi K3`、`Qwen3.8 Max`、`GLM-5.3`、`DeepSeek V4 Pro`、`DeepSeek V4.1 Flash`。截图不作为风格参考，也不直接嵌入最终卡片。

## 统一视觉规范

```text
Use case: scientific-educational
Asset type: 十一张原创中文本地大模型知识卡片，3:4竖版
Audience: 有基础电脑使用经验、但不熟悉模型参数和硬件术语的中文读者
Style/medium: 清爽扁平矢量技术信息图；完全不透明的浅米白背景；深海军蓝标题；蓝色、青绿色圆角信息块；少量橙色警示；简化的芯片、内存条、显卡、书本、服务器和操作系统图标；大字号、充足留白、手机端易读。
Composition: 顶部高对比标题，中部按阅读顺序排列3至5个信息块，底部一句准确结论；数字、公式和型号使用清晰的等宽风格。
Constraints: 所有引号内文字逐字呈现；准确保留英文大小写、数字、小数点、连字符、斜杠、加号和乘号；不添加提示词之外的文字；无品牌Logo、水印、二维码、平台标识和页码；不出现真实账号、内网地址、本机路径或凭据。
```

## 01 本地大模型能不能跑

```text
Title: "本地大模型能不能跑？"
Subtitle: "先看4项，不先看模型名"

Block 1: "① 权重文件" / "模型文件能否放进内存或显存"
Block 2: "② 运行容量" / "权重 + KV Cache + 缓冲区 + 系统"
Block 3: "③ 加速后端" / "CUDA、Metal、Vulkan是否可用"
Block 4: "④ 实际速度" / "核心性能、内存带宽、激活参数"

Bottom reminder: "能加载 ≠ 能流畅 ≠ 能开长上下文"
```

## 02 B、T、A 到底是什么

```text
Title: "B、T、A 到底是什么"
Subtitle: "参数数量，不是硬盘容量"

"B = Billion（十亿）"
"35B = 350亿参数"

"T = Trillion（一万亿）"
"2.4T = 2.4万亿参数"

"A = Activated（激活）"
"35B-A3B：总参数350亿，每个Token约激活30亿"

Definition: "MoE (Mixture of Experts，专家混合)"
Plain language: "每次只叫部分专家上班"

Bottom reminder: "B是参数数量，GB才是存储容量"
```

## 03 1B参数占多少内存

```text
Title: "1B参数占多少内存？"
Subtitle: "先按权重精度做理论估算"

Formula: "权重容量 ≈ 总参数 × 位数 ÷ 8"
Definition: "FP (Floating Point，浮点数) · INT (Integer，整数)"

Table:
"FP16 / BF16     约2GB"
"FP8 / INT8       约1GB"
"INT4 / FP4       约0.5GB"
"2-bit                 约0.25GB"

Small note: "实际还要加量化元数据、未量化层和运行开销"
Bottom reminder: "部署时通常再留10%～30%余量"
```

## 04 激活参数不等于所需内存

```text
Title: "激活参数 ≠ 所需内存"
Subtitle: "整本书要保存，回答时只翻一部分"

Example title: "Qwen3.8：2.4T-A95B，按4位估算"
"完整权重：约1.2TB"
"每Token活跃权重：约47.5GB"

Visual metaphor: a large library labeled "总参数" and a small stack of open books labeled "激活参数"
Explanation: "下一个Token可能选择另一批专家"

Bottom reminder: "装模型看总参数，估算计算量看激活参数"
```

## 05 运行内存不只装权重

```text
Title: "运行内存不只装权重"
Subtitle: "模型文件大小只是起点"

Equation blocks connected by plus signs:
"模型权重"
"KV Cache"
"中间激活与缓冲区"
"系统和推理框架"

Definition: "KV Cache (Key-Value Cache，键值缓存)"
"上下文越长，占用通常越大"
"并发越多，需要保存的缓存越多"

Example warning: "模型文件11.7GB ≠ 16GB内存一定够"
Bottom reminder: "还要给系统、缓存和缓冲区留空间"
```

## 06 量化更省内存也有代价

```text
Title: "量化：更省内存，也有代价"
Subtitle: "位数越低，通常越省；质量风险越高"

Definition: "GGUF：适合 llama.cpp 的模型文件格式"

Comparison:
"Qwen3.6 35B-A3B"
"IQ2_M     约11.7GB"

"Gemma 4 31B"
"Q3_K_M   约15.3GB"
"Q4_K_M   约18.7GB"

Small note: "A3B降低每Token计算量，不会把35B权重变成3B文件"
Bottom reminder: "能装下时，优先选质量更稳的较高量化"
```

## 07 35B模型机器门槛

```text
Title: "35B模型机器门槛"
Subtitle: "以约11.7GB的IQ2_M为例"

Definition: "RAM (Random Access Memory，内存)"
Definition: "VRAM (Video Random Access Memory，显存)"

Tier 1: "16GB内存" / "只适合纯文本、短上下文实验"
Tier 2: "32GB内存" / "较稳妥的容量下限；CPU速度另算"
Tier 3: "24GB显存 + 64GB内存" / "35B本地推理的高性价比档"
Tier 4: "48GB / 64GB统一内存" / "Mac更省心，购买后不能升级"

Bottom reminder: "容量决定能否装下，带宽和算力决定快不快"
```

## 08 Linux、Windows、Mac怎么选

```text
Title: "Linux、Windows、Mac怎么选"
Subtitle: "容量相同，生态和维护方式不同"

Linux block:
"Linux"
"服务、多GPU、容器更合适"
"CUDA（NVIDIA计算平台）"
"ROCm（AMD开放计算平台）"

Windows block:
"Windows"
"桌面工具和NVIDIA显卡更容易上手"
"适合个人聊天与测试"

macOS block:
"macOS"
"Metal（Apple图形计算接口）"
"统一内存、安静省心；内存不能后加"

Bottom reminder: "服务器优先Linux，桌面便利选Windows，统一内存选Mac"
```

## 09 三类电脑能跑吗

```text
Title: "三类电脑能跑35B吗？"
Subtitle: "能尝试，不等于适合长期使用"

Device 1: "MacBook Air M2 / 16GB" / "短上下文可实验；视觉与长上下文不推荐"
Device 2: "旧四核 / 16GB / 集成显卡" / "容量紧、带宽低，实际不实用"
Device 3: "飞腾FT-2000/4 / 16GB / 4GB独显" / "可尝试CPU版；四核速度慢，显卡支持未知"

Upgrade note: "飞腾机升32GB：更稳；升64GB：容量更多，但不会让CPU变快"
Bottom reminder: "硬盘够只代表放得下；内存、带宽和后端决定跑不跑得动"
```

## 10 前沿模型不是家用级

```text
Title: "前沿模型不是家用级"
Subtitle: "总参数 / 每Token激活参数"

Compact table:
"Kimi K3                 2.8T / 104B"
"Qwen3.8-Max         2.4T / 95B"
"GLM-5.3                 753B / 约40B"
"DeepSeek V4 Pro   1.6T / 49B"
"V4.1 Flash              552B / 输入8B、输出16B"

Callout: "最小实际检查点也约511GB"
Callout: "完整部署通常需要多张数据中心GPU"
Bottom reminder: "个人优先用API，私有部署按服务器集群立项"
```

## 11 采购方案按模型不按噱头

```text
Title: "采购方案：按模型，不按噱头"
Subtitle: "先买容量，再看型号"

Choice 1: "35B性价比" / "二手RTX 3090 24GB + 64GB内存" / "检查显存、温度、花屏和电源接口"
Choice 2: "全新显卡" / "16GB适合中小模型；35B较高量化更希望24GB以上"
Choice 3: "安静省心" / "Mac 48GB起步，64GB更适合长上下文与视觉"
Choice 4: "552B～2.8T" / "不要买家用电脑硬扛，优先官方API"

Bottom reminder: "显存或统一内存优先，其次才是显卡名称"
```

## 定向修订提示词

### 01 去除品牌形状

```text
只修改左下“③ 加速后端”信息块里的中间图标。把苹果形状删除，换成普通方形电路芯片，芯片上只写“Metal”。其他保持不变：所有文字、布局、颜色、尺寸和其余图标都不要修改。仍然不要品牌Logo、水印或二维码。
```

说明：初稿把 `Metal` 画成了苹果轮廓，容易被理解为品牌 Logo。最终图已改为普通电路芯片，文字和信息关系保持不变。
