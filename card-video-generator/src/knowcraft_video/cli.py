from __future__ import annotations

import argparse
import os
import shutil
import sys
from pathlib import Path
from typing import Sequence

from .generator import (
    RenderResult,
    RenderSettings,
    VideoGenerationError,
    render_all,
    render_folder,
)


def resolve_ffmpeg(explicit: Path | None = None) -> Path:
    candidates: list[Path] = []
    if explicit is not None:
        candidates.append(Path(explicit))

    configured = os.environ.get("KNOWCRAFT_FFMPEG")
    if configured:
        candidates.append(Path(configured))

    candidates.append(Path(sys.executable).resolve().parent / "ffmpeg.exe")

    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()

    path_match = shutil.which(str(explicit) if explicit is not None else "ffmpeg")
    if path_match:
        return Path(path_match).resolve()

    raise VideoGenerationError(
        "找不到 ffmpeg。请安装 FFmpeg 并加入 PATH，或使用 --ffmpeg 指定路径。"
    )


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="knowcraft-video",
        description="把一个知识点目录内的卡片按文件名顺序生成无声 YouTube Shorts 视频。",
    )
    parser.add_argument("path", type=Path, help="卡片目录，或与 --all 配合使用的 assets 目录")
    parser.add_argument(
        "--all",
        action="store_true",
        help="处理指定 assets 目录下所有含卡片的一级子目录",
    )
    parser.add_argument(
        "--seconds-per-card",
        type=float,
        default=4.0,
        help="每张卡片停留秒数，默认 4 秒",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="覆盖已有的 shorts.mp4",
    )
    parser.add_argument(
        "--ffmpeg",
        type=Path,
        help="ffmpeg 可执行文件路径；默认从环境变量或 PATH 查找",
    )
    return parser


def _print_result(result: RenderResult) -> None:
    print(
        f"已生成：{result.output_path} "
        f"({result.card_count} 张卡片，{result.duration_seconds:g} 秒，无背景音乐)"
    )


def main(argv: Sequence[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    try:
        settings = RenderSettings(seconds_per_card=args.seconds_per_card)
        ffmpeg = resolve_ffmpeg(args.ffmpeg)
        if args.all:
            results = render_all(
                args.path,
                ffmpeg=ffmpeg,
                settings=settings,
                overwrite=args.overwrite,
            )
            if not results:
                raise VideoGenerationError("指定目录下没有找到知识卡片图片")
            for result in results:
                _print_result(result)
        else:
            _print_result(
                render_folder(
                    args.path,
                    ffmpeg=ffmpeg,
                    settings=settings,
                    overwrite=args.overwrite,
                )
            )
    except (FileExistsError, NotADirectoryError, ValueError, VideoGenerationError) as error:
        print(f"错误：{error}", file=sys.stderr)
        return 1
    return 0
