#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Copilot Crew into VS Code and GitHub Copilot.
.DESCRIPTION
    Copies skills to ~/.copilot/skills/ and prompts to the VS Code User prompts folder.
    Existing files are backed up automatically before overwriting.
.PARAMETER Force
    Overwrite without confirmation prompts.
.PARAMETER SkipBackup
    Skip creating a backup of existing files.
.EXAMPLE
    .\install.ps1
    .\install.ps1 -Force -SkipBackup
#>

param(
    [switch]$Force,
    [switch]$SkipBackup
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsSource = Join-Path $RepoRoot "skills"
$PromptsSource = Join-Path $RepoRoot "prompts"

$SkillsDest = Join-Path $HOME ".copilot\skills"
$PromptsDest = Join-Path $env:APPDATA "Code\User\prompts"

$BackupDir = Join-Path $HOME ".copilot-crew-backup\$(Get-Date -Format 'yyyy-MM-dd_HHmmss')"

function Write-Step($msg) { Write-Host "  -> $msg" -ForegroundColor Cyan }
function Write-OK($msg) { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "  [!] $msg" -ForegroundColor Yellow }

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "       Copilot Crew - Installer         " -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Validate sources
if (-not (Test-Path $SkillsSource)) {
    Write-Error "skills/ folder not found at $SkillsSource. Run this script from the copilot-crew repo root."
    exit 1
}
if (-not (Test-Path $PromptsSource)) {
    Write-Error "prompts/ folder not found at $PromptsSource. Run this script from the copilot-crew repo root."
    exit 1
}

# Confirmation
if (-not $Force) {
    Write-Host "  This will install Copilot Crew to:" -ForegroundColor White
    Write-Host "    Skills:  $SkillsDest" -ForegroundColor Gray
    Write-Host "    Prompts: $PromptsDest" -ForegroundColor Gray
    Write-Host ""
    $confirm = Read-Host "  Continue? (Y/n)"
    if ($confirm -and $confirm -notin @('y', 'Y', 'yes', 'Yes', '')) {
        Write-Host "  Aborted." -ForegroundColor Yellow
        exit 0
    }
}

# Backup existing files
if (-not $SkipBackup) {
    $hasExisting = (Test-Path $SkillsDest) -or (Test-Path $PromptsDest)
    if ($hasExisting) {
        Write-Step "Backing up existing config..."
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        if (Test-Path $SkillsDest) {
            Copy-Item -Path $SkillsDest -Destination (Join-Path $BackupDir "skills") -Recurse -Force
        }
        if (Test-Path $PromptsDest) {
            Copy-Item -Path $PromptsDest -Destination (Join-Path $BackupDir "prompts") -Recurse -Force
        }
        Write-OK "Backup created at $BackupDir"
    }
}

# Install skills
Write-Step "Installing skills to $SkillsDest"
if (-not (Test-Path $SkillsDest)) {
    New-Item -ItemType Directory -Path $SkillsDest -Force | Out-Null
}
$skillFolders = Get-ChildItem -Path $SkillsSource -Directory
foreach ($folder in $skillFolders) {
    $dest = Join-Path $SkillsDest $folder.Name
    Copy-Item -Path $folder.FullName -Destination $dest -Recurse -Force
}
Write-OK "$($skillFolders.Count) skills installed"

# Install prompts
Write-Step "Installing prompts to $PromptsDest"
if (-not (Test-Path $PromptsDest)) {
    New-Item -ItemType Directory -Path $PromptsDest -Force | Out-Null
}
Copy-Item -Path "$PromptsSource\*" -Destination $PromptsDest -Recurse -Force
Write-OK "Prompts installed"

# Summary
$agentCount = (Get-ChildItem -Path (Join-Path $PromptsDest "agents") -Filter "*.agent.md" -ErrorAction SilentlyContinue).Count
$promptCount = (Get-ChildItem -Path $PromptsDest -Filter "*.prompt.md" -File -ErrorAction SilentlyContinue).Count
$instrCount = (Get-ChildItem -Path (Join-Path $PromptsDest "instructions") -Filter "*.instructions.md" -ErrorAction SilentlyContinue).Count
$toolsetCount = (Get-ChildItem -Path $PromptsDest -Filter "*.toolsets.jsonc" -File -ErrorAction SilentlyContinue).Count

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "       Installation Complete!           " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Agents:       $agentCount" -ForegroundColor White
Write-Host "  Prompts:      $promptCount" -ForegroundColor White
Write-Host "  Instructions: $instrCount" -ForegroundColor White
Write-Host "  Skills:       $($skillFolders.Count)" -ForegroundColor White
Write-Host "  Toolsets:     $toolsetCount" -ForegroundColor White
Write-Host ""
Write-Host "  Restart VS Code to activate." -ForegroundColor Yellow
Write-Host ""
