/// 车辆数据模型
class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String plateNumber;
  final String vin;
  final DateTime purchaseDate;
  final double mileage;
  final String? color;
  final String? description;

  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.vin,
    required this.purchaseDate,
    required this.mileage,
    this.color,
    this.description,
  });

  /// 从Map创建Vehicle对象
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      plateNumber: map['plateNumber'] as String,
      vin: map['vin'] as String,
      purchaseDate: DateTime.parse(map['purchaseDate'] as String),
      mileage: (map['mileage'] as num).toDouble(),
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
      'color': color,
      'description': description,
    };
  }

  /// 复制车辆对象
  Vehicle copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    String? plateNumber,
    String? vin,
    DateTime? purchaseDate,
    double? mileage,
    String? color,
    String? description,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      plateNumber: plateNumber ?? this.plateNumber,
      vin: vin ?? this.vin,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      mileage: mileage ?? this.mileage,
      color: color,
      description: description,
    );
  }
}
