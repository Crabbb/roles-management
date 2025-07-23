# ESCO Validation Test
Write-Host "=== ESCO STANDARD VALIDATION TEST ===" -ForegroundColor Green

# Check ESCO rules file
$escoRulesFile = "rules/esco-standards.md"
if (Test-Path $escoRulesFile) {
    Write-Host "OK: ESCO rules file exists" -ForegroundColor Green
} else {
    Write-Host "ERROR: ESCO rules file not found" -ForegroundColor Red
    exit 1
}

# Function to validate CSV format
function Test-CSVFormat {
    param($filePath)
    
    if (-not (Test-Path $filePath)) {
        Write-Host "ERROR: File not found: $filePath" -ForegroundColor Red
        return $false
    }
    
    $content = Get-Content $filePath -Encoding UTF8
    $lineCount = ($content | Measure-Object).Count
    
    if ($lineCount -lt 2) {
        Write-Host "ERROR: File has less than 2 lines: $filePath" -ForegroundColor Red
        return $false
    }
    
    # Check header
    $header = $content[0]
    if ($header -notmatch "skill name:separator:skill description") {
        Write-Host "ERROR: Invalid header format in $filePath" -ForegroundColor Red
        return $false
    }
    
    # Check data lines
    $validLines = 0
    $invalidLines = 0
    
    for ($i = 1; $i -lt $lineCount; $i++) {
        $line = $content[$i]
        if ($line -match "^[^:]+:separator:[^:]+$") {
            $validLines++
        } else {
            $invalidLines++
            Write-Host "WARNING: Invalid line format at line $($i+1): $line" -ForegroundColor Yellow
        }
    }
    
    Write-Host "File: $filePath" -ForegroundColor Cyan
    Write-Host "  Total lines: $lineCount" -ForegroundColor Cyan
    Write-Host "  Valid lines: $validLines" -ForegroundColor Green
    Write-Host "  Invalid lines: $invalidLines" -ForegroundColor Yellow
    
    return $invalidLines -eq 0
}

# Function to validate skill count
function Test-SkillCount {
    param($filePath)
    
    $content = Get-Content $filePath -Encoding UTF8
    $skillCount = ($content | Measure-Object).Count - 1  # Exclude header
    
    if ($skillCount -ge 5 -and $skillCount -le 10) {
        Write-Host "OK: Skill count $skillCount is within range (5-10)" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR: Skill count $skillCount is outside range (5-10)" -ForegroundColor Red
        return $false
    }
}

# Function to validate skill uniqueness
function Test-SkillUniqueness {
    param($filePath)
    
    $content = Get-Content $filePath -Encoding UTF8
    $skills = @()
    
    for ($i = 1; $i -lt $content.Count; $i++) {
        $line = $content[$i]
        if ($line -match "^([^:]+):separator:") {
            $skillName = $matches[1]
            $skills += $skillName
        }
    }
    
    $uniqueSkills = $skills | Sort-Object | Get-Unique
    $duplicates = $skills.Count - $uniqueSkills.Count
    
    if ($duplicates -eq 0) {
        Write-Host "OK: All skills are unique" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR: Found $duplicates duplicate skills" -ForegroundColor Red
        return $false
    }
}

# Function to validate skill descriptions
function Test-SkillDescriptions {
    param($filePath)
    
    $content = Get-Content $filePath -Encoding UTF8
    $roleSpecificTerms = @("аналитик", "бизнес-аналитик", "custdev", "ux", "конкурентный")
    $issues = 0
    
    for ($i = 1; $i -lt $content.Count; $i++) {
        $line = $content[$i]
        if ($line -match ":separator:(.+)$") {
            $description = $matches[1]
            
            foreach ($term in $roleSpecificTerms) {
                if ($description -match $term) {
                    Write-Host "WARNING: Role-specific term '$term' found in description at line $($i+1)" -ForegroundColor Yellow
                    $issues++
                }
            }
        }
    }
    
    if ($issues -eq 0) {
        Write-Host "OK: All descriptions are abstract" -ForegroundColor Green
        return $true
    } else {
        Write-Host "WARNING: Found $issues role-specific terms in descriptions" -ForegroundColor Yellow
        return $false
    }
}

# Main validation
Write-Host "`nChecking ESCO CSV files..." -ForegroundColor Yellow

$csvFiles = @(
    "decomposed/business-analyst-esco.csv",
    "decomposed/custdev-analyst-esco.csv", 
    "decomposed/client-needs-analyst-esco.csv",
    "decomposed/product-data-analyst-esco.csv",
    "decomposed/ux-researcher-esco.csv",
    "decomposed/competitive-analyst-esco.csv"
)

$allValid = $true

foreach ($file in $csvFiles) {
    Write-Host "`nValidating: $file" -ForegroundColor Cyan
    
    $formatValid = Test-CSVFormat $file
    $countValid = Test-SkillCount $file
    $uniquenessValid = Test-SkillUniqueness $file
    $descriptionsValid = Test-SkillDescriptions $file
    
    if (-not $formatValid -or -not $countValid -or -not $uniquenessValid) {
        $allValid = $false
    }
}

Write-Host "`n=== VALIDATION SUMMARY ===" -ForegroundColor Green
if ($allValid) {
    Write-Host "ALL ESCO FILES VALIDATED SUCCESSFULLY" -ForegroundColor Green
} else {
    Write-Host "SOME VALIDATION ISSUES FOUND" -ForegroundColor Red
}

Write-Host "`nESCO validation completed" -ForegroundColor Green 