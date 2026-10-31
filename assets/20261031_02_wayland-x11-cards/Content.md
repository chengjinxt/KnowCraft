# Wayland 和 X11 有什么不一样

显示服务器（Display Server）：程序和屏幕之间的传话员，画面经它才上屏幕。
X11（X Window System，X 窗口系统）：1984 年老协议，客户端/服务器（Client/Server）架构，程序可跨机器显示。
X11 老毛病：画面易撕裂，程序隔离差、能偷看别程序，现代功能靠合成器（Compositor）打补丁。
Wayland（Wayland 显示协议）：2008 年新协议，化繁为简，程序把画面交给合成器统一上屏。
Wayland 好处：画面不撕裂、隔离更安全、架构简单更省资源、触屏原生支持。
XWayland（XWayland 兼容层）：翻译层，老程序照常跑，换 Wayland 不等于老软件全不能用。
远程桌面：X11 用 RealVNC Server（远程桌面服务端），Wayland 改用 wayvnc（Wayland 远程桌面）；`raspi-config` 的 VNC 开关按桌面类型自动选；Raspberry Pi Connect 屏幕共享要 Wayland 会话。
学习机：Trixie + labwc 就是 Wayland，Chromium 原生跑，自启按 labwc 写，远程照常用。
