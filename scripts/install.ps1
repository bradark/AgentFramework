<#
.SYNOPSIS
  Installs AgentFramework agents and skills for Claude Code and/or GitHub Copilot.

.DESCRIPTION
  -Target ClaudeUser     Install into your user profile (~/.claude). Available in every project.
  -Target ClaudeProject  Install into <Repo>/.claude (+ CLAUDE.md, settings.json if absent).
  -Target Copilot        Install into <Repo>/.github (agents, prompts, skills, copilot-instructions.md).

  Existing files are skipped unless -Force is given. Files are copied, not linked,
  so re-run after pulling framework updates.

.EXAMPLE
  .\scripts\install.ps1 -Target ClaudeUser
  .\scripts\install.ps1 -Target ClaudeProject -Repo ..\MarketPrice
  .\scripts\install.ps1 -Target Copilot -Repo ..\MarketPrice -Force
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('ClaudeUser', 'ClaudeProject', 'Copilot')]
    [string]$Target,

    [string]$Repo,

    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$FrameworkRoot = Split-Path -Parent $PSScriptRoot

function Copy-Item-Safe {
    param([string]$Source, [string]$Destination)

    if ((Test-Path $Destination) -and -not $Force) {
        Write-Host "  skip    $Destination (exists; use -Force to overwrite)" -ForegroundColor Yellow
        return
    }
    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    Copy-Item -Path $Source -Destination $Destination -Recurse -Force
    Write-Host "  install $Destination" -ForegroundColor Green
}

function Install-SkillDirs {
    param([string[]]$SourceRoots, [string]$DestRoot)

    foreach ($root in $SourceRoots) {
        Get-ChildItem -Path $root -Directory | ForEach-Object {
            $dest = Join-Path $DestRoot $_.Name
            if ((Test-Path $dest) -and $Force) { Remove-Item -Path $dest -Recurse -Force }
            Copy-Item-Safe -Source $_.FullName -Destination $dest
        }
    }
}

function Install-Files {
    param([string]$SourceDir, [string]$Filter, [string]$DestDir)

    Get-ChildItem -Path $SourceDir -Filter $Filter -File | ForEach-Object {
        Copy-Item-Safe -Source $_.FullName -Destination (Join-Path $DestDir $_.Name)
    }
}

function Add-GitIgnoreEntry {
    param([string]$RepoPath)

    $gitignore = Join-Path $RepoPath '.gitignore'
    $entry = '.agent-work/'
    if ((Test-Path $gitignore) -and (Select-String -Path $gitignore -SimpleMatch $entry -Quiet)) { return }
    Add-Content -Path $gitignore -Value "`n# AgentFramework loop state`n$entry" -Encoding utf8
    Write-Host "  update  $gitignore (+ $entry)" -ForegroundColor Green
}

function Resolve-Repo {
    if (-not $Repo) { throw "-Repo is required for -Target $Target" }
    if (-not (Test-Path (Join-Path $Repo '.git'))) { throw "'$Repo' is not a git repository" }
    return (Resolve-Path $Repo).Path
}

$portableSkills = Join-Path $FrameworkRoot 'skills'
$claudeDir = Join-Path $FrameworkRoot 'claude'
$copilotDir = Join-Path $FrameworkRoot 'copilot'

switch ($Target) {
    'ClaudeUser' {
        $dest = Join-Path $HOME '.claude'
        Write-Host "Installing Claude agents and skills into $dest"
        Install-SkillDirs -SourceRoots @($portableSkills, (Join-Path $claudeDir 'skills')) -DestRoot (Join-Path $dest 'skills')
        Install-Files -SourceDir (Join-Path $claudeDir 'agents') -Filter '*.md' -DestDir (Join-Path $dest 'agents')
        Copy-Item-Safe -Source (Join-Path $claudeDir 'CLAUDE.md') -Destination (Join-Path $dest 'CLAUDE.md')
        Copy-Item-Safe -Source (Join-Path $claudeDir 'settings.json') -Destination (Join-Path $dest 'settings.json')
        Write-Host "`nIf CLAUDE.md or settings.json were skipped, merge them by hand from $claudeDir." -ForegroundColor Cyan
    }
    'ClaudeProject' {
        $repoPath = Resolve-Repo
        $dest = Join-Path $repoPath '.claude'
        Write-Host "Installing Claude agents and skills into $dest"
        Install-SkillDirs -SourceRoots @($portableSkills, (Join-Path $claudeDir 'skills')) -DestRoot (Join-Path $dest 'skills')
        Install-Files -SourceDir (Join-Path $claudeDir 'agents') -Filter '*.md' -DestDir (Join-Path $dest 'agents')
        Copy-Item-Safe -Source (Join-Path $claudeDir 'settings.json') -Destination (Join-Path $dest 'settings.json')
        Copy-Item-Safe -Source (Join-Path $claudeDir 'CLAUDE.md') -Destination (Join-Path $repoPath 'CLAUDE.md')
        Add-GitIgnoreEntry -RepoPath $repoPath
    }
    'Copilot' {
        $repoPath = Resolve-Repo
        $dest = Join-Path $repoPath '.github'
        Write-Host "Installing Copilot agents, prompts, and skills into $dest"
        Install-SkillDirs -SourceRoots @($portableSkills) -DestRoot (Join-Path $dest 'skills')
        Install-Files -SourceDir (Join-Path $copilotDir 'agents') -Filter '*.agent.md' -DestDir (Join-Path $dest 'agents')
        Install-Files -SourceDir (Join-Path $copilotDir 'prompts') -Filter '*.prompt.md' -DestDir (Join-Path $dest 'prompts')
        Copy-Item-Safe -Source (Join-Path $copilotDir 'copilot-instructions.md') -Destination (Join-Path $dest 'copilot-instructions.md')
        Add-GitIgnoreEntry -RepoPath $repoPath
    }
}

Write-Host "`nDone." -ForegroundColor Cyan
