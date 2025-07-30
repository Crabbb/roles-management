# CSV Validation Test Script
# Проверяет корректность CSV файлов согласно инструкции

Write-Host "=== CSV VALIDATION TEST ===" -ForegroundColor Green

$csvFolder = "decomposed/CSV-format"
$csvFiles = @("analyst-skills.csv", "developer-skills.csv", "product-manager-skills.csv")

# Проверка существования папки
if (-not (Test-Path $csvFolder)) {
    Write-Host "ERROR: Папка '$csvFolder' не найдена" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Папка CSV файлов найдена" -ForegroundColor Green

# Проверка каждого CSV файла
foreach ($file in $csvFiles) {
    $filePath = Join-Path $csvFolder $file
    Write-Host "`nValidating: $file" -ForegroundColor Yellow
    
    if (-not (Test-Path $filePath)) {
        Write-Host "ERROR: Файл '$file' не найден" -ForegroundColor Red
        continue
    }
    
    $content = Get-Content $filePath -Encoding UTF8
    
    # Проверка заголовков
    if ($content.Count -eq 0) {
        Write-Host "ERROR: Файл '$file' пустой" -ForegroundColor Red
        continue
    }
    
    $header = $content[0]
    if ($header -ne "skill name:separator:skill description") {
        Write-Host "ERROR: Неправильный заголовок в '$file'" -ForegroundColor Red
        Write-Host "Ожидается: skill name:separator:skill description" -ForegroundColor Red
        Write-Host "Получено: $header" -ForegroundColor Red
        continue
    }
    
    Write-Host "OK: Заголовки корректны" -ForegroundColor Green
    
    # Проверка разделителя
    $separator = ":separator:"
    $linesWithData = $content[1..($content.Count-1)]
    $invalidLines = @()
    
    foreach ($line in $linesWithData) {
        if ($line -and -not $line.Contains($separator)) {
            $invalidLines += $line
        }
    }
    
    if ($invalidLines.Count -gt 0) {
        Write-Host "ERROR: Найдены строки без правильного разделителя в '$file':" -ForegroundColor Red
        foreach ($line in $invalidLines) {
            Write-Host "  $line" -ForegroundColor Red
        }
        continue
    }
    
    Write-Host "OK: Разделитель корректный" -ForegroundColor Green
    
    # Проверка на английские названия навыков (должны быть удалены)
    $englishPatterns = @(
        "\(work under supervision\)",
        "\(work independently\)",
        "\(manage staff\)",
        "\(train employees\)",
        "\(implement new procedures\)",
        "\(develop methodologies\)",
        "\(gather requirements\)",
        "\(analyse business processes\)",
        "\(document requirements\)",
        "\(create process flow diagrams\)",
        "\(identify impact of change\)",
        "\(negotiate with stakeholders\)",
        "\(manage product backlog\)",
        "\(create prototypes\)",
        "\(re-engineer business processes\)",
        "\(maintain documentation\)",
        "\(identify technical limitations\)",
        "\(coordinate project activities\)",
        "\(conduct interviews\)",
        "\(conduct surveys\)",
        "\(design questionnaires\)",
        "\(classify data\)",
        "\(identify patterns\)",
        "\(record customer requirements\)",
        "\(use data analysis tools\)",
        "\(perform statistical analysis\)",
        "\(perform A/B testing\)",
        "\(create dashboards\)",
        "\(forecast trends\)",
        "\(optimise key performance indicators\)",
        "\(conduct usability testing\)",
        "\(develop information architecture\)",
        "\(create personas\)",
        "\(analyse behaviour data\)",
        "\(manage research projects\)",
        "\(monitor competitor activities\)",
        "\(conduct SWOT analysis\)",
        "\(analyse market trends\)",
        "\(analyse pricing strategies\)",
        "\(analyse financial performance\)",
        "\(develop competitive strategies\)"
    )
    
    $linesWithEnglish = @()
    foreach ($line in $linesWithData) {
        foreach ($pattern in $englishPatterns) {
            if ($line -match $pattern) {
                $linesWithEnglish += $line
                break
            }
        }
    }
    
    if ($linesWithEnglish.Count -gt 0) {
        Write-Host "ERROR: Найдены строки с английскими названиями в '$file':" -ForegroundColor Red
        foreach ($line in $linesWithEnglish) {
            Write-Host "  $line" -ForegroundColor Red
        }
        continue
    }
    
    Write-Host "OK: Английские названия удалены" -ForegroundColor Green
    
    # Подсчет строк с данными
    $dataLines = ($linesWithData | Where-Object { $_ -and $_ -ne "" }).Count
    Write-Host "OK: Найдено $dataLines строк с данными" -ForegroundColor Green
}

Write-Host "`n=== VALIDATION SUMMARY ===" -ForegroundColor Green
Write-Host "CSV validation completed" -ForegroundColor Green 