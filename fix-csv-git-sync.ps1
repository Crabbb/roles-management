# Fix CSV folder Git issues and sync
Write-Host "=== FIXING CSV FOLDER GIT ISSUES ===" -ForegroundColor Green

# Step 1: Rename the folder if it exists with Cyrillic characters
$oldPath = "decomposed/CSV формат"
$newPath = "decomposed/CSV-format"

if (Test-Path $oldPath) {
    Write-Host "`n1. Renaming folder with Cyrillic characters..." -ForegroundColor Yellow
    try {
        Rename-Item -Path $oldPath -NewName "CSV-format"
        Write-Host "✅ Folder renamed: '$oldPath' → '$newPath'" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error renaming: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 2: Update file references
Write-Host "`n2. Updating file references..." -ForegroundColor Yellow

$filesToUpdate = @(
    "test-skill-matrix-formation.ps1",
    "test-csv-validation.ps1", 
    "update-csv-files.ps1",
    "PROJECT-STRUCTURE.md"
)

foreach ($file in $filesToUpdate) {
    if (Test-Path $file) {
        try {
            $content = Get-Content $file -Raw
            $updatedContent = $content -replace "CSV формат", "CSV-format"
            Set-Content $file -Value $updatedContent -Encoding UTF8
            Write-Host "✅ Updated: $file" -ForegroundColor Green
        } catch {
            Write-Host "❌ Error updating $file: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Step 3: Check Git status
Write-Host "`n3. Checking Git status..." -ForegroundColor Yellow

try {
    $gitStatus = git status --porcelain
    Write-Host "Git status:" -ForegroundColor Cyan
    Write-Host $gitStatus -ForegroundColor White
} catch {
    Write-Host "❌ Error checking Git status: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Add all files to Git
Write-Host "`n4. Adding all files to Git..." -ForegroundColor Yellow

try {
    git add -A
    Write-Host "✅ All files added to Git" -ForegroundColor Green
} catch {
    Write-Host "❌ Error adding files: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 5: Check status again
Write-Host "`n5. Final Git status..." -ForegroundColor Yellow

try {
    $finalStatus = git status
    Write-Host "Final status:" -ForegroundColor Cyan
    Write-Host $finalStatus -ForegroundColor White
} catch {
    Write-Host "❌ Error checking final status: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== CSV FOLDER GIT FIX COMPLETED ===" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Review the changes above" -ForegroundColor White
Write-Host "2. Run: git commit -m 'Fixed CSV folder name and updated references'" -ForegroundColor White
Write-Host "3. Run: git push" -ForegroundColor White 