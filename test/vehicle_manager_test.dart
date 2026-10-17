import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_manager/main.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';

void main() {
  testWidgets('Vehicle model test', (WidgetTester tester) async {
    final vehicle = Vehicle(
      id: '1',
      name: '测试车辆',
      brand: '雅迪',
      model: 'NQi',
      plateNumber: '京A12345',
      vin: '1234567890',
      purchaseDate: DateTime.now(),
      mileage: 1000.0,
    );

    expect(vehicle.name, '测试车辆');
    expect(vehicle.brand, '雅迪');
    expect(vehicle.mileage, 1000.0);
  });

  testWidgets('Vehicle service test', (WidgetTester tester) async {
    final service = VehicleService();

    // 测试添加车辆
    final vehicle = Vehicle(
      id: '1',
      name: '测试车辆',
      brand: '雅迪',
      model: 'NQi',
      plateNumber: '京A12345',
      vin: '1234567890',
      purchaseDate: DateTime.now(),
      mileage: 1000.0,
    );

    service.addVehicle(vehicle);
    expect(service.vehicleCount, 1);

    // 测试删除车辆
    service.deleteVehicle('1');
    expect(service.vehicleCount, 0);
  });
}
