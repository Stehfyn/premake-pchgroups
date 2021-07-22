@echo off
pushd %~dp0..\
call vendor\premake\bin\premake5.exe vs2019
popd

if NOT "%1"=="rebuild" (TIMEOUT /t 300 & EXIT)