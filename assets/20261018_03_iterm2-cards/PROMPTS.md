# ImageGen 提示词记录

## 统一视觉规范

```text
Use case: infographic-diagram
Asset type: a four-card Chinese social-media technical knowledge series, 3:4 portrait
Style: original flat-vector technical infographic; warm off-white background; deep navy typography; sky-blue and teal rounded panels; small orange highlights; subtle shadows; generic terminal, keyboard and settings icons; generous spacing; phone-readable large type.
Constraints: render all supplied text verbatim; keep explanations attached to their own blocks; preserve English capitalization, Mac modifier symbols, arrows and parentheses. No copied platform template, logo, watermark, QR code, dense paragraph, tiny text, duplicated text or invented menu label.
```

后续卡片以上一张成品作为视觉风格参考，只参考色彩、圆角信息块、字体层级与图标语言，不复用上一张内容。

## 01 — iTerm2 分屏快捷键

```text
Title: "iTerm2 分屏快捷键"
Subtitle: "一个窗口，同时盯住多个终端"

Block 1:
"左右分屏"
"⌘ D"
"Split Vertically（垂直分割）"

Block 2:
"上下分屏"
"⇧ ⌘ D"
"Split Horizontally（水平分割）"

Block 3:
"切换 Pane（窗格）"
"⌘ ⌥ ← ↑ → ↓"
"在分屏之间移动焦点"

Block 4:
"临时放大"
"⇧ ⌘ Enter"
"再次按下恢复全部窗格"

Bottom tip: "拖动分隔线，可以调整各窗格大小"
Composition: large title, short subtitle, four rounded blocks in a 2x2 grid, one tip bar at bottom. Show generic terminal split diagrams and keyboard-key caps.
```

## 02 — 保存 Window Arrangement

```text
Title: "保存 iTerm2 分屏布局"
Subtitle: "Window Arrangement（窗口排列）会记住你的工作台"

Step 1:
"1  调整好布局"
"窗口位置、Tab（标签页）、Pane（窗格）与分屏比例"

Step 2:
"2  保存排列"
"Window → Arrangements → Save Window Arrangement"

Step 3:
"3  命名保存"
"例如：pc-client-dev"

Restore:
"手动恢复"
"Window → Arrangements → Restore Window Arrangement"

Bottom note: "普通 Arrangement 主要保存布局，不等于保活进程"
Composition: a clear three-step vertical flow with numbered blocks and arrows, a restore-path block and a short boundary note.
```

## 03 — 启动时自动还原布局

```text
Title: "启动时自动还原布局"
Subtitle: "先设为 Default（默认），再修改启动策略"

Step 1:
"1  选择保存项"
"Settings → Arrangements"

Step 2:
"2  设为默认排列"
"选中 Arrangement，设置为 Default"

Step 3:
"3  修改启动策略"
"Settings → General → Startup"
"Window restoration policy"
"Open Default Window Arrangement"

Result:
"下次启动"
"自动打开已保存的窗口、Tab 与 Pane 布局"

Bottom note: "旧版本可能显示：Open saved window arrangement"
Composition: three numbered settings steps in a top-to-bottom flow, followed by a restored multi-pane terminal and a compatibility note.
```

## 04 — Arrangement 与 tmux

```text
Title: "布局恢复 ≠ 进程继续运行"
Subtitle: "先分清：要保存“样子”，还是保存“运行状态”"

Left column heading: "Window Arrangement（窗口排列）"
Left bullets:
"保存窗口位置"
"保存 Tab 与 Pane 布局"
"保存分屏比例与 Profile"
Left summary: "适合：重建工作台"

Right column heading: "tmux"
Right explanation: "Terminal Multiplexer（终端复用器）"
Right bullets:
"会话可在后台继续"
"断开后还能重新连接"
"适合长任务与远程连接"
Right summary: "适合：保留运行状态"

Decision 1: "只要界面布局 → Arrangement"
Decision 2: "进程不能停 → tmux"
Bottom line: "退出前，先判断真正想保留什么"
Composition: balanced two-column comparison, a simple decision strip and a memorable bottom line. Show a pane-layout icon on the left and a persistent linked terminal-session icon on the right.
```
