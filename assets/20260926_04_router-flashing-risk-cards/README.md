# 路由器刷机风险与版本识别知识卡片

这组卡片把风险控制放在刷机之前：先确认设备身份、硬件修订版、存储类型和恢复路径，再选择固件。

## 卡片顺序

1. `01-prepurchase-checklist.png`：购买原厂未刷二手设备前的八项核对，以及到手后的备份底线。
2. `02-ch-vs-ch-ec.png`：解释 RAX3000M 标签中的 `CH` 与 `CH EC`，并给出存储类型核验命令。

## 关键结论

- 商品标题、外壳和无线规格不能唯一确定主板、存储或分区布局。
- 下单前应要求真实底部标签、准确型号、原厂固件版本、存储类型、改机历史和退货边界。
- 到手后先备份原厂分区以及 `Factory / EEPROM` 无线校准数据，再核对固件、校验值和恢复入口。
- 对 RAX3000M 标签，OpenWrt 文档将 `CH` 用作硬件修订代码，没有给出两个英文单词组成的公开全称。
- 在该设备的标签识别规则中，`CH` 对应 NAND 版本，`CH EC` 对应 eMMC 版本；不同存储类型不能混用引导文件和刷机流程。

## 参考依据

- [OpenWrt：CMCC RAX3000M 硬件修订与存储识别](https://openwrt.org/toh/cmcc/rax3000m)
- [RAX3000M eMMC / XR30 eMMC 社区刷机说明](https://github.com/lgs2007m/Actions-OpenWrt/blob/main/Tutorial/RAX3000M-eMMC_XR30-eMMC.md)
- [OpenWrt：安装方法总览](https://openwrt.org/docs/guide-user/installation/installation_methods/start)

## 生成与检查说明

- 生成方式：Codex 内置 `imagegen`。
- 版式：`1086 × 1448`，标准 `3:4` 竖版，完全不透明背景。
- 已检查 `NAND`、`eMMC`、`U-Boot`、`Factory`、`EEPROM`、接口名称和命令拼写。
- 卡片没有提供可直接复制执行的高风险刷写命令；实际刷机仍需使用对应硬件版本的最新文档。
