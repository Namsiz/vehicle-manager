import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

/// 车辆设置页：严格对标雅迪智行 B10-G 的真实设置项
class VehicleSettingsScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleSettingsScreen({super.key, required this.vehicle});

  @override
  State<VehicleSettingsScreen> createState() => _VehicleSettingsScreenState();
}

class _VehicleSettingsScreenState extends State<VehicleSettingsScreen> {
  // 安全守护
  bool _tcs = true;
  bool _alarmSound = true;
  String _alarmSensitivity = '中';
  String _armingMode = '关机自动设防';
  bool _beidou = true;

  // 灯光音效
  bool _autoHeadlight = false;
  String _volume = '高';
  String _soundEffect = '音效一';

  // 感应解锁
  bool _sideStandOn = true;
  bool _sideStandSensor = true;
  bool _sideStandAutoOff = true;
  bool _timedAutoOff = true;

  // 骑行控制
  bool _steepDescent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('车辆设置')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ===== 安全守护 =====
          _GroupTitle('安全守护'),
          _SwitchTile(
            title: 'TCS车身稳定',
            subtitle: '湿滑路面骑行时保持车身稳定',
            value: _tcs,
            onChanged: (v) => setState(() => _tcs = v),
          ),
          _SwitchTile(
            title: '报警音',
            subtitle: '关闭后，车辆报警时仅锁电机无声音提醒',
            value: _alarmSound,
            onChanged: (v) => setState(() => _alarmSound = v),
          ),
          _PickerTile(
            title: '车辆报警灵敏度',
            value: _alarmSensitivity,
            onTap: () => _pick('车辆报警灵敏度', ['低', '中', '高'],
                (v) => setState(() => _alarmSensitivity = v)),
          ),
          _PickerTile(
            title: '设防模式',
            value: _armingMode,
            onTap: () => _pick('设防模式', ['关机自动设防', '遥控设防', '不自动设防'],
                (v) => setState(() => _armingMode = v)),
          ),
          _SwitchTile(
            title: '北斗功能选择',
            subtitle: '开启北斗定位增强定位精度',
            value: _beidou,
            onChanged: (v) => setState(() => _beidou = v),
          ),

          // ===== 灯光音效 =====
          _GroupTitle('灯光音效'),
          _SwitchTile(
            title: '自动大灯',
            subtitle: '感应光线环境自动开关大灯',
            value: _autoHeadlight,
            onChanged: (v) => setState(() => _autoHeadlight = v),
          ),
          _PickerTile(
            title: '车辆音量',
            value: _volume,
            onTap: () => _pick('车辆音量', ['低', '中', '高'],
                (v) => setState(() => _volume = v)),
          ),
          _PickerTile(
            title: '车辆音效',
            value: _soundEffect,
            onTap: () => _pick('车辆音效', ['音效一', '音效二', '音效三'],
                (v) => setState(() => _soundEffect = v)),
          ),

          // ===== 感应解锁 =====
          _GroupTitle('感应解锁'),
          _SwitchTile(
            title: '边撑开机',
            subtitle: '蓝牙连接时踢起边撑车辆自动开机',
            value: _sideStandOn,
            onChanged: (v) => setState(() => _sideStandOn = v),
          ),
          _SwitchTile(
            title: '边撑感应',
            subtitle: '开启后，落下边撑不飞车，收起边撑直接骑',
            value: _sideStandSensor,
            onChanged: (v) => setState(() => _sideStandSensor = v),
          ),
          _SwitchTile(
            title: '边撑自动关机',
            value: _sideStandAutoOff,
            onChanged: (v) => setState(() => _sideStandAutoOff = v),
          ),
          _SwitchTile(
            title: '离车定时关机',
            value: _timedAutoOff,
            onChanged: (v) => setState(() => _timedAutoOff = v),
          ),

          // ===== 骑行控制 =====
          _GroupTitle('骑行控制'),
          _SwitchTile(
            title: '陡坡缓降',
            subtitle: '较陡的坡道下坡时，可增强抓地力，缓慢下降',
            value: _steepDescent,
            onChanged: (v) => setState(() => _steepDescent = v),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              '数据已按雅迪智行「${widget.vehicle.name}」真实设置项实现',
              style: const TextStyle(fontSize: 11, color: AppTheme.textHint),
            ),
          ),
        ],
      ),
    );
  }

  void _pick(String title, List<String> options, ValueChanged<String> onPicked) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(title),
        children: options
            .map((o) => SimpleDialogOption(
                  onPressed: () {
                    onPicked(o);
                    Navigator.pop(ctx);
                  },
                  child: Text(o),
                ))
            .toList(),
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final String text;
  const _GroupTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor)),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: const TextStyle(fontSize: 12)),
        value: value,
        activeColor: AppTheme.primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _PickerTile(
      {required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            Text(value,
                style: const TextStyle(
                    fontSize: 15, color: AppTheme.primaryColor)),
            const Icon(Icons.chevron_right, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
