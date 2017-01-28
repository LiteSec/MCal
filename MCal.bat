@echo off

:: initial launch compatibility check
:: because oneos apps has different deps -- i commented this out because oneos does not currently support the "oneos_apps" launch code
:: if "%1" NOT "oneos_apps" (
:: cls
:: echo Warning! MCal is not running as a OneOS App. You can use MCal, but some features may not be available.
:: pause
:: goto start
:: ) 

:: now we check if this is the initial start, or its started from the launcher
if "%1" == "launch" goto load

:start
:: we will check if MCal has been installed.
:: using a goto because of unexpected bug :P
IF NOT EXIST "MCal\MCal\MCal_deps\setup.chk" (
goto installask
) else (
goto startup
)

:installask
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

:: debug step
echo Removing MCcal directory..
rmdir /s /q MCal
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
..\..\system\7za.exe x ..\git.zip -y
cd ..
echo.

echo Downloading MCal deps using git...
git\cmd\git.exe clone https://github.com/LiteSec/MCal.git
echo.
cd ..
goto startup



:startup
cls
echo Starting MCal...
cd MCal
:: as explained above
call MCal.bat launch
cd ..\..
goto eof


:load
MCal_deps\chgcolor.exe f3
:: spacing guide for me, window size is shown on line
::   ________________________________________________________________________________
echo ллллллллллллллллллллллллллллллл = MCal Money = ллллллллллллллллллллллллллллллллл
echo.
echo     __  _________      __
echo    ^/  ^|^/  ^/ ____^/___ _^/ ^/
echo   ^/ ^/^|_^/ ^/ ^/   ^/ __ ^`^/ ^/ 
echo  ^/ ^/  ^/ ^/ ^/___^/ ^/_^/ ^/ ^/  
echo ^/_^/  ^/_^/^\____^/^\__,_^/_^/  by LiteSec
echo.
echo Money calculator and expense monitor app for OneOS: X.
echo.
:: splash screen
sleep 3 >NUL
:: actual loading
echo Checking for profiles...
if exist profiles\user.bat (
goto user_login
) else (
goto user_setup
)
goto eof

:user_setup
cls
MCal_deps\chgcolor.exe f3
:: spacing guide for me, window size is shown on line
::   ________________________________________________________________________________
echo ллллллллллллллллллллллллллллллл = MCal Money = ллллллллллллллллллллллллллллллллл
echo.
MCal_deps\chgcolor.exe f3
echo Hello there, and welcome to MCal Money. Let's get an account set up.
echo.
MCal_deps\chgcolor.exe f8
set /p fname="First Name: "
set /p lname="Last Name: "
MCal_deps\chgcolor.exe f3
echo.
echo Is %fname% %lname% correct?
CHOICE /C:yn
if "%ERRORLEVEL%" == "1" (
set fullname=%fname%%lname%
goto user_setup2
) else (
goto user_setup
)

:user_setup2
cls
MCal_deps\chgcolor.exe f3
:: spacing guide for me, window size is shown on line
::   ________________________________________________________________________________
echo ллллллллллллллллллллллллллллллл = MCal Money = ллллллллллллллллллллллллллллллллл
echo.
echo Now, %fname%, we must set up your security.
echo.
MCal_deps\chgcolor.exe f8
set /p password="Please choose a password: "
set /p pconfirm="Type it again: "
if "%password%" == "%pconfirm%" (
sleep 1 >NUL
goto user_setup_write
) else (
echo The passwords did not match.
pause
goto user_setup2
)

:user_setup_write
cls
MCal_deps\chgcolor.exe f3
:: spacing guide for me, window size is shown on line
::   ________________________________________________________________________________
echo ллллллллллллллллллллллллллллллл = MCal Money = ллллллллллллллллллллллллллллллллл
echo.
echo Just to make sure, here's your details.
echo.
MCal_deps\chgcolor.exe f8
echo First Name: %fname%
echo Last Name: %lname%
echo.
echo Password: %password%
echo Is this correct?
CHOICE /C:yn
if "%ERRORLEVEL%" == "1" (
goto user_setup_write_data
) else (
goto user_setup
)
goto eof

:user_setup_write_data
:: create new profile and write data
cls
echo Writing data...
mkdir profiles
echo set fname=%fname%> profiles\user.bat
echo set lname=%lname%>> profiles\user.bat
:: storing passwords in plain text ftw -- this will change soon though
echo set password=%password%>> profiles\user.bat
:: sleep for authenticity
sleep 1 >NUL
echo Account saved!
pause
goto load




:user_login
cls
echo Loading user profile
call profiles\user.bat
cls
MCal_deps\chgcolor.exe f3
:: spacing guide for me, window size is shown on line
::   ________________________________________________________________________________
echo ллллллллллллллллллллллллллллллл = MCal Money = ллллллллллллллллллллллллллллллллл
echo.
echo     __  _________      __
echo    ^/  ^|^/  ^/ ____^/___ _^/ ^/
echo   ^/ ^/^|_^/ ^/ ^/   ^/ __ ^`^/ ^/ 
echo  ^/ ^/  ^/ ^/ ^/___^/ ^/_^/ ^/ ^/  
echo ^/_^/  ^/_^/^\____^/^\__,_^/_^/  by LiteSec
echo.
echo Username: %fname%_%lname%
set /p pcheck="Password: "
if "%pcheck%" == "%password%" (
goto dashboard
) else (
MCal_deps\chgcolor.exe fc
echo Incorrect password!
pause
goto user_login
)
goto eof


:dashboard




:eof