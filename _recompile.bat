@ECHO OFF
SETLOCAL EnableDelayedExpansion

ECHO COMPILING site.hs...
cabal build
ECHO Success^^!
ECHO.

pause 