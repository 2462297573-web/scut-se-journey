# 用模板创建本月学习日志
# 用法：
#   .\scripts\new-journal.ps1              # 用当前年月
#   .\scripts\new-journal.ps1 -Month 2026-12

param(
    [string]$Month
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $root 'journal\TEMPLATE.md'

if (-not (Test-Path $template)) {
    Write-Error "找不到模板：$template"
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Month)) {
    $Month = Get-Date -Format 'yyyy-MM'
}

$dest = Join-Path $root "journal\$Month.md"

if (Test-Path $dest) {
    Write-Host "已存在，不覆盖：$dest" -ForegroundColor Yellow
    exit 0
}

$year = ($Month -split '-')[0]
$mon = [int](($Month -split '-')[1])

$text = [System.IO.File]::ReadAllText($template, [System.Text.Encoding]::UTF8)
$text = $text -replace '(?m)^# YYYY 年 MM 月\s*$', "# $year 年 $mon 月"

[System.IO.File]::WriteAllText($dest, $text, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "已创建：$dest" -ForegroundColor Green
Write-Host ""
Write-Host "下一步："
Write-Host "  1. 打开文件，把『本月主题』和四个周的空格填上"
Write-Host "  2. git add . ; git commit -m `"journal: $Month 开始`""
