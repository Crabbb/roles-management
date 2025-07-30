# Git Sync Script
Write-Host "=== GIT SYNC ===" -ForegroundColor Green

# Change to project directory
Set-Location -Path "roles-management"

Write-Host "1. Checking Git status..." -ForegroundColor Yellow
git status

Write-Host "`n2. Adding all changes..." -ForegroundColor Yellow
git add -A

Write-Host "`n3. Creating commit..." -ForegroundColor Yellow
git commit -m "Organized project reports and updated documentation"

Write-Host "`n4. Pushing changes..." -ForegroundColor Yellow
git push

Write-Host "`nSync completed!" -ForegroundColor Green 