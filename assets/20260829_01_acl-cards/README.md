# Windows 注册表 ACL 知识卡片

这组卡片面向初学者，用七张图解释 ACL、相关注册表项、权限差异、查看方法和其他适用对象。

1. `01-acl-basics.png`：`ACL (Access Control List，访问控制列表)` 的白话定义。
2. `02-registry-key-roles.png`：`Advanced`、`RunMRU` 和 `Policies\Explorer` 的职责。
3. `03-full-control-vs-read-key.png`：`Full Control（完全控制）` 与 `Read Key（读取注册表项）` 的区别。
4. `04-hkcu-acl-differences.png`：为什么同属 `HKCU` 的注册表项仍可拥有不同 ACL。
5. `05-where-and-how-to-view-acl.png`：ACL 保存在哪里，以及如何通过 `regedit` 和 PowerShell 查看。
6. `06-acl-to-registry-transition.png`：从通用 ACL 机制过渡到注册表对象，并区分注册表项与注册表值。
7. `07-acl-beyond-registry.png`：说明 ACL 不只用于注册表，还用于其他 Windows 可保护对象。

## 建议阅读顺序

文件序号按创建顺序保留。用于发布或连续阅读时，建议采用：

`01 → 06 → 07 → 02 → 03 → 04 → 05`

这样会先理解 ACL，再理解它为什么能应用到注册表，随后进入三个注册表项的具体权限。

## 核心结论

> 当前观察到的权限边界是：偏好能改、历史能写、策略只读。

这不是所有 Windows 设备的固定默认状态。判断最终有效权限时，还要综合继承、显式 ACE、用户组以及 `Allow / Deny`。

## 为什么从 ACL 讲到注册表

ACL 是 Windows 的通用权限机制，注册表项只是它可以保护的一类对象。完整关系是：

```text
ACL 通用规则
  → Securable Object（可保护对象）
  → Registry Key（注册表项）
  → Security Descriptor（安全描述符）
  → FullControl / ReadKey 等具体权限
```

`Advanced`、`RunMRU`、`Policies\Explorer` 是三个注册表项，不是三个注册表值。它们各自呈现的 `FullControl` 或 `ReadKey`，才是 ACL 在这些注册表对象上的具体配置。

可以把 `Registry Key（注册表项）` 理解成文件夹，把 `Registry Value（注册表值）` 理解成文件夹里的数据：键里保存值，权限挂在键上。

## ACL 还用在哪里

ACL 并非注册表专属。Windows 常见的可保护对象还包括：

- `Files & Folders（文件与文件夹）`
- `Services（系统服务）`
- `Printers & Shares（打印机与网络共享）`
- `Active Directory（目录对象）`
- `Processes & Threads（进程与线程）`

对象类型不同，支持的具体权限名称也不同，但规则骨架相同：谁可以对哪个对象执行哪些操作。

## ACL 在哪里

注册表 ACL 不是一个可以单独找到的文件。它保存在每个注册表项的 `Security Descriptor（安全描述符）` 中，实际访问控制主要由其中的 DACL 决定。

权限附着在注册表项上，不附着在单个注册表值上。例如 `Advanced` 项中的 `Hidden`、`HideFileExt` 等值，使用的是 `Advanced` 注册表项的权限。

## 怎么查看

图形界面：

1. 按 `Win + R`，输入 `regedit`。
2. 定位到目标注册表项。
3. 右键注册表项，选择“权限”。
4. 点击“高级”，查看所有者、权限条目和继承来源。

PowerShell：

```powershell
Push-Location HKCU:
(Get-Acl -LiteralPath '.\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer').Access |
    Format-Table IdentityReference, RegistryRights, AccessControlType, IsInherited
Pop-Location

```

重点查看：

- `IdentityReference（身份）`：这条规则属于哪个用户或用户组。
- `RegistryRights（注册表权限）`：允许或拒绝哪些具体操作。
- `AccessControlType（访问控制类型）`：这是 `Allow` 还是 `Deny`。
- `IsInherited（是否继承）`：规则来自父项还是直接写在当前项上。

一条 ACE 不等于最终有效权限；仍需结合用户组、继承以及其他 `Allow / Deny` 条目判断。

## 生成说明

- 生成方式：Codex 内置 `imagegen`
- 用例类型：`infographic-diagram`
- 版式：3:4 竖版中文知识卡片
- 视觉方向：浅色纸张背景、圆角信息块、高对比标题、扁平图标、无平台标识
- 文字约束：中英文术语逐字呈现，不增加无关文案；第二张在首轮出现信息归属歧义后已按“三个键、三个独立信息块”重做
- 目录命名：`20260829_01_acl-cards`，表示 2026-08-29 创建的第 1 个知识点卡片文件夹
- 后续补图：`06` 使用“通用机制 → 可保护对象 → 注册表项 → 具体权限”流程；`07` 使用 Windows 可保护对象示例网格
