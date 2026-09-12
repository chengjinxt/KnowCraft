# TCP 三次握手与四次挥手知识卡片

本目录包含两张竖版知识卡片：

- `01-tcp-three-way-handshake.png`：TCP 建立连接的三次握手。
- `02-tcp-four-way-termination.png`：TCP 正常关闭连接时常见的四次挥手。

## 基础概念

`TCP (Transmission Control Protocol，传输控制协议)` 是一种面向连接、可靠、有序的字节流传输协议。

卡片中的 `x / y / u / v` 都是教学用的示意序列号，并非固定数值。

## 三次握手：建立连接

### 第一次：Client → Server

```text
SYN, Seq = x
```

客户端申请建立连接，并发送自己的初始序列号 `x`。客户端进入 `SYN-SENT`。

### 第二次：Server → Client

```text
SYN + ACK, Seq = y, Ack = x + 1
```

服务端确认客户端的 `SYN`，同时发送自己的初始序列号 `y`。服务端进入 `SYN-RECEIVED`。

### 第三次：Client → Server

```text
ACK, Seq = x + 1, Ack = y + 1
```

客户端确认服务端的 `SYN`。完成后，双方进入 `ESTABLISHED（连接已建立）`。

### 为什么是三次

前两次让双方交换并确认初始序列号；第三次让服务端知道客户端已经收到服务端的 `SYN`。三次握手还可降低网络中旧的重复连接请求造成错误连接的风险。

握手建立的是 TCP 连接，不等于完成加密或应用身份认证；TLS 等上层协议有自己的握手过程。

## 四次挥手：正常关闭连接

以下用 A 表示 `Active Closer（主动关闭方）`，B 表示 `Passive Closer（被动关闭方）`。

### 第一次：A → B

```text
FIN, Seq = u
```

A 表示自己不再发送数据，但仍然可以接收 B 的数据。A 进入 `FIN-WAIT-1`；B 收到后进入 `CLOSE-WAIT`。

### 第二次：B → A

```text
ACK, Ack = u + 1
```

B 确认 A 的 `FIN`。A 进入 `FIN-WAIT-2`。此时连接处于 `Half-Closed Connection（半关闭连接）`：A→B 的发送方向已关闭，B→A 仍可发送剩余数据。

### 第三次：B → A

```text
FIN, Seq = v
```

B 处理完剩余数据后，也请求关闭自己的发送方向，并进入 `LAST-ACK`。

### 第四次：A → B

```text
ACK, Ack = v + 1
```

A 确认 B 的 `FIN` 并进入 `TIME-WAIT`；B 收到最终 `ACK` 后进入 `CLOSED`。主动关闭方等待 `2×MSL` 后再进入 `CLOSED`。

`MSL (Maximum Segment Lifetime，报文段最大生存时间)` 是一个 TCP 报文段在网络中允许存在的最长时间。`TIME-WAIT` 让最终 `ACK` 丢失时有机会重传，也有助于避免旧报文影响后续连接。

## 为什么通常是四次

TCP 是双向数据通道，两个发送方向可以独立关闭。B 收到 A 的 `FIN` 后需要立即确认，但此时 B 可能仍有数据要发送，因此自己的 `FIN` 往往稍后再发，教学上便表现为四次。

实际报文不一定永远恰好四个：如果 B 已经没有剩余数据，确认 A 的 `ACK` 与 B 自己的 `FIN` 可能合并在同一个报文段中。异常终止还可能使用 `RST (Reset，重置)`，不属于卡片展示的正常关闭流程。

## 术语速记

- `SYN (Synchronize，同步序列号)`
- `ACK (Acknowledgment，确认)`
- `FIN (Finish，发送结束)`
- `Seq (Sequence Number，序列号)`
- `Ack (Acknowledgment Number，确认号)`
- `TCP Segment（TCP 报文段）`

## 参考依据

- [RFC 9293 — Transmission Control Protocol (TCP)](https://www.rfc-editor.org/rfc/rfc9293.html)

## 生成与检查

- 生成方式：Codex 内置 `imagegen`。
- 提示词结构：客户端/服务端双时间线、方向箭头、序列号、状态变化、原因解释与术语速记。
- 已人工检查三次握手和四次挥手的报文顺序、箭头方向、序列号关系及主要连接状态。
- 四次挥手第一版曾出现第③步箭头方向错误，已重新生成最终版；错误版本未写入项目目录。
- 卡片采用常见的主动关闭教学主流程，不展开同时打开、同时关闭、TCP Fast Open、RST 异常终止或操作系统实现差异。
