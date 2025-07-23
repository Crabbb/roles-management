# Скрипт валидации декомпозиции навыков аналитиков
# Проверяет корректность и полноту документации

Write-Host "=== ВАЛИДАЦИЯ ДЕКОМПОЗИЦИИ НАВЫКОВ АНАЛИТИКОВ ===" -ForegroundColor Green
Write-Host ""

# Проверка существования файлов
$sourceFile = "source/Business_Analyst_Custdev_Analyst_Description.markdown"
$unifiedFile = "decomposed/business-custdev-analyst-skills-unified.md"
$tableFile = "decomposed/business-custdev-analyst-skills-unified-table.md"
$csvFile = "decomposed/business-custdev-analyst-skills-unified-export.csv"

$files = @($sourceFile, $unifiedFile, $tableFile, $csvFile)
$allFilesExist = $true

Write-Host "Проверка существования файлов:" -ForegroundColor Yellow
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "OK $file" -ForegroundColor Green
    } else {
        Write-Host "ERROR $file - НЕ НАЙДЕН" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host ""
    Write-Host "ОШИБКА: Не все необходимые файлы найдены!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Проверка структуры файлов:" -ForegroundColor Yellow

# Проверка исходного файла
Write-Host "Проверка исходного файла..." -ForegroundColor Cyan
$sourceContent = Get-Content $sourceFile -Raw
if ($sourceContent -match "# Бизнес-аналитик и Custdev-аналитик") {
    Write-Host "OK Заголовок найден" -ForegroundColor Green
} else {
    Write-Host "ERROR Заголовок не найден" -ForegroundColor Red
}

# Проверка уровней в исходном файле
$levels = @(
    "Начинающий бизнес-аналитик",
    "Младший бизнес-аналитик", 
    "Старший бизнес-аналитик",
    "Продвинутый бизнес-аналитик",
    "Ведущий бизнес-аналитик",
    "Эксперт бизнес-аналитик",
    "Техлид бизнес-аналитиков",
    "Начинающий Custdev-аналитик",
    "Младший Custdev-аналитик",
    "Старший Custdev-аналитик", 
    "Продвинутый Custdev-аналитик",
    "Ведущий Custdev-аналитик",
    "Эксперт Custdev-аналитик",
    "Техлид Custdev-аналитиков"
)

Write-Host "Проверка уровней в исходном файле:" -ForegroundColor Cyan
$allLevelsFound = $true
foreach ($level in $levels) {
    if ($sourceContent -match $level) {
        Write-Host "OK $level" -ForegroundColor Green
    } else {
        Write-Host "ERROR $level - НЕ НАЙДЕН" -ForegroundColor Red
        $allLevelsFound = $false
    }
}

# Проверка унифицированного файла
Write-Host ""
Write-Host "Проверка унифицированного файла..." -ForegroundColor Cyan
$unifiedContent = Get-Content $unifiedFile -Raw

if ($unifiedContent -match "Унифицированная декомпозиция навыков") {
    Write-Host "OK Заголовок найден" -ForegroundColor Green
} else {
    Write-Host "ERROR Заголовок не найден" -ForegroundColor Red
}

if ($unifiedContent -match "Метаданные") {
    Write-Host "OK Секция метаданных найдена" -ForegroundColor Green
} else {
    Write-Host "ERROR Секция метаданных не найдена" -ForegroundColor Red
}

if ($unifiedContent -match "Унифицированная матрица навыков") {
    Write-Host "OK Матрица навыков найдена" -ForegroundColor Green
} else {
    Write-Host "ERROR Матрица навыков не найдена" -ForegroundColor Red
}

# Проверка табличного файла
Write-Host ""
Write-Host "Проверка табличного файла..." -ForegroundColor Cyan
$tableContent = Get-Content $tableFile -Raw

if ($tableContent -match "Табличная декомпозиция навыков") {
    Write-Host "OK Заголовок найден" -ForegroundColor Green
} else {
    Write-Host "ERROR Заголовок не найден" -ForegroundColor Red
}

# Подсчет строк в таблице
$tableLines = Get-Content $tableFile
$dataLines = $tableLines | Where-Object { $_ -match "^\|.*\|.*\|.*\|.*\|$" }
$dataLineCount = ($dataLines | Measure-Object).Count

Write-Host "Количество строк с данными: $dataLineCount" -ForegroundColor Cyan

# Проверка CSV файла
Write-Host ""
Write-Host "Проверка CSV файла..." -ForegroundColor Cyan
$csvContent = Get-Content $csvFile
$csvLineCount = ($csvContent | Measure-Object).Count

Write-Host "Количество строк в CSV: $csvLineCount" -ForegroundColor Cyan

if ($csvContent[0] -match "Роль,Уровень,Навык,Описание") {
    Write-Host "OK Заголовки CSV корректны" -ForegroundColor Green
} else {
    Write-Host "ERROR Заголовки CSV некорректны" -ForegroundColor Red
}

# Проверка соответствия количества записей
$expectedRoles = @("Бизнес-аналитик", "Custdev-аналитик")
$expectedLevels = @("L1", "L2", "L3", "L4", "L5", "L6", "L7")

Write-Host ""
Write-Host "Проверка структуры данных:" -ForegroundColor Yellow

foreach ($role in $expectedRoles) {
    foreach ($level in $expectedLevels) {
        $count = ($csvContent | Where-Object { $_ -match "$role,$level," } | Measure-Object).Count
        if ($count -gt 0) {
            Write-Host "OK $role $level: $count навыков" -ForegroundColor Green
        } else {
            Write-Host "WARNING $role $level: 0 навыков" -ForegroundColor Yellow
        }
    }
}

# Проверка уникальности навыков
Write-Host ""
Write-Host "Проверка уникальности навыков:" -ForegroundColor Yellow
$skills = $csvContent | Select-Object -Skip 1 | ForEach-Object { ($_ -split ',')[2] }
$uniqueSkills = $skills | Sort-Object | Get-Unique
$totalSkills = ($skills | Measure-Object).Count
$uniqueSkillsCount = ($uniqueSkills | Measure-Object).Count

Write-Host "Всего навыков: $totalSkills" -ForegroundColor Cyan
Write-Host "Уникальных навыков: $uniqueSkillsCount" -ForegroundColor Cyan

if ($totalSkills -eq $uniqueSkillsCount) {
    Write-Host "OK Все навыки уникальны" -ForegroundColor Green
} else {
    Write-Host "WARNING Обнаружены дублирующиеся навыки" -ForegroundColor Yellow
}

# Итоговая проверка
Write-Host ""
Write-Host "=== ИТОГОВАЯ ОЦЕНКА ===" -ForegroundColor Green

$errors = 0
$warnings = 0

if (-not $allFilesExist) { $errors++ }
if (-not $allLevelsFound) { $errors++ }
if ($totalSkills -ne $uniqueSkillsCount) { $warnings++ }

if ($errors -eq 0) {
    Write-Host "OK ВАЛИДАЦИЯ ПРОЙДЕНА УСПЕШНО" -ForegroundColor Green
    if ($warnings -gt 0) {
        Write-Host "WARNING Обнаружено предупреждений: $warnings" -ForegroundColor Yellow
    }
} else {
    Write-Host "ERROR ВАЛИДАЦИЯ НЕ ПРОЙДЕНА" -ForegroundColor Red
    Write-Host "Ошибок: $errors" -ForegroundColor Red
    if ($warnings -gt 0) {
        Write-Host "Предупреждений: $warnings" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Статистика:" -ForegroundColor Cyan
Write-Host "- Всего ролей: $($expectedRoles.Count)" -ForegroundColor White
Write-Host "- Всего уровней: $($expectedLevels.Count)" -ForegroundColor White
Write-Host "- Всего навыков: $totalSkills" -ForegroundColor White
Write-Host "- Уникальных навыков: $uniqueSkillsCount" -ForegroundColor White
Write-Host "- Строк в CSV: $csvLineCount" -ForegroundColor White

Write-Host ""
Write-Host "Валидация завершена!" -ForegroundColor Green 