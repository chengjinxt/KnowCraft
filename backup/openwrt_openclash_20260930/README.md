# RAX3000M OpenClash TUN 与小闪存恢复包

这套恢复包用于当前设备：`CMCC RAX3000M (NAND version)`、OpenWrt `25.12.0-rc2`、OpenClash `v0.47.156`。它保存了本次故障的知识说明、安全配置快照和一键恢复脚本。

当前有效目标配置是：

```text
enable=1
operation_mode=fake-ip
en_mode=fake-ip-tun
stack_type=system
small_flash_memory=1
enable_custom_clash_rules=1
```

恢复脚本只强制设置这些运行参数，并幂等合并以下三条置顶直连规则；不会默认覆盖订阅、节点、DNS、认证信息或其他已有自定义规则：

```yaml
- DOMAIN,www.5k40.com,DIRECT
- DOMAIN,555kp40.com,DIRECT
- DOMAIN,www.555dyx9.com,DIRECT
```

目录中的 `openclash.config` 是包含私密信息的完整本机备份，已由 `.gitignore` 排除，禁止提交到 GitHub 或发给他人。

## 一、`en_mode` 有哪些值

`en_mode` 是 OpenClash 的组合运行模式：前半部分决定 DNS 映射方法，后半部分决定流量怎样进入 Mihomo。

| 值 | 白话说明 | 技术含义 |
| --- | --- | --- |
| `fake-ip` | Fake-IP + 增强 | DNS 返回保留地址段中的 Fake IP；TCP 主要走 Redirect，UDP 主要走 TProxy。 |
| `fake-ip-tun` | Fake-IP + TUN | Fake-IP DNS；TCP、UDP 进入 `TUN (Network TUNnel，三层虚拟网卡)`。本机当前使用。 |
| `fake-ip-mix` | Fake-IP + 混合 | Fake-IP DNS；TCP 走转发规则，UDP 走 TUN。 |
| `redir-host` | Redir-Host + 增强 | DNS 返回真实 IP；TCP 主要走 Redirect，UDP 主要走 TProxy。 |
| `redir-host-tun` | Redir-Host + TUN | 真实 IP DNS；TCP、UDP 进入 TUN。 |
| `redir-host-mix` | Redir-Host + 混合 | 真实 IP DNS；TCP 走转发规则，UDP 走 TUN。 |

“增强 / TUN / 混合”按钮并不是无中断热切换。OpenClash 会重写运行配置并重启核心；重启所需文件无法写入时，界面可能已经变色，但核心实际启动失败。

`operation_mode` 保存基础 DNS 模式，常见值是 `fake-ip` 或 `redir-host`。界面把它与按钮后缀 `""`、`-tun`、`-mix` 组合成 `en_mode`。

## 二、`stack_type` 有哪些值

当前 OpenClash `v0.47.156` 界面提供三种 TUN 协议栈：

| 值 | 含义 | 适用特点 |
| --- | --- | --- |
| `system` | System Stack（系统协议栈） | 使用 Linux 内核网络栈，资源占用较低、行为稳定。本机已验证可用。 |
| `gvisor` | gVisor Stack（用户态协议栈） | 在用户态实现网络协议栈，隔离性更强，部分特殊网络兼容性更好，但通常占用更多 CPU 和内存。 |
| `mixed` | Mixed Stack（混合协议栈） | TCP 使用 `system`，UDP 使用 `gvisor`，用于折中兼容性和性能。 |

Mihomo 的其他版本可能还支持 `mips`，但当前 OpenClash 界面没有暴露该值，不应直接写入本机配置。

注意：`fake-ip-mix` 的“混合运行模式”和 `stack_type=mixed` 的“混合协议栈”是两个层次。前者决定哪些流量进入 TUN，后者决定已经进入 TUN 的数据由哪套 TCP/IP 栈处理。

## 三、`/overlay` 是什么

OpenWrt 的根目录 `/` 由两层合并而成：

- `/rom`：`SquashFS` 只读系统层，存放固件自带文件。
- `/overlay`：持久化可写层，保存安装的软件包、配置、下载数据库以及对 `/rom` 文件的修改。
- `/tmp`：`tmpfs` 内存文件系统，速度快、空间来自 RAM，重启后清空。

本机实际硬件与分区：

| 项目 | 容量 |
| --- | ---: |
| NAND 闪存 | 128 MiB 级别 |
| RAM | 512 MiB，系统可见约 478 MiB |
| UBI 可用逻辑空间 | 约 110.4 MiB |
| `kernel` UBI 卷 | 约 5.8 MiB |
| `rootfs` 只读卷 | 约 69.3 MiB |
| `rootfs_data` 原始卷 | 约 32.4 MiB |
| UBIFS 格式化后的 `/overlay` | 约 28.11 MiB |

