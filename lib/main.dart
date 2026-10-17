import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/screens/vehicle_list_screen.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

void main() {
  runApp(const VehicleManagerApp());
}

class VehicleManagerApp extends StatelessWidget {
  const VehicleManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我的小摩托',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const VehicleListScreen(),
    );
  }
}
