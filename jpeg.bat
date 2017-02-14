@echo on
set PROJECT_DIR=%CD%

set CMAKE_EXE="C:\Program Files (x86)\CMake\bin\cmake.exe"
set MSBUILD="C:\Program Files (x86)\MSBuild\12.0\Bin\msbuild.exe"
set DEPS_DIR=%CD%\deps
SET INSTALL_DIR=%CD%\Install

set VARS_ALL="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"
call %VARS_ALL% x86_amd64

echo ------------------------------------JPEG-------------------------------
cd jpeg-9b

set INCLUDE=%INCLUDE%;c:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include

copy jconfig.vc jconfig.h
call :errorCheck
echo #define _CRT_SECURE_NO_WARNINGS >> jconfig.h
call :errorCheck
nmake /f makefile.vc nodebug=1
call :errorCheck
echo Copying JPEG files to %INSTALL_DIR%
robocopy  . %INSTALL_DIR%\include\ jerror.h  jpeglib.h  jconfig.h  jmorecfg.h /NFL /NDL /NJH /NJS /nc /ns /np

robocopy  . %INSTALL_DIR%\lib\ libjpeg.lib /NFL /NDL /NJH /NJS /nc /ns /np
robocopy . %INSTALL_DIR%\bin\ *.exe /NFL /NDL /NJH /NJS /nc /ns /np
call :errorCheck


goto :eof

:errorCheck
if %ERRORLEVEL% GEQ 1 (
    echo %~1
    cd %PROJECT_DIR%
    exit /b
)
goto :eof