`32.4 MiB` 变成约 `28.11 MiB`，差额用于 UBIFS 元数据、坏块预留和垃圾回收空间。因此 LuCI 显示的 `28.11 MiB` 只是可写层，不是整块 NAND，也不是内存。

### 为什么会写满

故障现场中，下列文件都位于可写层：

- OpenClash Web UI 约 `15.5 MiB`（未压缩统计）。
- Mihomo Meta 核心约 `10.3 MiB`。
- `GeoSite.dat` 约 `10 MiB`。
- `ASN.mmdb` 约 `12 MiB`。
- 规则集、配置、其他插件还会继续占空间。

UBIFS 会压缩数据，所以这些 `du` 数字不能直接相加，但它们足以把只有 `28.11 MiB` 的 `/overlay` 填满。空间为 0 后，UCI 配置提交、规则更新、数据库下载和 OpenClash 重启都可能失败。

### 大小能不能改

能改，但不能在当前已挂载的系统中安全地把 `28.11 MiB` 随手调大。可选方案是：

1. 使用更精简的固件，让只读 `rootfs` 更小，从同一 NAND 中给 `rootfs_data` 留出更多空间。
2. 自定义固件，把常用包压进 SquashFS；通常比安装到 `/overlay` 更节省空间。
3. 使用 `Extroot（外置根文件系统）` 把 `/overlay` 扩展到 USB 存储，但设备必须有可用的外置存储接口。
4. 修改 UBI/分区布局或刷写不同布局的固件。该方法可能导致设备无法启动，只应配合该型号的可靠救砖方案进行。

本次采用“小闪存模式”，无需改分区。

## 四、`GeoSite.dat` 与 `ASN.mmdb`

### `GeoSite.dat`

白话上，它是按用途或地区整理的域名分类库。

Mihomo 的 `GEOSITE` 规则和 DNS `nameserver-policy` 可以查询其中的 `cn`、`geolocation-!cn` 等集合，决定域名直连、代理或使用哪组 DNS。当前日志明确加载了 `cn` 和 `geolocation-!cn`。

### `ASN.mmdb`

`ASN (Autonomous System Number，自治系统号)` 用来标识一个运营商或大型网络。`ASN.mmdb` 把 IP 地址映射到 ASN，供 `IP-ASN` 和 `SRC-IP-ASN` 规则判断目标或来源属于哪个网络。

当前规则包含 `IP-ASN` 条件，因此这个文件不是“无用文件”。把它链接到 `/dev/null` 会被 Mihomo 判定为无效，随后核心仍会重新下载。

### 为什么这次会重新下载

1. `/overlay` 写满时，`GeoSite.dat` 只下载了一部分，启动日志报 `no space left on device`。
2. 旧 `ASN.mmdb` 也不完整，Mihomo 报 `ASN invalid, remove and download`。
3. 配置仍然引用 `GEOSITE` 和 `IP-ASN`，核心缺少有效数据库时会按照 `geox-url` 自动下载。
4. 仅关闭 OpenClash 的定时更新不能阻止核心为满足当前规则而补齐必需文件。

## 五、什么是“小闪存模式”

OpenClash 原生的 `small_flash_memory=1` 会把核心、缓存和 GEO 数据优先放到 `/tmp/etc/openclash`，再从 `/etc/openclash` 建立符号链接。原生设计能最大限度节省闪存，但路由器重启后 `/tmp` 会被清空，核心和数据库都可能需要重新下载；启动时 WAN 或下载源不可用就会影响 OpenClash 启动。

本机采用经过实测的“持久核心 + 临时数据库”方案：

- Mihomo 核心固定保存在 `/etc/openclash/core/clash_meta`，重启后无需重新下载。
- `GeoSite.dat`、`ASN.mmdb` 和 `cache.db` 使用 `/tmp/etc/openclash`。
- 启动脚本、LuCI 核心检测和核心更新脚本统一指向持久核心，避免各自检查不同路径。

优点是把十几到几十 MiB 的数据库从 NAND 可写层移到 RAM，减少写满和闪存磨损。最终幂等恢复后，`/overlay` 从 100% 降到约 80%，剩余约 `5.3 MiB`；`/tmp` 使用约 `24 MiB`，对 478 MiB 可用内存影响可接受。百分比会随日志、缓存和插件更新小幅变化。

代价是 `/tmp` 重启后清空，OpenClash 仍需要重新生成或下载 GEO 数据。核心可以立即从 `/etc` 启动，但引用 GEO 数据的规则要等数据库恢复后才能完整加载。

