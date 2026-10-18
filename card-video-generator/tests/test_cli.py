from pathlib import Path


def test_resolve_ffmpeg_accepts_an_explicit_executable(tmp_path: Path) -> None:
    from knowcraft_video.cli import resolve_ffmpeg

    executable = tmp_path / "ffmpeg.exe"
    executable.write_bytes(b"fixture")

    assert resolve_ffmpeg(executable) == executable.resolve()


def test_main_returns_error_when_card_folder_is_empty(
    tmp_path: Path, capsys
) -> None:
    from knowcraft_video.cli import main

    executable = tmp_path / "ffmpeg.exe"
    executable.write_bytes(b"fixture")
    card_dir = tmp_path / "empty-cards"
    card_dir.mkdir()

    exit_code = main([str(card_dir), "--ffmpeg", str(executable)])

    captured = capsys.readouterr()
    assert exit_code == 1
    assert "没有找到" in captured.err
