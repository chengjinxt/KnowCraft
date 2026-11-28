# 知识卡片生成提示词

将以下共用规范与各卡生成提示词拼接后提交给内置 ImageGen。四张卡首次生成均无输入图片，输出为不透明位图。第三、四张之后分别用各自初稿作局部编辑输入。

## 共用视觉规范

```text
Use case: infographic-diagram. Create a single original portrait 3:4 Chinese mobile knowledge card, artwork flat to the edge, with clean warm ivory background (#F7F5EE), near-black navy text (#142632), restrained teal (#087F75) for uv and sage green for Conda with small amber highlights. Editorial technology handout with extremely legible bold Chinese sans-serif headings, clean large body typography, simple flat line icons, soft rounded information blocks and balanced breathing room. Use a large left aligned title, strong visual hierarchy, 7% safe margin on all four sides, no cropping, very readable on a phone. Render all provided copy verbatim in simplified Chinese, exact capitalization and ASCII punctuation for code. Do not add any copy, numbering, branding, logos, watermarks or extraneous decorations. Finish the card as a polished standalone publication-ready image.
```

## 01-environment-model.png

### 生成

```text
Title exactly “Conda 和 uv 的环境差在哪？” set on two natural lines. Two generous full-width panels, stacked and clearly labeled. First panel label “Conda 环境”, line “Python 和依赖装在环境里”. Illustrate one outer folder or container with two neutral pictograms inside, a runtime chip and a package stack. Second panel label “uv 虚拟环境（Virtual Environment）”, then two lines “多个环境可共用一套 Python” and “第三方依赖各自安装”. Illustrate one teal runtime chip linked to two separate folder outlines, each folder has its own package stack. Leave pictograms unlabeled and keep the two illustrations simple so the text remains large. Bottom highlight exactly “切换已有环境，无需重装”. Do not show version numbers, commands, or other text.
```

## 02-python-discovery.png

### 生成

```text
Title exactly “uv 怎么找到 Python？” Below it, left aligned text “先找版本匹配的解释器（Interpreter）”. In a large rounded panel below, set three equally prominent short lines, each with a small unlabeled icon: “uv 管理目录”, “PATH（可执行文件搜索路径）”, “Windows 注册表（Registry）”. Under the panel, put a distinct thin amber insight strip with exactly “激活 Conda 环境，通常会把它加入 PATH”. At the bottom, use two separate very readable lines in one teal-tinted box: “找到就复用” and “没找到且允许下载，才尝试下载”. Keep only these eight text blocks. Do not put arrows between the three discovery locations or imply an absolute search order for them.
```

## 03-same-version-two-installs.png

### 生成

```text
Title exactly “两条同版本记录，等于装了两套？” split into two balanced lines, retain the full-width Chinese comma. Two stacked visual panels with ample space. Top panel exact heading “同一套 Python 的两个入口”. In top panel exactly two rounded labeled nodes “命令行启动器（Launcher）” and “Python 安装目录”, in a one-way flow where ONE arrow visibly points from the launcher TO the installation directory, never the reverse. Bottom panel exact heading “同版本也可能真装了两套”. In bottom panel two visually separate labeled nodes “Conda 环境” and “uv 管理目录”; each gets its own small runtime icon, with no arrows connecting them. Below the two nodes write exactly “uv 没找到 Conda 的版本，又下载安装了一套”. Keep ample room and high contrast for the last line; wrapping it is fine. The first panel has exactly one runtime icon, the second has exactly two. No version numbers and no other copy.
```

### 局部修订

输入图片为本卡的首次生成结果，仅用于图标修订。

```text
Input image 1 is the edit target. Make one local edit to this exact 3:4 Chinese portrait card: replace the interlocking blue-and-yellow snake emblem in the center of the upper panel with a single generic teal square microchip outline icon with simple pins and no letters, matching the existing line icon style. The arrow must still run from the left launcher to the right installation directory. Preserve all text verbatim, including the title, verbatim Chinese and Latin spellings, colors, original positions, safe margins, rounded panels, and line breaks. Keep the lower section unchanged. No logos, no watermarks, no added text. Return the complete card.
```

## 04-reuse-without-download.png

### 生成

```text
Title exactly “怎样复用 Conda 的 Python？” split naturally into two lines. Two vertically stacked light rounded panels with small restrained icons on the right and clean large copy aligned left. In first panel, print exactly “指定解释器（Interpreter）”, then “用 --python 传入 python.exe 的完整路径” across two lines as needed, keeping --python and python.exe intact and clearly rendered in monospace. In second panel print exactly “禁止自动下载” and on its own line the exact code “--no-python-downloads” in a large clearly readable monospace, with two leading plain ASCII hyphens, and single hyphens between words. Below the panels, a separate amber note with exactly “Python 2.7 不受 uv 支持” and “已有 2.7 环境可继续用 Conda”. Make the version numbers large and readable. No filesystem paths or other text.
```

### 局部修订

输入图片为本卡的首次生成结果，仅用于图标修订。

```text
Input image 1 is the edit target. Make one local edit to this exact 3:4 Chinese portrait card: replace the interlocking blue-and-yellow snake emblem inside the monitor on the first turquoise panel with a single generic teal square microchip outline icon with simple pins, no letters and no logos. Keep the monitor itself, layout, every Chinese and Latin line, typography, margins, card shapes, and palette unchanged. In particular preserve the exact text --python, python.exe, --no-python-downloads, and Python 2.7. Add no text, watermark, or marks. Return the complete card.
```
