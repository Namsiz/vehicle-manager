import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

/// 关于页：显示应用版本（与 pubspec.yaml / APK 文件名统一）
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '...';
  String _build = '...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _version = info.version;     // e.g. 1.3.0
        _build = info.buildNumber;   // e.g. 3
      });
    } catch (_) {
      // package_info 不可用时展示静态值，避免空白
      setState(() {
        _version = '1.3.0';
        _build = '3';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.directions_bike,
                      color: Colors.white, size: 56),
                ),
                const SizedBox(height: 16),
                const Text('我的小摩托',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('版本 $_version ($build)',
                    style: const TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _Row(label: '应用名称', value: '我的小摩托'),
          _Row(label: '版本号', value: _version),
          _Row(label: '构建号', value: _build),
          _Row(label: '包名', value: 'com.my.mymoto'),
          _Row(label: '仓库', value: 'github.com/Namsiz/vehicle-manager'),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              '骑上我的小摩托，一路向北…',
              style: TextStyle(color: AppTheme.textHint, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14, color: AppTheme.textSecondary)),
            const Spacer(),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
