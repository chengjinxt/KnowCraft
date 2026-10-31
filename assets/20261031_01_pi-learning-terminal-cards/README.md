# 树莓派墙面学习终端 · 知识卡片

## 主题

把一台树莓派做成挂墙的大屏学习机：全屏触屏，学习与播放双模式，
形态类似银行、医院的自助服务终端。本组卡片覆盖概念、方案对比、
硬件采购、老型号适配、系统对比、写卡步骤、远程接入、双卡并行、
权限回收共 9 个问题，一张卡只讲一个中心问题，顺序为概念卡 →
对象对比卡 → 机制卡 → 权限卡 → 注意事项卡。

## 图片清单（3:4 竖版，1080 × 1440 PNG）

| 文件 | 标题 | 中心问题 |
| --- | --- | --- |
| 01_concept.png | 墙面学习终端 | 学习终端是什么、两种模式 |
| 02_plan-compare.png | 三档软件方案怎么选 | A 自研 / B 现成 / C 纯播放 |
| 03_hardware.png | 硬件采购要点 | 屏幕、电源、存储、支架 |
| 04_pi3b-limits.png | Pi 3B 怎么跑 | 老型号的性能边界与轻量路线 |
| 05_os-compare.png | Stretch 和 Trixie | 两代官方系统的区别 |
| 06_flash.png | Trixie 写卡步骤 | 官方写卡工具的操作要点 |
| 07_ssh-access.png | 远程连 Pi 不用密码 | SSH（Secure Shell，安全外壳协议）密钥接入 |
| 08_dual-card.png | 双卡并行怎么用 | 两张卡如何切换 |
| 09_revoke.png | 怎么收回远程权限 | 查看、删除 authorized_keys |

## 详细内容

### 概念：墙面学习终端

- 学习模式：孩子点一点就学，入口只有学习应用，不跑偏。
- 播放模式：闲置一段时间自动进入轮播，播视频、绘本、科普。
- 与手机、平板的区别：固定在墙上、屏幕大、全屏锁定，不用抢设备。

### 方案对比：三档软件方案

- A 档（自研可控）：Raspberry Pi OS Lite + Chromium（浏览器）全屏 +
  Kolibri（开源离线学习平台）+ GCompris（2–10 岁益智套件）+
  自写双入口主页。最灵活，但要自己搭。
- B 档（省事）：Porteus Kiosk 或 FullPageOS 这类现成终端系统，
  开机即全屏，基本不用管。
- C 档（纯播放）：Anthias（原 Screenly OSE）数字标牌，只排播放列表，
  不互动。
- 可选补充：Tux Paint（绘画）、Scratch（编程启蒙）、Kiwix（离线维基）。

### 硬件采购要点

- 屏幕：27 寸是甜点；要确认 HDMI 输入、USB 触控、VESA（Video
  Electronics Standards Association，视频电子标准协会）孔位、
  电容十点触控；避开红外触控（阳光和灰尘会干扰）。
- 屏幕约占总成本 70%–80%；屏幕中心高约 110–120cm 方便孩子触及。
- 电源：用官方电源；杂牌电源供电不足会导致莫名重启。
- 存储：24 小时开机优先 USB 固态盘，存储卡长期通电读写容易损坏。
- 支架：按显示器重量选承重；带风扇的散热壳有助于长期开机。

### 老型号 Pi 3B 的边界

- 1GB 内存、四核 1.2GHz、最高 1080p、USB 2.0、micro-USB 5V 2.5A 供电。
- 瓶颈是内存不是 CPU：Chromium + 学习平台同时跑会挤内存。
- 缓解办法：单页面、精简服务、开 zram（内存压缩交换）、
  学习以本地应用为主、按需开服务。
- 更稳的路线：先跑轻量档（现成终端系统 + 本地应用 + 播放轮播），
  屏幕、支架、电源先买（升级不浪费），不够用再升新板子，
  旧板子退为纯播放屏。
- 3B 可设 OTP（One-Time Programmable，一次性可编程）熔丝位开
  USB 启动，系统盘可用 USB 固态盘。

### 系统对比：Stretch 与 Trixie

- 同宗同源：Raspbian 是树莓派基金会早期官方系统名（Debian 针对
  Pi 重新编译优化的版本），2020 年改叫 Raspberry Pi OS。
- Stretch：Debian 9（2017 年），官方更新 2020 年停止，软件源已归档；
  自带 Python 3.5、老版本 Chromium；Kolibri、GCompris 新版装不上。
- Trixie：Debian 13（2025 年），持续更新，安全更新到 2028 年、
  长期支持到 2030 年；自带 Python 3.13、现代 Chromium、内核 6.12；
  新软件直接安装。
- Trixie 在 Pi 4/5 上默认 labwc Wayland（新一代显示协议），
  但 Pi 3B 上默认仍是 X11（老牌显示系统）+ RealVNC，
  与旧系统用法一致。
- Trixie 也没有默认用户（Stretch 是 pi / raspberry），写卡时必须自建用户。
- 32 位与 64 位：Stretch 只有 32 位；Trixie 有 64 位版，
  但 3B 只有 1GB 内存，32 位版更合适。
- Kolibri 注意：Trixie 上须用官方给 Debian 13 单独准备的安装源，
  不能照搬 Debian 12 的旧命令。

### 写卡步骤：Trixie 32-bit Full

