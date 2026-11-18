[CmdletBinding()]
param(
    [Parameter()]
    [string]$Revision = 'origin/main',

    [Parameter()]
    [ValidateRange(1, 100)]
    [int]$MaxRetries = 10,

    [Parameter()]
    [ValidateRange(0, 300)]
    [int]$RetryDelaySeconds = 2,

    [Parameter()]
    [switch]$RestoreDefaultConfig
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-GitCommand {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw '未找到 git 命令，请先安装 Git for Windows。'
    }
}

function Assert-GitRepository {
    $insideWorkTree = & git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $insideWorkTree -ne 'true') {
        throw '当前目录不是 Git 工作区，请先进入仓库目录。'
    }
}

function Assert-PromisorRemote {
    $promisor = & git config --bool --get remote.origin.promisor 2>$null
    if ($LASTEXITCODE -ne 0 -or $promisor -ne 'true') {
        throw @'
origin 尚未配置为 Promisor Remote（承诺远程仓库）。请先执行：

git config remote.origin.promisor true
git config remote.origin.partialclonefilter blob:none
git -c protocol.version=2 fetch --filter=blob:none --no-tags origin main
'@
    }
}

function Get-MissingObjectIds {
    param(
        [Parameter(Mandatory)]
        [string[]]$RevListArguments
    )

    $output = & git rev-list --objects --missing=print @RevListArguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "无法检查缺失对象：`n$($output -join [Environment]::NewLine)"
    }

    $objectIds = foreach ($line in $output) {
        $text = $line.ToString()
        if ($text -match '^\?([0-9a-fA-F]{40,64})(?:\s|$)') {
            $Matches[1].ToLowerInvariant()
        }
    }

    return @($objectIds | Sort-Object -Unique)
}

function Remove-GitConfigKey {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    & git config --unset-all $Name
    if ($LASTEXITCODE -notin @(0, 1)) {
        throw "无法删除 Git 配置项：$Name"
    }
}

Assert-GitCommand
Assert-GitRepository
Assert-PromisorRemote

# 先确认目标引用存在，避免把分支名拼写错误误判为“没有缺失对象”。
& git rev-parse --verify "$Revision^{commit}" > $null
if ($LASTEXITCODE -ne 0) {
    throw "找不到提交引用：$Revision。请先完成 blob:none 元数据拉取。"
}

$missingObjectIds = @(Get-MissingObjectIds -RevListArguments @($Revision))
if ($missingObjectIds.Count -eq 0) {
    Write-Host "$Revision 没有缺失对象。" -ForegroundColor Green
}
else {
    Write-Host "待拉取对象数量：$($missingObjectIds.Count)"

    for ($index = 0; $index -lt $missingObjectIds.Count; $index++) {
        $objectId = $missingObjectIds[$index]
        $success = $false
        $position = $index + 1
        $percentComplete = [int](100 * $position / $missingObjectIds.Count)

        Write-Progress `
            -Activity '分批拉取 Git 对象' `
            -Status "$position/$($missingObjectIds.Count)  $objectId" `
            -PercentComplete $percentComplete

        for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
            Write-Host "[$position/$($missingObjectIds.Count)] 拉取 $objectId，第 $attempt 次尝试"

            # 读取对象会触发 Promisor Remote 按对象补取；标准输出直接丢弃。
            & git cat-file -p $objectId > $null
            if ($LASTEXITCODE -eq 0) {
                $success = $true
                break
            }

            if ($attempt -lt $MaxRetries) {
                Write-Warning "对象 $objectId 拉取失败，$RetryDelaySeconds 秒后重试。"
                Start-Sleep -Seconds $RetryDelaySeconds
            }
        }

        if (-not $success) {
            Write-Progress -Activity '分批拉取 Git 对象' -Completed
            throw "对象 $objectId 连续失败。网络稳定后重新运行脚本即可，已成功的对象不会重复下载。"
        }
    }

    Write-Progress -Activity '分批拉取 Git 对象' -Completed
}

$remainingObjectIds = @(Get-MissingObjectIds -RevListArguments @($Revision))
if ($remainingObjectIds.Count -ne 0) {
    throw "仍有 $($remainingObjectIds.Count) 个缺失对象，请重新运行脚本。"
}

Write-Host "$Revision 的缺失对象已经全部补齐。" -ForegroundColor Green

if ($RestoreDefaultConfig) {
    # 删除 Promisor 配置前检查所有本地引用，而不只是参数指定的分支。
    $allMissingObjectIds = @(Get-MissingObjectIds -RevListArguments @('--all'))
    if ($allMissingObjectIds.Count -ne 0) {
        throw "整个仓库仍有 $($allMissingObjectIds.Count) 个缺失对象，拒绝还原 Promisor 配置。"
    }

    Remove-GitConfigKey -Name 'remote.origin.promisor'
    Remove-GitConfigKey -Name 'remote.origin.partialclonefilter'
    Write-Host '已恢复默认配置：origin 不再是 Promisor Remote，也不再使用 blob:none。' -ForegroundColor Green
}
else {
    Write-Host '已保留部分拉取配置。确认整个仓库没有缺失对象后，可使用 -RestoreDefaultConfig 还原默认配置。'
}
