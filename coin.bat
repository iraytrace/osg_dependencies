@echo off
echo --------------------------------------Coin3D------------------------------------
set PROJECT_DIR=%CD%
set CMAKE_EXE="C:\Program Files (x86)\CMake\bin\cmake.exe"
set MSBUILD="C:\Program Files (x86)\MSBuild\12.0\Bin\msbuild.exe"
set DEPS_DIR=%CD%\deps
SET INSTALL_DIR=%CD%\Install

set VARS_ALL="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"
call %VARS_ALL% x86_amd64
set COINDIR=%INSTALL_DIR%
if NOT EXIST %COINDIR% mkdir %COINDIR%

echo Building Coin3D into %COINDIR%
cd Coin-3.1.3\build\msvc9

%MSBUILD% coin3.sln /p:Configuration="DLL (Debug)" /p:Platform="x64" > buildDeb.log
call :errorCheck
%MSBUILD% coin3.sln /p:Configuration="DLL (Debug)" /p:Platform="x64" /target:coin3_install > InstallDeb.log
call :errorCheck

%MSBUILD% coin3.sln /p:Configuration="DLL (Release)" /p:Platform="x64" > buildRel.log
call :errorCheck
%MSBUILD% coin3.sln /p:Configuration="DLL (Release)" /p:Platform="x64" /target:coin3_install > InstallRel.log
call :errorCheck

goto :eof

:errorCheck
if %ERRORLEVEL% GEQ 1 (
    echo %~1
    cd %PROJECT_DIR%
    exit /b
)
goto :eof
