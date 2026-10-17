@echo off
chcp 65001 >nul
echo ========================================
echo 车辆管家应用打包脚本 (Windows)
echo ========================================

REM 检查Flutter是否安装
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Flutter未安装
    echo.
    echo 请先安装Flutter SDK:
    echo 1. 访问 https://docs.flutter.dev/get-started/install
    echo 2. 下载并解压Flutter SDK
    echo 3. 配置环境变量: set PATH=%PATH%;C:\flutter\bin
    echo.
    pause
    exit /b 1
)

REM 检查Android SDK
where adb >nul 2>&1
if %errorlevel% neq 0 (
    echo 警告: ADB未安装
    echo 请安装Android SDK Platform Tools
    echo.
)

REM 进入项目目录
cd /d "%~dp0" || exit /b 1

REM 清理之前的构建
echo 清理之前的构建...
flutter clean

REM 安装依赖
echo.
echo 安装依赖...
flutter pub get

REM 检查设备连接
echo.
echo 检查设备连接...
flutter devices

REM 生成Debug APK
echo.
echo ========================================
echo 生成Debug APK...
echo ========================================
flutter build apk --debug

if %errorlevel% equ 0 (
    echo.
    echo ✅ Debug APK生成成功!
    echo 位置: build\app\outputs\flutter-apk\app-debug.apk
    echo.

    REM 复制到外部存储
    copy /Y build\app\outputs\flutter-apk\app-debug.apk "%USERPROFILE%\Downloads\vehicle_manager_debug.apk" >nul
    echo ✅ 已复制到下载目录: %USERPROFILE%\Downloads\vehicle_manager_debug.apk
) else (
    echo ❌ Debug APK生成失败
    pause
    exit /b 1
)

REM 生成Release APK
echo.
echo ========================================
echo 生成Release APK...
echo ========================================
flutter build apk --release

if %errorlevel% equ 0 (
    echo.
    echo ✅ Release APK生成成功!
    echo 位置: build\app\outputs\flutter-apk\app-release.apk
    echo.

    REM 复制到外部存储
    copy /Y build\app\outputs\flutter-apk\app-release.apk "%USERPROFILE%\Downloads\vehicle_manager_release.apk" >nul
    echo ✅ 已复制到下载目录: %USERPROFILE%\Downloads\vehicle_manager_release.apk
) else (
    echo ❌ Release APK生成失败
    pause
    exit /b 1
)

REM 生成App Bundle
echo.
echo ========================================
echo 生成App Bundle...
echo ========================================
flutter build appbundle --release

if %errorlevel% equ 0 (
    echo.
    echo ✅ App Bundle生成成功!
    echo 位置: build\app\outputs\bundle\release\app-release.aab
    echo.

    REM 复制到外部存储
    copy /Y build\app\outputs\bundle\release\app-release.aab "%USERPROFILE%\Downloads\vehicle_manager_release.aab" >nul
    echo ✅ 已复制到下载目录: %USERPROFILE%\Downloads\vehicle_manager_release.aab
) else (
    echo ❌ App Bundle生成失败
)

echo.
echo ========================================
echo ✅ 打包完成!
echo ========================================
echo.
echo 生成的文件已复制到下载目录:
echo   - vehicle_manager_debug.apk
echo   - vehicle_manager_release.apk
echo   - vehicle_manager_release.aab
echo.
echo 安装方法:
echo   1. 打开文件管理器
echo   2. 进入下载文件夹
echo   3. 找到APK文件
echo   4. 点击安装
echo.
pause
