[CmdletBinding()]
param(
    [string]$OutputPath = (Join-Path (Get-Location) ("llm-hardware-report-windows-{0}.txt" -f (Get-Date -Format 'yyyyMMdd-HHmmss')))
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:ReportLines = [System.Collections.Generic.List[string]]::new()

function ConvertTo-SingleLine {
    param([AllowNull()][object]$Value)

    if ($null -eq $Value) {
        return ''
    }

    $text = if ($Value -is [System.Array]) { $Value -join ', ' } else { [string]$Value }
    return (($text -replace '[\r\n]+', ' ') -replace '\s{2,}', ' ').Trim()
}

function Add-Section {
    param([string]$Name)
    [void]$script:ReportLines.Add('')
    [void]$script:ReportLines.Add("[$Name]")
}

function Add-Field {
    param(
        [string]$Name,
        [AllowNull()][object]$Value
    )
    [void]$script:ReportLines.Add("$Name=$(ConvertTo-SingleLine $Value)")
}

function ConvertTo-GiB {
    param([AllowNull()][object]$Bytes)
    if ($null -eq $Bytes -or [double]$Bytes -le 0) {
        return ''
    }
    return [math]::Round(([double]$Bytes / 1GB), 2)
}

function Get-CimData {
    param(
        [string]$ClassName,
        [string]$Filter = ''
    )

    try {
        if ($Filter) {
            return @(Get-CimInstance -ClassName $ClassName -Filter $Filter -ErrorAction Stop)
        }
        return @(Get-CimInstance -ClassName $ClassName -ErrorAction Stop)
    }
    catch {
        Add-Field "warning_$ClassName" $_.Exception.Message
        return @()
    }
}

function Add-ToolVersion {
    param(
        [string]$Name,
        [string[]]$Arguments
    )

    $command = Get-Command -Name $Name -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $command) {
        Add-Field $Name 'not_found'
        return
    }

    try {
        $firstLine = & $command.Source @Arguments 2>&1 | Select-Object -First 1
        Add-Field $Name (ConvertTo-SingleLine $firstLine)
    }
    catch {
        Add-Field $Name 'found_but_version_failed'
    }
}

[void]$script:ReportLines.Add('LLM_HARDWARE_REPORT_V1')
Add-Section 'meta'
Add-Field 'os_family' 'Windows'
Add-Field 'collected_at_utc' ([DateTime]::UtcNow.ToString('o'))
Add-Field 'privacy' 'No hostname, username, serial number, IP (Internet Protocol) address, MAC (Media Access Control) address, Wi-Fi network name, or process list is collected.'

$operatingSystems = @(Get-CimData 'Win32_OperatingSystem')
$computerSystems = @(Get-CimData 'Win32_ComputerSystem')
$baseBoards = @(Get-CimData 'Win32_BaseBoard')

Add-Section 'system'
if ($operatingSystems.Count -gt 0) {
    $os = $operatingSystems[0]
    Add-Field 'os_name' $os.Caption
    Add-Field 'os_version' $os.Version
    Add-Field 'os_build' $os.BuildNumber
    Add-Field 'os_architecture' $os.OSArchitecture
    Add-Field 'available_memory_gib' (ConvertTo-GiB ([double]$os.FreePhysicalMemory * 1KB))
}
if ($computerSystems.Count -gt 0) {
    $computer = $computerSystems[0]
    Add-Field 'system_manufacturer' $computer.Manufacturer
    Add-Field 'system_model' $computer.Model
    Add-Field 'installed_memory_gib' (ConvertTo-GiB $computer.TotalPhysicalMemory)
}
if ($baseBoards.Count -gt 0) {
    $board = $baseBoards[0]
    Add-Field 'baseboard_manufacturer' $board.Manufacturer
    Add-Field 'baseboard_product' $board.Product
    Add-Field 'baseboard_version' $board.Version
}
Add-Field 'powershell_version' $PSVersionTable.PSVersion.ToString()

$processors = @(Get-CimData 'Win32_Processor')
for ($index = 0; $index -lt $processors.Count; $index++) {
    $processor = $processors[$index]
    Add-Section "cpu.$index"
    Add-Field 'name' $processor.Name
    Add-Field 'architecture_code' $processor.Architecture
    Add-Field 'cores' $processor.NumberOfCores
    Add-Field 'logical_processors' $processor.NumberOfLogicalProcessors
    Add-Field 'max_clock_mhz' $processor.MaxClockSpeed
}

