@echo off

:: initial launch compatibility check
:: because oneos apps has different deps
if "%1" NOT "oneos_apps" (
cls
echo Warning! MCal is not running as a OneOS App. You can use MCal, but some features may not be available.
pause
goto start
)

:start
:: we will check if MCal has been installed.
IF NOT EXIST "MCal_deps\setup.chk" (
cls MCal has not been run before.
CHOICE /C:yn "Install now"
if "%ERRORLEVEL%" == "1" (
goto install
) else (
goto eof
)