1. 在电脑上装官方写卡工具 Raspberry Pi Imager。
2. 另买一张新卡（16GB 起步，32GB 更宽裕），不要覆盖旧卡。
3. Imager 里选设备型号 → 系统选 Trixie 32-bit Full 版；
   当前写卡工具（Imager 2.0.12）里，Trixie 32 位带桌面的就是
   Full 版，Lite 是无桌面版；Bookworm 已归到 Legacy 组里。
   或从官网操作系统页直接下载 Trixie 的 `.img.xz` 再用
   Imager 的 Use custom（使用自定义镜像）选取。
4. 写卡设置一次填好：主机名、新建用户名和密码、WiFi 名称密码、
   国家选 CN、启用 SSH，并可直接粘贴 SSH 公钥。
5. 写完插卡上电；进系统先跑一遍更新补丁：

```bash
sudo apt update && sudo apt full-upgrade
```

6. VNC（Virtual Network Computing，虚拟网络计算，远程桌面协议）
   在 raspi-config（Interfacing → VNC）里开启。

### 远程接入：SSH 密钥

- 前提：电脑和 Pi 在同一局域网；Pi 的 SSH（22 端口）与 VNC（5900 端口）
  均已开启。
- 密钥接入：把自己的公钥追加进 Pi 上 `~/.ssh/authorized_keys`
  （每行一把钥匙，行尾标记用于区分归属）：

```bash
mkdir -p ~/.ssh && echo '<你的公钥>' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
```

- 此后凭私钥直连，不用密码；公钥本身不是秘密，私钥只留自己手里。
- 写卡时在 Imager 的 SSH 设置里粘贴公钥，效果相同，卡一插上就能连。
- VNC 只能看屏幕；装软件、改配置走 SSH 更方便。

### 双卡并行

- 树莓派只有一个存储卡槽，不能同时插两张系统卡。
- 双卡并行 = 两张卡、两个互不干扰的系统，随换随用：
  旧卡收好当“后悔药”，新卡做开发。
- 切换：关机 → 换卡 → 开机，约一分钟。
- 换卡前必须先关机（`sudo shutdown -h now` 或点桌面关机），
  带电拔插存储卡可能损坏文件系统。
- 两张卡贴标签，别拿混；新系统玩坏了，旧卡一插就恢复。

### 收回远程权限

- 查看：`cat ~/.ssh/authorized_keys`，每行一把钥匙，
  按行尾标记认出要删的那行。
- 只删一行：

```bash
sed -i '/<行尾标记>/d' ~/.ssh/authorized_keys
```

  也可以用 `nano ~/.ssh/authorized_keys` 手动删行（Ctrl+O 保存、
  Ctrl+X 退出）。
- 再看一眼确认：`cat ~/.ssh/authorized_keys`。
- 生效：删完对新登录立即生效；已建立的会话保持到断开，
  断开后无法再登录。
- 核查登录记录（可能需要 sudo）：

```bash
grep 'Accepted publickey' /var/log/auth.log
```

## 适用前提

- 设备：树莓派（本组卡片以 Pi 3B 为例）；屏幕、电源、存储卡另购。
- 网络：远程接入与写卡设置均假设电脑与 Pi 在同一局域网。
- 内容中的“旧系统 / 新系统”指 Stretch 与 Trixie 两代官方系统。

## 排错方法

- SSH 不通：先确认电脑与 Pi 在同一网段、Pi 的 22 端口通、
  SSH 服务已开启；再查用户名与密钥是否对应。
- 写卡后进不去：Trixie 没有默认用户，检查写卡时是否建好了用户。
- 触屏点不准：优先确认是免驱 HID（Human Interface Device，
  人机接口设备）型号；偏移可用系统自带的触屏校准处理。
- 莫名重启：先换官方电源排查供电。
- 存储卡损坏：24 小时开机场景改用 USB 固态盘。
- 浏览器打不开现代页面：老系统自带浏览器版本过旧，换新系统卡。

## 参考资料

- Raspberry Pi 官方写卡工具与操作系统下载：raspberrypi.com/software
- Raspberry Pi OS 官方文档：raspberrypi.com/documentation
- Kolibri（开源离线学习平台）：learningequality.org
- GCompris（儿童益智套件）：gcompris.net
- Porteus Kiosk、FullPageOS、Anthias（终端系统与数字标牌）官网

## 生成方式

- 卡片为确定性本地排版：HTML 模板 + 无界面 Chromium 截图，
  画布 1080 × 1440（3:4 竖版），浅色背景、高对比标题、圆角信息块。
- 全程未调用生成式图片工具，因此按项目规则不创建 PROMPTS.md；
  制作脚本见工作区备份（不在本目录内）。
- Shorts 视频由项目自带的 card-video-generator 生成，
  规格：9:16、1080 × 1920、H.264、30 fps、yuv420p、BT.709、无音轨，
  每张卡 4 秒。

## 检查结果

- 9 张卡逐张目视检查：文字与文案一致，无错字、无溢出、无裁切，
  风格统一（浅色背景、绿色标签、黄色结论条）。
- 脱敏检查：卡片与本文档均不含真实局域网地址、密钥、本地绝对路径、
  账号、口令；需要表达连接关系时统一使用占位符
  （如 `<你的公钥>`、`<行尾标记>`）。
- Content.md 与 9 张卡逐项对应；一级标题 9 字，正文 277 字，
  均在项目限制内（一级标题 ≤ 20 字，正文 ≤ 500 字）。

## 仍需人工确认的风险

- 硬件价格、型号供货以购买时为准；触屏型号的兼容性以实测为准。
- Imager 中的系统菜单位置可能随工具版本变化，
  以实际界面为准。
- Pi 3B 的性能结论基于 1GB 内存机型；不同板子结论不同。
- 本组卡片不含真实环境信息，照着做之前请按自家设备核对一遍。