## 六、为什么防火墙规则会影响 TUN

白话上，“允许通过”和“送进代理”是两件事。这里的防火墙不只是负责拒绝连接，它还是 OpenClash 接管流量的入口。

OpenWrt 使用 `nftables（Linux 内核数据包过滤与转发框架）`。这个框架既能写 `DROP / REJECT（丢弃 / 拒绝）` 规则，也能做下面这些并不属于“拦截”的工作：

- `NAT (Network Address Translation，网络地址转换)`：让 LAN 设备共享 WAN 地址上网。
- `mangle（数据包标记和改写阶段）`：给需要代理的数据包打标记。
- `PBR (Policy-Based Routing，策略路由)`：根据标记把数据包送到 `utun`，而不是沿普通 WAN 路由发出。
- `Redirect / TProxy（重定向 / 透明代理）`：在增强或混合模式下把流量交给 Mihomo 的监听端口。
- 绕过规则：让局域网、路由器管理地址和明确指定的直连目标不进入代理。

本机使用 `fake-ip-tun` 时，一次典型的客户端访问路径是：

```text
电脑请求 www.google.com
  → OpenClash DNS 返回 198.18.0.0/16 中的 Fake IP
  → 数据包从 LAN 进入 OpenWrt
  → OpenClash 的 nftables 规则匹配并标记数据包
  → 策略路由把数据包送入 utun
  → Mihomo 根据 Fake IP 找回原域名并选择代理节点
  → 代理服务器代为连接真实 Google 地址
```

如果 `openclash_mangle` 等 OpenClash 规则没有创建，默认 `ACCEPT（允许）` 只表示继续走普通路由，并不会自动把数据交给 Mihomo。`198.18.0.0/16` 是 Fake-IP 映射使用的保留地址，并不是 Google 的真实公网地址；它直接从 WAN 发出时没有可用的目标服务器，所以表现为超时、连接重置或 TLS 握手失败。

因此，“没有 OpenClash 防火墙规则”不会让代理访问更畅通，只会让需要代理的流量绕过代理入口。进一步关闭整个 OpenWrt 防火墙还可能同时失去 LAN 到 WAN 的区域转发和源地址伪装，普通上网也可能中断。

判断 TUN 是否真正就绪，至少需要同时满足：

1. Mihomo 核心进程存在。
2. `utun` 网卡存在且状态为 `UP`。
3. OpenClash 的 nftables 链已经安装；本机以 `openclash_mangle` 为就绪标志。
4. 国内与境外 HTTPS 请求能够连续成功。
5. 从 LAN 电脑再访问一次目标网站，确认客户端流量也被正确接管。

仅看到核心进程或 `utun`，不能证明防火墙挂载、策略路由、DNS 映射和节点连接都已经完成。

## 七、本次故障、卡点与最终修复

### 第一阶段：存储空间写满，模式无法切换

```text
点击增强/TUN
  → OpenClash 重写配置并重启
  → GeoSite.dat / ASN.mmdb 需要写入
  → /overlay 100%
  → 下载只得到残缺文件，配置提交或核心启动失败
  → 页面按钮看起来已切换，实际运行状态没有完整生效
```

处理方法是删除确认不完整的数据库文件，设置 `fake-ip-tun`、`system`、`small_flash_memory=1`，再将有效 `GeoSite.dat` 和 `ASN.mmdb` 移到 `/tmp/etc/openclash` 并建立符号链接。经过下载、二次迁移和重启后，`/overlay` 从 100% 降至约 80%，剩余约 `5.3 MiB`。

### 第二阶段：首次恢复脚本过早判定成功

第一次实际执行幂等恢复时，脚本只等待 Mihomo 核心进程和 `utun` 网卡。OpenClash 的启动是分阶段完成的：核心和虚拟网卡先出现，防火墙规则稍后才安装。旧检查在这个时间窗口提前返回成功。

当时观察到的证据是：

- Mihomo 核心存在，`utun` 也为 `UP`。
- DNS 已经为 Google 返回 `198.18.0.0/16` 中的 Fake IP。
- `nft list ruleset` 中没有 `openclash_mangle` 链。
- Fake-IP 流量没有进入 TUN，Google 无法连接。
- 手工重启 OpenClash 后，`openclash_mangle` 出现，百度和 Google 恢复。

这不是“防火墙把 Google 拦了”，而是负责把 Google 流量送入代理的规则还没有就绪。

### 恢复脚本现在怎样避免再次发生

