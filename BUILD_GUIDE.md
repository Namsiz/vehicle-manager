# 车辆管家应用 - 打包和安装指南

## 📱 应用信息

- **应用名称**: 车辆管家
- **包名**: com.yd.vehiclemanager
- **版本**: 1.0.0
- **设计风格**: 雅迪智行风格

## 🛠️ 打包步骤

### 前提条件

1. 安装 Flutter SDK
2. 安装 Android Studio
3. 配置 Android SDK
4. 连接 Android 设备或启动模拟器

### 详细步骤

#### 1. 进入项目目录

```bash
cd vehicle_manager
```

#### 2. 安装依赖

```bash
flutter pub get
```

#### 3. 检查环境

```bash
flutter doctor
```

确保所有检查项都通过。

#### 4. 生成Debug APK

```bash
flutter build apk --debug
```

生成的APK位置：
```
build/app/outputs/flutter-apk/app-debug.apk
```

#### 5. 生成Release APK（推荐）

```bash
flutter build apk --release
```

生成的APK位置：
```
build/app/outputs/flutter-apk/app-release.apk
```

#### 6. 生成App Bundle（推荐用于发布）

```bash
flutter build appbundle --release
```

生成的文件位置：
```
build/app/outputs/bundle/release/app-release.aab
```

## 📲 安装步骤

### 方法1：通过ADB安装

1. 连接Android设备并启用USB调试
2. 检查设备连接：
```bash
adb devices
```

3. 安装APK：
```bash
flutter install
```

或直接安装：
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 方法2：手动安装

1. 将APK文件复制到手机
2. 使用文件管理器打开APK文件
3. 允许安装未知来源应用
4. 点击"安装"

### 方法3：通过Android Studio安装

1. 连接设备或启动模拟器
2. 在Android Studio中打开项目
3. 点击工具栏的"Run"按钮
4. 选择目标设备
5. 等待安装完成

## 🎨 自定义图标

### 创建应用图标

1. **下载图标资源**：
   - 使用Canva或Figma创建图标
   - 或从网上下载免费图标资源
   - 建议尺寸：512x512px

2. **替换图标文件**：
   ```bash
   # 复制图标到项目目录
   cp icon.png android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
   ```

3. **重新打包**：
   ```bash
   flutter build apk --release
   ```

### 图标文件位置

```
android/app/src/main/res/
├── mipmap-anydpi-v26/
│   └── ic_launcher.xml          # 512x512px
├── mipmap-mdpi/
│   └── ic_launcher.png           # 48x48px
├── mipmap-hdpi/
│   └── ic_launcher.png           # 72x72px
├── mipmap-xhdpi/
│   └── ic_launcher.png           # 96x96px
├── mipmap-xxhdpi/
│   └── ic_launcher.png           # 144x144px
├── mipmap-xxxhdpi/
│   └── ic_launcher.png           # 192x192px
└── drawable/
    └── ic_launcher_background.xml # 启动背景
```

## 🔧 修改应用信息

### 修改应用名称

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<application
    android:label="车辆管家"
    ...>
```

### 修改包名

1. 编辑 `android/app/build.gradle`：
```gradle
android {
    namespace "com.yd.vehiclemanager"
    ...
}
defaultConfig {
    applicationId "com.yd.vehiclemanager"
    ...
}
```

2. 重命名文件夹：
```bash
cd android/app/src/main/java
mv com/example/vehicle_manager com/yd/vehicle_manager
```

3. 更新所有Java/Kotlin文件中的包名引用

4. 重新打包

### 修改版本号

编辑 `android/app/build.gradle`：

```gradle
defaultConfig {
    versionCode 1
    versionName "1.0.0"
}
```

## 📋 应用权限说明

应用需要以下权限：

- **INTERNET**: 网络访问
- **READ_EXTERNAL_STORAGE**: 读取存储
- **WRITE_EXTERNAL_STORAGE**: 写入存储
- **READ_MEDIA_IMAGES**: 读取图片
- **CAMERA**: 相机访问

## 🐛 常见问题

### 1. flutter命令找不到

确保Flutter已添加到PATH环境变量：
```bash
export PATH="$PATH:$HOME/flutter/bin"
```

### 2. 依赖安装失败

清理缓存后重新安装：
```bash
flutter clean
flutter pub get
```

### 3. 设备连接失败

- 检查USB调试是否启用
- 尝试更换USB端口
- 检查ADB驱动

### 4. 打包失败

- 确保Android SDK已安装
- 检查Java JDK版本（需要JDK 8或更高）
- 清理构建缓存：
```bash
flutter clean
```

## 📞 获取帮助

- Flutter官方文档: https://docs.flutter.dev
- Flutter问题追踪: https://github.com/flutter/flutter/issues
- Android开发者文档: https://developer.android.com

## 📄 许可证

MIT License

## 🎯 下一步

- [ ] 添加车辆照片功能
- [ ] 实现数据导出功能
- [ ] 添加深色模式
- [ ] 实现数据备份
- [ ] 添加保养提醒功能
