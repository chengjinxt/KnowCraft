#  

很多人第一次接触 Windows 权限时，会被 **ACL、Security Descriptor、Full Control、Read Key、HKCU** 这些概念绕晕。

其实 ACL 可以简单理解为一张**“权限规则清单”**：

> **谁（Who） → 对什么资源（Resource） → 可以做什么操作（Action）**

在 Windows 中，ACL 不只用于文件和文件夹，**注册表项、系统服务、打印机、进程等对象同样可以拥有访问控制权限。**

以注册表为例：

- **Advanced**：用户偏好相关配置
- **RunMRU**：运行历史记录
- **Policies\Explorer**：资源管理器相关策略

看起来都是注册表项，但它们的权限可能完全不同。
 有的拥有 **Full Control（完全控制）**，可以读取、写入、新建、删除；有的只有 **Read Key（读取）**，只能读取、枚举和监听变化，却不能修改内容。

而 **HKCU（HKEY_CURRENT_USER）** 之所以容易让人产生“明明都是当前用户，为什么权限还不一样？”的疑问，是因为**每一个注册表对象都有自己的 ACL**，不能简单地认为“属于当前用户 = 当前用户就拥有全部权限”。

**所以，理解 Windows 权限的关键不是死记 Full Control、Read Key，而是记住这条逻辑：**

> **ACL = 谁 → 对什么对象 → 拥有什么权限**

搞懂这一点，Windows 文件权限、注册表权限以及很多“为什么我明明是管理员却改不了”的问题，就会清晰很多。



把 **ACL 从“概念”落到 Windows 实际机制**上。

先纠正一个很关键的认识：

