# preload 安全边界

## preload 是桥

真正的 Electron preload 由 `BrowserWindow` 在页面脚本前加载：页面调用受限方法，preload 封装接口，主进程执行高权限操作。Web 侧同名 SDK 只是普通页面脚本，不会自动获得系统权限。

## 两个关键配置

`contextIsolation: true` 隔离页面与 preload 的全局对象；`nodeIntegration: false` 阻止页面直接使用 Node.js。`process.contextIsolated` 只读取状态，不会开启隔离。

## 桥接也要收口

不要暴露原始 `ipcRenderer` 或任意 `channel`。应提供细粒度方法，并校验参数、`sender` 与 `Origin`。

## SDK 能删吗

共享 SDK 源码通常承载运行时门面和类型契约，不能直接删。`dist` 若能稳定重建通常可删；整包删除前必须迁移 `imports`、`alias`、`workspace` 和 `build` 引用。
