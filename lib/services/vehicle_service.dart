import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';

/// 车辆管理服务（带本地持久化）
class VehicleService {
  static const String _storageKey = 'vehicle_manager_data';

  final List<Vehicle> _vehicles = [];
  SharedPreferences? _prefs;

  VehicleService() {
    // 构造即加载 demo 兜底，避免首屏空白；init() 会用真实本地数据覆盖
    _loadDemo();
  }

  /// 初始化：从本地存储加载真实数据（若已有则覆盖 demo）
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_storageKey);
    if (raw != null) {
      _vehicles.clear();
      try {
        final list = json.decode(raw) as List;
        for (final item in list) {
          _vehicles.add(Vehicle.fromMap(item as Map<String, dynamic>));
        }
      } catch (e) {
        debugPrint('解析车辆数据失败: $e');
      }
    }
    // raw == null（从未保存过）则保留构造时的 demo 兜底数据
    _persist();
  }

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);

  /// 持久化到本地
  void _persist() {
    final p = _prefs;
    if (p == null) return;
    p.setString(_storageKey, toJson());
  }

  /// 添加车辆
  void addVehicle(Vehicle vehicle) {
    _vehicles.insert(0, vehicle);
    _persist();
  }

  /// 更新车辆
  void updateVehicle(Vehicle vehicle) {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      _persist();
    }
  }

  /// 删除车辆
  void deleteVehicle(String id) {
    _vehicles.removeWhere((v) => v.id == id);
    _persist();
  }

  /// 根据ID获取车辆
  Vehicle? getVehicleById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  int get vehicleCount => _vehicles.length;

  /// 搜索车辆
  List<Vehicle> searchVehicles(String query) {
    if (query.isEmpty) return vehicles;
    final q = query.toLowerCase();
    return _vehicles
        .where((v) =>
            v.name.toLowerCase().contains(q) ||
            v.brand.toLowerCase().contains(q) ||
            v.model.toLowerCase().contains(q) ||
            v.plateNumber.toLowerCase().contains(q))
        .toList();
  }

  // ===== 车辆操作（模拟，对标雅迪智行的控制能力）=====

  void startCharge(String id) {
    final v = getVehicleById(id);
    if (v != null) {
      v.charging = true;
      v.online = true;
      _persist();
    }
  }

  void stopCharge(String id) {
    final v = getVehicleById(id);
    if (v != null) {
      v.charging = false;
      _persist();
    }
  }

  void locateVehicle(String id) {
    final v = getVehicleById(id);
    if (v != null) {
      v.online = true;
      v.location =
          v.location.isEmpty ? '已定位到当前位置' : '已在${v.location}定位';
      _persist();
    }
  }

  /// 手动设置车辆状态（电量/续航/位置/在线）
  void updateState(String id,
      {double? battery,
      double? range,
      String? location,
      bool? online}) {
    final v = getVehicleById(id);
    if (v == null) return;
    if (battery != null) {
      v.battery = battery.clamp(0, 100).toDouble();
      v.range = (v.battery * 0.5).toDouble();
    }
    if (range != null) v.range = range;
    if (location != null) v.location = location;
    if (online != null) v.online = online;
    _persist();
  }

  // ===== 序列化 =====

  String toJson() => json.encode(_vehicles.map((v) => v.toMap()).toList());

  /// 示例数据（首屏兜底）
  void _loadDemo() {
    _vehicles.addAll([
      Vehicle(
        id: 'demo-1',
        name: '我的小摩托',
        brand: '我的',
        model: '小摩托',
        plateNumber: '粤A·D12345',
        vin: 'MYMOTO0000000001',
        purchaseDate: DateTime(2024, 6, 1),
        mileage: 1230,
        battery: 78,
        range: 39,
        online: true,
        charging: false,
        location: '家中楼下',
        lastRide: DateTime.now().subtract(const Duration(hours: 3)),
        color: '红色',
        description: '通勤主力',
      ),
      Vehicle(
        id: 'demo-2',
        name: '备用车',
        brand: '我的',
        model: '小摩托·轻',
        plateNumber: '粤A·E67890',
        vin: 'MYMOTO0000000002',
        purchaseDate: DateTime(2023, 11, 15),
        mileage: 4210,
        battery: 12,
        range: 6,
        online: false,
        charging: true,
        location: '公司充电桩',
        lastRide: DateTime.now().subtract(const Duration(days: 2)),
        color: '白色',
      ),
    ]);
  }
}
