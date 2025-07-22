@echo off
echo ========================================
echo    Синхронизация с GitHub
echo ========================================
echo.

echo Добавление изменений в индекс...
git add .

echo.
echo Создание коммита...
git commit -m "Auto-sync: %date% %time%"

echo.
echo Отправка на GitHub...
git push origin main

echo.
echo ========================================
echo    Синхронизация завершена!
echo ========================================
echo.
pause 