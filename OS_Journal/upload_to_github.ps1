# PowerShell script to upload OS Journal to GitHub
# Repository URL provided by user
$RepoUrl = "https://github.com/Saurabh-report/operating-system.git"
$LogFile = "$PSScriptRoot\upload_log.txt"

Start-Transcript -Path $LogFile -Force

Write-Host "=========================================="
Write-Host "   Uploading OS Journal to GitHub"
Write-Host "=========================================="

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is NOT installed or not in your PATH."
    Write-Host "Please download Git from https://git-scm.com/download/win"
    Stop-Transcript
    Pause
    Exit
}

# Navigate to script location
Set-Location $PSScriptRoot

Write-Host "[1/6] Initializing Git Repository..."
if (-not (Test-Path ".git")) {
    git init
}

Write-Host "[2/6] Adding files..."
git add .

Write-Host "[3/6] Committing files..."
git commit -m "Initial commit of Operating Systems Journal Phases 1-7" --allow-empty

Write-Host "[4/6] Renaming branch to main..."
git branch -M main

Write-Host "[5/6] Adding remote origin..."
git remote remove origin 2>$null
git remote add origin $RepoUrl

Write-Host "[6/6] Pushing to GitHub..."
Write-Host "NOTE: A login window may appear. Please check your taskbar."
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSUCCESS: Files uploaded to $RepoUrl"
}
else {
    Write-Host "`nERROR: Push failed. Return code: $LASTEXITCODE"
    Write-Host "Check the 'upload_log.txt' file in this folder for details."
}

Stop-Transcript
Write-Host "Press Enter to close..."
Read-Host
