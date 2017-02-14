@echo on
set PROJECT_DIR=%CD%


set CMAKE_EXE="C:\Program Files (x86)\CMake\bin\cmake.exe"
set MSBUILD="C:\Program Files (x86)\MSBuild\12.0\Bin\msbuild.exe"
set DEPS_DIR=%CD%\deps
SET INSTALL_DIR=%CD%\Install

if NOT EXIST %INSTALL_DIR% mkdir %INSTALL_DIR%

set VARS_ALL="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"
call %VARS_ALL% x86_amd64

echo ---------------------------------------GDAL-------------------------------------
set GDAL_HOME=%INSTALL_DIR%

cd gdal


rem makegdal_gen 12.0 64 makefileproj_vs12
set gdalOptions=MSVC_VER=1800 WIN64=YES DEBUG=1

nmake /f makefile.vc %gdalOptions% > build.log
rem call :errorCheck "GDAL BUILD ERROR. Check %CD%\build.log."
nmake /f makefile.vc %gdalOptions% devinstall > install.log
rem call :errorCheck "GDAL INSTALL ERROR. Check %CD%\install.log."
ren %INSTALL_DIR%\bin\gdal201.dll %INSTALL_DIR%\bin\gdal201d.dll
ren %INSTALL_DIR%\lib\gdal_i.lib %INSTALL_DIR%\bin\gdal_d.dll

nmake /f makefile.vc clean

set gdalOptions=MSVC_VER=1800 WIN64=YES

nmake /f makefile.vc %gdalOptions% > build.log
call :errorCheck "GDAL BUILD ERROR. Check %CD%\build.log."
nmake /f makefile.vc %gdalOptions% devinstall > install.log
call :errorCheck "GDAL INSTALL ERROR. Check %CD%\install.log."

goto :eof

:errorCheck
if %ERRORLEVEL% GEQ 1 (
    echo %~1
    cd %PROJECT_DIR%
    exit /b
)
goto :eof
