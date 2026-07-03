# Drishti's Agents for Claude - Windows installer
# Copies agents and skills into your user-level Claude Code folders.
$ErrorActionPreference = "Stop"

$claudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME ".claude" }
$repoRoot  = $PSScriptRoot

New-Item -ItemType Directory -Force (Join-Path $claudeDir "agents") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $claudeDir "skills") | Out-Null

Copy-Item (Join-Path $repoRoot "agents\*") (Join-Path $claudeDir "agents\") -Force
Copy-Item (Join-Path $repoRoot "skills\*") (Join-Path $claudeDir "skills\") -Recurse -Force

Write-Host ""
Write-Host "Installed to $claudeDir :" -ForegroundColor Green
Write-Host "  - agents\totem.md"
Write-Host "  - agents\rancho.md"
Write-Host "  - skills\unagi\SKILL.md"
Write-Host ""
Write-Host "Restart Claude Code, then try: 'run totem' or '/unagi'"
