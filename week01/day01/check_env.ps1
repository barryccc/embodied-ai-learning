<#
=====================================================================
 Day 1 环境体检脚本 —— Windows 端 (PowerShell)
---------------------------------------------------------------------
 作用：打印 Windows / WSL / 显卡 / 磁盘 等关键信息，
       并把结果保存成 env_report_windows.txt，方便贴给 Claude。

 用法（推荐）：在该文件所在目录打开 PowerShell，执行：

     powershell -ExecutionPolicy Bypass -File .\check_env.ps1

 如果是右键“用 PowerShell 运行”，可能会一闪而过，
 所以建议用上面命令行方式。
=====================================================================
#>

$ErrorActionPreference = "SilentlyContinue"

Start-Transcript -Path "env_report_windows.txt" -Force | Out-Null

function Sec($t) { Write-Output ""; Write-Output "===== $t =====" }

Sec "时间"
Get-Date

Sec "Windows 版本"
(Get-CimInstance Win32_OperatingSystem).Caption
"Version : " + (Get-CimInstance Win32_OperatingSystem).Version
"Build   : " + (Get-CimInstance Win32_OperatingSystem).BuildNumber
"Arch    : $env:PROCESSOR_ARCHITECTURE"

Sec "PowerShell 版本"
$PSVersionTable.PSVersion.ToString()

Sec "CPU"
(Get-CimInstance Win32_Processor).Name
"VirtualizationFirmwareEnabled : " + (Get-CimInstance Win32_Processor).VirtualizationFirmwareEnabled

Sec "内存"
"{0:N1} GB" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)

Sec "显卡 (Windows 设备管理器视角)"
Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion | Format-List

Sec "nvidia-smi (NVIDIA 驱动)"
if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
    nvidia-smi
} else {
    "nvidia-smi 不在 PATH —— 可能没装 NVIDIA 驱动，或驱动没装好"
}

Sec "WSL 状态"
if (Get-Command wsl -ErrorAction SilentlyContinue) {
    "---- wsl --version ----"
    wsl --version
    "---- 已安装的发行版 (wsl -l -v) ----"
    wsl -l -v
} else {
    "wsl 命令不存在 —— WSL 还没安装"
}

Sec "Git (Windows 端)"
if (Get-Command git -ErrorAction SilentlyContinue) { git --version } else { "git : 未安装（Windows 端）" }

Sec "VS Code"
if (Get-Command code -ErrorAction SilentlyContinue) { "code 命令可用" } else { "code 命令不可用（不影响，WSL 端装 VS Code Server 即可）" }

Sec "磁盘空间"
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -ne $null } |
    Select-Object Name, @{n='Free(GB)';e={"{0:N1}" -f ($_.Free/1GB)}}, @{n='Used(GB)';e={"{0:N1}" -f ($_.Used/1GB)}} |
    Format-Table -AutoSize

Sec "结束"
"体检完毕。请把 env_report_windows.txt 的内容整体复制，粘给 Claude。"

Stop-Transcript | Out-Null
