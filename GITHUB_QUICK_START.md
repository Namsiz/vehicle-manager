# 🚀 GitHub方案 - 5分钟快速上手

## ✅ 为什么选择GitHub方案？

- ✅ **不需要安装Flutter**（节省2-4 GB空间）
- ✅ **完全免费**（GitHub免费提供）
- ✅ **自动构建**（代码推送后自动生成APK）
- ✅ **一键下载**（构建完成后直接下载）
- ✅ **多版本管理**（自动保存历史版本）

## 📋 3步完成构建

### 步骤1：创建GitHub仓库（2分钟）

1. 访问 https://github.com/new
2. 填写信息：
   - Repository name: `vehicle-manager`
   - Description: `车辆管家 - 雅迪智行风格车辆管理应用`
   - Public（公开）或 Private（私有）
   - **不要**勾选任何初始化选项
3. 点击 "Create repository"

### 步骤2：上传项目文件（1分钟）

**方法A：使用Git命令（推荐）**

```bash
# 在您的电脑上执行
cd vehicle_manager

# 初始化Git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: 车辆管家应用"

# 添加远程仓库（替换为您的GitHub用户名）
git remote add origin https://github.com/你的用户名/vehicle-manager.git

# 推送到GitHub
git push -u origin main
```

**方法B：使用网页上传**

1. 在仓库页面点击 "uploading an existing file"
2. 将 `vehicle_manager` 文件夹中的所有文件拖拽到上传区域
3. 每个文件点击 "Commit changes"

### 步骤3：等待构建并下载APK（5-10分钟）

1. **等待自动构建**
   - 进入仓库 "Actions" 标签
   - 点击第一个工作流运行
   - 等待构建完成（约5-10分钟）

2. **下载APK**
   - 在构建页面滚动到 "Artifacts" 部分
   - 点击下载 `release-apk`
   - 解压下载得到 `app-release.apk`

3. **安装到手机**
   - 将APK复制到手机
   - 使用文件管理器打开并安装

## 📥 构建产物

### 下载的文件

```
release-apk/
└── app-release.apk (~4MB)
```

### 其他构建产物

- `debug-apk` - Debug版本（测试用）
- `release-aab` - App Bundle（用于Google Play）

## 🎨 自定义应用

### 修改应用名称

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<application
    android:label="车辆管家"
    ...>
```

### 修改包名

编辑 `android/app/build.gradle`：

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

### 修改版本号

编辑 `android/app/build.gradle`：

```gradle
defaultConfig {
    versionCode 1
    versionName "1.0.0"
}
```

## 🔄 更新应用

### 更新流程

1. **修改代码**
2. **提交到GitHub**
   ```bash
   git add .
   git commit -m "更新内容"
   git push
   ```
3. **等待自动构建**（5-10分钟）
4. **下载新APK**
5. **安装更新**

## 📊 构建状态

### 查看构建进度

1. 进入仓库 "Actions" 标签
2. 选择最新的工作流运行
3. 查看构建日志

### 构建状态说明

- ✅ **成功**：APK已生成，可以下载
- ⏳ **运行中**：正在构建
- ❌ **失败**：查看日志修复

## 🐛 常见问题

### Q1: 构建失败怎么办？

**A**: 查看 Actions 日志，常见问题：
- Flutter版本不兼容 → 修改 build.yml
- 依赖安装失败 → 在本地清理后重新上传
- 代码分析失败 → 在 build.yml 中跳过分析

### Q2: 如何修改Flutter版本？

**A**: 编辑 `.github/workflows/build.yml`：

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'  # 改为 'beta' 或 'dev'
```

### Q3: 可以修改APK名称吗？

**A**: 可以，在 build.yml 中添加：

```yaml
- name: Build Release APK
  run: flutter build apk --release --release-name="车辆管家 v1.0.0"
```

### Q4: 下载的APK在哪里？

**A**: 在 Actions 页面的 "Artifacts" 部分，点击下载按钮。

### Q5: 构建需要多长时间？

**A**: 通常5-10分钟，取决于网络和GitHub服务器负载。

## 📱 安装APK

### 方法1：手动安装

1. 下载APK到手机
2. 打开文件管理器
3. 找到APK文件
4. 点击安装
5. 允许安装未知来源应用

### 方法2：ADB安装

```bash
adb install app-release.apk
```

## 🎯 下一步

- 📖 [完整构建指南](GITHUB_BUILD_GUIDE.md) - 详细教程
- 📖 [项目说明](README.md) - 功能介绍
- 📖 [打包指南](BUILD_GUIDE.md) - 本地打包方式

## 💡 提示

- ✅ 首次推送代码后，Actions会自动运行
- ✅ 构建完成后，APK会保留30天
- ✅ 可以创建Release自动发布到GitHub
- ✅ 支持多平台构建（Windows/Mac/Linux）

## 🎉 完成！

现在您的车辆管家应用已经配置好自动构建系统！

**下次推送代码时，GitHub Actions会自动构建APK，您只需要下载即可！**

就这么简单！🚀
