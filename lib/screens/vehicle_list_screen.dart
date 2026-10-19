import 'package:flutter/foundation.dart';
import 'package:vehicle_manager/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/screens/vehicle_detail_screen.dart';
import 'package:vehicle_manager/screens/vehicle_form_screen.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleService _vehicleService = VehicleService();
  final TextEditingController _searchController = TextEditingController();
  List<Vehicle> _filteredVehicles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await _vehicleService.init();
    } catch (e) {
      debugPrint('加载车辆数据失败: $e');
    }
    if (!mounted) return;
    setState(() {
      _filteredVehicles = _vehicleService.vehicles;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _filteredVehicles = _searchController.text.isEmpty
          ? _vehicleService.vehicles
          : _vehicleService.searchVehicles(_searchController.text);
    });
  }

  Future<void> _addVehicle() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleFormScreen(
          service: _vehicleService,
          onDone: _refresh,
        ),
      ),
    );
  }

  Future<void> _editVehicle(Vehicle v) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleFormScreen(
          service: _vehicleService,
          vehicle: v,
          onDone: _refresh,
        ),
      ),
    );
  }

  void _deleteVehicle(Vehicle v) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除车辆'),
        content: Text('确定删除「${v.name}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            onPressed: () {
              _vehicleService.deleteVehicle(v.id);
              _refresh();
              Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已删除')),
                );
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _openDetail(Vehicle v) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleDetailScreen(
          vehicle: v,
          service: _vehicleService,
          onChanged: _refresh,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的小摩托'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final c = TextEditingController();
              c.text = _searchController.text;
              c.selection = TextSelection(
                  baseOffset: c.text.length, extentOffset: c.text.length);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text('搜索车辆'),
                      content: TextField(
                        autofocus: true,
                        controller: c,
                        decoration:
                            const InputDecoration(hintText: '名称 / 品牌 / 车牌'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('取消'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _searchController.text = c.text;
                            _refresh();
                            Navigator.pop(ctx);
                          },
                          child: const Text('搜索'),
                        ),
                      ],
                    ),
              );
            },
          ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: '关于',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _refresh(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: '搜索车辆...',
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredVehicles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_bike,
                                  size: 72, color: AppTheme.textHint),
                              const SizedBox(height: 16),
                              const Text('暂无车辆',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppTheme.textSecondary)),
                              const SizedBox(height: 4),
                              Text('共 ${_vehicleService.vehicleCount} 辆车',
                                  style: const TextStyle(
                                      color: AppTheme.textHint)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 96),
                          itemCount: _filteredVehicles.length,
                          itemBuilder: (context, index) {
                            final v = _filteredVehicles[index];
                            return _VehicleCard(
                                vehicle: v,
                                onTap: () => _openDetail(v),
                                onEdit: () => _editVehicle(v),
                                onDelete: () => _deleteVehicle(v));
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVehicle,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _VehicleCard({
    required this.vehicle,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color batteryColor = vehicle.battery >= 60
        ? AppTheme.successColor
        : vehicle.battery >= 20
            ? AppTheme.warningColor
            : AppTheme.errorColor;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryColorLight,
                    child: Icon(
                      vehicle.charging ? Icons.charging_station : Icons.directions_bike,
                      color: vehicle.charging
                          ? AppTheme.accentColor
                          : AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              vehicle.name,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 8),
                            _StatusChip(vehicle: vehicle),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${vehicle.brand} ${vehicle.model}  ·  ${vehicle.plateNumber}',
                          style: const TextStyle(
                              fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                    if (onEdit != null)
                      PopupMenuButton<String>(
                        tooltip: "更多操作",
                        onSelected: (v) {
                          if (v == "edit") {
                            onEdit!();
                          } else if (v == "delete" && onDelete != null) {
                            onDelete!();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("编辑"),
                          ),
                          if (onDelete != null)
                            PopupMenuItem(
                              value: "delete",
                              child: Text(
                                "删除",
                                style: TextStyle(color: AppTheme.errorColor),
                              ),
                            ),
                        ],
                      ),
                ],
              ),
              const SizedBox(height: 14),
              // 电量条
              Row(
                children: [
                  Icon(
                    vehicle.charging ? Icons.charging_station : Icons.battery_full,
                    size: 18,
                    color: batteryColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: vehicle.battery / 100,
                        minHeight: 10,
                        backgroundColor: const Color(0xFFEEEEEE),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(batteryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${vehicle.battery.round()}%',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: batteryColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _InfoTag(
                      label: '续航',
                      value: '${vehicle.range.round()} km',
                      icon: Icons.rocket_launch),
                  const SizedBox(width: 16),
                  _InfoTag(
                      label: '总里程',
                      value: '${vehicle.mileage.round()} km',
                      icon: Icons.speed),
                  const SizedBox(width: 16),
                  _InfoTag(
                      label: '位置',
                      value: vehicle.location.isEmpty
                          ? '未知'
                          : vehicle.location,
                      icon: Icons.location_on),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final Vehicle vehicle;
  const _StatusChip({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    Color dot;
    String text;
    if (vehicle.charging) {
      dot = AppTheme.accentColor;
      text = '充电中';
    } else if (vehicle.online) {
      dot = AppTheme.successColor;
      text = '在线';
    } else {
      dot = AppTheme.textHint;
      text = '离线';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: dot.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(fontSize: 11, color: dot, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _InfoTag({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTheme.primaryColor),
            const SizedBox(width: 3),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary)),
      ],
    );
  }
}
