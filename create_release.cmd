@echo off

set QT=C:\Qt\5.6.0-desktop-vs2013-x64
set PATH=%QT%\bin;%PATH%

call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" x64

set BUILD="%~dp0Build\Build\Release"
for /f "delims=" %%i IN ('git rev-list --count HEAD') do set TARGET=CxxProfiler-r%%i

mkdir "%TARGET%" 2>nul

copy "%~dp0Readme.md" "%TARGET%\Readme.txt"
copy "%~dp0LICENSE" "%TARGET%\License.txt"
copy "%BUILD%\CxxProfiler.exe" "%TARGET%"
copy "%BUILD%\dbghelp.dll" "%TARGET%"
copy "%BUILD%\symsrv.dll" "%TARGET%"
type NUL > "%TARGET%\symsrv.yes"

windeployqt.exe --no-translations  --no-compiler-runtime --no-svg "%TARGET%\CxxProfiler.exe"
rd /s /q "%TARGET%\imageformats"

copy "%VS120COMNTOOLS%..\..\VC\redist\x64\Microsoft.VC120.CRT\msvcp120.dll" "%TARGET%"
copy "%VS120COMNTOOLS%..\..\VC\redist\x64\Microsoft.VC120.CRT\msvcr120.dll" "%TARGET%"

7za.exe a -mx=9 -r -tzip "%TARGET%.zip" "%TARGET%"
rd /s /q "%TARGET%"