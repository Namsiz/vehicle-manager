import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';

void main() {
  group('Vehicle Model Tests', () {
    test('should create vehicle with required fields', () {
      final vehicle = Vehicle(
        id: '1',
        name: '测试车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      );

      expect(vehicle.id, '1');
      expect(vehicle.name, '测试车辆');
      expect(vehicle.brand, '雅迪');
      expect(vehicle.model, 'T5');
      expect(vehicle.plateNumber, '粤B12345');
      expect(vehicle.vin, '12345678901234567');
      expect(vehicle.mileage, 1000.0);
    });

    test('should convert vehicle to map', () {
      final vehicle = Vehicle(
        id: '1',
        name: '测试车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      );

      final map = vehicle.toMap();

      expect(map['id'], '1');
      expect(map['name'], '测试车辆');
      expect(map['brand'], '雅迪');
      expect(map['model'], 'T5');
      expect(map['plateNumber'], '粤B12345');
      expect(map['vin'], '12345678901234567');
      expect(map['purchaseDate'], '2023-01-01T00:00:00.000');
      expect(map['mileage'], 1000.0);
    });

    test('should create vehicle from map', () {
      final map = {
        'id': '1',
        'name': '测试车辆',
        'brand': '雅迪',
        'model': 'T5',
        'plateNumber': '粤B12345',
        'vin': '12345678901234567',
        'purchaseDate': '2023-01-01T00:00:00.000',
        'mileage': 1000.0,
        'color': '蓝色',
        'description': '测试描述',
      };

      final vehicle = Vehicle.fromMap(map);

      expect(vehicle.id, '1');
      expect(vehicle.name, '测试车辆');
      expect(vehicle.brand, '雅迪');
      expect(vehicle.model, 'T5');
      expect(vehicle.plateNumber, '粤B12345');
      expect(vehicle.vin, '12345678901234567');
      expect(vehicle.purchaseDate.year, 2023);
      expect(vehicle.mileage, 1000.0);
      expect(vehicle.color, '蓝色');
      expect(vehicle.description, '测试描述');
    });

    test('should copy vehicle with updated fields', () {
      final original = Vehicle(
        id: '1',
        name: '原始车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      );

      final updated = original.copyWith(
        name: '更新后的车辆',
        mileage: 2000.0,
      );

      expect(updated.id, '1');
      expect(updated.name, '更新后的车辆');
      expect(updated.mileage, 2000.0);
      expect(updated.purchaseDate, original.purchaseDate);
    });

    test('should handle optional fields', () {
      final vehicle = Vehicle(
        id: '1',
        name: '测试车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
        color: null,
        description: null,
      );

      expect(vehicle.color, isNull);
      expect(vehicle.description, isNull);
    });
  });

  group('Vehicle Service Tests', () {
    late VehicleService service;

    setUp(() {
      service = VehicleService();
    });

    tearDown(() {
      // 清理测试数据
    });

    test('should add vehicle', () {
      final vehicle = Vehicle(
        id: '1',
        name: '测试车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      );

      service.addVehicle(vehicle);

      expect(service.vehicleCount, 1);
      expect(service.vehicles.first.name, '测试车辆');
    });

    test('should update vehicle', () {
      final vehicle = Vehicle(
        id: '1',
        name: '原始车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      );

      service.addVehicle(vehicle);

      final updatedVehicle = vehicle.copyWith(
        name: '更新后的车辆',
        mileage: 2000.0,
      );

      service.updateVehicle(updatedVehicle);

      expect(service.vehicleCount, 1);
      expect(service.vehicles.first.name, '更新后的车辆');
      expect(service.vehicles.first.mileage, 2000.0);
    });

    test('should delete vehicle', () {
      final vehicle = Vehicle(
        id: '1',
        name: '测试车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      );

      service.addVehicle(vehicle);
      service.deleteVehicle('1');

      expect(service.vehicleCount, 0);
    });

    test('should get vehicle by id', () {
      final vehicle = Vehicle(
        id: '1',
        name: '测试车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      );

      service.addVehicle(vehicle);

      final foundVehicle = service.getVehicleById('1');
      expect(foundVehicle, isNotNull);
      expect(foundVehicle?.name, '测试车辆');
    });

    test('should return null for non-existent vehicle', () {
      final foundVehicle = service.getVehicleById('999');
      expect(foundVehicle, isNull);
    });

    test('should search vehicles', () {
      service.addVehicle(Vehicle(
        id: '1',
        name: '雅迪T5',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      ));

      service.addVehicle(Vehicle(
        id: '2',
        name: '爱玛M6',
        brand: '爱玛',
        model: 'M6',
        plateNumber: '粤B67890',
        vin: '98765432109876543',
        purchaseDate: DateTime(2023, 2, 1),
        mileage: 2000.0,
      ));

      final results = service.searchVehicles('雅迪');
      expect(results.length, 1);
      expect(results.first.name, '雅迪T5');

      final allResults = service.searchVehicles('');
      expect(allResults.length, 2);
    });

    test('should handle empty search results', () {
      service.addVehicle(Vehicle(
        id: '1',
        name: '测试车辆',
        brand: '雅迪',
        model: 'T5',
        plateNumber: '粤B12345',
        vin: '12345678901234567',
        purchaseDate: DateTime(2023, 1, 1),
        mileage: 1000.0,
      ));

      final results = service.searchVehicles('不存在的车辆');
      expect(results.length, 0);
    });
  });
}
