# OpenWrt OpenClash TUN 一键恢复入口（Windows PowerShell 7+）
[CmdletBinding()]
param(
    [string]$RouterIP = "192.168.100.1",
    [string]$RouterUser = "root",
    [switch]$RestorePrivateConfig,
    [switch]$SkipUiFixes
)

$ErrorActionPreference = "Stop"
$packageRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$routerFiles = Join-Path $packageRoot "router"
$privateConfig = Join-Path $packageRoot "openclash.config"
$target = "${RouterUser}@${RouterIP}"
$remoteDir = "/tmp/openclash-tun-recovery-$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"
$sshOptions = @("-o", "StrictHostKeyChecking=accept-new")

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory)] [string]$FilePath,
        [Parameter(Mandatory)] [string[]]$Arguments
    )

    & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "命令执行失败（退出码 $LASTEXITCODE）：$FilePath $($Arguments -join ' ')"
    }
}

foreach ($command in @("ssh", "scp")) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        throw "未找到 $command。请先在 Windows 可选功能中安装 OpenSSH Client。"
    }
}

foreach ($requiredFile in @("restore-openclash-tun.sh", "merge-custom-rules.awk")) {
    if (-not (Test-Path -LiteralPath (Join-Path $routerFiles $requiredFile))) {
        throw "恢复包不完整：缺少 router/$requiredFile。"
    }
}

Write-Host "将恢复包上传到 $target。SSH/SCP 可能分别要求输入路由器密码。" -ForegroundColor Cyan
Invoke-NativeCommand -FilePath "scp" -Arguments ($sshOptions + @(
    "-r",
    $routerFiles,
    "${target}:${remoteDir}"
))

$remoteArguments = @()
if (-not $SkipUiFixes) {
    $remoteArguments += "--apply-ui-fixes"
    $remoteArguments += "$remoteDir/status-width.patch.html"
}

if ($RestorePrivateConfig) {
    if (-not (Test-Path -LiteralPath $privateConfig)) {
        throw "未找到私密配置备份 openclash.config。"
    }

    Write-Warning "即将恢复包含订阅地址和认证信息的完整私密配置。"
    Invoke-NativeCommand -FilePath "scp" -Arguments ($sshOptions + @(
        $privateConfig,
        "${target}:${remoteDir}/openclash.config.private"
    ))
    $remoteArguments += "--private-config"
    $remoteArguments += "$remoteDir/openclash.config.private"
}

$remoteCommand = "/bin/sh $remoteDir/restore-openclash-tun.sh"
if ($remoteArguments.Count -gt 0) {
    $remoteCommand += " " + ($remoteArguments -join " ")
}

Write-Host "开始恢复 OpenClash 配置并验证 TUN。下载 GEO 数据时可能需要数分钟。" -ForegroundColor Cyan
Invoke-NativeCommand -FilePath "ssh" -Arguments ($sshOptions + @("-t", $target, $remoteCommand))

Write-Host "恢复完成。请访问 http://$RouterIP/cgi-bin/luci/admin/services/openclash 查看状态。" -ForegroundColor Green