1. 最长等待 240 秒，同时检查核心进程、`utun` 和 `openclash_mangle`。
2. 数据库发生二次迁移和重启后，重新执行完整就绪检查。
3. 百度和 Google 的 HTTPS 检测各最多尝试 12 次，每次间隔 5 秒。
4. 每个网站必须连续成功两次，避免把启动瞬间的一次偶然成功当成正常。
5. 检查失败时恢复执行前的 UCI 配置和两个界面文件，再重启 OpenClash。
6. 最后从 Windows LAN 客户端复测，Google `generate_204` 返回 `HTTP 204`、百度返回 `HTTP 200`、路由器 Ping 丢包率为 0%。

启动过程中曾出现过 `curl: (35) Send failure: Broken pipe`。这是服务切换阶段已有连接被重置的瞬时现象；单次失败不能判定最终状态，所以脚本采用有上限的重试和“连续成功两次”条件。达到上限仍失败就执行回滚，不能无限重试掩盖真实故障。

### 第三阶段：LuCI 误报“还未安装内核”

2026-10-01 再次排查时，路由器已连续运行约 20 小时，并没有在夜间重启。现场同时满足：

- `/etc/openclash/core/clash_meta` 存在、可执行，大小约 `10.3 MiB`。
- `/etc/openclash/clash` 正确链接到该文件。
- Mihomo 进程、`utun` 和 `openclash_mangle` 都存在。
- `/tmp/etc/openclash/core/clash_meta` 不存在。

弹窗来自 LuCI 的 `check_core()`：只要 `small_flash_memory=1`，它就检查 `/tmp/etc/openclash/core/clash_meta`。旧现场修改过 `/etc/init.d/openclash`，让启动脚本继续使用 `/etc` 中的核心，却没有同步 LuCI 控制器和 `/usr/share/openclash/openclash_core.sh`。结果是核心实际正在运行，界面和更新器却认为核心应在 `/tmp`。

新恢复脚本通过 `patch-persistent-core.lua` 对三个文件做带标记、可重复执行的最小补丁，使启动、检测和更新都使用 `/etc/openclash/core/clash_meta`。补丁应用前会备份原文件，源码结构不匹配时直接失败并回滚。OpenClash 插件升级可能覆盖这些补丁，升级后应重新运行恢复脚本。

### 第四阶段：Google 实际不稳定来自单节点出口

同一次排查中，日志在约 27 分钟内记录了 `2913` 次以下错误：

```text
0815.aidddns.com:50012 connect error: EOF
0815.aidddns.com:50012 connect error: i/o timeout
```

当时的策略链是 `Google → GOOGO.US → [1.5x-IEPL]-美国 NO.1`。这三层使用 `Selector（手工选择器）`，手工节点故障时不会自动换到其他节点。配置中已有 `Fallback（故障转移）` 组，但 `GOOGO.US` 没有选择它。

排查时曾实测三个策略组访问 Google：手工出口约 `236 ms`，“自动选择”约 `2025 ms`，“故障转移”约 `82 ms`。该测试只能说明当时的瞬时状态，不能替代用户对出口地区和应用兼容性的要求。

最终按用户要求恢复并保留手工路径 `Google → GOOGO.US → [1.5x-IEPL]-美国 NO.1`，同时调用 OpenClash 历史保存脚本持久化选择。这样可以固定出口地区，避免自动切换到其他地区后影响特定应用；代价是该节点故障时不会自动换节点，Google 会直接不可用，需要人工选择另一个符合地区要求的节点。

### 第五阶段：ChromeOS Flex 显示 Wi-Fi 无互联网

设备 `192.168.100.122` 是安装 ChromeOS Flex 的华硕 K53SJ，使用 MAC `78:92:9c:0e:66:8a` 连接 `CMCC-1909`。路由器现场检查结果：

- DHCP 已分配 `192.168.100.122`，租约有效。
- 设备在 `phy0-ap0` 的 2.4 GHz SSID 上处于 `authenticated / associated / authorized` 状态。
- SSID 正确桥接到 `lan`，没有启用客户端隔离，也没有针对该 IP 或 MAC 的 OpenClash 访问控制。
- OpenClash 能看到该设备访问 `connectivitycheck.gstatic.com`、`www.google.com`、`android.clients.google.com` 和 `mtalk.google.com`，说明数据包已从 Wi-Fi 进入路由和代理链路。

ChromeOS 使用 Google 的 `generate_204` 地址判断网络是否真正在线。检测没有得到预期的 `HTTP 204` 时，系统会把已经连上 Wi-Fi 的网络标记为门户或“无互联网”。本次 `.122` 的检测和 Google 服务都走固定的美国节点；该节点端口超时后，ChromeOS 因而把 `CMCC-1909` 显示为无互联网。

