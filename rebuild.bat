@echo off
rem Rebuild entry point. Kept ASCII-only: cmd.exe reads .bat in the OEM
rem codepage, so non-ASCII text here can garble or break parsing.
rem All Chinese messages are printed by rebuild.ps1 (UTF-8 with BOM).
cd /d "%~dp0"
echo ========================================
echo   Quiz Bank - Standard Rebuild
echo ========================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0rebuild.ps1"
echo.
if errorlevel 1 (
  echo [FAILED] See messages above.
) else (
  echo [OK] Rebuild finished. Refresh the browser.
)
pause
