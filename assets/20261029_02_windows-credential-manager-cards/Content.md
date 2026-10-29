# Windows 普通凭据

## 类型别选错

“添加 Windows 凭据”创建的是 `Domain Password（域密码）`，用于 NTLM、Kerberos、Negotiate 等系统身份验证。应用自己保存的口令应选择页面下方“普通凭据”，类型必须显示 `Generic`。

## 创建与检查

```powershell
cmdkey /generic:<凭据目标> /user:<工具用户> /pass
cmdkey /list:<凭据目标>
```

`/pass` 不带明文时交互输入。检查结果应包含 `Type: Generic`；不要使用 `/pass:<明文密码>`。

## 受控读取

工具可用 `CredReadW` 按目标名和 `CRED_TYPE_GENERIC` 读取，只向本次子进程注入口令。环境变量只作为兼容回退，因为旧进程不会自动获得后来更新的用户环境变量。

遇到 `Wrong password` 时，先区分凭据、输入通道和压缩格式。日志无法安全解密就停止分析，不用源码猜根因。
