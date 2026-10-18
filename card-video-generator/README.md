# KnowCraft 知识卡片 Shorts 生成器

这个工具把一个知识点目录中的卡片按文件名自然顺序串成一个无声竖版视频。默认输出到卡片目录内的 `shorts.mp4`。

## 输出规格

- 画布：`1080 × 1920`，9:16 竖版。
- 内容：卡片完整居中显示，不裁切；剩余区域使用同图模糊背景填充。
- 时长：每张卡默认 4 秒，总时长不超过 180 秒。
- 视频：MP4 容器、H.264 High Profile、30 fps、`yuv420p`、BT.709（TV/limited range）、Fast Start。
- 音频：默认且固定为无音轨，程序不会自动混入来源或授权不明确的音乐。

采用这些规格的依据：YouTube 官方说明 Shorts 是最长 3 分钟的竖版短视频，上传工具接受方形或竖版视频；官方上传建议使用 MP4、H.264、逐行扫描、常见帧率和 BT.709。参考：

- [YouTube Shorts upload tips](https://support.google.com/youtube/answer/12921536)
- [Upload YouTube Shorts](https://support.google.com/youtube/answer/12779649)
- [YouTube recommended upload encoding settings](https://support.google.com/youtube/answer/1722171)

YouTube 仅明确保证其 Audio Library（音频库）中的音乐和音效对 YouTube 而言是版权安全的。需要音乐时，优先在上传后通过 YouTube Shorts 工具或 Audio Library 添加；不要把网络上仅标注“免费”的音乐直接混入视频。参考：[Use music and sound effects from the Audio Library](https://support.google.com/youtube/answer/3376882)。

## 直接调用

在 KnowCraft 根目录运行：

```powershell
.\card-video-generator\dist\knowcraft-video.exe `
  .\assets\20261018_02_computer-use-cards
```

卡片修改后重新生成：

```powershell
.\card-video-generator\dist\knowcraft-video.exe `
  .\assets\20261018_02_computer-use-cards `
  --overwrite
```

批量处理 `assets` 下所有知识点：

```powershell
.\card-video-generator\dist\knowcraft-video.exe .\assets --all --overwrite
```

可用 `--seconds-per-card 5` 调整单张停留时间。程序会拒绝生成超过 180 秒的视频。

运行时需要 FFmpeg。程序依次查找 `--ffmpeg` 指定路径、`KNOWCRAFT_FFMPEG` 环境变量、程序同目录和系统 `PATH`。

## 从源码运行与构建

源码没有第三方 Python 运行库依赖：

```powershell
$env:PYTHONPATH = ".\card-video-generator\src"
python -m knowcraft_video .\assets\20261018_02_computer-use-cards
```

构建 Windows 单文件程序需要 PyInstaller：

```powershell
python -m pip install pyinstaller
.\card-video-generator\build.ps1
```

运行测试：

```powershell
python -m pytest .\card-video-generator\tests
```
