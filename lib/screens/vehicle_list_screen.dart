import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleService _vehicleService = VehicleService();
  final TextEditingController _searchController = TextEditingController();
  List<Vehicle> _filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    _filteredVehicles = _vehicleService.vehicles;
    _vehicleService.addListener(_onVehicleChanged);
  }

  @override
  void dispose() {
    _vehicleService.removeListener(_onVehicleChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onVehicleChanged() {
    setState(() {
      _filteredVehicles = _searchController.text.isEmpty
          ? _vehicleService.vehicles
          : _vehicleService.searchVehicles(_searchController.text);
    });
  }

  void _showAddVehicleDialog() {
    _showVehicleFormDialog(null);
  }

  void _showEditVehicleDialog(Vehicle vehicle) {
    _showVehicleFormDialog(vehicle);
  }

  Future<void> _showVehicleFormDialog(Vehicle? vehicle) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: vehicle?.name ?? '');
    final brandController = TextEditingController(text: vehicle?.brand ?? '');
    final modelController = TextEditingController(text: vehicle?.model ?? '');
    final plateController = TextEditingController(text: vehicle?.plateNumber ?? '');
    final vinController = TextEditingController(text: vehicle?.vin ?? '');
    final mileageController = TextEditingController(
        text: vehicle?.mileage.toString() ?? '0');
    final colorController = TextEditingController(text: vehicle?.color ?? '');
    final descController = TextEditingController(text: vehicle?.description ?? '');

    DateTime? selectedDate = vehicle?.purchaseDate;
    double? selectedMileage = vehicle?.mileage;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(vehicle == null ? '添加新车辆' : '编辑车辆'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '车辆名称'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? '请输入车辆名称' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: '品牌'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? '请输入品牌' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: '型号'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? '请输入型号' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: plateController,
                  decoration: const InputDecoration(labelText: '车牌号'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? '请输入车牌号' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: vinController,
                  decoration: const InputDecoration(labelText: '车架号(VIN)'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? '请输入车架号' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '购买日期: ${selectedDate?.toLocal().toString().split(' ')[0] ?? '未选择'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: const Text('选择日期'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '里程: ${selectedMileage?.toStringAsFixed(1) ?? '0.0'} km',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final input = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('设置里程'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: '里程(km)'),
                              controller: TextEditingController(
                                  text: selectedMileage?.toStringAsFixed(1) ?? '0'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final value = double.tryParse(
                                    TextEditingController(
                                      text: selectedMileage?.toStringAsFixed(1) ?? '0',
                                    ).text,
                                  );
                                  if (value != null && value >= 0) {
                                    setState(() => selectedMileage = value);
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('确定'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('设置里程'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: '颜色'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: '备注'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final vehicle = Vehicle(
                  id: vehicle?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  brand: brandController.text,
                  model: modelController.text,
                  plateNumber: plateController.text,
                  vin: vinController.text,
                  purchaseDate: selectedDate ?? DateTime.now(),
                  mileage: selectedMileage ?? 0,
                  color: colorController.text.isEmpty ? null : colorController.text,
                  description:
                      descController.text.isEmpty ? null : descController.text,
                );

                if (vehicle == null) {
                  _vehicleService.addVehicle(vehicle);
                } else {
                  _vehicleService.updateVehicle(vehicle);
                }

                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 "${vehicle.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              _vehicleService.deleteVehicle(vehicle.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的车辆'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddVehicleDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索车辆...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredVehicles = _searchController.text.isEmpty
                      ? _vehicleService.vehicles
                      : _vehicleService.searchVehicles(_searchController.text);
                });
              },
            ),
          ),
          Expanded(
            child: _filteredVehicles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_bike,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '还没有车辆',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '点击右上角添加第一辆车',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Icon(
                              Icons.directions_bike,
                              color: Colors.blue[700],
                            ),
                          ),
                          title: Text(
                            vehicle.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('${vehicle.brand} ${vehicle.model}'),
                              Text('车牌: ${vehicle.plateNumber}'),
                              Text('里程: ${vehicle.mileage.toStringAsFixed(1)} km'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showEditVehicleDialog(vehicle),
                                color: Colors.blue,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () => _showDeleteConfirmDialog(vehicle),
                                color: Colors.red,
                              ),
                            ],
                          ),
                          onTap: () => _showEditVehicleDialog(vehicle),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
