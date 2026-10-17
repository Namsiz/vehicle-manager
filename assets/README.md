# 资源文件说明

## 图标资源

### 需要准备的图标文件

1. **应用图标** (`mipmap-anydpi-v26/ic_launcher.xml`)
   - 尺寸: 512x512px
   - 格式: PNG
   - 透明背景

2. **启动画面** (`drawable/ic_launcher_background.xml`)
   - 尺寸: 1024x1024px
   - 格式: PNG
   - 蓝色渐变背景

3. **应用图标** (`mipmap-mdpi/ic_launcher.png`)
   - 尺寸: 48x48px

4. **应用图标** (`mipmap-hdpi/ic_launcher.png`)
   - 尺寸: 72x72px

5. **应用图标** (`mipmap-xhdpi/ic_launcher.png`)
   - 尺寸: 96x96px

6. **应用图标** (`mipmap-xxhdpi/ic_launcher.png`)
   - 尺寸: 144x144px

7. **应用图标** (`mipmap-xxxhdpi/ic_launcher.png`)
   - 尺寸: 192x192px

## 图标设计建议

- **主色调**: 雅迪蓝 (#0056D2)
- **辅助色**: 橙色 (#FF9500)
- **背景**: 白色或浅蓝色渐变
- **形状**: 圆角矩形或圆形
- **文字**: "车辆管家"或"车辆管家"

## 创建应用图标

可以使用以下工具创建应用图标：

1. **Android Studio**: 图标资源编辑器
2. **Canva**: 在线设计工具
3. **Figma**: 专业UI设计工具
4. **在线图标生成器**: https://www.favicon-generator.org/

## 临时方案

在开发阶段，可以使用Android Studio默认图标，应用发布时再替换。

## 字体资源

### 自定义字体 (assets/fonts/YadeaFont.ttf)

- 当前使用系统字体
- 如需使用自定义字体，请添加字体文件并配置pubspec.yaml
