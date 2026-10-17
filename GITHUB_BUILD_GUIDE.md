# 🚀 GitHub Actions 自动构建指南

## ✅ 优势

- ✅ **不占用手机存储**（2-4 GB）
- ✅ **免费使用**（GitHub免费提供）
- ✅ **自动构建**（代码推送后自动生成APK）
- ✅ **多版本管理**（自动保存历史版本）
- ✅ **一键下载**（构建完成后直接下载APK）

## 📋 准备工作

### 1. 创建GitHub仓库

1. 访问 https://github.com
2. 点击右上角 "+" → "New repository"
3. 填写信息：
   - Repository name: `vehicle-manager`
   - Description: `车辆管家 - 雅迪智行风格车辆管理应用`
   - Public 或 Private
   - **不要**勾选 "Initialize this repository with a README"
4. 点击 "Create repository"

### 2. 上传项目文件

#### 方法A：使用Git命令（推荐）

```bash
# 1. 进入项目目录
cd vehicle_manager

# 2. 初始化Git仓库
git init

# 3. 添加所有文件
git add .

# 4. 提交
git commit -m "Initial commit: 车辆管家应用"

# 5. 添加远程仓库
git remote add origin https://github.com/你的用户名/vehicle-manager.git

# 6. 推送到GitHub
git push -u origin main
```

#### 方法B：使用GitHub网页上传

1. 在仓库页面点击 "uploading an existing file"
2. 将所有文件拖拽到上传区域
3. 点击 "Commit changes"

### 3. 启用GitHub Actions

1. 进入仓库页面
2. 点击 "Actions" 标签
3. 点击 "I understand my workflows, go ahead and enable them"
4. 首次使用需要授权

## 🎯 构建过程

### 自动触发

**方式1：推送代码**
```bash
git add .
git commit -m "更新代码"
git push
```

**方式2：创建Release**
1. 在GitHub仓库页面点击 "Releases"
2. 点击 "Create a new release"
3. 填写版本信息
4. 点击 "Publish release"

### 查看构建进度

1. 进入仓库 "Actions" 标签
2. 选择最新的工作流运行
3. 查看构建日志

**构建时间**：约5-10分钟

## 📥 下载APK

### 方式1：下载构建产物

1. 进入 "Actions" 标签
2. 选择最新的工作流运行
3. 滚动到 "Artifacts" 部分
4. 点击下载：
   - `debug-apk` - Debug版本
   - `release-apk` - Release版本
   - `release-aab` - App Bundle

### 方式2：通过Release下载

如果创建了Release：
1. 进入 "Releases" 页面
2. 选择对应版本
3. 在 "Assets" 部分下载APK

### 方式3：直接下载链接

构建完成后会生成直接下载链接：
```
https://github.com/你的用户名/vehicle-manager/actions/runs/运行ID
```

## 🔧 自定义配置

### 修改构建配置

编辑 `.github/workflows/build.yml`：

```yaml
# 修改Flutter版本
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'  # 改为 'beta' 或 'dev'
    cache: true

# 添加更多测试
- name: Run tests with coverage
  run: flutter test --coverage

# 修改APK名称
- name: Build Release APK
  run: flutter build apk --release --release-name="车辆管家 v1.0.0"

# 添加更多构建选项
- name: Build APK for different architectures
  run: |
    flutter build apk --split-per-abi --release
```

### 添加环境变量

```yaml
env:
  FLUTTER_VERSION: '3.16.0'
  BUILD_TYPE: 'release'
```

## 📊 构建产物说明

### 生成的文件

```
debug-apk/
└── app-debug.apk (~8MB)

release-apk/
└── app-release.apk (~4MB)

release-aab/
└── app-release.aab (~4MB)
```

### 文件用途

- **Debug APK**：用于测试，未优化
- **Release APK**：用于发布，已优化
- **App Bundle (.aab)**：用于Google Play，可生成多个APK

## 🎨 自定义应用信息

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

3. 更新所有Java/Kotlin文件中的包名引用

### 修改版本号

编辑 `android/app/build.gradle`：

```gradle
defaultConfig {
    versionCode 1
    versionName "1.0.0"
}
```

### 修改应用图标

1. 准备图标文件（512x512px PNG）
2. 替换 `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
3. 替换其他分辨率的图标文件
4. 提交代码，重新构建

## 📱 安装APK到手机

### 方法1：通过ADB安装

```bash
# 连接手机，启用USB调试
adb devices

# 安装APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 方法2：手动安装

1. 下载APK到手机
2. 使用文件管理器打开
3. 允许安装未知来源应用
4. 点击安装

## 🔄 更新应用

### 更新流程

1. **修改代码**
```bash
# 在您的电脑上修改代码
cd vehicle_manager
# ... 修改文件 ...
```

2. **提交更改**
```bash
git add .
git commit -m "更新内容"
git push
```

3. **等待自动构建**
   - GitHub Actions会自动开始构建
   - 约5-10分钟完成

4. **下载新APK**
   - 在Actions页面下载最新构建产物
   - 或通过Release下载

5. **安装更新**
   - 使用新APK覆盖安装
   - 或卸载旧版本后安装新版本

## 🐛 故障排除

### 构建失败

**问题1：Flutter版本不兼容**
```yaml
# 在build.yml中指定Flutter版本
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'
    flutter-version: '3.16.0'
```

**问题2：依赖安装失败**
```bash
# 在本地清理并重新安装
flutter clean
flutter pub get
```

**问题3：代码分析失败**
```yaml
# 在build.yml中跳过分析（可选）
- name: Analyze code
  run: flutter analyze || true
```

### 查看详细日志

1. 进入Actions页面
2. 点击失败的工作流
3. 点击具体的失败步骤
4. 查看完整日志

## 📊 监控构建

### 构建状态

- ✅ 成功：APK已生成
- ⏳ 运行中：正在构建
- ❌ 失败：查看日志修复

### 构建统计

GitHub Actions提供：
- 构建时间
- 成功率
- 下载次数
- 仓库统计

## 💡 高级功能

### 自动发布到Google Play

1. 配置Google Play Console API密钥
2. 添加发布步骤到workflow：
```yaml
- name: Upload to Play Store
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.PLAY_STORE_API_KEY }}
    packageName: com.yd.vehiclemanager
        releaseFiles: build/app/outputs/bundle/release/app-release.aab
        track: internal
```

### 添加截图生成

```yaml
- name: Generate Screenshots
  run: |
    flutter build apk --release
    # 使用adb截图工具生成应用截图
```

### 通知功能

```yaml
- name: Notify on Success
  if: success()
  uses: 8398a7/action-slack@v3
  with:
    status: custom
    custom_payload: |
      {
        text: '✅ 车辆管家APK构建成功！',
        attachments: [{
          color: 'good',
          text: '下载链接: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}'
        }]
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## 📞 需要帮助？

### GitHub Actions文档
- https://docs.github.com/en/actions

### Flutter文档
- https://docs.flutter.dev

### 常见问题
- https://github.com/actions/toolkit

## 🎉 完成！

现在您的车辆管家应用已经配置好自动构建系统！

**下次推送代码时，GitHub Actions会自动构建APK，您只需要下载即可！**

### 快速开始

1. ✅ 创建GitHub仓库
2. ✅ 上传项目文件
3. ✅ 推送代码
4. ✅ 等待构建（5-10分钟）
5. ✅ 下载APK

就这么简单！🚀