$memoryModules = @(Get-CimData 'Win32_PhysicalMemory')
$memoryArrays = @(Get-CimData 'Win32_PhysicalMemoryArray')
Add-Section 'memory'
Add-Field 'installed_module_count' $memoryModules.Count
if ($memoryArrays.Count -gt 0) {
    $memoryArray = $memoryArrays[0]
    Add-Field 'memory_device_slots' $memoryArray.MemoryDevices
    $extendedMaximum = 0
    if ($memoryArray.PSObject.Properties.Name -contains 'ExtendedMaxCapacity') {
        $extendedMaximum = [double]$memoryArray.ExtendedMaxCapacity
    }
    if ($extendedMaximum -gt 0) {
        Add-Field 'firmware_reported_max_memory_gib' (ConvertTo-GiB $extendedMaximum)
    }
    elseif ([double]$memoryArray.MaxCapacity -gt 0) {
        Add-Field 'firmware_reported_max_memory_gib' (ConvertTo-GiB ([double]$memoryArray.MaxCapacity * 1KB))
    }
}
for ($index = 0; $index -lt $memoryModules.Count; $index++) {
    $module = $memoryModules[$index]
    Add-Section "memory.module.$index"
    Add-Field 'locator' $module.DeviceLocator
    Add-Field 'bank' $module.BankLabel
    Add-Field 'capacity_gib' (ConvertTo-GiB $module.Capacity)
    Add-Field 'speed_mhz' $module.Speed
    Add-Field 'configured_speed_mhz' $module.ConfiguredClockSpeed
    Add-Field 'manufacturer' $module.Manufacturer
    Add-Field 'part_number' $module.PartNumber
}

$videoControllers = @(Get-CimData 'Win32_VideoController')
for ($index = 0; $index -lt $videoControllers.Count; $index++) {
    $video = $videoControllers[$index]
    Add-Section "gpu.windows.$index"
    Add-Field 'name' $video.Name
    Add-Field 'adapter_ram_gib_unreliable' (ConvertTo-GiB $video.AdapterRAM)
    Add-Field 'driver_version' $video.DriverVersion
    Add-Field 'status' $video.Status
}
Add-Section 'gpu.windows.note'
Add-Field 'adapter_ram_warning' 'Win32_VideoController.AdapterRAM can be inaccurate, especially for GPUs above 4 GiB. Prefer vendor tools when available.'

$nvidiaCommand = Get-Command -Name 'nvidia-smi' -ErrorAction SilentlyContinue | Select-Object -First 1
Add-Section 'gpu.nvidia_smi'
if ($nvidiaCommand) {
    try {
        $nvidiaRows = @(& $nvidiaCommand.Source '--query-gpu=name,memory.total,driver_version' '--format=csv,noheader,nounits' 2>&1)
        if ($LASTEXITCODE -eq 0) {
            for ($index = 0; $index -lt $nvidiaRows.Count; $index++) {
                $parts = ([string]$nvidiaRows[$index]).Split(',') | ForEach-Object { $_.Trim() }
                Add-Field "gpu_$index" ("name={0}; vram_mib={1}; driver={2}" -f $parts[0], $parts[1], $parts[2])
            }
        }
        else {
            Add-Field 'status' 'command_failed'
        }
    }
    catch {
        Add-Field 'status' 'command_failed'
    }
}
else {
    Add-Field 'status' 'not_found'
}

$logicalDisks = @(Get-CimData 'Win32_LogicalDisk' 'DriveType=3')
for ($index = 0; $index -lt $logicalDisks.Count; $index++) {
    $disk = $logicalDisks[$index]
    Add-Section "storage.volume.$index"
    Add-Field 'drive' $disk.DeviceID
    Add-Field 'filesystem' $disk.FileSystem
    Add-Field 'size_gib' (ConvertTo-GiB $disk.Size)
    Add-Field 'free_gib' (ConvertTo-GiB $disk.FreeSpace)
}

$pageFiles = @(Get-CimData 'Win32_PageFileUsage')
Add-Section 'page_file'
Add-Field 'count' $pageFiles.Count
$allocatedPageFileMiB = 0.0
$usedPageFileMiB = 0.0
foreach ($pageFile in $pageFiles) {
    $allocatedPageFileMiB += [double]$pageFile.AllocatedBaseSize
    $usedPageFileMiB += [double]$pageFile.CurrentUsage
}
Add-Field 'allocated_gib' ([math]::Round(($allocatedPageFileMiB / 1024), 2))
Add-Field 'current_usage_gib' ([math]::Round(($usedPageFileMiB / 1024), 2))

Add-Section 'backend_tools'
foreach ($tool in @('nvidia-smi', 'rocm-smi', 'rocminfo', 'vulkaninfo', 'ollama', 'llama-cli', 'llama-server', 'python', 'python3')) {
    $found = Get-Command -Name $tool -ErrorAction SilentlyContinue | Select-Object -First 1
    Add-Field $tool $(if ($found) { 'found' } else { 'not_found' })
}

Add-Section 'tool_versions'
Add-ToolVersion 'ollama' @('--version')
Add-ToolVersion 'llama-cli' @('--version')
Add-ToolVersion 'llama-server' @('--version')

Add-Section 'manual_inputs_needed'
Add-Field 'model_file' '<填写完整模型文件名>'
Add-Field 'model_file_size' '<填写实际文件大小>'
Add-Field 'context_length' '<填写计划使用的上下文长度>'
Add-Field 'multimodal' '<填写是否使用图片/音频输入>'
Add-Field 'concurrency' '<填写同时运行的会话数>'

$fullOutputPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputDirectory = Split-Path -Parent $fullOutputPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}
$utf8WithoutBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllLines($fullOutputPath, $script:ReportLines, $utf8WithoutBom)

Write-Host "Report written to: $fullOutputPath"
Write-Host 'Please fill in the [manual_inputs_needed] section before sending the report for analysis.'
