Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Синхронизация с GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Добавление изменений в индекс..." -ForegroundColor Yellow
git add .

Write-Host ""
Write-Host "Создание коммита..." -ForegroundColor Yellow
$commitMessage = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMessage

Write-Host ""
Write-Host "Отправка на GitHub..." -ForegroundColor Yellow
git push origin main

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "    Синхронизация завершена!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Read-Host "Нажмите Enter для продолжения" 