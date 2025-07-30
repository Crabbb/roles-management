@echo off
cd roles-management
echo === GIT SYNC ===
echo.
echo 1. Checking Git status...
git status
echo.
echo 2. Adding all changes...
git add -A
echo.
echo 3. Creating commit...
git commit -m "Organized project reports and updated documentation"
echo.
echo 4. Pushing changes...
git push
echo.
echo Sync completed!
pause 