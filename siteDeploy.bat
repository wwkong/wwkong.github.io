@ECHO OFF
SETLOCAL EnableDelayedExpansion

cd "%CD%\_site"
git add --all .
git commit -m "Deployed content using custom batch script."
git push --progress origin master:master

pause