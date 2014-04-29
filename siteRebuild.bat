@ECHO OFF
SETLOCAL EnableDelayedExpansion

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

pause 