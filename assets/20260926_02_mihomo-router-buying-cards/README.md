# Mihomo 路由器二手选购知识卡片

这组卡片承接 `20260925_03_openwrt-stack-cards`，回答“为了在路由器端运行 Mihomo，二手设备应当怎么买”。重点不是提供万能机型，而是建立可复用的判断方法。

## 卡片顺序

1. `01-mihomo-router-requirements.png`：固件、CPU 架构、内存与存储、恢复能力四项前提。
2. `02-stock-vs-preflashed.png`：比较原厂未刷与已刷第三方固件设备的收益和风险。
3. `03-used-price-comparison.png`：解释用户截图中的挂牌样本，并把配件、工具、时间与救砖风险计入总成本。

## 关键结论

- 路由器能够发射 Wi-Fi，不等于能够运行 Mihomo。
- OpenClash 是 OpenWrt 上的管理插件；Mihomo 是真正执行代理连接、DNS 与分流规则的核心。
- 普通路由器的 PPTP / VPN 页面不能直接填写 Clash 订阅。
- `256 MB` 内存属于可入门的经验档位，`512 MB` 通常更从容；这不是项目方公布的硬性最低配置。
- 原厂未刷只描述当前状态，不代表一定容易提权、一定没有批次差异，也不保证比已刷设备便宜。
- 价格卡中的数字来自本次对话所附商品截图，只用于说明比较方法，不是市场均价或成交承诺。

## 参考依据

- [OpenClash 官方仓库](https://github.com/vernesong/OpenClash)
- [Mihomo 官方仓库](https://github.com/MetaCubeX/mihomo)
- [Mihomo FAQ：按操作系统和 CPU 架构选择核心](https://github.com/MetaCubeX/mihomo/wiki/FAQ)
- [OpenWrt Table of Hardware](https://openwrt.org/toh/start)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`。
- 版式：`1086 × 1448`，标准 `3:4` 竖版，完全不透明浅色背景。
- 已检查型号、英文大小写、数字区间、软件层级与隐私字段。
- 剩余风险：二手价格、原厂固件版本、提权入口和第三方项目维护状态会变化，购买当天仍需重新核对。
