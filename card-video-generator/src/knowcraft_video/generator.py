from __future__ import annotations

import os
import re
import subprocess
import uuid
from collections.abc import Callable, Sequence
from dataclasses import dataclass
from pathlib import Path


IMAGE_EXTENSIONS = frozenset({".png", ".jpg", ".jpeg", ".webp"})


class VideoGenerationError(RuntimeError):
    """Raised when the requested video cannot be rendered safely."""


@dataclass(frozen=True)
class RenderSettings:
    seconds_per_card: float = 4.0
    width: int = 1080
    height: int = 1920
    card_width: int = 960
    card_height: int = 1800
    frame_rate: int = 30
    max_duration_seconds: float = 180.0

    def __post_init__(self) -> None:
        if self.seconds_per_card <= 0:
            raise ValueError("seconds_per_card must be greater than zero")


@dataclass(frozen=True)
class RenderResult:
    output_path: Path
    card_count: int
    duration_seconds: float


CommandRunner = Callable[[list[str]], subprocess.CompletedProcess[str]]


def _natural_key(path: Path) -> tuple[object, ...]:
    parts = re.split(r"(\d+)", path.name.casefold())
    return tuple(int(part) if part.isdigit() else part for part in parts)


def collect_card_images(folder: Path) -> list[Path]:
    folder = Path(folder)
    if not folder.is_dir():
        raise NotADirectoryError(folder)
    return sorted(
        (
            path
            for path in folder.iterdir()
            if path.is_file() and path.suffix.casefold() in IMAGE_EXTENSIONS
        ),
        key=_natural_key,
    )


def build_ffmpeg_command(
    ffmpeg: Path,
    images: Sequence[Path],
    output_path: Path,
    settings: RenderSettings,
) -> list[str]:
    if not images:
        raise VideoGenerationError("没有找到可生成视频的知识卡片图片")

    duration = len(images) * settings.seconds_per_card
    if duration > settings.max_duration_seconds:
        raise VideoGenerationError(
            f"视频总时长 {duration:g} 秒超过 YouTube Shorts 的 "
            f"{settings.max_duration_seconds:g} 秒限制"
        )

    command = [str(ffmpeg), "-hide_banner", "-y"]
    for image in images:
        command.extend(
            [
                "-loop",
                "1",
                "-framerate",
                str(settings.frame_rate),
                "-t",
                f"{settings.seconds_per_card:g}",
                "-i",
                str(image),
            ]
        )

    filters: list[str] = []
    for index in range(len(images)):
        filters.append(
            f"[{index}:v]split=2[bg{index}src][fg{index}src];"
            f"[bg{index}src]"
            f"scale={settings.width}:{settings.height}:"
            "force_original_aspect_ratio=increase:force_divisible_by=2,"
            f"crop={settings.width}:{settings.height},"
            "gblur=sigma=24,eq=brightness=-0.12:saturation=0.75"
            f"[bg{index}];"
            f"[fg{index}src]"
            f"scale={settings.card_width}:{settings.card_height}:"
            "force_original_aspect_ratio=decrease:force_divisible_by=2"
            f"[fg{index}];"
            f"[bg{index}][fg{index}]"
            "overlay=(W-w)/2:(H-h)/2,setsar=1,"
            f"fps={settings.frame_rate},format=yuv420p,"
            "scale=iw:ih:out_range=tv,"
            "setparams=range=tv:color_primaries=bt709:"
            "color_trc=bt709:colorspace=bt709"
            f"[v{index}]"
        )

    if len(images) == 1:
        output_label = "[v0]"
    else:
        output_label = "[outv]"
        filters.append(
            "".join(f"[v{index}]" for index in range(len(images)))
            + f"concat=n={len(images)}:v=1:a=0[outv]"
        )

    command.extend(
        [
            "-filter_complex",
            ";".join(filters),
            "-map",
            output_label,
            "-an",
            "-c:v",
            "libx264",
            "-preset",
            "medium",
            "-crf",
            "18",
            "-profile:v",
            "high",
            "-pix_fmt",
            "yuv420p",
            "-g",
            str(settings.frame_rate // 2),
            "-keyint_min",
            str(settings.frame_rate // 2),
            "-bf",
            "2",
            "-colorspace",
            "bt709",
            "-color_primaries",
            "bt709",
            "-color_trc",
            "bt709",
            "-movflags",
            "+faststart",
            str(output_path),
        ]
    )
    return command


def _run_ffmpeg(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=False, text=True)


def render_folder(
    folder: Path,
    *,
    ffmpeg: Path,
    settings: RenderSettings,
    output_name: str = "shorts.mp4",
    overwrite: bool = False,
    runner: CommandRunner = _run_ffmpeg,
) -> RenderResult:
    folder = Path(folder).resolve()
    images = collect_card_images(folder)
    output_path = folder / output_name
    if output_path.exists() and not overwrite:
        raise FileExistsError(f"输出文件已存在：{output_path}")

    duration = len(images) * settings.seconds_per_card
    temporary_output = folder / f".{output_path.stem}.{uuid.uuid4().hex}.mp4"
    command = build_ffmpeg_command(ffmpeg, images, temporary_output, settings)

    try:
        completed = runner(command)
        if completed.returncode != 0:
            raise VideoGenerationError(
                f"FFmpeg 生成失败，退出码：{completed.returncode}"
            )
        if not temporary_output.is_file():
            raise VideoGenerationError("FFmpeg 未生成预期的视频文件")
        os.replace(temporary_output, output_path)
    finally:
        temporary_output.unlink(missing_ok=True)

    return RenderResult(
        output_path=output_path,
        card_count=len(images),
        duration_seconds=duration,
    )


def render_all(
    assets_root: Path,
    *,
    ffmpeg: Path,
    settings: RenderSettings,
    output_name: str = "shorts.mp4",
    overwrite: bool = False,
    runner: CommandRunner = _run_ffmpeg,
) -> list[RenderResult]:
    assets_root = Path(assets_root).resolve()
    if not assets_root.is_dir():
        raise NotADirectoryError(assets_root)

    results: list[RenderResult] = []
    for folder in sorted(
        (path for path in assets_root.iterdir() if path.is_dir()),
        key=_natural_key,
    ):
        if not collect_card_images(folder):
            continue
        results.append(
            render_folder(
                folder,
                ffmpeg=ffmpeg,
                settings=settings,
                output_name=output_name,
                overwrite=overwrite,
                runner=runner,
            )
        )
    return results