> **ACL 不是单独存在于某个 `ACL` 文件里的。**
>
> Windows 会把资源的**安全描述符（Security Descriptor）**与资源关联起来；其中的 **DACL** 里面保存一条条 **ACE**，也就是“哪个用户/组拥有什么权限”。文件、文件夹、注册表项等对象都可以有自己的安全描述符。([TECHCOMMUNITY.MICROSOFT.COM](https://techcommunity.microsoft.com/blog/askds/the-security-descriptor-definition-language-of-love-part-1/395202?utm_source=chatgpt.com))

下面我分别用 **注册表 HKCU** 和 **文件夹**举一个可以实际操作的例子。

------

# 一、先建立一个完整的模型

可以把 Windows 权限理解成：

```
资源
 │
 └── Security Descriptor（安全描述符）
       │
       ├── Owner（所有者）
       │
       ├── DACL（谁可以做什么）
       │     │
       │     ├── ACE：Administrator → Full Control
       │     ├── ACE：SYSTEM      → Full Control
       │     ├── ACE：Users       → Read
       │     └── ...
       │
       └── SACL（哪些访问行为需要审计）
```



所以：

**ACL 本质上是 Security Descriptor 中的访问控制信息。**

而 DACL 又可以理解为：

```
DACL
 ├── ACE 1：Administrator → Full Control
 ├── ACE 2：SYSTEM        → Full Control
 ├── ACE 3：Users         → Read
 └── ACE 4：某个用户      → Modify
```



Windows 每次访问资源时，就会根据这些 ACE 判断：

> 当前进程代表的用户/组，是否具有所请求的权限？

注册表的访问检查也是通过注册表项的 security descriptor 完成的。微软文档明确说明，可以通过 `RegGetKeySecurity`、`GetNamedSecurityInfo` 等 API 获取注册表项的安全描述符。([Microsoft Learn](https://learn.microsoft.com/th-th/windows/win32/SysInfo/registry-key-security-and-access-rights?utm_source=chatgpt.com))

------

# 二、以 HKCU 为例：ACL 到底在哪里？

例如我们拿这个注册表项做实验：

```
HKEY_CURRENT_USER
└── Software
    └── Microsoft
        └── Windows
            └── CurrentVersion
                └── Explorer
                    └── Advanced
```



也就是：

```
HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
```



你在 `regedit.exe` 中：

```
右键 Advanced
    ↓
权限
    ↓
高级
```



看到的：

```
主体              类型       基本权限
------------------------------------------------
SYSTEM             允许       完全控制
Administrator      允许       完全控制
你的用户           允许       完全控制
...
```



**这些内容就是这个注册表项 DACL 中的 ACE。**

微软也明确说明，注册表编辑器可以直接查看注册表项当前的访问权限。([Microsoft Learn](https://learn.microsoft.com/th-th/windows/win32/SysInfo/registry-key-security-and-access-rights?utm_source=chatgpt.com))

------

# 三、你可以直接用 PowerShell 看 ACL

这个非常推荐你自己测试。

打开 PowerShell：

```
Get-Acl "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" |
    Format-List
```



你会看到类似：

```
Path   : Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\...
Owner  : DESKTOP-XXXX\Administrator
Group  : ...
Access : ...
Sddl   : ...
```



其中最值得关注的是：

```
Owner
Access
Sddl
```



`Get-Acl` 不只是针对文件系统，它同时支持 **Registry Provider**，所以可以直接读取注册表项的安全描述符。([Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-acl?view=powershell-7.4&utm_source=chatgpt.com))

------

# 四、最有意思的是 SDDL

例如：

```
(Get-Acl "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced").Sddl
```



可能得到类似：

```
O:SYG:SYD:AI(A;CI;KA;;;SY)(A;CI;KA;;;BA)(A;CI;KA;;;BU)
```



这东西看起来非常吓人，但它实际上是一种**安全描述符文本表示法**。

例如：

```
O:SY
```



代表 Owner。

```
G:SY
```



代表 Group。

然后：

```
D:
```



开始描述 DACL。

例如：

```
(A;CI;KA;;;BA)
```



可以粗略理解成：

```
允许
某些继承属性
完全访问
Administrators
```



这里的：

```
BA
```



是 Windows 著名的 SID 缩写之一：

```
BA = Built-in Administrators
```



而：

```
SY
```



通常表示：

```
Local System
```



------

# 五、这里有一个特别容易搞错的地方

你说：

> 当前 Windows 登录的是系统管理员 Administrator 账号

这里要区分：

```
Administrator
```



和：

```
Administrators
```



它们不是一个东西。

例如：

```
Administrator
```



是一个具体用户账户。

而：

```
Administrators
```



是一个 Windows 本地组。

可以理解成：

```
Administrators
├── Administrator
├── 其他管理员账户
└── ...
```



所以一个资源可能出现：

```
Administrator → Full Control
```



也可能出现：

```
Administrators → Full Control
```



甚至：

```
SYSTEM → Full Control
Administrators → Full Control
Users → Read
```



------

# 六、那么 Administrator 为什么还会“没有权限”？

这是 Windows 权限体系里非常重要的一点。

**管理员 ≠ 所有资源天然 Full Control。**

例如：

```
Administrator
     │
     ├── 是 Administrators 成员
     │
     ├── 拥有管理员权限
     │
     └── 但是某个对象的 DACL 可能没有给 Administrators
         Full Control
```



而且还有：

```
Owner
DACL
UAC
Integrity Level
SYSTEM
TrustedInstaller
```



等多个因素。

因此你会遇到非常经典的情况：

> “我明明是管理员，为什么这个文件还是删不了？”

------

# 七、最典型的例子：TrustedInstaller

Windows 系统目录中有很多资源的 Owner 并不是：

```
Administrator
```



甚至也不是：

```
Administrators
```



而可能是：

```
NT SERVICE\TrustedInstaller
```



例如 Windows 的一些核心系统文件。

所以你可能看到：

```
C:\Windows\System32\某个文件
```



然后：

```
Administrator → Read & Execute
SYSTEM        → Full Control
TrustedInstaller → Full Control
```



这时候你虽然是管理员：

```
Administrator
```



但仍然可能无法直接修改/删除。

这就是为什么 Windows 有：

```
TrustedInstaller
```



这个特殊服务账户。

------

# 八、那么怎么让 Administrator 获得 Full Control？

这里我建议你**不要直接修改 System32、WinSxS 等系统目录做实验**。

自己创建一个实验目录最安全。

例如：

```
C:\ACLTest
```



然后：

```
mkdir C:\ACLTest
```



查看：

```
icacls C:\ACLTest
```



可能看到：

```
C:\ACLTest NT AUTHORITY\SYSTEM:(OI)(CI)(F)
            BUILTIN\Administrators:(OI)(CI)(F)
            BUILTIN\Users:(OI)(CI)(RX)
```



这里：

```
(F)
```



就是：

```
Full Control
```



微软的 `icacls` 就是 Windows 官方用于显示和修改文件/目录 DACL 的工具。([Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/icacls?utm_source=chatgpt.com))

------

# 九、给 Administrator Full Control

管理员 PowerShell：

```
icacls C:\ACLTest /grant Administrator:F
```



然后：

```
icacls C:\ACLTest
```



你就应该能够看到：

```
Administrator:(F)
```



这里：

```
/F
```



准确写法是：

```
:F
```



表示：

```
Full access
```



微软 `icacls` 文档定义的简单权限包括：

```
F  Full access
M  Modify
RX Read & execute
R  Read-only
W  Write-only
D  Delete
```



([Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/icacls?utm_source=chatgpt.com))

------

# 十、如果连权限都改不了怎么办？

这时候就涉及另外一个概念：

> **Owner（所有者）**

假设：

```
C:\ACLTest
```



Owner 是：

```
TrustedInstaller
```



而：

```
Administrator
```



只有：

```
Read
```



那么你可能连 DACL 都没办法修改。

这时候通常是：

```
第一步：取得所有权
        ↓
第二步：修改 DACL
        ↓
第三步：获得 Full Control
```



例如：

```
takeown /f C:\ACLTest /r /d y
```



然后：

```
icacls C:\ACLTest /grant Administrator:F /t
```



`takeown` 的作用就是让管理员取得原本无法访问的文件/目录的所有权；微软文档也明确说明，取得所有权后，有时还需要进一步使用 Explorer 或权限工具授予完整权限。([Microsoft Learn](https://learn.microsoft.com/windows-server/administration/windows-commands/takeown?utm_source=chatgpt.com))

------

# 十一、注意：Take Ownership ≠ Full Control

这是理解 Windows ACL 非常重要的一点。

例如：

```
Owner
  ↓
Administrator
```



并不自动等于：

```
Administrator
  ↓
Full Control
```



实际上应该理解成：

```
Owner
   │
   └── 有权修改安全描述符/DACL
              │
              ↓
          DACL 修改
              │
              ↓
Administrator → Full Control
```



所以：

```
takeown
```



和：

```
icacls /grant
```



是两个不同层次的动作。

------

# 十二、注册表也完全一样

我们可以自己建立一个实验注册表项。

例如：

```
HKCU\Software\ACLTest
```



PowerShell：

```
New-Item -Path "HKCU:\Software\ACLTest"
```



然后：

```
Get-Acl "HKCU:\Software\ACLTest" | Format-List
```



查看：

```
Owner
Access
Sddl
```



------

# 十三、然后用 Regedit 修改

打开：

```
regedit.exe
```



找到：

```
HKEY_CURRENT_USER
└── Software
    └── ACLTest
```



右键：

```
权限
```



然后：

```
高级
```



你就会看到：

```
权限条目
-----------------------------
SYSTEM
Administrator
你的用户
...
```



选择：

```
Administrator
```



编辑：

```
完全控制
```



点击：

```
应用
确定
```



实际上你刚才做的事情就是：

```
Regedit
   ↓
修改 Security Descriptor
   ↓
修改 DACL
   ↓
增加/修改 ACE
   ↓
Administrator → Full Control
```



------

# 十四、PowerShell 也可以修改注册表 ACL

例如：

```
$key = "HKCU:\Software\ACLTest"

$acl = Get-Acl $key

$rule = New-Object System.Security.AccessControl.RegistryAccessRule(
    "Administrator",
    "FullControl",
    "Allow"
)

$acl.AddAccessRule($rule)

Set-Acl -Path $key -AclObject $acl
```



然后检查：

```
Get-Acl $key | Format-List
```



这样你就真正走了一遍：

```
Get-Acl
   ↓
读取 Security Descriptor
   ↓
修改 DACL
   ↓
AddAccessRule()
   ↓
Set-Acl
   ↓
写回 Security Descriptor
```



------

# 十五、但是这里还有一个非常重要的细节

**HKCU 和 HKLM 不应该混为一谈。**

例如：

```
HKCU
```



实际上对应当前用户的用户配置。

而：

```
HKLM
```



是整个系统范围的配置。

所以如果你做权限实验，我建议按照下面这个顺序：

```
第一阶段
HKCU:\Software\ACLTest

        ↓

第二阶段
C:\ACLTest

        ↓

第三阶段
HKLM:\SOFTWARE\ACLTest

        ↓

第四阶段
Windows 系统目录
```



不要一开始就在：

```
C:\Windows
C:\Windows\System32
C:\Windows\WinSxS
C:\Program Files
```



里面乱改 ACL。

------

# 十六、你问“哪些文件夹 Administrator 不能访问？”

这个问题其实非常有意思。

严格来说，不应该简单理解成：

> Administrator 哪些目录不能访问？

而应该理解成：

> **哪些资源的 Security Descriptor 没有给当前身份所需要的访问权限？**

典型情况包括：

| 资源                             | 常见原因                    |
| -------------------------------- | --------------------------- |
| `C:\Windows\System32` 中部分文件 | TrustedInstaller / 特殊 ACL |
| `C:\Windows\WinSxS`              | 系统保护                    |
| 某些 `C:\Program Files` 子目录   | 权限/继承策略               |
| 其他用户的某些数据目录           | 用户隔离                    |
| 系统保护文件                     | SYSTEM / TrustedInstaller   |
| 某些服务相关目录                 | 服务账户权限                |
| 某些注册表项                     | 特殊 DACL / Owner           |

所以真正应该检查的是：

```
Get-Acl "C:\某个目录" | Format-List
```



以及：

```
icacls "C:\某个目录"
```



------

# 十七、你甚至可以做一个非常好的实验

我建议你亲自做下面这个实验。

### 实验 1：创建文件

```
mkdir C:\ACLTest
New-Item C:\ACLTest\test.txt
```



### 实验 2：查看 ACL

```
icacls C:\ACLTest
```



### 实验 3：删除 Administrator 权限

```
icacls C:\ACLTest /remove Administrator
```



然后测试：

```
echo hello > C:\ACLTest\test.txt
```



### 实验 4：重新授权

```
icacls C:\ACLTest /grant Administrator:F
```



再测试：

```
echo hello > C:\ACLTest\test.txt
```



你会非常直观地看到：

```
有权限
  ↓
可以写

删除 ACE
  ↓
Access Denied

重新 Grant
  ↓
恢复访问
```



这就是 ACL 最核心的工作机制。

------

# 十八、再做一个“Owner”和“DACL”的实验

可以进一步把：

```
Owner
```



和：

```
DACL
```



故意分开。

最终你会发现：

```
我是谁？
     ↓
Administrator

我是 Owner 吗？
     ↓
不一定

DACL 给我 Full Control 吗？
     ↓
不一定

我是 Administrators 成员吗？
     ↓
可能是

管理员权限能绕过去吗？
     ↓
不一定

Owner 能不能修改 DACL？
     ↓
通常可以

修改 DACL 后：
Administrator → Full Control
     ↓
最终获得访问权限
```



这比单纯记住“管理员拥有最高权限”准确得多。

------

## 最后给你一个完整的心智模型

你可以把 Windows ACL 理解成：

```
                    Windows 对象
                 /                \
              文件                注册表项
               │                     │
               └─────────┬───────────┘
                         ↓
                Security Descriptor
                         │
          ┌──────────────┼──────────────┐
          ↓              ↓              ↓
       Owner           DACL            SACL
          │              │              │
       谁拥有它       谁能做什么       谁的访问
                         │              │
                      ACE ACE ACE       审计
                         │
             ┌───────────┼───────────┐
             ↓           ↓           ↓
        Administrator   SYSTEM      Users
             │
             ↓
        Full Control
```



而实际操作时，你最应该记住的三个命令就是：

```
# 查看
Get-Acl "C:\ACLTest"

# 取得所有权
takeown /f "C:\ACLTest" /r /d y

# 修改 DACL
icacls "C:\ACLTest" /grant Administrator:F /t
```



其中 **`takeown` 解决“谁是 Owner”问题，`icacls` 解决“谁有什么权限”问题**。([Microsoft Learn](https://learn.microsoft.com/windows-server/administration/windows-commands/takeown?utm_source=chatgpt.com))

如果你是在做 **Windows/C++ 开发**，下一步其实非常值得继续搞清楚：**ACL 在 NTFS 磁盘上究竟以什么结构保存、注册表 ACL 又到底保存在哪里，以及 C++ 如何通过 `GetNamedSecurityInfo / SetNamedSecurityInfo / RegGetKeySecurity / RegSetKeySecurity` 直接读取和修改 ACL。**这就从“会用 `icacls`”进入到真正理解 Windows Security API 的层面了。



============================

可以把这几个概念放到一张“Windows 安全权限体系图”里理解。它们并不是同一层面的东西，有的是**数据结构**，有的是**权限规则**，有的是**安全机制**。

| 缩写/名称               | 英文全称                                       | 中文                                                 | 核心作用                                                  |
| ----------------------- | ---------------------------------------------- | ---------------------------------------------------- | --------------------------------------------------------- |
| **DACL**                | **Discretionary Access Control List**          | **自主访问控制列表**                                 | 决定“谁可以对资源做什么”                                  |
| **SACL**                | **System Access Control List**                 | **系统访问控制列表**                                 | 决定“哪些访问行为需要被审计/记录”                         |
| **ACE**                 | **Access Control Entry**                       | **访问控制项 / 访问控制条目**                        | DACL/SACL 中的一条具体规则                                |
| **SDDL**                | **Security Descriptor Definition Language**    | **安全描述符定义语言**                               | 用字符串描述 Security Descriptor                          |
| **UAC**                 | **User Account Control**                       | **用户账户控制**                                     | 控制管理员权限提升，防止程序默认获得高权限                |
| **Integrity Level**     | —                                              | **完整性级别**                                       | 表示进程/对象的可信等级，限制低完整性进程影响高完整性资源 |
| **TrustedInstaller**    | **Windows Modules Installer** 服务账户相关机制 | **Windows 模块安装程序 / TrustedInstaller 服务账户** | Windows 系统文件的重要保护主体                            |
| **Security Descriptor** | —                                              | **安全描述符**                                       | 一个 Windows 对象完整的安全信息描述                       |

## 1. DACL — Discretionary Access Control List

**Discretionary Access Control List**

中文通常翻译：

> **自主访问控制列表**

它回答一个问题：

> **谁可以访问这个资源，以及可以做什么？**

例如：

```
C:\Test
│
└── DACL
    ├── Administrator → Full Control
    ├── SYSTEM        → Full Control
    └── Users         → Read
```



所以：

```
DACL = 权限规则列表
```



这是你前面问的 **“为什么 Administrator 可以/不能访问某个文件”**的核心之一。

------

# 2. ACE — Access Control Entry

**Access Control Entry**

中文：

> **访问控制项 / 访问控制条目**

ACE 是 DACL 里面的**一条规则**。

例如：

```
DACL
│
├── ACE ① Administrator → Full Control
├── ACE ② SYSTEM        → Full Control
└── ACE ③ Users         → Read
```



这里每一行就是一个 ACE。

所以最简单的关系：

```
DACL
 │
 ├── ACE
 ├── ACE
 └── ACE
```



可以记：

> **DACL 是“规则表”，ACE 是“表中的一行”。**

------

# 3. SACL — System Access Control List

**System Access Control List**

中文：

> **系统访问控制列表**

它和 DACL 很像，但用途完全不同。

### DACL

问：

> **允许不允许？**

例如：

```
Administrator → Allow → Full Control
Users         → Deny  → Write
```



### SACL

问：

> **这个访问行为要不要记录？**

例如：

```
Administrator
    ↓
访问某个机密文件
    ↓
SACL 要求审计
    ↓
Windows Event Log
    ↓
记录这次访问
```



所以：

```
DACL → Access Control
SACL → Auditing
```



这是非常重要的区别。

------

# 4. Security Descriptor

中文：

> **安全描述符**

这个不是缩写。

它可以理解为：

> **Windows 对象的“安全身份证”。**

一个文件、目录、注册表项等对象，可以关联一个 Security Descriptor。

它里面主要包含：

```
Security Descriptor
│
├── Owner
│
├── Group
│
├── DACL
│
└── SACL
```



所以你可以把它理解成：

```
Security Descriptor
        │
        ├── 谁拥有它？
        │      ↓
        │    Owner
        │
        ├── 谁可以访问？
        │      ↓
        │    DACL
        │
        └── 哪些访问需要审计？
               ↓
             SACL
```



因此：

> **DACL / SACL 是 Security Descriptor 的组成部分。**

------

# 5. SDDL — Security Descriptor Definition Language

全称：

> **Security Descriptor Definition Language**

中文：

> **安全描述符定义语言**

这是一个非常有意思的东西。

Windows 可以把 Security Descriptor 表示成一串字符串。

例如：

```
O:BAG:BAD:(A;;FA;;;SY)(A;;FA;;;BA)
```



这就是 **SDDL**。

可以粗略拆成：

```
O:BA
```



Owner

```
G:BA
```



Group

```
D:
```



DACL

后面的：

```
(A;;FA;;;SY)
```



就是 ACE 的 SDDL 表示。

所以：

```
Security Descriptor
       ↓
可以转换成
       ↓
SDDL字符串
```



反过来也可以：

```
SDDL字符串
       ↓
解析
       ↓
Security Descriptor
```



因此：

> **SDDL 就像 Windows 安全权限的“文本序列化格式”。**

------

# 6. UAC — User Account Control

全称：

> **User Account Control**

中文：

> **用户账户控制**

也就是你 Windows 里面经常看到的：

> “是否允许此应用对你的设备进行更改？”

那个弹窗背后的重要机制之一就是 UAC。

例如你登录：

```
Administrator
```



并不意味着所有程序一启动就拥有最高权限。

Windows 会通过 UAC 等机制控制：

```
普通权限进程
      ↓
需要管理员权限
      ↓
Elevation（权限提升）
      ↓
管理员权限进程
```



例如：

```
regedit.exe
```



如果需要修改某些受保护的系统资源，可能需要：

```
Run as administrator
```



------

# 7. Integrity Level

中文：

> **完整性级别**

它不是一个缩写。

Windows 常见的完整性级别包括：

```
Low
Medium
High
System
```



可以粗略理解为：

```
Low
 ↓
Medium
 ↓
High
 ↓
System
```



等级越高，一般意味着进程具有更高的可信程度。

例如：

```
普通桌面程序
    ↓
Medium Integrity

管理员权限程序
    ↓
High Integrity

SYSTEM 进程
    ↓
System Integrity
```



它和 DACL 是**不同维度**。

这点特别重要。

------

# 8. 为什么有了 DACL 还需要 Integrity Level？

假设：

```
Administrator → Full Control
```



你可能以为：

> 那是不是任何管理员程序都可以随便操作？

并不是。

Windows 还会进行完整性级别相关的访问控制。

例如：

```
低完整性进程
      ↓
想修改
      ↓
高完整性对象
```



Windows 可以阻止这种操作。

所以可以简单理解为：

```
DACL
 ↓
你有没有权限？

Integrity Level
 ↓
你的安全等级是否允许这种交互？
```



二者是不同的安全机制。

------

# 9. TrustedInstaller

这个稍微特殊。

**TrustedInstaller** 不是像 DACL 那样的缩写。

它通常指：

> **Windows Modules Installer** 服务使用的特殊服务账户/安全主体 `NT SERVICE\TrustedInstaller`

Windows 中很多非常重要的系统文件，其 Owner 可能是：

```
NT SERVICE\TrustedInstaller
```



而不是：

```
Administrator
```



例如某些：

```
C:\Windows\System32
C:\Windows\WinSxS
```



里面的系统文件。

于是你可能遇到：

```
Administrator
    ↓
明明是管理员
    ↓
删除某个系统文件
    ↓
Access Denied
```



因为：

```
Owner = TrustedInstaller
```



以及相关 DACL 对 Administrator 的权限可能受到限制。

所以 TrustedInstaller 的核心作用可以理解为：

> **保护 Windows 核心系统文件，避免管理员或普通程序轻易修改。**

------

# 10. 把这 8 个概念串起来

这是最重要的一张图：

```
                    Windows 对象
                文件 / 注册表 / 服务...
                       │
                       ↓
              Security Descriptor
                       │
       ┌───────────────┼───────────────┐
       ↓               ↓               ↓
     Owner            DACL            SACL
       │               │               │
    谁拥有它？       谁能访问？       谁需要审计？
                       │
                       ↓
                     ACE
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
    Administrator     SYSTEM       Users
          │
          ↓
    Full Control
```



与此同时，系统还有：

```
UAC
 │
 └── 管理员权限是否需要提升？
```



以及：

```
Integrity Level
 │
 └── 当前进程/对象的完整性等级
```



还有：

```
TrustedInstaller
 │
 └── Windows 核心系统资源的重要保护主体
```



最后：

```
SDDL
 │
 └── 把 Security Descriptor 表示成字符串
```



------

## 最简单的记忆方法

如果你正在学习 Windows 底层，我建议直接记成下面这句话：

> **Security Descriptor 是“安全信息总表”；DACL 管“谁能干什么”；ACE 是 DACL 里面的一条权限规则；SACL 管“哪些访问要记录”；SDDL 是描述这些安全信息的字符串语言；UAC 管“管理员权限是否提升”；Integrity Level 管“安全等级”；TrustedInstaller 是 Windows 核心资源的重要保护主体。**

再压缩成：

```
Security Descriptor
       │
       ├── Owner  → 谁拥有
       ├── DACL   → 谁能干什么
       │     └── ACE → 一条权限规则
       │
       └── SACL   → 哪些行为要审计

SDDL → 上面这些安全信息的字符串表达方式

UAC → 权限提升机制

Integrity Level → 安全等级

TrustedInstaller → Windows 核心资源保护主体
```



