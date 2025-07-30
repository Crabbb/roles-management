# Rename CSV folder to avoid Git issues with Cyrillic characters
Write-Host "=== RENAMING CSV FOLDER ===" -ForegroundColor Green

$oldPath = "decomposed/CSV формат"
$newPath = "decomposed/CSV-format"

if (Test-Path $oldPath) {
    Write-Host "Renaming '$oldPath' to '$newPath'..." -ForegroundColor Yellow
    
    try {
        Rename-Item -Path $oldPath -NewName "CSV-format"
        Write-Host "✅ Folder renamed successfully!" -ForegroundColor Green
        
        # Update references in files
        Write-Host "Updating file references..." -ForegroundColor Yellow
        
        # Update test files
        $filesToUpdate = @(
            "test-skill-matrix-formation.ps1",
            "test-csv-validation.ps1",
            "update-csv-files.ps1"
        )
        
        foreach ($file in $filesToUpdate) {
            if (Test-Path $file) {
                $content = Get-Content $file -Raw
                $updatedContent = $content -replace "CSV формат", "CSV-format"
                Set-Content $file -Value $updatedContent -Encoding UTF8
                Write-Host "Updated: $file" -ForegroundColor Green
            }
        }
        
        Write-Host "✅ All references updated!" -ForegroundColor Green
        
    } catch {
        Write-Host "❌ Error renaming folder: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Old folder not found: $oldPath" -ForegroundColor Red
}

Write-Host "`nRenaming completed!" -ForegroundColor Green 