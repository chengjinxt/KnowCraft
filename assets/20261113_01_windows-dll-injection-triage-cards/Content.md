# Explorer卡死排查

## 先说结论

Explorer 反复无响应、自动重启，不一定是 CPU 或磁盘不够。若 WER（Windows Error Reporting，Windows 错误报告）记录 `AppHang`，而调用栈显示系统组件都在等待 DLL 加载器，应继续向下寻找异常第三方模块。

## 证据怎么串起来

先确认 `Responding = False` 和 `AppHangB1`，再用 CDB（Console Debugger，控制台调试器）的 `lm` 查看模块、`kb` 查看调用栈。若 DLL 加载断点显示堆内存直接调用 `LdrLoadDll`，要警惕远程或内核注入，并继续检查运行中的 `SYSTEM_START` 驱动。

## 卸载后怎么验收

不再需要的安全接入客户端，应使用官方卸载器完整卸载。随后检查服务、驱动和 `AppInit_DLLs`，集中完成改动后只计划一次重启，并确认注入模块列表为空、Explorer 持续响应、没有新增 `AppHang`。只删除主程序不等于注入链已经消失。
