# Git Sync Script
# Синхронизирует изменения с Git

Write-Host "=== GIT SYNC ===" -ForegroundColor Green

# Переходим в папку проекта
Set-Location -Path "roles-management"

Write-Host "`n1. Проверка статуса Git..." -ForegroundColor Yellow
git status

Write-Host "`n2. Добавление всех изменений..." -ForegroundColor Yellow
git add -A

Write-Host "`n3. Создание коммита..." -ForegroundColor Yellow
git commit -m "Добавлены CSV файлы навыков и обновлены тесты"

Write-Host "`n4. Отправка изменений..." -ForegroundColor Yellow
git push

Write-Host "`nСинхронизация завершена!" -ForegroundColor Green 