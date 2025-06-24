@echo off
setlocal EnableDelayedExpansion

REM === Set working directory to script location ===
cd /d %~dp0

REM === Check if inside a Flutter project ===
if not exist "pubspec.yaml" (
    echo ❌ This is not a Flutter project folder. Please run this script inside a Flutter project.
    pause
    exit /b
)

REM === Add core packages ===
echo 📦 Adding core packages...
call flutter pub add bloc
call flutter pub add flutter_bloc
call flutter pub add dartz
call flutter pub add equatable
call flutter pub add connectivity_plus
call flutter pub add get_it
call flutter pub add intl
call flutter pub add sizer

REM === Ask for Firebase or Dio ===
set /p use_which=Do you want to use Firebase or Dio? (firebase/dio): 
if /I "%use_which%"=="dio" (
    echo 📦 Adding Dio packages...
    call flutter pub add dio
    call flutter pub add pretty_dio_logger
) else if /I "%use_which%"=="firebase" (
    echo 📦 Adding Firebase packages...
    call flutter pub add firebase_core
    call flutter pub add cloud_firestore
)

REM === Create core folders ===
echo 🗂️ Creating core structure...
mkdir lib\src\core 2>nul
mkdir lib\src\core\utils 2>nul
mkdir lib\src\core\widgets 2>nul

REM === Ask for modules ===
set /p modules=Enter module names separated by space (e.g. auth home settings): 

REM === Ask if you want bloc or cubit ===
set /p state_type=Do you want to use Bloc or Cubit? (bloc/cubit): 

REM === Create folders for each module ===
for %%M in (%modules%) do (
    set module_name=%%M
    echo 🛠️ Creating folders for module: !module_name!
    mkdir lib\src\modules\!module_name! 2>nul
    mkdir lib\src\modules\!module_name!\data 2>nul
    mkdir lib\src\modules\!module_name!\data\models 2>nul
    mkdir lib\src\modules\!module_name!\data\services 2>nul
    mkdir lib\src\modules\!module_name!\data\repositories 2>nul
    mkdir lib\src\modules\!module_name!\%state_type% 2>nul
    mkdir lib\src\modules\!module_name!\ui 2>nul
    mkdir lib\src\modules\!module_name!\ui\screens 2>nul
    mkdir lib\src\modules\!module_name!\ui\widgets 2>nul
)

echo.
echo ✅ Flutter structure setup complete inside current project!
pause
