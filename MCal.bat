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
cd MCal
:: as explained above
call MCal.bat launch
cd ..\..
goto eof


:load
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

:: setting everyting to default values
echo set sign=$>> profiles\user.bat
echo set currentbal=0.00>> profiles\user.bat
echo set todaysbal_ad=No change>> profiles\user.bat
echo set todaysbal=0.00>> profiles\user.bat
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
cls
echo Loading user profile
call profiles\user.bat
cls
MCal_deps\chgcolor.exe f3
:: spacing guide for me, window size is shown on line
::   ________________________________________________________________________________
echo ллллллллллллллллллллллллллллллл = MCal Money = ллллллллллллллллллллллллллллллллл
echo.
MCal_deps\chgcolor.exe f8
echo                                        Total Balance: %sign%%currentbal%
if "%todaysbal_ad%" == "No change" (
MCal_deps\chgcolor.exe f8
echo                                        Today^'s Change: %todaysbal_ad% - %sign%%currentbal%
) 
if "%todaysbal_ad%" == "Added" (
MCal_deps\chgcolor.exe f2
echo                                        Today^'s Change: %todaysbal_ad% - %sign%%currentbal%
) 
if "%todaysbal_ad%" == "Spent" (
MCal_deps\chgcolor.exe f4
echo                                        Today^'s Change: %todaysbal_ad% - %sign%%currentbal%
) 
MCal_deps\chgcolor.exe f3
echo.
echo ^(A^)dd money to balance.
echo ^(R^)ecord an expense.
echo ^(V^)iew log.
echo ^(E^)xit.
CHOICE /C:arv /N
set menuchoice=%ERRORLEVEL%
if "%menuchoice%" == "1" goto add_money
if "%menuchoice%" == "2" goto expense
if "%menuchoice%" == "3" goto view_log
if "%menuchoice%" == "4" goto eof
goto dashboard

:add_money
cls
echo Loading user profile
call profiles\user.bat
cls
MCal_deps\chgcolor.exe f3
:: spacing guide for me, window size is shown on line
::   ________________________________________________________________________________
echo ллллллллллллллллллллллллллллллл = MCal Money = ллллллллллллллллллллллллллллллллл
echo.
echo ^(N^)otes, ^(C)^oins or ^(E^)xit?
CHOICE /C:nce
set menuchoice=%ERRORLEVEL%
if "%menuchoice%" == "1" goto add_money_notes
if "%menuchoice%" == "2" goto add_money_coins
if "%menuchoice%" == "3" goto dashboard
goto add_money

:add_money_notes
cls
echo Loading user profile
call profiles\user.bat
set addedbal=0.00
:add_money_notes_reload
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
MCal_deps\chgcolor.exe f2
echo CURRENT BALANCE: %sign%%currentbal% ADDED BALANCE: %sign%%addedbal%
echo.
MCal_deps\chgcolor.exe f8
echo A: $100 - Z: $50 - S: $20 - X: $10 - D: $5 - E: Exit
CHOICE /C:azsxde
set menuchoice=%ERRORLEVEL%
if "%menuchoice%" == "1" goto addbal_100
if "%menuchoice%" == "2" goto addbal_50
if "%menuchoice%" == "3" goto addbal_20
if "%menuchoice%" == "4" goto addbal_10
if "%menuchoice%" == "5" goto addbal_5
if "%menuchoice%" == "6" goto reload_and_exit
goto add_money_notes_reload

:addbal_100
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+100`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+100`) DO (
SET addedbal=%%F
)
goto add_money_notes_reload
:addbal_50
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+50`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+50`) DO (
SET addedbal=%%F
)
goto add_money_notes_reload
:addbal_20
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+20`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+20`) DO (
SET addedbal=%%F
)
goto add_money_notes_reload
:addbal_10
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+10`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+10`) DO (
SET addedbal=%%F
)
goto add_money_notes_reload
:addbal_5
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+5`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+5`) DO (
SET addedbal=%%F
)
goto add_money_notes_reload

:reload_and_exit
echo set sign=$>> profiles\user.bat
echo set currentbal=%currentbal%>> profiles\user.bat
echo set todaysbal_ad=Added>> profiles\user.bat
echo set todaysbal=%addedbal%>> profiles\user.bat
goto add_money




:add_money_coins
cls
echo Loading user profile
call profiles\user.bat
set addedbal=0.00
:add_money_coins_reload
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
MCal_deps\chgcolor.exe f2
echo CURRENT BALANCE: %sign%%currentbal% ADDED BALANCE: %sign%%addedbal%
echo.
MCal_deps\chgcolor.exe f8
echo A: $2 - Z: $1 - S: $0.50 - X: $0.20 - D: $0.10 - C: $0.05 - E: Exit
CHOICE /C:azsxdce
set menuchoice=%ERRORLEVEL%
if "%menuchoice%" == "1" goto addbal_2
if "%menuchoice%" == "2" goto addbal_1
if "%menuchoice%" == "3" goto addbal_050
if "%menuchoice%" == "4" goto addbal_020
if "%menuchoice%" == "5" goto addbal_010
if "%menuchoice%" == "6" goto addbal_005
if "%menuchoice%" == "7" goto reload_and_exit
goto add_money_coins_reload

:addbal_2
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+2`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+2`) DO (
SET addedbal=%%F
)
goto add_money_coins_reload
:addbal_1
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+1`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+1`) DO (
SET addedbal=%%F
)
goto add_money_coins_reload
:addbal_050
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+0.50`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+0.50`) DO (
SET addedbal=%%F
)
goto add_money_coins_reload
:addbal_020
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+0.20`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+0.20`) DO (
SET addedbal=%%F
)
goto add_money_coins_reload
:addbal_010
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+0.05`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+0.05`) DO (
SET addedbal=%%F
)
goto add_money_coins_reload
:addbal_005
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%+0.05`) DO (
SET currentbal=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %addedbal%+0.05`) DO (
SET addedbal=%%F
)
goto add_money_coins_reload

:reload_and_exit
echo set sign=$>> profiles\user.bat
echo set currentbal=%currentbal%>> profiles\user.bat
echo set todaysbal_ad=Added>> profiles\user.bat
echo set todaysbal=%addedbal%>> profiles\user.bat
goto add_money

:expense
cls
echo Loading user profile
call profiles\user.bat
set rembal=0.00
:expense_reload
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
MCal_deps\chgcolor.exe f2
echo CURRENT BALANCE: %sign%%currentbal% REMOVED BALANCE: %sign%%addedbal%
echo.
MCal_deps\chgcolor.exe f8
echo Enter spent amount, without dollarsigns, letters or commas.
set /p spend="Spent: "
FOR /F "tokens=* USEBACKQ" %%F IN (`MCal_deps\calc.exe %currentbal%-%spend%`) DO (
SET currentbal=%%F
)
echo set sign=$>> profiles\user.bat
echo set currentbal=%currentbal%>> profiles\user.bat
echo set todaysbal_ad=Spent>> profiles\user.bat
echo set todaysbal=%spend%>> profiles\user.bat
goto dashboard

:eof