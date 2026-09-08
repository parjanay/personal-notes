[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoPath = Split-Path -Parent $PSScriptRoot
$syncStatePath = Join-Path $env:LOCALAPPDATA 'PersonalNotesSync'
$logPath = Join-Path $syncStatePath 'sync.log'
$lockPath = Join-Path $syncStatePath 'sync.lock'

New-Item -ItemType Directory -Path $syncStatePath -Force | Out-Null

function Write-SyncLog {
    param([string]$Message)

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss K'
    Add-Content -LiteralPath $logPath -Value "$timestamp $Message"
}

if (Test-Path -LiteralPath $lockPath) {
    Write-SyncLog 'Skipped: another sync appears to be running.'
    exit 0
}

New-Item -ItemType File -Path $lockPath -Force | Out-Null

try {
    Set-Location -LiteralPath $repoPath

    $branch = (git branch --show-current).Trim()
    if ($LASTEXITCODE -ne 0 -or $branch -ne 'main') {
        throw "Expected the main branch, found '$branch'."
    }

    $changes = git status --porcelain
    if ($LASTEXITCODE -ne 0) {
        throw 'Could not read the repository status.'
    }

    if ($changes) {
        git add --all
        if ($LASTEXITCODE -ne 0) {
            throw 'Could not stage local changes.'
        }

        git diff --cached --quiet
        if ($LASTEXITCODE -eq 1) {
            $message = "chore: hourly notes sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
            git commit -m $message
            if ($LASTEXITCODE -ne 0) {
                throw 'Could not create the hourly sync commit.'
            }
            Write-SyncLog "Created local commit: $message"
        }
        elseif ($LASTEXITCODE -ne 0) {
            throw 'Could not inspect staged changes.'
        }
    }

    git push origin main
    if ($LASTEXITCODE -ne 0) {
        throw 'Push failed. No remote changes were overwritten; resolve the conflict before the next sync.'
    }

    Write-SyncLog 'Sync completed successfully.'
}
catch {
    Write-SyncLog "Sync failed: $($_.Exception.Message)"
    exit 1
}
finally {
    Remove-Item -LiteralPath $lockPath -Force -ErrorAction SilentlyContinue
}
