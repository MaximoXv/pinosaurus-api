
@echo off
title Pinosaurus API Generator
cd /d "%~dp0"

echo ========================================
echo       PINOSAURUS API GENERATOR
echo ========================================
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate-api-v1.ps1"

set "exitCode=%ERRORLEVEL%"

echo.
echo ========================================
if "%exitCode%"=="0" (
    echo API.JSON GENERADO CORRECTAMENTE
) else (
    echo HUBO UN ERROR AL GENERAR EL JSON
)
echo ========================================
echo.
echo Presiona una tecla para cerrar...
pause > nul
