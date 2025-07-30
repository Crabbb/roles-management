@echo off
cd roles-management
git status
git add -A
git commit -m "Добавлены CSV файлы навыков и обновлены тесты"
git push
pause 