这不是 `.122` 被防火墙单独拦截。同一故障分钟内，`.122` 有 8 次节点端口错误，`.238` 有 1 次，`.249` 有 14 次；下一分钟三个地址仍同时出现错误，而国内 `DIRECT` 流量继续成功。证据表明代理节点或其上游线路当时发生了全局故障。

无线链路还有一个次要问题：`.122` 的信号约 `-67 dBm`，发送重试和失败次数偏高；2.4 GHz 信道 1 的累计忙碌时间约占活动时间的 55%。这会放大延迟和丢包，但不足以解释多个有线/无线客户端在同一时段同时发生相同代理端口超时。

在保持手工地区出口的前提下，处理顺序是：

1. 节点恢复后，在 ChromeOS Flex 中关闭再开启 Wi-Fi，触发新的联网检测。
2. 打开“设置 → 关于 ChromeOS → 诊断 → 连接”，检查 Wi-Fi、DNS 和 Google Services。
3. 如果日志继续出现同一端口的 `EOF` 或 `i/o timeout`，人工选择另一个符合地区要求的节点；恢复脚本不会自动改动策略组。
4. 如果只有 `.122` 仍不稳定，再处理 2.4 GHz 信号和信道拥塞，例如靠近路由器、避开干扰源或在确认兼容后使用双频无线网卡。

设备关联后不响应路由器 Ping 不能单独证明断网；ChromeOS 的防火墙、省电状态或睡眠都可能不回应 ICMP。判断依据应以无线关联、DHCP、实际连接日志和 ChromeOS 诊断结果为主。

### 第六阶段：配置文件切换失败与订阅流量误读

2026-10-02 现场有两份配置：`8_218_244_182.yaml` 和 `s2_trojanflare_one.yaml`。上方的 `8_218_244_182.yaml` 在 `12:28`、`12:29` 均成功下载，并通过 Mihomo 配置校验；`12:30` 的核心启动日志也显示成功。因此它不是 YAML 语法损坏，也不是 TUN 或 Meta 核心不兼容。

真正失败的是订阅中的代理入口。使用临时独立 Mihomo 实例测试、且不切换现网配置时得到：

- `[1.5x-IEPL]-美国 NO.1` 连接 `0815.aidddns.com:50012` 超时，HTTP 代理测试返回 `502 Bad Gateway`。
- `[2x-IEPL]-日本 NO.1` 连接同一域名的 `50000` 端口也超时。
- 通过 Cloudflare `DoH (DNS over HTTPS，通过 HTTPS 查询 DNS)` 查询，`0815.aidddns.com` 当时公开解析为 `www.baidu.com`，已不是可用的代理服务器入口。

这说明订阅接口仍能返回一份格式正确的配置，但节点域名已经被供应商停用、停放或错误指向。节点协议在真正建立连接时才失败，所以“下载成功”和“配置检查成功”不能证明节点可用。

页面上的配置下拉框还有一个容易误解的交互：选中另一项只会切换页面上查看的配置和订阅信息；必须再点击右侧的双箭头“切换配置”按钮，控制器才会把 `openclash.config.config_path` 写入 UCI 并重启 OpenClash。列表刷新时，下拉框会重新显示 UCI 中实际生效的配置，因此只改下拉框时看起来像“自动切回”。

如果已经点击切换按钮，本次日志仍没有出现健康检查失败后自动回滚：上方配置在 `12:30` 启动成功，`12:31` 又发生了一次 `/etc/config/openclash` 写入并重启，最终路径才变回 `s2_trojanflare_one.yaml`。当前代码只会在所选配置文件不存在时另选一个文件；节点端口超时不会自动切换配置文件。

截图中的 `92.1 GB / 100.0 GB (92.1%)` 是**剩余流量**，不是已用流量。OpenClash 后端计算的是 `(total - used) / total`，并把 `surplus` 交给页面显示；页面局部变量仍命名为 `used`，容易造成反向理解。订阅服务器当时返回：

| 项目 | 字节值 | 约合 |
| --- | ---: | ---: |
| 下载 | `6,583,447,210` | `6.13 GiB` |
| 上传 | `1,873,051,327` | `1.74 GiB` |
| 实际已用 | `8,456,498,537` | `7.88 GiB` |
| 套餐总量 | `107,374,182,400` | `100 GiB` |
| 实际剩余 | `98,917,683,863` | `92.12 GiB` |

当前 `s2_trojanflare_one.yaml` 运行配置包含 `GEOIP,CN,DIRECT`，最终规则为 `MATCH,Proxy`。国内 IP 和明确列出的国内域名通常直连；其余未匹配流量都会进入代理，并由订阅同时统计上传和下载。同一订阅如果还在其他设备或客户端使用，也会合并到服务端总量中。

