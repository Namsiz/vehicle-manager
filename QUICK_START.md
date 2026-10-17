# 车辆管家应用 - 快速开始指南

## 📱 应用信息

- **应用名称**: 车辆管家
- **包名**: com.yd.vehiclemanager
- **版本**: 1.0.0
- **设计风格**: 雅迪智行风格

## 🚀 快速打包安装

### 方法一：使用打包脚本（推荐）

#### Windows用户
```bash
# 双击运行
build.bat
```

#### macOS/Linux用户
```bash
# 添加执行权限
chmod +x build.sh

# 运行打包脚本
bash build.sh
```

打包完成后，APK文件会自动复制到下载目录。

### 方法二：手动打包

#### 步骤1：安装Flutter SDK

1. **下载Flutter SDK**：
   - 访问：https://docs.flutter.dev/get-started/install
   - 下载最新稳定版（推荐3.16+）
   - 解压到任意目录

2. **配置环境变量**：

   **Windows**:
   ```bash
   setx PATH "%PATH%;C:\flutter\bin"
   ```

   **macOS/Linux**:
   ```bash
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **验证安装**：
   ```bash
   flutter doctor
   ```

#### 步骤2：安装Android SDK

1. **安装Android Studio**：
   - 下载：https://developer.android.com/studio
   - 安装Android SDK Platform 33

2. **配置环境变量**：
   ```bash
   # Windows
   setx ANDROID_HOME "C:\Users\你的用户名\AppData\Local\Android\Sdk"
   setx PATH "%PATH%;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\tools"

   # macOS/Linux
   export ANDROID_HOME=$HOME/Library/Android/sdk
   export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools
   ```

#### 步骤3：打包应用

```bash
# 进入项目目录
cd vehicle_manager

# 安装依赖
flutter pub get

# 清理缓存
flutter clean

# 生成Debug APK
flutter build apk --debug

# 生成Release APK
flutter build apk --release
```

#### 步骤4：安装到手机

**方法1：通过ADB安装**
```bash
# 检查设备连接
adb devices

# 安装APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

**方法2：手动安装**
1. 将APK文件复制到手机
2. 使用文件管理器打开APK
3. 允许安装未知来源应用
4. 点击安装

## 📲 安装到手机

### 使用ADB安装

1. **连接手机**：
   - 启用USB调试
   - 使用USB线连接电脑

2. **验证连接**：
   ```bash
   adb devices
   ```
   应该看到您的设备

3. **安装应用**：
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

### 手动安装

1. **复制APK到手机**：
   - 通过USB传输
   - 通过微信/QQ发送
   - 通过邮件发送

2. **安装**：
   - 打开文件管理器
   - 进入下载文件夹
   - 找到APK文件
   - 点击安装

3. **允许安装**：
   - 首次安装需要允许"安装未知应用"
   - 在设置中找到文件管理器或浏览器
   - 允许安装未知应用

## 🎨 自定义应用

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

2. 重命名包名文件夹：
```bash
cd android/app/src/main/java
mv com/example/vehicle_manager com/yd/vehicle_manager
```

### 修改应用图标

1. 准备图标文件（512x512px PNG）

2. 替换图标文件：
   - `mipmap-anydpi-v26/ic_launcher.xml`
   - `mipmap-mdpi/ic_launcher.png`
   - `mipmap-hdpi/ic_launcher.png`
   - `mipmap-xhdpi/ic_launcher.png`
   - `mipmap-xxhdpi/ic_launcher.png`
   - `mipmap-xxxhdpi/ic_launcher.png`

3. 重新打包

## 🔧 常见问题

### 1. Flutter命令找不到

**错误**: `'flutter' 不是内部或外部命令`

**解决**:
```bash
# Windows
setx PATH "%PATH%;C:\flutter\bin"

# macOS/Linux
export PATH="$PATH:$HOME/flutter/bin"
```

### 2. Gradle构建失败

**错误**: `Gradle build failed`

**解决**:
```bash
# 清理缓存
flutter clean
flutter pub get

# 更新依赖
flutter upgrade

# 检查Gradle版本
cd android
./gradlew clean
cd ..
```

### 3. 设备连接失败

**错误**: `No devices found`

**解决**:
- 确保USB调试已启用
- 尝试更换USB端口
- 在手机上授权电脑
- 检查ADB驱动

### 4. 权限被拒绝

**错误**: `Permission denied`

**解决**:
```bash
# macOS/Linux
chmod +x build.sh
chmod +x build.bat

# Windows
右键 build.bat → 属性 → 解除锁定 → 确定
```

### 5. 依赖安装失败

**错误**: `Package not found`

**解决**:
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## 📊 打包输出文件说明

### Debug APK
- **文件名**: app-debug.apk
- **用途**: 开发和测试
- **特点**: 未混淆、未优化、体积较大
- **大小**: 约8-10MB

### Release APK
- **文件名**: app-release.apk
- **用途**: 发布和安装
- **特点**: 已优化、已混淆、体积较小
- **大小**: 约4-6MB

### App Bundle (.aab)
- **文件名**: app-release.aab
- **用途**: Google Play发布
- **特点**: 可生成多个APK，支持多种设备
- **优势**: 自动优化，节省用户流量

## 🎯 下一步

安装完成后，您可以：

1. **添加第一辆车**：
   - 点击右上角"+"按钮
   - 填写车辆信息

2. **管理车辆**：
   - 查看车辆列表
   - 编辑车辆信息
   - 删除不需要的车辆

3. **搜索车辆**：
   - 在搜索框输入关键词

## 📞 获取帮助

- **Flutter文档**: https://docs.flutter.dev
- **问题反馈**: https://github.com/flutter/flutter/issues
- **Android文档**: https://developer.android.com

## 📄 许可证

MIT License
