#Requires -Version 5.1
<#
.SYNOPSIS
    Uninstalls Copilot Crew from VS Code and GitHub Copilot.
.DESCRIPTION
    Removes installed skills and prompts. Creates a backup before removal.
.PARAMETER SkipBackup
    Skip creating a backup before removal.
#>

param(
    [switch]$SkipBackup
)

$ErrorActionPreference = "Stop"

$SkillsDest = Join-Path $HOME ".copilot\skills"
$PromptsDest = Join-Path $env:APPDATA "Code\User\prompts"
$BackupDir = Join-Path $HOME ".copilot-crew-backup\uninstall_$(Get-Date -Format 'yyyy-MM-dd_HHmmss')"

Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "      Copilot Crew - Uninstaller        " -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "  This will remove all Copilot Crew files. Continue? (y/N)"
if ($confirm -notin @('y', 'Y', 'yes', 'Yes')) {
    Write-Host "  Aborted." -ForegroundColor Yellow
    exit 0
}

if (-not $SkipBackup) {
    Write-Host "  -> Backing up before removal..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    if (Test-Path $SkillsDest) {
        Copy-Item -Path $SkillsDest -Destination (Join-Path $BackupDir "skills") -Recurse -Force
    }
    if (Test-Path $PromptsDest) {
        Copy-Item -Path $PromptsDest -Destination (Join-Path $BackupDir "prompts") -Recurse -Force
    }
    Write-Host "  [OK] Backup at $BackupDir" -ForegroundColor Green
}

if (Test-Path $SkillsDest) {
    Remove-Item -Path $SkillsDest -Recurse -Force
    Write-Host "  [OK] Skills removed" -ForegroundColor Green
} else {
    Write-Host "  [!] Skills folder not found, skipping" -ForegroundColor Yellow
}

if (Test-Path $PromptsDest) {
    Remove-Item -Path $PromptsDest -Recurse -Force
    Write-Host "  [OK] Prompts removed" -ForegroundColor Green
} else {
    Write-Host "  [!] Prompts folder not found, skipping" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Copilot Crew has been removed." -ForegroundColor Green
Write-Host "  Restart VS Code to complete uninstall." -ForegroundColor Yellow
Write-Host ""
