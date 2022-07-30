@ECHO OFF
SETLOCAL EnableDelayedExpansion

ECHO BUILDING RESOURCES...
cabal run site build
ECHO.

pause 