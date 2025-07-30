@echo off
cd roles-management
echo === RUNNING TESTS ===
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
echo Tests completed!
pause 