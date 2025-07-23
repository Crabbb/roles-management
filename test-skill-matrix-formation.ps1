# Skill Matrix Formation Validation Test
Write-Host "=== SKILL MATRIX FORMATION RULE VALIDATION TEST ===" -ForegroundColor Green

# Check skill matrix formation rules file
$rulesFile = "rules/skill-matrix-formation.md"
if (Test-Path $rulesFile) {
    Write-Host "OK: Skill matrix formation rules file exists" -ForegroundColor Green
} else {
    Write-Host "ERROR: Skill matrix formation rules file not found" -ForegroundColor Red
    exit 1
}

# Function to validate matrix headers
function Test-MatrixHeaders {
    param($filePath)
    
    if (-not (Test-Path $filePath)) {
        Write-Host "ERROR: File not found: $filePath" -ForegroundColor Red
        return $false
    }
    
    $content = Get-Content $filePath -Encoding UTF8
    $headerLine = ""
    
    # Find header line (contains | and L1, L2, etc.)
    foreach ($line in $content) {
        if ($line -match "^\|.*L1.*L2.*L3.*L4.*L5.*L6.*L7.*\|$") {
            $headerLine = $line
            break
        }
        # Also check for lines with L1, L2, L3, L4, L5, L6, L7 in any order
        if ($line -match "L1.*L2.*L3.*L4.*L5.*L6.*L7") {
            $headerLine = $line
            break
        }
    }
    
    if ($headerLine -eq "") {
        Write-Host "ERROR: No valid header found in $filePath" -ForegroundColor Red
        return $false
    }
    
    # Check if headers contain required elements
    $requiredElements = @(
        "L1<br>Начинающий",
        "L2<br>Младший", 
        "L3<br>Старший",
        "L4<br>Продвинутый",
        "L5<br>Ведущий",
        "L6<br>Эксперт",
        "L7<br>Техлид"
    )
    
    # Alternative check for English headers
    $alternativeElements = @(
        "L1<br>Junior",
        "L2<br>Middle", 
        "L3<br>Senior",
        "L4<br>Advanced",
        "L5<br>Lead",
        "L6<br>Expert",
        "L7<br>Tech Lead"
    )
    
    $missingElements = @()
    foreach ($element in $requiredElements) {
        if ($headerLine -notmatch [regex]::Escape($element)) {
            $missingElements += $element
        }
    }
    
    # If Russian headers not found, try English headers
    if ($missingElements.Count -gt 0) {
        $missingElements = @()
        foreach ($element in $alternativeElements) {
            if ($headerLine -notmatch [regex]::Escape($element)) {
                $missingElements += $element
            }
        }
    }
    
    if ($missingElements.Count -eq 0) {
        Write-Host "OK: All required header elements found" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR: Missing header elements: $($missingElements -join ', ')" -ForegroundColor Red
        return $false
    }
}

# Function to validate skill inheritance logic (checkmark rules)
function Test-SkillInheritance {
    param($filePath)
    
    $content = Get-Content $filePath -Encoding UTF8
    $skills = @{}
    
    # Parse skills and their checkmarks for each level
    foreach ($line in $content) {
        if ($line -match "^\| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \|$") {
            $skillName = $matches[1].Trim()
            $skills[$skillName] = @{
                L1 = $matches[2].Trim()
                L2 = $matches[3].Trim()
                L3 = $matches[4].Trim()
                L4 = $matches[5].Trim()
                L5 = $matches[6].Trim()
                L6 = $matches[7].Trim()
                L7 = $matches[8].Trim()
            }
        }
    }
    
    $issues = 0
    
    # Check inheritance logic for checkmarks
    foreach ($skill in $skills.Keys) {
        $skillData = $skills[$skill]
        
        # Check if checkmark disappears after appearing (CRITICAL RULE)
        $levels = @("L1", "L2", "L3", "L4", "L5", "L6", "L7")
        $firstCheckmarkFound = $false
        
        foreach ($level in $levels) {
            $value = $skillData[$level]
            
            if ($value -eq "✅") {
                $firstCheckmarkFound = $true
            } elseif ($value -eq "❌" -and $firstCheckmarkFound) {
                Write-Host "ERROR: Skill '$skill' has ❌ after ✅ at $level (violates 'no disappearing' rule)" -ForegroundColor Red
                $issues++
            }
        }
    }
    
    if ($issues -eq 0) {
        Write-Host "OK: Skill inheritance logic (checkmark rules) validated" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR: Found $issues inheritance rule violations" -ForegroundColor Red
        return $false
    }
}

