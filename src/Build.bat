@echo off
:: Compiles DynamoCoreUpdate.csproj into a single self-contained exe.
:: Output: dist\DynamoCoreUpdate.exe

cd /d "%~dp0"

echo Building DynamoCoreUpdate.exe...
dotnet publish DynamoCoreUpdate.csproj ^
    -c Release ^
    -r win-x64 ^
    --self-contained true ^
    -p:PublishSingleFile=true ^
    -p:PublishDir=dist ^
    -o dist

if %errorLevel% neq 0 (
    echo.
    echo Build failed.
    pause
    exit /b %errorLevel%
)

echo.
echo Build complete: dist\DynamoCoreUpdate.exe
pause
