import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';

/// 车辆管理服务（内存持久化，简化版）
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

  /// 获取车辆总数
  int get vehicleCount => _vehicles.length;

  /// 搜索车辆
  List<Vehicle> searchVehicles(String query) {
    if (query.isEmpty) return vehicles;
    final lowerQuery = query.toLowerCase();
    return _vehicles
        .where((v) =>
            v.name.toLowerCase().contains(lowerQuery) ||
            v.brand.toLowerCase().contains(lowerQuery) ||
            v.model.toLowerCase().contains(lowerQuery) ||
            v.plateNumber.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// 序列化为 JSON 字符串（用于持久化存储）
  String toJson() =>
      json.encode(_vehicles.map((v) => v.toMap()).toList());

  /// 从 JSON 字符串恢复
  static VehicleService fromJson(String raw) {
    final svc = VehicleService();
    try {
      final List<dynamic> list = json.decode(raw);
      svc._vehicles = list.map((item) => Vehicle.fromMap(item)).toList();
    } catch (e) {
      debugPrint('解析车辆数据失败: $e');
    }
    return svc;
  }

  /// 创建示例数据
  factory VehicleService.demo() {
    final svc = VehicleService();
    svc._vehicles = [
      Vehicle(
        id: 'demo-1',
        name: '我的小摩托',
        brand: '我的',
        model: '小摩托',
        plateNumber: 'YUE·A12345',
        vin: 'DEMO0000000000001',
        purchaseDate: DateTime(2024, 6, 1),
        mileage: 1200,
        color: '红色',
        description: '示例车辆数据',
      ),
    ];
    return svc;
  }
}
