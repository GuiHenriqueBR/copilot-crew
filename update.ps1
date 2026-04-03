# Copilot Crew — Update Script (Windows)
# Run: .\update.ps1

$ErrorActionPreference = "Stop"

$RepoDir = $PSScriptRoot
$PromptsSource = Join-Path $RepoDir "prompts"
$SkillsSource = Join-Path $RepoDir "skills"

# Determine install targets
$PromptsTarget = Join-Path $env:APPDATA "Code\User\prompts"
$SkillsTarget = Join-Path $env:USERPROFILE ".copilot\skills"

Write-Host "=== Copilot Crew Updater ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Pull latest changes
Write-Host "[1/3] Pulling latest changes..." -ForegroundColor Yellow
Push-Location $RepoDir
try {
    git pull origin main 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: git pull failed. Check your network or resolve conflicts." -ForegroundColor Red
        Pop-Location
        exit 1
    }
    Write-Host "  OK — pulled latest from GitHub" -ForegroundColor Green
} finally {
    Pop-Location
}

# Step 2: Copy prompts (agents, instructions, prompts)
Write-Host "[2/3] Updating prompts..." -ForegroundColor Yellow
if (Test-Path $PromptsSource) {
    if (-not (Test-Path $PromptsTarget)) {
        New-Item -ItemType Directory -Path $PromptsTarget -Force | Out-Null
    }
    Copy-Item -Path "$PromptsSource\*" -Destination $PromptsTarget -Recurse -Force
    Write-Host "  OK — prompts updated at $PromptsTarget" -ForegroundColor Green
} else {
    Write-Host "  SKIP — prompts directory not found in repo" -ForegroundColor DarkYellow
}

# Step 3: Copy skills
Write-Host "[3/3] Updating skills..." -ForegroundColor Yellow
if (Test-Path $SkillsSource) {
    if (-not (Test-Path $SkillsTarget)) {
        New-Item -ItemType Directory -Path $SkillsTarget -Force | Out-Null
    }
    Copy-Item -Path "$SkillsSource\*" -Destination $SkillsTarget -Recurse -Force
    Write-Host "  OK — skills updated at $SkillsTarget" -ForegroundColor Green
} else {
    Write-Host "  SKIP — skills directory not found in repo" -ForegroundColor DarkYellow
}

# Done
$Version = if (Test-Path (Join-Path $RepoDir "VERSION")) { Get-Content (Join-Path $RepoDir "VERSION") -First 1 } else { "unknown" }
Write-Host ""
Write-Host "=== Update complete! Version: $Version ===" -ForegroundColor Cyan
Write-Host "Restart VS Code to apply changes." -ForegroundColor DarkGray
