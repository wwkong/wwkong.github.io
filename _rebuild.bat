@ECHO OFF
SETLOCAL EnableDelayedExpansion

ECHO REBUILDING RESOURCES...
cabal run site rebuild
ECHO.

pause 