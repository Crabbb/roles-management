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
if %errorlevel% neq 0 (
    echo ERROR: Skill matrix test failed!
    pause
    exit /b 1
)
echo.

echo 2. Running CSV validation test...
powershell -ExecutionPolicy Bypass -File test-csv-validation.ps1
if %errorlevel% neq 0 (
    echo ERROR: CSV validation test failed!
    pause
    exit /b 1
)
echo.

echo 3. Running README validation test...
powershell -ExecutionPolicy Bypass -File test-readme-validation.ps1
if %errorlevel% neq 0 (
    echo ERROR: README validation test failed!
    pause
    exit /b 1
)
echo.

echo === ALL TESTS PASSED SUCCESSFULLY ===
echo.
echo All tests completed without errors!
echo.
pause 