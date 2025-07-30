# README Validation Test Script
# Проверяет корректность обновлений README файла

Write-Host "=== README VALIDATION TEST ===" -ForegroundColor Green

# Проверка существования README файла
$readmeFile = "README.md"
if (-not (Test-Path $readmeFile)) {
    Write-Host "ERROR: README.md не найден!" -ForegroundColor Red
    exit 1
}

Write-Host "`n1. Проверка существования README.md..." -ForegroundColor Yellow
Write-Host "OK: README.md найден" -ForegroundColor Green

# Чтение содержимого README
$content = Get-Content $readmeFile -Encoding UTF8
$contentText = $content -join "`n"

Write-Host "`n2. Проверка версии..." -ForegroundColor Yellow

# Проверка версии
if ($contentText -match "Версия.*4\.2") {
    Write-Host "OK: Версия 4.2 указана" -ForegroundColor Green
} else {
    Write-Host "WARNING: Версия может быть не обновлена" -ForegroundColor Yellow
}

Write-Host "`n3. Проверка упоминания навыков разработчиков..." -ForegroundColor Yellow

# Проверка упоминания новых навыков разработчиков
$developerSkills = @(
    "серверный код",
    "API",
    "базы данных", 
    "микросервисы",
    "контейнеризация",
    "CI/CD",
    "клиентский код",
    "SPA",
    "HTML/CSS",
    "UX/UI",
    "PWA",
    "микрофронтенды"
)

$foundSkills = 0
foreach ($skill in $developerSkills) {
    if ($contentText -match $skill) {
        $foundSkills++
        Write-Host "OK: Найден навык '$skill'" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Навык '$skill' не найден в README" -ForegroundColor Yellow
    }
}

Write-Host "`nНайдено навыков разработчиков: $foundSkills из $($developerSkills.Count)" -ForegroundColor Cyan

Write-Host "`n4. Проверка статистики..." -ForegroundColor Yellow

# Проверка статистики
if ($contentText -match "120\+") {
    Write-Host "OK: Статистика обновлена (120+ навыков)" -ForegroundColor Green
} else {
    Write-Host "WARNING: Статистика может быть не обновлена" -ForegroundColor Yellow
}

Write-Host "`n5. Проверка упоминания обновлений..." -ForegroundColor Yellow

# Проверка упоминания обновлений
if ($contentText -match "обновлены навыки разработчиков") {
    Write-Host "OK: Упоминание обновлений найдено" -ForegroundColor Green
} else {
    Write-Host "WARNING: Нет упоминания обновлений навыков разработчиков" -ForegroundColor Yellow
}

Write-Host "`n6. Проверка структуры проекта..." -ForegroundColor Yellow

# Проверка упоминания ключевых файлов
$keyFiles = @(
    "developer-skills-unified-table.md",
    "developer-skills-list.md",
    "developer-skills.csv"
)

foreach ($file in $keyFiles) {
    if ($contentText -match $file) {
        Write-Host "OK: Упоминание файла '$file' найдено" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Файл '$file' не упомянут в README" -ForegroundColor Yellow
    }
}

Write-Host "`n=== РЕЗУЛЬТАТ ПРОВЕРКИ ===" -ForegroundColor Cyan

if ($foundSkills -ge 8) {
    Write-Host "✅ README обновлен корректно" -ForegroundColor Green
    Write-Host "Найдено $foundSkills из $($developerSkills.Count) навыков разработчиков" -ForegroundColor Green
} else {
    Write-Host "⚠️ README может требовать дополнительных обновлений" -ForegroundColor Yellow
    Write-Host "Найдено только $foundSkills из $($developerSkills.Count) навыков разработчиков" -ForegroundColor Yellow
}

Write-Host "`nРекомендации:" -ForegroundColor Cyan
Write-Host "- Убедитесь, что все новые навыки разработчиков упомянуты в README" -ForegroundColor White
Write-Host "- Проверьте актуальность статистики" -ForegroundColor White
Write-Host "- Обновите версию при необходимости" -ForegroundColor White

Write-Host "`nREADME validation test completed!" -ForegroundColor Green 