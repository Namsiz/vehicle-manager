/// 车辆数据模型（对标雅迪智行的车辆管理信息）
class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String plateNumber;
  final String vin;
  final DateTime purchaseDate;
  double mileage;

  // 车辆实时状态
  double battery; // 电量 0-100
  double range; // 估算续航 km
  bool online; // 是否在线
  bool charging; // 是否充电中
  String location; // 最近位置
  DateTime? lastRide; // 最近骑行时间

  String? color;
  String? description;

  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.vin,
    required this.purchaseDate,
    this.mileage = 0,
    this.battery = 0,
    this.range = 0,
    this.online = false,
    this.charging = false,
    this.location = '',
    this.lastRide,
    this.color,
    this.description,
  });

  /// 从Map创建Vehicle对象（旧数据兼容：缺失的实时字段给默认值）
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      plateNumber: map['plateNumber'] as String,
      vin: map['vin'] as String,
      purchaseDate: DateTime.parse(map['purchaseDate'] as String),
      mileage: (map['mileage'] as num?)?.toDouble() ?? 0,
      battery: (map['battery'] as num?)?.toDouble() ?? 0,
      range: (map['range'] as num?)?.toDouble() ?? 0,
      online: map['online'] as bool? ?? false,
      charging: map['charging'] as bool? ?? false,
      location: map['location'] as String? ?? '',
      lastRide: map['lastRide'] != null
          ? DateTime.parse(map['lastRide'] as String)
          : null,
      color: map['color'] as String?,
      description: map['description'] as String?,
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'plateNumber': plateNumber,
      'vin': vin,
      'purchaseDate': purchaseDate.toIso8601String(),
      'mileage': mileage,
      'battery': battery,
      'range': range,
      'online': online,
      'charging': charging,
      'location': location,
      'lastRide': lastRide?.toIso8601String(),
      'color': color,
      'description': description,
    };
  }
}
