import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/screens/about_screen.dart';
import 'package:vehicle_manager/screens/vehicle_detail_screen.dart';
import 'package:vehicle_manager/screens/vehicle_form_screen.dart';
import 'package:vehicle_manager/screens/vehicle_settings_screen.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

/// 爱车主页：仿雅迪智行布局，展示实时车辆状态
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

  void _openSettings(Vehicle v) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleSettingsScreen(vehicle: v),
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
          : _filteredVehicles.isEmpty
              ? _EmptyView(onAdd: _addVehicle)
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: _filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final v = _filteredVehicles[index];
                    return _VehicleHomeCard(
                        vehicle: v,
                        onTap: () => _openDetail(v),
                        onEdit: () => _editVehicle(v),
                        onDelete: () => _deleteVehicle(v),
                        onSettings: () => _openSettings(v));
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVehicle,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_bike, size: 72, color: AppTheme.textHint),
          const SizedBox(height: 16),
          const Text('暂无车辆',
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          TextButton(onPressed: onAdd, child: const Text('添加车辆')),
        ],
      ),
    );
  }
}

/// 爱车主页卡片：仿雅迪智行（电量% + 状态 + 续航 + 位置 + 总里程 + 快捷操作）
class _VehicleHomeCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onSettings;

  const _VehicleHomeCard({
    required this.vehicle,
    required this.onTap,
    required this.onSettings,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final batteryColor = vehicle.battery >= 60
        ? AppTheme.successColor
        : vehicle.battery >= 20
            ? AppTheme.warningColor
            : AppTheme.errorColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 昵称 + 状态
          Row(
            children: [
              Expanded(
                child: Text(vehicle.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              PopupMenuButton<String>(
                tooltip: '更多操作',
                onSelected: (v) {
                  if (v == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (v == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(value: 'edit', child: Text('编辑')),
                  if (onDelete != null)
                    PopupMenuItem(
                        value: 'delete',
                        child: Text('删除',
                            style: TextStyle(color: AppTheme.errorColor))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 顶部渐变卡片：电量 + 状态 + 续航
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
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 84,
                            height: 84,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white
                                        .withValues(alpha: 0.15),
                                  ),
                                ),
                                SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: CircularProgressIndicator(
                                    value: vehicle.battery / 100,
                                    strokeWidth: 6,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.2),
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${vehicle.battery.round()}%',
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicle.charging
                                    ? '充电中'
                                    : vehicle.online
                                        ? '已开机'
                                        : '已锁车',
                                style: TextStyle(
                                    color: Colors.white
                                        .withValues(alpha: 0.95),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '续航 ${vehicle.range.toStringAsFixed(1)}km',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // 位置 + 总里程
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: AppTheme.primaryColor),
                        const SizedBox(width: 4),
                        const Text('爱车位置',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicle.location.isEmpty ? '未知' : vehicle.location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('总里程',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.mileage.toStringAsFixed(1)} km',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 快捷操作行：开关机 / 车锁 / 寻车 / 车辆详情
          Row(
            children: [
              _ActionButton(
                  icon: Icons.power_settings_new, label: '开关机', onTap: () {}),
              _ActionButton(
                  icon: Icons.lock_outline, label: '车锁', onTap: () {}),
              _ActionButton(
                  icon: Icons.location_searching, label: '寻车', onTap: () {}),
              _ActionButton(
                  icon: Icons.chevron_right, label: '车辆详情', onTap: onTap),
            ],
          ),
          const SizedBox(height: 14),
          // 设置入口
          ListTile(
            tileColor: const Color(0xFFF7F8FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.settings_outlined,
                color: AppTheme.primaryColor),
            title: const Text('车辆设置',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right),
            onTap: onSettings,
          ),
          const SizedBox(height: 6),
          ListTile(
            tileColor: const Color(0xFFF7F8FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.bluetooth,
                color: AppTheme.primaryColor),
            title: const Text('蓝牙钥匙',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: 6),
          ListTile(
            tileColor: const Color(0xFFF7F8FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.group_outlined,
                color: AppTheme.primaryColor),
            title: const Text('亲友用车',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 24),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
