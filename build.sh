#!/bin/bash

# 车辆管家应用打包脚本
# 使用方法: bash build.sh

echo "========================================"
echo "车辆管家应用打包脚本"
echo "========================================"

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "错误: Flutter未安装"
    echo ""
    echo "请先安装Flutter SDK:"
    echo "1. 访问 https://docs.flutter.dev/get-started/install"
    echo "2. 下载并解压Flutter SDK"
    echo "3. 配置环境变量: export PATH=\$PATH:\$HOME/flutter/bin"
    echo ""
    exit 1
fi

# 检查Android SDK
if ! command -v adb &> /dev/null; then
    echo "警告: ADB未安装"
    echo "请安装Android SDK Platform Tools"
    echo ""
fi

# 进入项目目录
cd "$(dirname "$0")" || exit 1

# 清理之前的构建
echo "清理之前的构建..."
flutter clean

# 安装依赖
echo ""
echo "安装依赖..."
flutter pub get

# 检查设备连接
echo ""
echo "检查设备连接..."
flutter devices

# 生成Debug APK
echo ""
echo "========================================"
echo "生成Debug APK..."
echo "========================================"
flutter build apk --debug

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Debug APK生成成功!"
    echo "位置: build/app/outputs/flutter-apk/app-debug.apk"
    echo ""

    # 复制到外部存储
    cp build/app/outputs/flutter-apk/app-debug.apk /storage/emulated/0/Download/vehicle_manager_debug.apk
    echo "✅ 已复制到下载目录: /storage/emulated/0/Download/vehicle_manager_debug.apk"
else
    echo "❌ Debug APK生成失败"
    exit 1
fi

# 生成Release APK
echo ""
echo "========================================"
echo "生成Release APK..."
echo "========================================"
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Release APK生成成功!"
    echo "位置: build/app/outputs/flutter-apk/app-release.apk"
    echo ""

    # 复制到外部存储
    cp build/app/outputs/flutter-apk/app-release.apk /storage/emulated/0/Download/vehicle_manager_release.apk
    echo "✅ 已复制到下载目录: /storage/emulated/0/Download/vehicle_manager_release.apk"
else
    echo "❌ Release APK生成失败"
    exit 1
fi

# 生成App Bundle
echo ""
echo "========================================"
echo "生成App Bundle..."
echo "========================================"
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ App Bundle生成成功!"
    echo "位置: build/app/outputs/bundle/release/app-release.aab"
    echo ""

    # 复制到外部存储
    cp build/app/outputs/bundle/release/app-release.aab /storage/emulated/0/Download/vehicle_manager_release.aab
    echo "✅ 已复制到下载目录: /storage/emulated/0/Download/vehicle_manager_release.aab"
else
    echo "❌ App Bundle生成失败"
fi

echo ""
echo "========================================"
echo "✅ 打包完成!"
echo "========================================"
echo ""
echo "生成的文件已复制到下载目录:"
echo "  - vehicle_manager_debug.apk"
echo "  - vehicle_manager_release.apk"
echo "  - vehicle_manager_release.aab"
echo ""
echo "安装方法:"
echo "  1. 打开文件管理器"
echo "  2. 进入下载文件夹"
echo "  3. 找到APK文件"
echo "  4. 点击安装"
echo ""
