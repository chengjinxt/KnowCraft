# Windows 凭据管理器：普通凭据、域密码与受控口令注入

## 白话结论

Windows“凭据管理器”里的条目并不都是同一种凭据。“添加 Windows 凭据”创建的是 `Domain Password`，主要服务于 Windows 身份验证；应用自行保存的业务口令应创建“普通凭据”，API 类型是 `CRED_TYPE_GENERIC`。

目标名相同并不代表条目可互换。应用通过 `CredReadW` 读取时同时指定目标名和类型，所以同名 `Domain Password` 不能替代 Generic Credential。若应用约定读取 Generic，界面上必须向下滚动到“普通凭据”，点击“添加普通凭据”。

## 卡片目录

1. `01-domain-vs-generic.png`：区分 Domain Password 与 Generic Credential。
2. `02-create-generic-in-ui.png`：在控制面板中找到“添加普通凭据”。
3. `03-create-and-check-with-cmdkey.png`：用交互命令创建并检查 Generic。
4. `04-controlled-credential-injection.png`：解释为何凭据管理器优于长期用户环境变量。
5. `05-troubleshoot-wrong-password.png`：拆分凭据、输入通道与压缩格式三层故障。

## 两类凭据的边界

| 类型 | Win32 类型 | 典型用途 | 是否适合作为应用自定义口令 |
| --- | --- | --- | --- |
| 普通凭据 | `CRED_TYPE_GENERIC = 1` | 应用自行定义的用户名、口令或其他私密数据 | 是 |
| 域密码 | `CRED_TYPE_DOMAIN_PASSWORD = 2` | NTLM、Kerberos、Negotiate 等 Windows 身份验证 | 否 |

Windows 还会显示 Web 凭据和基于证书的凭据，它们也不是 Generic Credential。凭据类型在创建后不能原地改成另一种；建错类型时应重新创建正确条目。

## 在界面中创建 Generic

1. 打开“控制面板 → 用户帐户 → 凭据管理器”。
2. 进入“Windows 凭据”。
3. 向下滚动，越过“Windows 凭据”和“基于证书的凭据”。
4. 找到“普通凭据”，点击“添加普通凭据”。
5. 填写应用约定的目标名、工具用户和口令。

不要使用上方的“添加 Windows 凭据”代替第 4 步。真实界面截图可能包含服务器地址、用户名等敏感信息，因此本知识卡仅使用脱敏示意图。

## 用命令行创建与检查

```powershell
cmdkey /generic:<凭据目标> /user:<工具用户> /pass
cmdkey /list:<凭据目标>
```

`/pass` 后不提供值时，系统会交互询问口令，避免明文进入命令历史和进程参数。不要使用 `/pass:<明文密码>`。

检查结果应包含 `Type: Generic`。`cmdkey /list` 只能查看元数据，不能读取保存的口令。

## 按目标名和类型受控读取

应用可通过 Win32 API 明确读取 Generic：

```cpp
PCREDENTIALW credential = nullptr;
if (CredReadW(L"<凭据目标>", CRED_TYPE_GENERIC, 0, &credential)) {
    // 仅在受控范围内使用 credential，完成后调用 CredFree。
}
```

`CredReadW` 的关键条件是“目标名 + 凭据类型”。同名不同类型的条目可以并存，读取 Generic 失败时不应自动回退到 Domain Password，否则会把系统登录凭据误当作应用业务口令。

## 为什么不长期放用户环境变量

每个 Windows 进程都有自己的环境块，子进程默认从父进程继承。后来修改用户环境变量，并不会自动更新已经运行的终端、编辑器或 Agent 进程，所以容易出现“新终端可用，旧进程仍取到旧值”的情况。

更稳妥的受控模式是：

```text
凭据管理器(Generic)
        ↓ CredReadW
    受控启动器
        ↓ 只注入本次所需变量
      目标子进程
        ↓ 读取后从自身环境映射移除
      解密或访问数据
```

环境变量可作为兼容回退，但不应长期保存敏感口令。注入范围只覆盖目标子进程，不应运行会整体打印环境变量的诊断命令。

## `Wrong password` 的三层排查

看到 `Wrong password`，不能立即断定“保存的密码错了”，应依次区分：

1. **凭据层**：是否存在正确目标名、正确用户、`Type: Generic` 的条目。
2. **输入通道层**：外部程序是否真的从预期的标准输入、文件描述符或 API 收到口令；出现交互提示不等于重定向输入已经生效。
3. **压缩格式层**：解密库是否支持该包的加密方式。ZIP、AES ZIP、7z、RAR 不能只凭扩展名视为同一能力。

Python 标准库 `zipfile` 可以解密传统 ZIP，但并不覆盖所有现代加密压缩格式。对于未支持格式，不要为了绕过问题把明文口令拼进命令行。

## 失败关闭原则

- Generic Credential 不存在或类型不匹配：停止，不读取同名 Domain Password。
- 凭据能读取但目标操作仍失败：停止，要求核对正确的受控解密方式。
- 问题分析依赖日志而日志无法安全解密：停止日志分析，不用源码猜测替代现场证据。
- Generic Credential 只能降低明文持久化、命令行和大范围环境继承风险；同一 Windows 用户下获得代码执行能力的进程仍可能调用 `CredReadW`，它不是跨进程强隔离保险箱。

## 参考资料

- [cmdkey](https://learn.microsoft.com/windows-server/administration/windows-commands/cmdkey)
- [Kinds of Credentials](https://learn.microsoft.com/en-us/windows/win32/secauthn/kinds-of-credentials)
- [CREDENTIALW structure](https://learn.microsoft.com/en-us/windows/win32/api/wincred/ns-wincred-credentialw)
- [CredReadW function](https://learn.microsoft.com/windows/win32/api/wincred/nf-wincred-credreadw)
- [Environment Variables](https://learn.microsoft.com/windows/win32/procthread/environment-variables)
- [Python `zipfile`](https://docs.python.org/3/library/zipfile.html)

## 生成与校验

- 画面比例：3:4 竖版知识卡，共 5 张。
- 图片尺寸：5 张均为 1086 × 1448，视频生成器统一适配到 1080 × 1920。
- 视频：由项目 `knowcraft-video.exe` 按卡片顺序生成 `shorts.mp4`。
- 提示词：见 `PROMPTS.md`。
