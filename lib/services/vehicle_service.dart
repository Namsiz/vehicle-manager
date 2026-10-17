import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';

/// 车辆管理服务
class VehicleService {
  static const String _storageKey = 'vehicle_manager_data';

  List<Vehicle> _vehicles = [];

  VehicleService();

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);

  /// 添加车辆
  void addVehicle(Vehicle vehicle) {
    _vehicles.insert(0, vehicle);
  }

  /// 更新车辆
  void updateVehicle(Vehicle vehicle) {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
    }
  }

  /// 删除车辆
  void deleteVehicle(String id) {
    _vehicles.removeWhere((v) => v.id == id);
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

  /// 开始充电
  void startCharge(String id) {
    final v = getVehicleById(id);
    if (v != null) {
      v.charging = true;
      v.online = true;
    }
  }

  /// 停止充电
  void stopCharge(String id) {
    final v = getVehicleById(id);
    if (v != null) {
      v.charging = false;
    }
  }

  /// 模拟寻车（闪灯鸣笛）——更新最近位置
  void locateVehicle(String id) {
    final v = getVehicleById(id);
    if (v != null) {
      v.online = true;
      v.location =
          v.location.isEmpty ? '已定位到当前位置' : '已在${v.location}定位';
    }
  }

  /// 模拟充电动画：提升电量与续航
  void simulateChargeTick(String id) {
    final v = getVehicleById(id);
    if (v == null || !v.charging) return;
    v.battery = (v.battery + 2).clamp(0, 100);
    v.range = (v.battery * 0.5).toDouble(); // 粗略续航估算
    if (v.battery >= 100) {
      v.charging = false;
    }
  }

  /// 序列化
  String toJson() => json.encode(_vehicles.map((v) => v.toMap()).toList());

  /// 从 JSON 恢复
  static VehicleService fromJson(String raw) {
    final svc = VehicleService();
    try {
      final List<dynamic> list = json.decode(raw);
      svc._vehicles =
          list.map((item) => Vehicle.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('解析车辆数据失败: $e');
    }
    return svc;
  }

  /// 示例数据
  factory VehicleService.demo() {
    final svc = VehicleService();
    svc._vehicles = [
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
    ];
    return svc;
  }
}
