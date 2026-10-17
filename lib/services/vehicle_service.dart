import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'vehicle_model.dart';

/// 车辆管理服务
class VehicleService extends ChangeNotifier {
  static const String _storageKey = 'vehicle_manager_data';

  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  VehicleService() {
    _loadVehicles();
  }

  /// 加载车辆数据
  void _loadVehicles() {
    try {
      final prefs = await _getSharedPreferences();
      final data = prefs.getString(_storageKey);
      if (data != null) {
        final List<dynamic> list = json.decode(data);
        _vehicles = list.map((item) => Vehicle.fromMap(item)).toList();
      }
    } catch (e) {
      debugPrint('加载车辆数据失败: $e');
    }
    notifyListeners();
  }

  /// 保存车辆数据
  Future<void> _saveVehicles() async {
    try {
      final prefs = await _getSharedPreferences();
      final data = json.encode(_vehicles.map((v) => v.toMap()).toList());
      await prefs.setString(_storageKey, data);
    } catch (e) {
      debugPrint('保存车辆数据失败: $e');
    }
  }

  /// 获取SharedPreferences
  Future<SharedPreferences> _getSharedPreferences() async {
    // 在实际应用中，这里应该使用shared_preferences包
    // 这里为了简化，我们创建一个模拟实现
    return _MockSharedPreferences();
  }

  /// 添加车辆
  void addVehicle(Vehicle vehicle) {
    _vehicles.insert(0, vehicle);
    _saveVehicles();
    notifyListeners();
  }

  /// 更新车辆
  void updateVehicle(Vehicle vehicle) {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      _saveVehicles();
      notifyListeners();
    }
  }

  /// 删除车辆
  void deleteVehicle(String id) {
    _vehicles.removeWhere((v) => v.id == id);
    _saveVehicles();
    notifyListeners();
  }

  /// 根据ID获取车辆
  Vehicle? getVehicleById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取车辆总数
  int get vehicleCount => _vehicles.length;

  /// 搜索车辆
  List<Vehicle> searchVehicles(String query) {
    if (query.isEmpty) return _vehicles;
    final lowerQuery = query.toLowerCase();
    return _vehicles.where((v) =>
        v.name.toLowerCase().contains(lowerQuery) ||
        v.brand.toLowerCase().contains(lowerQuery) ||
        v.model.toLowerCase().contains(lowerQuery) ||
        v.plateNumber.toLowerCase().contains(lowerQuery)).toList();
  }
}

/// 模拟SharedPreferences实现
class _MockSharedPreferences {
  Map<String, String> _data = {};

  Future<String?> getString(String key) async {
    return _data[key];
  }

  Future<void> setString(String key, String value) async {
    _data[key] = value;
  }
}
