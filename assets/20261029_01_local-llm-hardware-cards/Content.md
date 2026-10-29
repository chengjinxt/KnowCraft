# 本地大模型配置怎么看

判断能不能跑，先看权重大小、可用内存/显存、推理后端和上下文长度。能加载不等于流畅。

`B` 是 Billion（十亿），`T` 是 Trillion（一万亿），`A` 是 Activated（激活）。`35B-A3B` 指总参数350亿、每个 Token（词元）约激活30亿。`MoE (Mixture of Experts，专家混合)` 只调用部分专家，但全部权重仍要保存。

权重内存约等于“总参数×位数÷8”。`GB (Gigabyte，十亿字节)` 是容量单位。每1B参数：16位约2GB，8位约1GB，4位约0.5GB，2位约0.25GB；另留 `KV Cache (Key-Value Cache，键值缓存)`、缓冲区和系统空间。

11.7GB的35B低量化模型，16GB内存只宜短上下文试跑，32GB较稳。长期使用优先24GB显存+64GB内存，或48GB以上统一内存。Linux适合服务，Windows适合桌面，Mac胜在统一内存。

旧四核16GB、M2/16GB和飞腾四核机都不适合长期跑35B。552B～2.8T前沿模型属于多卡集群级，个人优先用 `API (Application Programming Interface，应用程序编程接口)`。
