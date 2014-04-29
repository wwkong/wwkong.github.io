@ECHO OFF
SETLOCAL EnableDelayedExpansion

ECHO SETTING UP TEMP DIRECTORY...
if not exist "%CD%\temp" mkdir "%CD%\temp"

set "sourcedir=%CD%\_site"
set "destdir=%CD%\temp"

if not exist "%destdir%\.git" mkdir "%destdir%\.git"

ECHO COPYING .git RESOURCES...
xcopy "%sourcedir%\.gitignore" %destdir% /s /Y >nul
xcopy "%sourcedir%\README.md" %destdir% /s /Y >nul
xcopy "%sourcedir%\.git" "%destdir%\.git" /s /Y /D >nul
ECHO Success^^!
ECHO.

ECHO DELETING OLD FILES...
del %sourcedir%\*.* /s /F /Q >nul
ECHO Success^^!
ECHO.

ECHO REBUILDING RESOURCES...
site rebuild
ECHO.

ECHO MOVING .git RESOURCES...
xcopy %destdir%  %sourcedir% /s /Y >nul
mkdir "%sourcedir%\.git" >nul
xcopy "%destdir%\.git" "%sourcedir%\.git" /s /Y /D >nul
ECHO.
ECHO Success^^!

ECHO DELETING TEMP DIRECTORY...
del "%destdir%\*.*" /S /A /Q >nul
for /f %%a in ('dir %destdir% /b /s /a:hd') do rd /s /q "%%a" >nul
rd %destdir% >nul
ECHO Success^^!
ECHO.

pause 