现场还发现了一项可能造成突发消耗的客户端流量：`192.168.100.249` 就是执行排查的 Windows 电脑，Mihomo 连接快照中一条到 `daily-cloudcode-pa.googleapis.com` 的连接已上传约 `90.5 MiB`。根据本机源端口反查，进程是 Antigravity `2.19.1` 的：

```text
C:\Users\Administrator\AppData\Local\Programs\Antigravity\resources\bin\language_server.exe
```

该连接结束后的 10 秒复测只增加约 `0.019 MiB`，说明现场表现为突发上传，不是每秒持续增长。GoogleCloudPlatform 的 Cloud Code VS Code 官方仓库中已有用户报告同一进程向同一域名异常上传大量数据，并给出限制工作区搜索文件数、关闭常驻语言服务器的临时规避参数。该报告不是厂商正式公告，而且报告版本与本机 `2.19.1` 不同，不能直接认定为同一缺陷；但域名、进程和流量方向一致，值得持续监控。

如果后续再次快速增长，可以先退出 Antigravity，观察订阅已用量是否停止上升；确认相关后，再在 Antigravity 的 `settings.json` 中测试以下临时设置：

```json
{
  "antigravity.searchMaxWorkspaceFileCount": 100,
  "antigravity.persistentLanguageServer": false
}
```

应用前应备份原设置，应用后重新启动 Antigravity，并用 OpenClash 活动连接或进程流量工具复测。不能仅凭绿色进度条判断是否异常消耗。

### 本次遇到的相关卡点

| 卡点或现象 | 直接原因 | 处理与防复发措施 |
| --- | --- | --- |
| 增强/TUN 按钮无法稳定切换 | `/overlay` 写满，配置和数据库不能完整写入 | 启用小闪存模式，把大型 GEO 数据移到 `/tmp`，并检查可用空间。 |
| `GeoSite.dat` 重复下载 | 先前下载因空间不足而残缺，当前规则仍需要它 | 删除残件，让核心下载有效文件，再迁移到 `/tmp`。 |
| `ASN.mmdb` 报无效并重下 | 文件不完整；旧方案还曾建议链接到 `/dev/null` | 保留有效 ASN 数据，禁止使用 `/dev/null` 占位。 |
| 页面显示已切换但实际网络未就绪 | UI 配置值、核心进程、虚拟网卡和防火墙规则分阶段生效 | 同时检查 UCI、核心、`utun`、nftables 和 HTTPS。 |
| 核心和 `utun` 正常，但 Google 不通 | `openclash_mangle` 尚未安装，Fake-IP 流量无法进入 TUN | 等待 nftables 链；超时则回滚并查看 `/tmp/openclash.log`。 |
| 页面提示“还未安装内核”，但核心实际运行 | 小闪存模式下 LuCI 检查 `/tmp`，旧启动补丁却使用 `/etc` | 统一启动、LuCI 检测和核心更新器的路径，核心持久保存在 `/etc`。 |
| Google 间歇性打不开，日志大量 `EOF`/超时 | 手工节点当时发生服务端或线路异常 | 保持用户指定的手工路径；节点异常时明确报告，由用户人工选择同地区节点。恢复脚本不自动改变策略组。 |
| ChromeOS Flex 显示 `CMCC-1909` 无互联网 | Google `generate_204` 联网检测也走故障节点，没有得到预期的 `204` | 节点恢复后重连 Wi-Fi；持续失败时人工选择同地区节点，并用 ChromeOS 诊断确认。 |
| `.122` 无线重试/失败偏高 | 2.4 GHz 信号约 `-67 dBm`，信道 1 忙碌度约 55% | 作为次要问题优化摆放、干扰和无线网卡，不把它误判为本次全局节点故障。 |
| `8_218_244_182.yaml` 能下载、能校验，但切换后不能上网 | 节点共同依赖的 `0815.aidddns.com` 已解析到百度，多个代理端口超时 | 等供应商恢复入口或更换订阅；配置校验通过后仍要实际测试节点连通性。 |
| 下拉框选中上方配置后又显示原配置 | 下拉框只改变页面查看对象，刷新会重新显示 UCI 中的活动配置 | 需要点击旁边的双箭头切换按钮，并通过 `uci get openclash.config.config_path` 核对。 |
| 流量条显示 `92.1 / 100 GB`，误以为两天用了 92% | 当前单订阅卡显示的是 `surplus（剩余量）` 和剩余百分比 | 实际已用约 `7.88 GiB`；核对订阅响应中的上传、下载和总量。 |
| 订阅流量仍出现突发增长 | Windows 上的 Antigravity `language_server.exe` 曾单连接上传约 `90.5 MiB` | 先退出 Antigravity 做对照，持续复现时限制搜索文件数、关闭常驻语言服务器并继续监控。 |
| 启动初期 HTTPS 偶发 `Broken pipe` | OpenClash 重启时旧连接被关闭，新链路仍在收敛 | 有上限重试，并要求连续两次成功。 |
| 路由器自身测试成功，但客户端仍可能异常 | 路由器本机流量和 LAN 转发流量经过的 hook/链路不完全相同 | 恢复后同时从一台 LAN 电脑测试 Google、百度和路由器连通性。 |
| 重启后 `/tmp` 数据消失 | `/tmp` 是 RAM 文件系统 | 让 OpenClash 在 WAN 恢复后重新下载/生成，并再次确认数据库链接有效。 |
| 直接覆盖旧 `openclash.init` | 旧快照只改了启动路径，没有同步 LuCI 和更新器 | 不复制旧快照；使用结构校验后的最小补丁同步三个组件，并在失败时回滚。 |
| 默认恢复完整配置风险较大 | 完整配置含订阅、认证和设备相关内容 | 默认只写六个运行参数；只有显式使用 `-RestorePrivateConfig` 才恢复私密配置。 |

