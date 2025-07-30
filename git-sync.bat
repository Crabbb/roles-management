@echo off
echo === GIT SYNC ===
echo.

echo Current directory:
cd
echo.

echo Changing to roles-management directory...
cd roles-management
echo.

echo Current Git status:
git status
echo.

echo Adding all files to Git...
git add -A
echo.

echo Git status after add:
git status
echo.

echo Creating commit...
git commit -m "Updated project files and documentation - 2025-01-23"
echo.

echo Pushing to remote...
git push
echo.

echo === COMPLETED ===
echo All changes have been committed and pushed to Git
pause 