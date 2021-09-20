@ECHO OFF
SETLOCAL EnableDelayedExpansion

START chrome "http://localhost:8000/"
cabal run site watch

pause