### 现场快速诊断

在路由器 SSH 中依次检查：

```sh
uci -q get openclash.config.en_mode
uci -q get openclash.config.stack_type
uci -q get openclash.config.small_flash_memory
ps w | grep '[c]lash -d /etc/openclash'
ip addr show utun
nft list ruleset | grep -n 'chain openclash_mangle'
df -h /overlay /tmp
ls -l /etc/openclash/GeoSite.dat /etc/openclash/ASN.mmdb
tail -n 80 /tmp/openclash.log
```

结果应分别能看到 `fake-ip-tun`、`system`、`1`、Mihomo 进程、状态为 `UP` 的 `utun`、`openclash_mangle` 链、非零的 `/overlay` 可用空间，以及两个指向 `/tmp/etc/openclash` 的数据库链接。

在 Windows LAN 客户端检查实际上网链路：

```powershell
ping.exe -n 2 192.168.100.1
curl.exe -L -sS -o NUL -w "Google HTTP %{http_code}`n" --connect-timeout 10 --max-time 25 https://www.google.com/generate_204
curl.exe -L -sS -o NUL -w "Baidu HTTP %{http_code}`n" --connect-timeout 10 --max-time 25 https://www.baidu.com/
```

本次最终结果是路由器 Ping 无丢包、Google 返回 `204`、百度返回 `200`。如果路由器 SSH 中的 HTTPS 正常而 Windows 客户端失败，应继续检查 LAN 流量对应的 nftables hook、客户端 DNS 缓存、Windows 系统代理和浏览器扩展；不能只依据路由器本机请求认定客户端链路正常。

## 八、参考文档中的界面修复点

参考来源：`D:\gitea\ProjectKnowledgeBase\硬件设置组建\家庭组网\界面修复一键恢复.md`。

原文混有另一工具的执行日志和伪装成系统消息的内容，本恢复包只保留经过源码核对的技术点：

| 原修复点 | 核对结论 | 新恢复方式 |
| --- | --- | --- |
| `run_mode` 空值导致增强模式接口异常 | 成立。上游 `v0.47.156` 直接拼接表单值。 | 只把该行补成 `HTTP.formvalue("run_mode") or ""`，不替换整个控制器。 |
| 状态文字“保存中/正在启动”被截断 | 属于界面补丁，可安全保留。 | 按标记插入最小 CSS，重复执行不会重复插入。 |
| 修改 `/etc/init.d/openclash` 固定 Meta 核心软链 | 单独修改会造成启动脚本、LuCI 检测和核心更新器路径不一致，已实测触发“未安装内核”假警报。 | 不复制旧文件；对三个组件应用带结构校验的最小补丁，统一使用持久核心。 |
| 禁止下载 `ASN.mmdb` 并链接 `/dev/null` | 不适用于当前规则；会触发核心判定无效并重新下载。 | 保留有效 ASN 数据，将其迁入 `/tmp`。 |

目录中的 `openclash.lua`、`status.htm`、`openclash.init`、`openclash_geo.sh` 是当时路由器的完整源码快照，供对比和人工回溯。新 `restore.ps1` 不会把这些旧快照整文件复制回路由器；它只使用独立补丁器修改已核对的语句。

## 九、一键恢复

### 前置条件

1. 电脑连接到 OpenWrt LAN/Wi-Fi，能访问 `192.168.100.1`。
2. 路由器已安装 OpenClash 和 Meta 核心。
3. Windows 已安装 `OpenSSH Client`，可以使用 `ssh` 和 `scp`。
4. 恢复脚本不会安装插件；它恢复的是本次参数、数据库布局和两个最小界面补丁。

### 恢复本次调整

在 PowerShell 中执行：

```powershell
cd E:\PerSourceCodeStore\github\chengjinxt\KnowCraft\backup\openwrt_openclash_20260930
.\restore.ps1
```

脚本会上传临时恢复程序、在路由器的 `/root/openclash-tun-recovery-backups/<时间>/` 备份修改前文件、设置 TUN 和小闪存模式、迁移数据库、重启并验证。SSH/SCP 可能分别提示输入密码。

恢复脚本不会修改 `GOOGO.US`、Google、OpenAI、`Proxy` 等策略组的当前选择，避免出口地区发生变化。它会保留 `/etc/openclash/custom/openclash_custom_rules.list` 中的已有内容，把三个必要的 `DIRECT（直连）` 域名规则放到规则列表顶部，并启用 `enable_custom_clash_rules=1`；重复执行不会产生重复规则。

### 同时恢复包含订阅的完整私密配置

只有确认目标仍是这台路由器、OpenClash 版本兼容时才使用：

```powershell
.\restore.ps1 -RestorePrivateConfig
```

### 跳过界面补丁

```powershell
.\restore.ps1 -SkipUiFixes
```

### 验证结果

脚本必须同时通过以下检查才返回成功；任一项失败会恢复修改前的配置与界面文件，并重新启动 OpenClash：

- `uci` 中模式值正确。
- Clash 核心进程存在。
- `utun` 网卡存在且为 `UP`。
- nftables 中已经出现 `openclash_mangle` 防火墙链。
- `/overlay` 仍有可用空间。
- `GeoSite.dat`、`ASN.mmdb` 指向 `/tmp/etc/openclash`。
- 启动脚本、LuCI 控制器和核心更新器都带有持久核心兼容补丁。
- 自定义规则覆写已启用，三个直连域名在生成配置中各出现一次，并且位于最终 `MATCH` 规则之前。
- 路由器自身访问百度和 Google 的 HTTPS 请求均成功。

## 十、恢复包文件

| 文件 | 用途 |
| --- | --- |
| `restore.ps1` | Windows 一键恢复入口。 |
| `router/restore-openclash-tun.sh` | 在路由器上执行配置、迁移、重启和验证。 |
| `router/patch-persistent-core.lua` | 幂等修正小闪存模式下三个组件的核心路径。 |
| `router/merge-custom-rules.awk` | 保留已有规则，幂等合并三个置顶直连域名规则。 |
| `router/status-width.patch.html` | 状态文字宽度的最小 CSS 补丁。 |
| `tests/test-merge-custom-rules.sh` | 验证规则合并顺序、唯一性、内容保留和幂等性。 |
| `openclash-tun-settings.uci.txt` | 不含订阅和密码的配置快照。 |
| `界面修复一键恢复-核对记录.md` | 对外部参考文档四个修复点的核对记录。 |
| `openclash.config` | 私密完整配置，仅本机保存，已忽略。 |
| `openclash.lua` 等四个源码文件 | 旧现场完整快照，不由新脚本自动覆盖。 |

## 十一、参考资料

- [Mihomo TUN 配置](https://wiki.metacubex.one/config/inbound/tun/)
- [Mihomo 路由规则](https://wiki.metacubex.one/config/rules/)
- [OpenClash `settings.lua`](https://github.com/vernesong/OpenClash/blob/master/luci-app-openclash/luasrc/model/cbi/openclash/settings.lua)
- [OpenClash 启动脚本](https://github.com/vernesong/OpenClash/blob/master/luci-app-openclash/root/etc/init.d/openclash)
- [OpenWrt 文件系统说明](https://openwrt.org/docs/techref/file_system)
- [OpenWrt Extroot](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration)
- [Chromium OS Network Portal Detection](https://chromium.googlesource.com/playground/chromium-org-site/+/master/chromium-os/chromiumos-design-docs/network-portal-detection/index.md)
- [Chromium 切换到 `connectivitycheck.gstatic.com` 的说明](https://chromium.googlesource.com/chromium/src/+/0307e728703a96f6c86b35e705937e85821cde0d)
- [Google Chromebook 诊断工具说明](https://support.google.com/chromebook/answer/10566784?hl=zh-Hans)
- [GoogleCloudPlatform Cloud Code VS Code：`language_server` 异常上传问题报告](https://github.com/GoogleCloudPlatform/cloud-code-vscode/issues/1214)
