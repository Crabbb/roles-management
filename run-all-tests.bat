@echo off
echo === RUNNING ALL TESTS ===
echo.

echo Current directory:
cd
echo.

echo Changing to roles-management directory...
cd roles-management
echo.

echo 1. Running skill matrix validation test...
powershell -ExecutionPolicy Bypass -File test-skill-matrix-formation.ps1
echo.

echo 2. Running CSV validation test...
powershell -ExecutionPolicy Bypass -File test-csv-validation.ps1
echo.

echo 3. Running README validation test...
powershell -ExecutionPolicy Bypass -File test-readme-validation.ps1
echo.

echo === ALL TESTS COMPLETED ===
echo.
echo Press any key to continue...
pause 