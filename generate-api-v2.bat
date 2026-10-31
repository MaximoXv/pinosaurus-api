
@echo off
title Pinosaurus API Generator
cd /d "%~dp0"

echo ========================================
echo       PINOSAURUS API GENERATOR
echo ========================================
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate-api-v2.ps1"

set "exitCode=%ERRORLEVEL%"

echo.
echo ========================================
if "%exitCode%"=="0" (
    echo API GENERADA CORRECTAMENTE
) else (
    echo HUBO UN ERROR AL GENERAR LA API
)
echo ========================================
echo.
echo Presiona una tecla para cerrar...
pause > nul
