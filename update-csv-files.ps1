# Update CSV Files Script
# Автоматически обновляет CSV файлы при изменении навыков

Write-Host "=== UPDATE CSV FILES ===" -ForegroundColor Green

$csvFolder = "decomposed/CSV-format"

# Проверка существования папки
if (-not (Test-Path $csvFolder)) {
    New-Item -ItemType Directory -Path $csvFolder -Force
    Write-Host "Создана папка: $csvFolder" -ForegroundColor Green
}

# Функция для создания CSV из markdown файла
function Create-CSVFromMarkdown {
    param(
        [string]$MarkdownFile,
        [string]$CSVFile
    )
    
    if (-not (Test-Path $MarkdownFile)) {
        Write-Host "ERROR: Файл '$MarkdownFile' не найден" -ForegroundColor Red
        return $false
    }
    
    $content = Get-Content $MarkdownFile -Encoding UTF8
    $skills = @()
    
    foreach ($line in $content) {
        # Ищем строки с навыками (не пустые, не заголовки)
        if ($line -match "^[^-].*" -and $line.Trim() -ne "" -and $line -notmatch "^#") {
            $skill = $line.Trim()
            # Удаляем английские названия в скобках
            $skill = $skill -replace "\s*\([^)]*\)", ""
            if ($skill -ne "") {
                $skills += $skill
            }
        }
    }
    
    # Создаем CSV контент
    $csvContent = "skill name:separator:skill description`n"
    foreach ($skill in $skills) {
        $csvContent += "$skill:separator:Описание навыка $skill`n"
    }
    
    # Записываем в файл
    $csvContent | Out-File -FilePath $CSVFile -Encoding UTF8
    Write-Host "OK: Создан файл $CSVFile с $($skills.Count) навыками" -ForegroundColor Green
    return $true
}

# Обновляем CSV файлы
Write-Host "`nОбновление CSV файлов..." -ForegroundColor Yellow

$success = $true

# Аналитики
if (-not (Create-CSVFromMarkdown "analyst-skills-list.md" "$csvFolder/analyst-skills.csv")) {
    $success = $false
}

# Разработчики
if (-not (Create-CSVFromMarkdown "developer-skills-list.md" "$csvFolder/developer-skills.csv")) {
    $success = $false
}

# Продукт-менеджеры
if (-not (Create-CSVFromMarkdown "product-manager-skills-list.md" "$csvFolder/product-manager-skills.csv")) {
    $success = $false
}

if ($success) {
    Write-Host "`nВсе CSV файлы успешно обновлены!" -ForegroundColor Green
} else {
    Write-Host "`nОшибки при обновлении CSV файлов!" -ForegroundColor Red
    exit 1
}

Write-Host "`nЗапуск тестов валидации..." -ForegroundColor Yellow
& .\test-csv-validation.ps1 