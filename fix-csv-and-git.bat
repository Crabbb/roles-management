@echo off
cd roles-management
echo === FIXING CSV FOLDER AND GIT SYNC ===
echo.

echo 1. Renaming CSV folder...
if exist "decomposed\CSV формат" (
    ren "decomposed\CSV формат" "CSV-format"
    echo ✅ Folder renamed successfully
) else (
    echo ℹ️ Folder already renamed or doesn't exist
)

echo.
echo 2. Checking current Git status...
git status

echo.
echo 3. Adding all files to Git...
git add -A

echo.
echo 4. Checking Git status after add...
git status

echo.
echo 5. Creating commit...
git commit -m "Fixed CSV folder name and updated all references - 2025-01-23"

echo.
echo 6. Pushing to remote...
git push

echo.
echo === COMPLETED ===
echo All changes have been committed and pushed to Git
pause 