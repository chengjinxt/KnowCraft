Windows、Linux 与 macOS ABI是什么？
`ABI (Application Binary Interface，应用二进制接口)` 是编译后二进制组件之间的对接规则。它常涉及：
- `Architecture（体系结构）`：例如 `x86`、`x64 / x86_64`、`arm64`。
- `Binary Format（二进制格式）`：Windows 常见 `PE`，Linux 常见 `ELF`，macOS 使用 `Mach-O`。
- `Calling Convention（调用约定）`：参数和返回值怎样通过寄存器或栈传递。
- `Data Layout（数据布局）`：类型大小、内存对齐、结构体布局。
- `Symbol（符号）`：函数或数据的导入名、导出名、序号和版本。
- `Runtime（运行时）`：操作系统、C/C++ 运行库和语言运行时提供的二进制能力。

白话上可以理解为：`API (Application Programming Interface，应用程序编程接口)` 规定源代码怎么调用，ABI 规定源代码编译成机器码以后怎么对接。文件名相同不等于 ABI 兼容；库能被找到，也不等于程序需要的符号一定存在。