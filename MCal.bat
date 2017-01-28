@echo off

:: initial launch compatibility check
:: because oneos apps has different deps -- i commented this out because oneos does not currently support the "oneos_apps" launch code
:: if "%1" NOT "oneos_apps" (
:: cls
:: echo Warning! MCal is not running as a OneOS App. You can use MCal, but some features may not be available.
:: pause
:: goto start
:: ) 

:start
:: we will check if MCal has been installed.
IF NOT EXIST "MCal_deps\setup.chk" (
goto installask
:: doing this because of the way batch is shit
)

::installask
cls 
echo MCal has not been run before.
CHOICE /C:yn "Install now"
if "%ERRORLEVEL%" == "1" (
goto install
) else (
goto eof
)


:install
cls
echo Installing MCal...
sleep 1 >NUL
echo Creating MCal directory...
mkdir MCal
echo.

echo Entering MCal directory...
cd MCal
echo.

echo Downloading gitcmd...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://update.litesec.co/stable/appdeps/PortableGit.zip', 'git.zip')"
echo.

echo Unpacking git...
mkdir git
cd git
..\..\system\7za.exe e git.zip -y
cd ..
echo.

echo Downloading MCal deps using git...
git\cmd\git.exe clone https://github.com/LiteSec/MCal.git
echo.


:: for testing
echo Dev test!
call cmd
cd ..
