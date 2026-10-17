# 应用图标占位符

## 当前状态

应用目前使用Android Studio默认图标。

## 如何添加自定义图标

### 步骤1：准备图标资源

1. **图标尺寸**：
   - 512x512px (主图标)
   - 48x48px (mdpi)
   - 72x72px (hdpi)
   - 96x96px (xhdpi)
   - 144x144px (xxhdpi)
   - 192x192px (xxxhdpi)

2. **图标格式**：PNG，透明背景

3. **设计建议**：
   - 主色调：雅迪蓝 (#0056D2)
   - 辅助色：橙色 (#FF9500)
   - 形状：圆角矩形或圆形
   - 文字：车辆管家

### 步骤2：创建图标文件

**在线工具**：
- https://www.favicon-generator.org/
- https://www.canva.com/
- https://www.figma.com/

**设计工具**：
- Android Studio图标编辑器
- Adobe Photoshop
- Sketch
- Figma

### 步骤3：替换图标文件

将准备好的图标文件复制到以下位置：

```
android/app/src/main/res/
├── mipmap-anydpi-v26/
│   └── ic_launcher.xml              # 512x512px (XML格式)
├── mipmap-mdpi/
│   └── ic_launcher.png               # 48x48px
├── mipmap-hdpi/
│   └── ic_launcher.png               # 72x72px
├── mipmap-xhdpi/
│   └── ic_launcher.png               # 96x96px
├── mipmap-xxhdpi/
│   └── ic_launcher.png               # 144x144px
└── mipmap-xxxhdpi/
    └── ic_launcher.png               # 192x192px
```

### 步骤4：重新打包

```bash
flutter build apk --release
```

### 步骤5：测试

1. 安装新的APK
2. 查看应用图标
3. 检查不同分辨率下的显示效果

## 快速方案

在开发阶段，可以继续使用默认图标。

发布前再添加自定义图标。

## 图标设计示例

### 简单图标设计
```
┌─────────────────┐
│                 │
│    ╔═════╗      │
│    ║ 车 ║      │
│    ╚═════╝      │
│                 │
└─────────────────┘
```

### 渐变背景图标
```
┌─────────────────┐
│  ╔══════════╗   │
│  ║  ▓▓▓▓▓▓  ║   │
│  ║  ▓▓▓▓▓▓  ║   │
│  ║  车辆管家  ║   │
│  ╚══════════╝   │
└─────────────────┘
```

## 推荐图标资源

### 免费图标库
- https://www.flaticon.com/
- https://icons8.com/
- https://fontawesome.com/
- https://material.io/tools/icon/

### 在线生成器
- https://www.appicon.co/
- https://www.appiconmaker.com/
- https://www.iconfont.cn/

## 注意事项

1. **文件名必须准确**
   - ic_launcher.xml
   - ic_launcher.png

2. **尺寸必须正确**
   - 不要使用错误的尺寸

3. **格式必须正确**
   - PNG格式
   - 透明背景

4. **命名必须正确**
   - 不要修改文件名

## 技术说明

Android会自动根据设备密度选择合适的图标：
- mdpi: 1x
- hdpi: 1.5x
- xhdpi: 2x
- xxhdpi: 3x
- xxxhdpi: 4x

## 示例代码

### ic_launcher.xml (mipmap-anydpi-v26)

```xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
```

### ic_launcher_background.xml (drawable)

```xml
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <gradient
        android:startColor="#0056D2"
        android:endColor="#003D99"
        android:angle="90"/>
</shape>
```

## 完成

添加图标后，记得重新打包并测试！
