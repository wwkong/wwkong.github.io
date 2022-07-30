@ECHO OFF
SETLOCAL EnableDelayedExpansion

cd "%CD%\docs"
git add -f --all .
git commit -m "Deployed content using custom batch script."
git push --progress origin master:master

pause