# Claude Code One-Click Installer - Windows PowerShell bootstrap
#
# One-liner usage (PowerShell as Administrator):
#   iex ($(try { irm <raw install.ps1 url> } catch { irm <jsdelivr install.ps1 url> }))
#
# Downloads src/installer.ps1 + src/config.json and runs the installer.
# Resilient to GitHub HTTP 429 rate limits: raw.githubusercontent.com and
# codeload can both 429 per IP, so each file falls back to the jsDelivr CDN,
# and finally to the repository zip archive.

$ErrorActionPreference = 'Stop'

$RawBase = 'https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/windows'
$CdnBase = 'https://cdn.jsdelivr.net/gh/peleg-jpg/claude-code-installer@main/windows'

$TempDir = Join-Path $env:TEMP ("ClaudeCodeInstaller_" + [System.IO.Path]::GetRandomFileName().Replace('.', ''))
New-Item -ItemType Directory -Path (Join-Path $TempDir 'src') -Force | Out-Null

function Get-InstallerFile([string]$RelPath, [string]$Dest) {
    try { Invoke-WebRequest -Uri "$RawBase/$RelPath" -OutFile $Dest -UseBasicParsing; return $true } catch {}
    try { Invoke-WebRequest -Uri "$CdnBase/$RelPath" -OutFile $Dest -UseBasicParsing; return $true } catch {}
    return $false
}

Write-Host 'Downloading installer files...'
$ok = (Get-InstallerFile 'src/config.json' (Join-Path $TempDir 'src\config.json')) -and
      (Get-InstallerFile 'src/installer.ps1' (Join-Path $TempDir 'src\installer.ps1'))

if (-not $ok) {
    Write-Host 'Direct downloads failed (GitHub may be rate-limiting). Trying repository archive...'
    try {
        $zip = Join-Path $TempDir 'repo.zip'
        Invoke-WebRequest -Uri 'https://github.com/peleg-jpg/claude-code-installer/archive/main.zip' -OutFile $zip -UseBasicParsing
        Expand-Archive -LiteralPath $zip -DestinationPath (Join-Path $TempDir 'repo') -Force
        Copy-Item (Join-Path $TempDir 'repo\claude-code-installer-main\windows\src\config.json') (Join-Path $TempDir 'src\config.json') -Force
        Copy-Item (Join-Path $TempDir 'repo\claude-code-installer-main\windows\src\installer.ps1') (Join-Path $TempDir 'src\installer.ps1') -Force
    } catch {
        Write-Host 'ERROR: Failed to download installer files from GitHub.'
        Write-Host 'Please check your internet connection and try again.'
        exit 1
    }
}

Write-Host 'Files downloaded successfully!'
Write-Host ''
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $TempDir 'src\installer.ps1')
