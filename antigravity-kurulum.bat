@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

REM Maximize Window (Full Screen)
mode con cols=180 lines=100

REM ============================================
REM HAVSAN Antigravity - Kurulum Wrapper
REM ============================================

echo.
echo.
echo ============================================================
echo.
echo           HAVSAN Antigravity Kurulum Basladi
echo.
echo ============================================================
echo.
echo.

REM Check if PowerShell is installed
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  [HATA] PowerShell bulunamadi!
    echo.
    echo  PowerShell, Windows 7 ve uzeri sistemlerde 
    echo  varsayilan olarak yukludur.
    echo.
    echo  Lutfen Windows guncellemelerinizi kontrol edin.
    echo.
    echo.
    pause
    exit /b 1
)

REM Check PowerShell version
for /f "tokens=*" %%i in ('powershell -Command "$PSVersionTable.PSVersion.Major"') do set PS_VERSION=%%i
if %PS_VERSION% LSS 5 (
    echo.
    echo  [UYARI] PowerShell versiyonunuz eski: v%PS_VERSION%
    echo  Minimum gereksinim: PowerShell 5.1
    echo  Devam ediliyor...
    echo.
)

echo.
echo  [BILGI] PowerShell script baslatiliyor...
echo.
echo ============================================================
echo.

REM Run the PowerShell script
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0script\antigravity-kurulum.ps1"

REM Check exit code
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo.
    echo ============================================================
    echo.
    echo  [HATA] Script hata ile sonlandi. 
    echo  Hata Kodu: %ERRORLEVEL%
    echo.
    echo ============================================================
    echo.
    pause
    exit /b %ERRORLEVEL%
)

exit /b 0
