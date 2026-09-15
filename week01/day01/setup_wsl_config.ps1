<#
=====================================================================
 Day 1 · 第二步：修复 WSL 代理警告 (+ 顺手设默认发行版)
---------------------------------------------------------------------
 它做三件事：
   1) 写入 %USERPROFILE%\.wslconfig，开启 mirrored 网络模式 + autoProxy，
      让 Windows 的 localhost 代理（FlClash）能被 WSL 使用
   2) 把 Ubuntu (24.04) 设为默认发行版
   3) 提示你 reboot WSL 并验证

 用法（在 PowerShell 里，进到本文件所在目录后）：
     powershell -ExecutionPolicy Bypass -File .\setup_wsl_config.ps1
=====================================================================
#>

$wslconfig = "$HOME\.wslconfig"

Write-Host "===== 1. 写入 $wslconfig =====" -ForegroundColor Cyan

# 如果已有配置，先备份，避免覆盖你原来的设置
if (Test-Path $wslconfig) {
    Copy-Item $wslconfig "$wslconfig.bak" -Force
    Write-Host "发现已有配置，已备份到 $wslconfig.bak" -ForegroundColor Yellow
}

@(
    "[wsl2]",
    "networkingMode=mirrored",
    "autoProxy=true"
) | Set-Content -Path $wslconfig -Encoding ASCII

Write-Host "写入完成，当前内容："
Get-Content $wslconfig
Write-Host ""

Write-Host "===== 2. 设为默认发行版 Ubuntu (24.04) =====" -ForegroundColor Cyan
wsl --set-default Ubuntu
wsl -l -v
Write-Host ""

Write-Host "===== 3. 下一步（需要你手动执行）=====" -ForegroundColor Cyan
Write-Host "先关掉全部 WSL：" -ForegroundColor Yellow
Write-Host "    wsl --shutdown" -ForegroundColor Yellow
Write-Host "等 8 秒左右，重新进 WSL，在里面验证代理通了没：" -ForegroundColor Yellow
Write-Host "    curl -I https://github.com" -ForegroundColor Yellow
Write-Host "看到 HTTP/2 200 或 301 就算修好了。" -ForegroundColor Yellow
