# KnowCraft 项目协作规则

## 项目定位

- 本项目用于沉淀简单、准确、有吸引力的技术知识内容。
- 默认面向有基础电脑使用经验、但不熟悉底层术语的中文读者。
- 先讲结论和实际作用，再补充必要的技术边界；不要只堆定义。

## 禁用工具

- 本项目禁止调用 `richinfo-cr` 技能及 `richinfo-cr` CLI。即使修改源码、准备提交、推送或发起 PR，也不要触发；改用项目自带检查、测试、构建和常规人工审查流程。

## 技术知识的白话表达

- 缩写第一次出现时必须同时给出英文全称和中文解释，例如 `ACL (Access Control List，访问控制列表)`。
- 专有名词至少同时保留原文和中文，例如 `Full Control（完全控制）`、`Read Key（读取注册表项）`。
- 优先按“它是什么 → 管什么 → 为什么这样设计 → 容易误解什么”组织内容。
- 每个知识点先用一句白话说明，再补一条准确的技术解释；避免把白话写成不正确的绝对结论。
- 注册表路径、命令、API、权限名和错误码保持原文，并使用代码格式。
- 涉及版本差异、权限边界或安全结论时，优先核对 Microsoft Learn 等一手资料。

## 知识卡片与公众号贴图

- 用户要求“小红书卡片、公众号贴图、知识卡片、信息图”时，默认制作原创的中文社交媒体知识卡片，不复制平台标识、具体账号模板或他人作品。
- 位图卡片使用 `imagegen` 技能；默认采用 3:4 竖版、浅色背景、高对比标题、圆角信息块和少量图标。
- 一张卡只讲一个中心问题。系列内容优先采用：概念卡 → 对象对比卡 → 权限/机制卡 → 注意事项卡。
- 当内容从通用机制跳到某个具体系统时，增加一张转场卡，明确“通用规则 → 可保护对象 → 具体权限”的关系，避免读者误以为通用机制只属于当前示例。
- 卡片必须包含相关短语的中英文解释；英文大小写、缩写、反斜杠和注册表路径必须逐字检查。
- 如果用户提示词中存在明显的单词拼写错误或术语误写，制作卡片时直接使用核对后的正确写法，不在卡片正文中单独增加“纠错”模块或提示；只有当错误本身就是要讲解的知识点时，才说明错误写法与正确写法的区别。
- 正文以手机端一眼能读完为准，不使用密集段落和过小字号。重要结论可以使用一句短口号，但不能牺牲准确性。
- 生成后逐张检查信息归属。如果释义被排成独立对象、文字误写或视觉关系可能误导读者，应只针对该问题重做。
- 项目使用的最终图片保存到 `assets/YYYYMMDD_NN_<topic>-cards/`，其中 `YYYYMMDD` 是创建当天的本地日期，`NN` 是当天第几个知识点卡片文件夹，必须使用两位数字，不足两位前面补 `0`，例如 `assets/20260829_01_acl-cards/`。
- 创建目录前先扫描 `assets/YYYYMMDD_??_*`：当天没有目录时从 `01` 开始，否则使用现有最大序号加 `1`；目录内图片继续使用带两位顺序号的英文文件名。
- 不覆盖未确认替换的旧图片或旧目录；重命名目录后同步更新项目内引用和说明文档。
- 最终交付同时说明图片路径、生成方式、检查结果和仍需人工确认的技术风险。

## Windows 注册表 ACL 知识锚点

解释本项目中的 Windows 注册表权限内容时，以以下事实为基础：

- `ACL (Access Control List，访问控制列表)`：描述哪些安全主体可以或不可以对注册表项执行哪些操作。
- `ACE (Access Control Entry，访问控制条目)`：ACL 中针对某个用户或用户组的一条 `Allow` 或 `Deny` 规则。
- `Securable Object（可保护对象）`：能够拥有 `Security Descriptor（安全描述符）` 的 Windows 对象；ACL 是安全描述符中的访问控制组成部分。
- ACL 不是注册表专属机制。Windows 的文件与文件夹、注册表项、服务、打印机、网络共享、Active Directory 对象、进程和线程等都可以是可保护对象。
- 不同对象支持的具体权限不同：文件常见 `Read / Write / Modify`，注册表项常见 `ReadKey / SetValue / FullControl`，但核心结构都是“哪个身份可以对哪个对象执行哪些操作”。
- `HKCU (HKEY_CURRENT_USER，当前用户配置单元)`：保存当前登录用户的配置；它不代表所有子项都必然由当前用户完全控制。
- `Advanced`、`RunMRU`、`Policies\Explorer` 是三个 `Registry Key（注册表项）`，不是三个注册表值。它们各自显示的 `FullControl` 或 `ReadKey`，是 ACL 在具体注册表对象上的权限配置。
- `Registry Value（注册表值）` 是注册表项内部保存的数据，例如 `Hidden`、`MRUList` 或 `NoRun`；白话上可以理解为“Key 像文件夹，Value 像里面的数据，权限挂在 Key 上”。
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced`：Explorer 的高级设置和用户偏好，常见情况下需要当前用户可写。
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`：`MRU` 是 `Most Recently Used（最近使用）`，这里主要保存 `Win + R` 的运行历史，Explorer 需要更新它。
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer`：当前用户范围的 Explorer 策略位置；策略供应用读取并执行，权限可能由组策略、MDM、安全软件或人工加固控制。
- `Full Control（完全控制）`：通常包含查询和设置值、创建子项、枚举、通知以及删除和修改安全信息等权限。
- `Read Key（读取注册表项）`：通常包含查询值、枚举子项、变化通知和标准读取权限，不包含设置值、创建子项或删除权限。
- 注册表 ACL 不在单独文件中，而是保存在每个注册表项的 `Security Descriptor（安全描述符）` 中；通常讨论访问权限时，重点是其中的 `DACL (Discretionary Access Control List，自主访问控制列表)`。
- ACL 作用于注册表项，注册表值没有各自独立的 ACL；值的读写能力由所属注册表项的权限决定。
- 图形界面查看方法：运行 `regedit`，定位并右键目标注册表项，依次选择“权限”→“高级”，查看所有者、权限条目和继承状态。
- PowerShell 查看方法：先把目标路径保存到 `$key`，再读取 ACL，例如：

  ```powershell
  $key = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
  Get-Acl -LiteralPath $key | Format-List Owner, AccessToString, Sddl
  (Get-Acl -LiteralPath $key).Access |
      Format-Table IdentityReference, RegistryRights, AccessControlType, IsInherited
  ```

- 查看结果时重点解释 `IdentityReference（身份）`、`RegistryRights（注册表权限）`、`AccessControlType（Allow / Deny）` 和 `IsInherited（是否继承）`。
- 白话结论可以写成“偏好能改、历史能写、策略只读”，但必须注明这是当前观察到的有效权限边界，不是所有 Windows 设备的固定默认状态。
- 不能根据单独一条 ACE 直接断定最终有效权限。还要综合用户组、继承、显式规则、`Allow / Deny`、所有者以及进程访问令牌。
- `Policies` 路径本身不自动产生只读权限；发现 `ReadKey` 时，应继续检查 ACL 是否停止继承、是否存在显式条目，以及由哪个管理组件设置。

## 参考依据

- Microsoft Learn：`Registry Key Security and Access Rights`
- Microsoft Learn：`Checking the Registry for Policies and Preferences`
- Microsoft Learn：`Implementing Registry-based Policy`
- Microsoft Learn：`Access Control Overview`
- Microsoft Learn：`Securable Objects`
