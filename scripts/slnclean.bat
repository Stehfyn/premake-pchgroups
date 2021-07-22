@echo off

pushd %~dp0..\
del /S /Q "*.vs"
del /S /Q "*.sln"
del /S /Q "*.vcxproj"
del /S /Q "*.vcxproj.filters"
del /S /Q "*.vcxproj.user"
popd

if NOT "%1"=="rebuild" (TIMEOUT /t 3 & EXIT)