import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;
  final VehicleService service;
  final VoidCallback onChanged;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
    required this.service,
    required this.onChanged,
  });

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  late Vehicle _v;

  @override
  void initState() {
    super.initState();
    _v = widget.vehicle;
  }

  @override
  Widget build(BuildContext context) {
    final batteryColor = _v.battery >= 60
        ? AppTheme.successColor
        : _v.battery >= 20
            ? AppTheme.warningColor
            : AppTheme.errorColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(_v.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 顶部电量卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Icon(
                        _v.charging ? Icons.charging_station : Icons.directions_bike,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_v.brand} ${_v.model}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _v.plateNumber,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 大电量圆环
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 背景圆
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      // 电量进度（用 CircularProgressIndicator 表示电量）
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: CircularProgressIndicator(
                          value: _v.battery / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_v.battery.round()}%',
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          Text(_v.charging ? '充电中' : '电量',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white
                                      .withValues(alpha: 0.8))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '估算续航 ${_v.range.round()} km',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 控制操作区
          Row(
            children: [
              _ActionCard(
                icon: _v.charging ? Icons.stop : Icons.charging_station,
                label: _v.charging ? '停止充电' : '开始充电',
                color: _v.charging
                    ? AppTheme.errorColor
                    : AppTheme.accentColor,
                onTap: () {
                  if (_v.charging) {
                    widget.service.stopCharge(_v.id);
                  } else {
                    widget.service.startCharge(_v.id);
                  }
                  setState(() {});
                  widget.onChanged();
                  _showSnack('已${_v.charging ? "停止" : "开始"}充电');
                },
              ),
              const SizedBox(width: 12),
              _ActionCard(
                icon: Icons.location_searching,
                label: '寻车定位',
                color: AppTheme.primaryColor,
                onTap: () {
                  widget.service.locateVehicle(_v.id);
                  setState(() {});
                  widget.onChanged();
                  _showSnack('已发送寻车指令，车辆将闪灯鸣笛');
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 车辆信息
          _SectionTitle('车辆信息'),
          _InfoRow(icon: Icons.tag, label: '车辆名称', value: _v.name),
          _InfoRow(icon: Icons.branding_watermark, label: '品牌', value: _v.brand),
          _InfoRow(icon: Icons.model_training, label: '型号', value: _v.model),
          _InfoRow(icon: Icons.car_rental, label: '车牌号', value: _v.plateNumber),
          _InfoRow(icon: Icons.qr_code, label: '车架号', value: _v.vin),
          _InfoRow(
              icon: Icons.calendar_month,
              label: '购买日期',
              value: _v.purchaseDate.toIso8601String().split('T')[0]),
          _InfoRow(icon: Icons.speed, label: '总里程', value: '${_v.mileage.round()} km'),
          if (_v.color != null && _v.color!.isNotEmpty)
            _InfoRow(icon: Icons.palette, label: '颜色', value: _v.color!),
          if (_v.description != null && _v.description!.isNotEmpty)
            _InfoRow(icon: Icons.notes, label: '备注', value: _v.description!),

          const SizedBox(height: 16),
          // 删除
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: const BorderSide(color: AppTheme.errorColor),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text('删除车辆'),
                        content: Text('确定删除「${_v.name}」吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('取消'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.errorColor),
                            onPressed: () {
                              widget.service.deleteVehicle(_v.id);
                              widget.onChanged();
                              Navigator.pop(ctx);
                              if (mounted) Navigator.pop(context);
                            },
                            child: const Text('删除'),
                          ),
                        ],
                      ),
                );
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('删除车辆'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: AppTheme.textSecondary)),
          const Spacer(),
          Expanded(
            flex: 3,
            child: Text(value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
          ),
        ],
      ),
    );
  }
}
