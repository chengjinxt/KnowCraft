from __future__ import annotations

import subprocess
from pathlib import Path

import pytest


def test_collect_card_images_uses_natural_filename_order(tmp_path: Path) -> None:
    from knowcraft_video.generator import collect_card_images

    for name in ("10-last.webp", "02-middle.JPG", "1-first.png", "notes.md"):
        (tmp_path / name).write_bytes(b"fixture")

    images = collect_card_images(tmp_path)

    assert [image.name for image in images] == [
        "1-first.png",
        "02-middle.JPG",
        "10-last.webp",
    ]


def test_build_ffmpeg_command_targets_youtube_shorts_format(tmp_path: Path) -> None:
    from knowcraft_video.generator import RenderSettings, build_ffmpeg_command

    images = [tmp_path / "01-first.png", tmp_path / "02-second.png"]
    output = tmp_path / "rendering.mp4"

    command = build_ffmpeg_command(
        Path("ffmpeg.exe"), images, output, RenderSettings(seconds_per_card=4.0)
    )
    command_text = " ".join(str(part) for part in command)

    assert command[:3] == ["ffmpeg.exe", "-hide_banner", "-y"]
    assert command.count("-i") == 2
    assert str(images[0]) in command and str(images[1]) in command
    assert "scale=1080:1920:force_original_aspect_ratio=increase" in command_text
    assert "scale=960:1800:force_original_aspect_ratio=decrease" in command_text
    assert (
        "scale=iw:ih:out_range=tv,"
        "setparams=range=tv:color_primaries=bt709:color_trc=bt709:colorspace=bt709"
        in command_text
    )
    assert "concat=n=2:v=1:a=0" in command_text
    assert "-an" in command
    assert command[command.index("-c:v") + 1] == "libx264"
    assert command[command.index("-pix_fmt") + 1] == "yuv420p"
    assert command[command.index("-movflags") + 1] == "+faststart"
    assert command[-1] == str(output)


def test_render_folder_writes_video_atomically_and_refuses_overwrite(
    tmp_path: Path,
) -> None:
    from knowcraft_video.generator import RenderSettings, render_folder

    card_dir = tmp_path / "20261018_01-example-cards"
    card_dir.mkdir()
    (card_dir / "01-example.png").write_bytes(b"fixture")
    calls: list[list[str]] = []

    def successful_ffmpeg(command: list[str]) -> subprocess.CompletedProcess[str]:
        calls.append(command)
        Path(command[-1]).write_bytes(b"video")
        return subprocess.CompletedProcess(command, 0)

    result = render_folder(
        card_dir,
        ffmpeg=Path("ffmpeg.exe"),
        settings=RenderSettings(),
        runner=successful_ffmpeg,
    )

    assert result.output_path == card_dir / "shorts.mp4"
    assert result.output_path.read_bytes() == b"video"
    assert result.card_count == 1
    assert result.duration_seconds == 4.0
    assert len(calls) == 1
    assert Path(calls[0][-1]) != result.output_path

    with pytest.raises(FileExistsError, match="shorts.mp4"):
        render_folder(
            card_dir,
            ffmpeg=Path("ffmpeg.exe"),
            settings=RenderSettings(),
            runner=successful_ffmpeg,
        )


def test_render_folder_rejects_duration_over_three_minutes(tmp_path: Path) -> None:
    from knowcraft_video.generator import RenderSettings, VideoGenerationError, render_folder

    card_dir = tmp_path / "too-many-cards"
    card_dir.mkdir()
    for index in range(46):
        (card_dir / f"{index:02d}.png").write_bytes(b"fixture")

    with pytest.raises(VideoGenerationError, match="180"):
        render_folder(
            card_dir,
            ffmpeg=Path("ffmpeg.exe"),
            settings=RenderSettings(seconds_per_card=4.0),
            runner=lambda command: subprocess.CompletedProcess(command, 0),
        )


def test_render_all_processes_only_immediate_folders_with_cards(tmp_path: Path) -> None:
    from knowcraft_video.generator import RenderSettings, render_all

    first = tmp_path / "20261018_01-first-cards"
    second = tmp_path / "20261018_02-second-cards"
    empty = tmp_path / "empty"
    for folder in (first, second, empty):
        folder.mkdir()
    (first / "01.png").write_bytes(b"fixture")
    (second / "01.jpg").write_bytes(b"fixture")

    def successful_ffmpeg(command: list[str]) -> subprocess.CompletedProcess[str]:
        Path(command[-1]).write_bytes(b"video")
        return subprocess.CompletedProcess(command, 0)

    results = render_all(
        tmp_path,
        ffmpeg=Path("ffmpeg.exe"),
        settings=RenderSettings(),
        runner=successful_ffmpeg,
    )

    assert [result.output_path.parent.name for result in results] == [
        first.name,
        second.name,
    ]
    assert not (empty / "shorts.mp4").exists()
