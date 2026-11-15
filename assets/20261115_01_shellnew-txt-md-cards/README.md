# Windows 右键“新建”恢复 TXT 和 Markdown

## 白话结论

“默认用哪个软件打开”和“右键能不能新建”是两条相关但不同的配置链。

- 默认打开依赖扩展名、`ProgID (Programmatic Identifier，程序标识符)`、打开命令以及用户选择。
- 右键“新建”还要求扩展名下存在 `ShellNew`（新建菜单配置）；使用空白文件方式时，需要一个无内容的 `NullFile` 字符串值。

本次现场中，`.txt` 缺失 `ShellNew\NullFile`，`.md` 缺少有效的默认 `ProgID`。两者补齐后，仍需刷新 Explorer（文件资源管理器）。本机原菜单现场已经呈现 15 个文件类型项；备份并移除闲置的 `Regsnap Document` 新建项后，重新打开 Explorer，TXT 与 Markdown 才同时出现。这个“15 项”只是本机验收结果，不是 Windows 对所有设备承诺的统一上限。

## 本次实际修复

### TXT：保持 Notepad++ 为默认打开程序

修复后的有效关系：

```text
.txt
  (Default) = NotepadPlusPlus.txt
  ShellNew
    NullFile = ""

NotepadPlusPlus.txt
  (Default) = 文本文档
  DefaultIcon
    (Default) = "<Notepad++安装目录>\notepad++.exe,0"
  shell\open\command
    (Default) = "\"<Notepad++安装目录>\notepad++.exe\" \"%1\""
```

本机原有 `.txt` 的 `UserChoice` 已经指向 Notepad++，所以没有直接改写受哈希保护的 `UserChoice`；只补齐文件类型和新建菜单链路。

使用当前用户注册表进行同类修复时，可参考：

```powershell
$notepadExe = '<Notepad++安装目录>\notepad++.exe'

New-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\.txt\ShellNew' -Force | Out-Null
Set-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\.txt' -Value 'NotepadPlusPlus.txt'
New-ItemProperty 'Registry::HKEY_CURRENT_USER\Software\Classes\.txt\ShellNew' `
  -Name 'NullFile' -Value '' -PropertyType String -Force | Out-Null

New-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\NotepadPlusPlus.txt\shell\open\command' -Force | Out-Null
Set-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\NotepadPlusPlus.txt' -Value '文本文档'
Set-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\NotepadPlusPlus.txt\shell\open\command' `
  -Value ('"{0}" "%1"' -f $notepadExe)
```

### Markdown：保持 Typora 为默认打开程序

修复后的有效关系：

```text
.md
  (Default) = Typora.md
  Content Type = text/markdown
  PerceivedType = text
  ShellNew
    ItemName = Markdown 文档
    NullFile = ""

Typora.md
  (Default) = Markdown 文档
  shell\open\command
    (Default) = "\"<Typora安装目录>\Typora.exe\" \"%1\""
```

本机的 `.md` `UserChoice` 已经是 `Typora.md`，因此同样保留用户选择，只修复扩展名、`ProgID`、显示名和 `ShellNew`。

当前用户范围的核心配置可参考：

```powershell
$typoraExe = '<Typora安装目录>\Typora.exe'

New-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\.md\ShellNew' -Force | Out-Null
Set-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\.md' -Value 'Typora.md'
New-ItemProperty 'Registry::HKEY_CURRENT_USER\Software\Classes\.md' `
  -Name 'Content Type' -Value 'text/markdown' -PropertyType String -Force | Out-Null
New-ItemProperty 'Registry::HKEY_CURRENT_USER\Software\Classes\.md' `
  -Name 'PerceivedType' -Value 'text' -PropertyType String -Force | Out-Null
New-ItemProperty 'Registry::HKEY_CURRENT_USER\Software\Classes\.md\ShellNew' `
  -Name 'NullFile' -Value '' -PropertyType String -Force | Out-Null
New-ItemProperty 'Registry::HKEY_CURRENT_USER\Software\Classes\.md\ShellNew' `
  -Name 'ItemName' -Value 'Markdown 文档' -PropertyType String -Force | Out-Null

New-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\Typora.md\shell\open\command' -Force | Out-Null
Set-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\Typora.md' -Value 'Markdown 文档'
Set-Item 'Registry::HKEY_CURRENT_USER\Software\Classes\Typora.md\shell\open\command' `
  -Value ('"{0}" "%1"' -f $typoraExe)
```

