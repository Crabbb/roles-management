@echo off
echo === FIXING CSV FOLDER AND GIT SYNC ===
echo.

echo Step 1: Renaming CSV folder...
if exist "decomposed\CSV формат" (
    echo Found old folder, renaming...
    ren "decomposed\CSV формат" "CSV-format"
    echo ✅ Folder renamed successfully
) else (
    echo ℹ️ Folder already renamed or doesn't exist
)

echo.
echo Step 2: Checking Git status...
git status

echo.
echo Step 3: Adding all files to Git...
git add -A

echo.
echo Step 4: Checking Git status after add...
git status

echo.
echo Step 5: Creating commit...
git commit -m "Fixed CSV folder name and updated all references - 2025-01-23"

echo.
echo Step 6: Pushing to remote...
git push

echo.
echo === COMPLETED ===
echo All changes have been committed and pushed to Git
pause 