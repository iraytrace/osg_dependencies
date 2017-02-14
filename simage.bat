@echo on
set PROJECT_DIR=%CD%

set CMAKE_EXE="C:\Program Files (x86)\CMake\bin\cmake.exe"
set MSBUILD="C:\Program Files (x86)\MSBuild\12.0\Bin\msbuild.exe"
set DEPS_DIR=%CD%\deps 
SET INSTALL_DIR=%CD%\Install

if NOT EXIST %INSTALL_DIR% mkdir %INSTALL_DIR%

set VARS_ALL="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"
call %VARS_ALL% x86_amd64

REM simage
echo --------------------------------------simage------------------------------------
echo Building simage
set COINDIR=%INSTALL_DIR%

cd simage-1.7.0\build\msvc12
%MSBUILD% simage1.sln /p:Configuration="DLL (Release)" /p:Platform="x64" > buildRel.log
%MSBUILD% simage1.sln /p:Configuration="DLL (Release)" /p:Platform="x64" /target:simage1_install > InstallRel.log
%MSBUILD% simage1.sln /p:Configuration="DLL (Debug)" /p:Platform="x64" > buildDeb.log
%MSBUILD% simage1.sln /p:Configuration="DLL (Debug)" /p:Platform="x64" /target:simage1_install > InstallDeb.log
