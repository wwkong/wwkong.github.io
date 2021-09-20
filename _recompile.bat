@ECHO OFF
SETLOCAL EnableDelayedExpansion

call utilSetup.bat

ECHO COMPILING site.hs...
cabal build
ECHO Success^^!
ECHO.

ECHO REBUILDING RESOURCES...
cabal run site rebuild
ECHO.

call utilFinish.bat

pause 