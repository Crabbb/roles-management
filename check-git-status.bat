@echo off
cd roles-management
echo === CHECKING GIT STATUS ===
echo.
echo Current directory:
cd
echo.
echo Git status:
git status
echo.
echo Checking if CSV folder is tracked:
git ls-files | findstr "CSV"
echo.
echo Adding all files including CSV folder:
git add -A
echo.
echo Git status after add:
git status
echo.
echo Press any key to continue...
pause 