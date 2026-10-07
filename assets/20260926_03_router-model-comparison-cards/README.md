# 二手路由器型号比较知识卡片

这组卡片比较用户截图中出现的主要型号。硬件梯度只纳入公开资料较明确、确实具有比较价值的代表设备；支持程度卡则把其余型号纳入“需要进一步证明”的范围。

## 卡片顺序

1. `01-hardware-ladder.png`：以 CPU、RAM、存储和网口为主，从低到高比较五类代表设备。
2. `02-flashing-support-levels.png`：区分正式版本、主线但有批次风险、社区适配、开发快照和证据不足。
3. `03-buying-recommendations.png`：按省心自刷、低预算、愿意折腾和追求强硬件给出选择建议。
4. `04-brand-vs-model.png`：解释中国移动定制型号为什么在截图中出现较多，并区分“出现最多、市场流行、适合自刷”。

## 核心比较

| 设备 | 平台与内存 | 存储/网口 | 刷机证据与主要风险 |
|---|---|---|---|
| 小米 CR6609 | MT7621AT，双核 880 MHz，256 MB RAM | 128 MB NAND，全千兆 | OpenWrt 正式版本较明确；性能余量较低 |
| 360T7 | MT7981B，双核 1.3 GHz，256 MB RAM | 128 MB NAND，全千兆 | 主线有适配；部分 NAND 颗粒存在明确兼容风险 |
| 中国移动 RAX3000M / Me | MT7981B，双核 1.3 GHz，512 MB RAM | NAND 或 eMMC，全千兆 | 正式版本支持较明确；必须核对准确修订版和存储类型 |
| XR30 / RAX3000Z 增强版 | MT7981B，双核 1.3 GHz，512 MB RAM | eMMC 版本需核对 | 主要依赖社区固件与对应 U-Boot；卖家名称容易混用 |
| 京东云雅典娜 RE-CS-02 | IPQ6010，四核 1.8 GHz，1 GB RAM | eMMC，1×2.5G + 4×1G | OpenWrt 主线当前以 Snapshot 为主；存在驱动、网络栈和恢复复杂度 |

## 如何理解“最流行”和“最好”

- 大众品牌的市场流行度不能直接推导某个具体型号可刷。
- 用户截图里中国移动定制设备出现较多，只能说明这批商品中的货源集中，不能据此判断全国销量或质量排名。
- 中国移动定制设备不是同一厂家、同一芯片或同一分区方案。
- 对自行刷机的新手，成熟适配、可验证教程和可恢复性通常比更强硬件重要。
- 在本组设备中，RAX3000M / Me 更接近“省心自刷的平衡选择”；CR6609 适合低预算入门；雅典娜硬件更强，但不等于更适合新手。

## 参考依据

- [OpenWrt：CMCC RAX3000M / Me](https://openwrt.org/toh/cmcc/rax3000m)
- [OpenWrt：Xiaomi Mi Router CR6609](https://openwrt.org/toh/hwdata/xiaomi/xiaomi_mi_router_cr6609)
- [OpenWrt：Qihoo 360T7](https://openwrt.org/toh/qihoo/360t7_1.0)
- [OpenWrt：JDCloud RE-CS-02 (Athena)](https://openwrt.org/toh/hwdata/jdcloud/jdcloud_re-cs-02)
- [OpenWrt issue：雅典娜 Snapshot 网络回归案例](https://github.com/openwrt/openwrt/issues/24423)
- [RAX3000QY 社区刷机项目](https://github.com/sfxfs/rax3000qy-OpenWrt)
- [XR30 / RAX3000Z 增强版社区适配说明](https://github.com/lgs2007m/Actions-OpenWrt/blob/main/Tutorial/RAX3000M-eMMC_XR30-eMMC.md)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`。
- 版式：`1086 × 1448`，标准 `3:4` 竖版，完全不透明背景。
- 硬件排名不等于购买排名；卡片没有把社区固件冒充官方正式版本。
- `RAX3000H`、`RAX1800Z`、`UNR030Z`、`SIMAX3000T`、`HW3000A / B1` 和含糊的 `RAX3000Z / Ze` 商品标题被归入“证据不足或必须核对”的层级，并非断言它们永远不能刷。
