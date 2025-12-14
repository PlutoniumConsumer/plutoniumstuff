@echo off
setlocal EnableDelayedExpansion

echo This will convert all TGA files in this folder to cropped PNGs and then delete the original TGA files.
echo Please make sure this .bat file is inside the folder with your images, nothing else.
set /p CONFIRM=Proceed? (y/n): 

if /i not "%CONFIRM%"=="y" (
    echo Operation cancelled.
    pause
    exit /b
)

pushd "%~dp0"

where magick >nul 2>nul
if errorlevel 1 (
    echo ImageMagick not found. Please install it or add it to PATH.
    popd
    pause
    exit /b
)

set FOUND=0

echo Looking for TGA files in: "%cd%"

for %%f in (*.tga *.TGA) do (
    set FOUND=1

    if exist "%%~nf.png" (
        echo Skipping "%%f" - "%%~nf.png" already exists.
    ) else (
        echo Converting and cropping "%%f"...
        magick "%%f" -alpha on -trim +repage "%%~nf.png" 

        if exist "%%~nf.png" (
            del "%%f"
        ) else (
            echo Conversion failed for "%%f"
        )
    )
)

if !FOUND! EQU 0 (
    echo No TGA files found.
)

popd

echo Conversion finished.
pause