如果机器范围的 `.md` 注册缺失或损坏，也应在管理员权限下同步检查 `HKLM\Software\Classes\.md` 与 `HKLM\Software\Classes\Typora.md`。本次现场同时补齐了机器范围配置，避免当前用户覆盖被移除后再次失效。

## 为什么注册表写对了仍可能不显示

Explorer 会收集 `HKEY_CLASSES_ROOT` 下带有 `ShellNew` 的扩展名，并生成“新建”子菜单。`HKEY_CLASSES_ROOT` 是当前用户和本机文件类型配置的合并视图，所以只检查一个物理位置可能漏掉覆盖关系。

本次现场还有两点：

1. Explorer 进程仍持有旧菜单状态，必须关闭相关文件夹窗口并重新打开，才能看到最终结果。
2. 原菜单实际显示了 15 个文件类型项。移除已备份、闲置的 `.rsnp\ShellNew` 后，新建的 `Markdown 文档` 才进入菜单。这个行为是现场验证，不把它解释成所有 Windows 版本都固定为 15 项。

恢复被移除的旧项时，可导入事先导出的备份：

```powershell
reg import "<备份目录>\hkcr-dot-rsnp.reg"
```

## 验证方法

### 注册表链路

```powershell
reg query HKCR\.txt /ve
reg query HKCR\.txt\ShellNew
reg query HKCR\NotepadPlusPlus.txt\shell\open\command /ve

reg query HKCR\.md /ve
reg query HKCR\.md\ShellNew
reg query HKCR\Typora.md\shell\open\command /ve
```

预期结果：

- `.txt` 默认值为 `NotepadPlusPlus.txt`，存在 `NullFile`，打开命令指向 Notepad++。
- `.md` 默认值为 `Typora.md`，存在 `NullFile`，菜单名为 `Markdown 文档`，打开命令指向 Typora。
- 重新打开 Explorer 后，右键“新建”同时出现“文本文档”和“Markdown 文档”。

### 不要直接改写 UserChoice

Windows 的 `UserChoice` 包含系统维护的哈希。若默认打开程序本来不正确，优先使用“设置 → 应用 → 默认应用”重新选择，不要简单复制或硬写别人的 `UserChoice` 值。

## 图片清单

1. `01-why-shellnew-disappears.png`：扩展名、`ProgID`、`ShellNew` 的关系。
2. `02-repair-txt-notepad-plus-plus.png`：TXT 与 Notepad++ 的修复链路。
3. `03-repair-md-typora.png`：Markdown 与 Typora 的修复链路。
4. `04-refresh-and-verify.png`：备份、刷新及本机菜单现场验收。

## 生成方式与检查结果

- 图片由生成式图片工具按统一视觉规范逐张生成，第四张因第一次多出说明文字而整张重生成；最终提示词见 `PROMPTS.md`。
- 四张图片均为 3:4 竖版，已逐张检查标题、英文大小写、扩展名、箭头、品牌名和信息归属。
- Shorts 使用项目内 `knowcraft-video.exe` 生成，并按项目规则核对编码、分辨率、帧率、像素格式、色彩标记、音轨和时长。

## 技术边界与风险

- 修改注册表前必须导出相关项；错误的扩展名或 `ProgID` 配置可能让双击打开、图标或右键命令失效。
- `HKEY_LOCAL_MACHINE` 修改需要管理员权限，会影响这台电脑上的其他用户；仅修复当前账户时优先使用 `HKEY_CURRENT_USER`。
- 删除第三方 `ShellNew` 只会移除该类型的“新建”入口，不会卸载软件或删除已有文件。若仍需该入口，应从备份恢复。
- Explorer 菜单的收集顺序属于实现细节，不能依赖固定排序或固定数量编写长期策略。

## 参考资料

- Microsoft Learn：[Extending the New Submenu](https://learn.microsoft.com/en-us/windows/win32/shell/context#extending-the-new-submenu)
- Microsoft Learn：[File Types](https://learn.microsoft.com/en-us/windows/win32/shell/fa-file-types)
- Microsoft DevBlogs：[What order do the items in the “New” menu appear?](https://devblogs.microsoft.com/oldnewthing/20190611-00/?p=102581)
