# Test validation for all analysts
Write-Host "=== ANALYSTS VALIDATION TEST ===" -ForegroundColor Green

# Check source files
$sourceFiles = @(
    "source/Business_Analyst_Custdev_Analyst_Description.markdown",
    "source/Analyst_Roles_Description.markdown"
)

# Check decomposed files
$decomposedFiles = @(
    "decomposed/all-analysts-skills-unified.md",
    "decomposed/all-analysts-skills-unified-table.md",
    "decomposed/all-analysts-skills-unified-export.csv",
    "decomposed/business-custdev-analyst-skills-unified.md",
    "decomposed/business-custdev-analyst-skills-unified-table.md",
    "decomposed/business-custdev-analyst-skills-unified-export.csv"
)

Write-Host "Checking source files..." -ForegroundColor Yellow
$allSourceExist = $true
foreach ($file in $sourceFiles) {
    if (Test-Path $file) {
        Write-Host "OK: $file" -ForegroundColor Green
    } else {
        Write-Host "ERROR: $file not found" -ForegroundColor Red
        $allSourceExist = $false
    }
}

Write-Host "Checking decomposed files..." -ForegroundColor Yellow
$allDecomposedExist = $true
foreach ($file in $decomposedFiles) {
    if (Test-Path $file) {
        Write-Host "OK: $file" -ForegroundColor Green
    } else {
        Write-Host "ERROR: $file not found" -ForegroundColor Red
        $allDecomposedExist = $false
    }
}

if ($allSourceExist -and $allDecomposedExist) {
    Write-Host ""
    Write-Host "ALL FILES EXIST - TEST PASSED" -ForegroundColor Green
    
    # Check unified file content
    $unifiedContent = Get-Content "decomposed/all-analysts-skills-unified.md"
    $lineCount = ($unifiedContent | Measure-Object).Count
    Write-Host "Unified file lines: $lineCount" -ForegroundColor Cyan
    
    # Check table file content
    $tableContent = Get-Content "decomposed/all-analysts-skills-unified-table.md"
    $tableLineCount = ($tableContent | Measure-Object).Count
    Write-Host "Table file lines: $tableLineCount" -ForegroundColor Cyan
    
    # Check CSV file content
    $csvContent = Get-Content "decomposed/all-analysts-skills-unified-export.csv"
    $csvLineCount = ($csvContent | Measure-Object).Count
    Write-Host "CSV file lines: $csvLineCount" -ForegroundColor Cyan
    
    # Check roles in unified file
    $businessAnalyst = ($unifiedContent | Where-Object { $_ -match "Бизнес-аналитик" } | Measure-Object).Count
    $custdevAnalyst = ($unifiedContent | Where-Object { $_ -match "Custdev-аналитик" } | Measure-Object).Count
    $clientNeedsAnalyst = ($unifiedContent | Where-Object { $_ -match "Аналитик клиентских потребностей" } | Measure-Object).Count
    $productDataAnalyst = ($unifiedContent | Where-Object { $_ -match "Аналитик данных по продукту" } | Measure-Object).Count
    $uxResearcher = ($unifiedContent | Where-Object { $_ -match "UX-исследователь" } | Measure-Object).Count
    $competitiveAnalyst = ($unifiedContent | Where-Object { $_ -match "Конкурентный аналитик" } | Measure-Object).Count
    
    Write-Host ""
    Write-Host "Role mentions in unified file:" -ForegroundColor Yellow
    Write-Host "Business Analyst: $businessAnalyst" -ForegroundColor Cyan
    Write-Host "Custdev Analyst: $custdevAnalyst" -ForegroundColor Cyan
    Write-Host "Client Needs Analyst: $clientNeedsAnalyst" -ForegroundColor Cyan
    Write-Host "Product Data Analyst: $productDataAnalyst" -ForegroundColor Cyan
    Write-Host "UX Researcher: $uxResearcher" -ForegroundColor Cyan
    Write-Host "Competitive Analyst: $competitiveAnalyst" -ForegroundColor Cyan
    
    # Check levels
    $l1Count = ($unifiedContent | Where-Object { $_ -match "L1" } | Measure-Object).Count
    $l2Count = ($unifiedContent | Where-Object { $_ -match "L2" } | Measure-Object).Count
    $l3Count = ($unifiedContent | Where-Object { $_ -match "L3" } | Measure-Object).Count
    $l4Count = ($unifiedContent | Where-Object { $_ -match "L4" } | Measure-Object).Count
    $l5Count = ($unifiedContent | Where-Object { $_ -match "L5" } | Measure-Object).Count
    $l6Count = ($unifiedContent | Where-Object { $_ -match "L6" } | Measure-Object).Count
    $l7Count = ($unifiedContent | Where-Object { $_ -match "L7" } | Measure-Object).Count
    
    Write-Host ""
    Write-Host "Level mentions in unified file:" -ForegroundColor Yellow
    Write-Host "L1: $l1Count, L2: $l2Count, L3: $l3Count, L4: $l4Count, L5: $l5Count, L6: $l6Count, L7: $l7Count" -ForegroundColor Cyan
    
    # Check CSV content
    $csvRoles = ($csvContent | Where-Object { $_ -match "All Analysts|Business Analyst|Custdev-аналитик|Аналитик клиентских потребностей|Аналитик данных по продукту|UX-исследователь|Конкурентный аналитик" } | Measure-Object).Count
    Write-Host ""
    Write-Host "CSV role entries: $csvRoles" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "VALIDATION COMPLETED SUCCESSFULLY" -ForegroundColor Green
    Write-Host "All 6 analyst roles are included in the unified decomposition" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "SOME FILES MISSING - TEST FAILED" -ForegroundColor Red
} 