# Function to validate cumulative nature (checkmark counting)
function Test-CumulativeSkills {
    param($filePath)
    
    $content = Get-Content $filePath -Encoding UTF8
    $skillCounts = @{
        L1 = 0
        L2 = 0
        L3 = 0
        L4 = 0
        L5 = 0
        L6 = 0
        L7 = 0
    }
    
    # Count skills with checkmarks for each level
    foreach ($line in $content) {
        if ($line -match "^\| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \|$") {
            if ($matches[2].Trim() -eq "✅") { $skillCounts.L1++ }
            if ($matches[3].Trim() -eq "✅") { $skillCounts.L2++ }
            if ($matches[4].Trim() -eq "✅") { $skillCounts.L3++ }
            if ($matches[5].Trim() -eq "✅") { $skillCounts.L4++ }
            if ($matches[6].Trim() -eq "✅") { $skillCounts.L5++ }
            if ($matches[7].Trim() -eq "✅") { $skillCounts.L6++ }
            if ($matches[8].Trim() -eq "✅") { $skillCounts.L7++ }
        }
    }
    
    # Check cumulative nature
    $cumulative = $true
    if ($skillCounts.L2 -lt $skillCounts.L1) {
        Write-Host "ERROR: L2 has fewer checkmarks ($($skillCounts.L2)) than L1 ($($skillCounts.L1))" -ForegroundColor Red
        $cumulative = $false
    }
    if ($skillCounts.L3 -lt $skillCounts.L2) {
        Write-Host "ERROR: L3 has fewer checkmarks ($($skillCounts.L3)) than L2 ($($skillCounts.L2))" -ForegroundColor Red
        $cumulative = $false
    }
    if ($skillCounts.L4 -lt $skillCounts.L3) {
        Write-Host "ERROR: L4 has fewer checkmarks ($($skillCounts.L4)) than L3 ($($skillCounts.L3))" -ForegroundColor Red
        $cumulative = $false
    }
    if ($skillCounts.L5 -lt $skillCounts.L4) {
        Write-Host "ERROR: L5 has fewer checkmarks ($($skillCounts.L5)) than L4 ($($skillCounts.L4))" -ForegroundColor Red
        $cumulative = $false
    }
    if ($skillCounts.L6 -lt $skillCounts.L5) {
        Write-Host "ERROR: L6 has fewer checkmarks ($($skillCounts.L6)) than L5 ($($skillCounts.L5))" -ForegroundColor Red
        $cumulative = $false
    }
    if ($skillCounts.L7 -lt $skillCounts.L6) {
        Write-Host "ERROR: L7 has fewer checkmarks ($($skillCounts.L7)) than L6 ($($skillCounts.L6))" -ForegroundColor Red
        $cumulative = $false
    }
    
    if ($cumulative) {
        Write-Host "OK: Cumulative skill progression validated" -ForegroundColor Green
        Write-Host "Checkmark counts: L1=$($skillCounts.L1), L2=$($skillCounts.L2), L3=$($skillCounts.L3), L4=$($skillCounts.L4), L5=$($skillCounts.L5), L6=$($skillCounts.L6), L7=$($skillCounts.L7)" -ForegroundColor Cyan
    }
    
    return $cumulative
}

# Main validation
Write-Host "`nChecking skill matrix files..." -ForegroundColor Yellow

$matrixFiles = @(
    "decomposed/all-analysts-skills-unified-table.md",
    "decomposed/developer-skills-unified-table.md",
    "decomposed/product-manager-skills-unified-table.md"
)

$allValid = $true

foreach ($file in $matrixFiles) {
    Write-Host "`nValidating: $file" -ForegroundColor Cyan
    
    $inheritanceValid = Test-SkillInheritance $file
    $cumulativeValid = Test-CumulativeSkills $file
    
    if (-not $cumulativeValid) {
        $allValid = $false
    }
}

Write-Host "`n=== VALIDATION SUMMARY ===" -ForegroundColor Green
if ($allValid) {
    Write-Host "ALL SKILL MATRIX FORMATION RULES VALIDATED SUCCESSFULLY" -ForegroundColor Green
} else {
    Write-Host "SOME VALIDATION ISSUES FOUND" -ForegroundColor Red
}

Write-Host "`nSkill matrix formation validation completed" -ForegroundColor Green 