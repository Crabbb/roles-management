# Простой тест валидации
Write-Host "=== ТЕСТ ВАЛИДАЦИИ АНАЛИТИКОВ ===" -ForegroundColor Green

# Проверка файлов
$files = @(
    "source/Business_Analyst_Custdev_Analyst_Description.markdown",
    "decomposed/business-custdev-analyst-skills-unified.md",
    "decomposed/business-custdev-analyst-skills-unified-table.md",
    "decomposed/business-custdev-analyst-skills-unified-export.csv"
)

$allExist = $true
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "OK: $file" -ForegroundColor Green
    } else {
        Write-Host "ERROR: $file not found" -ForegroundColor Red
        $allExist = $false
    }
}

if ($allExist) {
    Write-Host ""
    Write-Host "ALL FILES EXIST - TEST PASSED" -ForegroundColor Green
    
    # Проверка CSV
    $csv = Get-Content "decomposed/business-custdev-analyst-skills-unified-export.csv"
    $lineCount = ($csv | Measure-Object).Count
    Write-Host "CSV lines: $lineCount" -ForegroundColor Cyan
    
    # Проверка ролей
    $businessAnalyst = ($csv | Where-Object { $_ -match "Бизнес-аналитик" } | Measure-Object).Count
    $custdevAnalyst = ($csv | Where-Object { $_ -match "Custdev-аналитик" } | Measure-Object).Count
    
    Write-Host "Business Analyst skills: $businessAnalyst" -ForegroundColor Cyan
    Write-Host "Custdev Analyst skills: $custdevAnalyst" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "VALIDATION COMPLETED SUCCESSFULLY" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "SOME FILES MISSING - TEST FAILED" -ForegroundColor Red
} 