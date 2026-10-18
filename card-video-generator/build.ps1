param(
    [string]$Python = "python"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$entrypoint = Join-Path $projectRoot "entrypoint.py"
$sourceRoot = Join-Path $projectRoot "src"
$distRoot = Join-Path $projectRoot "dist"
$buildRoot = Join-Path $projectRoot "build"

& $Python -m PyInstaller `
    --noconfirm `
    --clean `
    --onefile `
    --name knowcraft-video `
    --paths $sourceRoot `
    --distpath $distRoot `
    --workpath $buildRoot `
    --specpath $buildRoot `
    $entrypoint

if ($LASTEXITCODE -ne 0) {
    throw "PyInstaller 构建失败，退出码：$LASTEXITCODE"
}

Write-Output "已生成：$(Join-Path $distRoot 'knowcraft-video.exe')"
