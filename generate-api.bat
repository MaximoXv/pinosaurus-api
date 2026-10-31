
@echo off
title Pinosaurus API Generator
cd /d "%~dp0"

echo ========================================
echo       PINOSAURUS API GENERATOR
echo ========================================
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate-api.ps1"

echo.
echo ========================================
echo Codigo de salida: %ERRORLEVEL%
echo ========================================
echo.
echo Presiona una tecla para cerrar...
pause > nul
