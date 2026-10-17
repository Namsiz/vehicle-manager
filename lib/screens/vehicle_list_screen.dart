import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshFilter() {
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

  Future<void> _showVehicleFormDialog(Vehicle? existing) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: existing?.name ?? '');
    final brandController = TextEditingController(text: existing?.brand ?? '');
    final modelController = TextEditingController(text: existing?.model ?? '');
    final plateController =
        TextEditingController(text: existing?.plateNumber ?? '');
    final vinController = TextEditingController(text: existing?.vin ?? '');
    final colorController =
        TextEditingController(text: existing?.color ?? '');
    final descController =
        TextEditingController(text: existing?.description ?? '');
    final mileageController = TextEditingController(
        text: existing?.mileage.toString() ?? '0');

    DateTime? selectedDate = existing?.purchaseDate;
    double? selectedMileage = existing?.mileage;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? '添加新车辆' : '编辑车辆'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '车辆名称'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? '请输入车辆名称' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: '品牌'),
                  validator: (v) => (v == null || v.isEmpty) ? '请输入品牌' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: '型号'),
                  validator: (v) => (v == null || v.isEmpty) ? '请输入型号' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: plateController,
                  decoration: const InputDecoration(labelText: '车牌号'),
                  validator: (v) => (v == null || v.isEmpty) ? '请输入车牌号' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: vinController,
                  decoration: const InputDecoration(labelText: '车架号(VIN)'),
                  validator: (v) => (v == null || v.isEmpty) ? '请输入车架号' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: mileageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '里程(km)'),
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
                      child: const Text('选择'),
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
                final newVehicle = Vehicle(
                  id: existing?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  brand: brandController.text,
                  model: modelController.text,
                  plateNumber: plateController.text,
                  vin: vinController.text,
                  purchaseDate: selectedDate ?? DateTime.now(),
                  mileage: selectedMileage ?? 0,
                  color:
                      colorController.text.isEmpty ? null : colorController.text,
                  description:
                      descController.text.isEmpty ? null : descController.text,
                );

                if (existing == null) {
                  _vehicleService.addVehicle(newVehicle);
                } else {
                  _vehicleService.updateVehicle(newVehicle);
                }

                _refreshFilter();
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
              _refreshFilter();
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
        title: const Text('我的小摩托'),
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
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _refreshFilter(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '搜索车辆...',
              ),
            ),
          ),
          Expanded(
            child: _filteredVehicles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions_bike, size: 64,
                            color: AppTheme.textHint),
                        const SizedBox(height: 16),
                        const Text('暂无车辆',
                            style: TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _showAddVehicleDialog,
                          child: const Text('添加第一辆车'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColorLight,
                            child: const Icon(Icons.directions_bike,
                                color: AppTheme.primaryColor),
                          ),
                          title: Text(vehicle.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              '${vehicle.brand} ${vehicle.model} · ${vehicle.plateNumber}'),
                          trailing: PopupMenuButton(
                            onSelected: (v) {
                              if (v == 'edit') {
                                _showEditVehicleDialog(vehicle);
                              } else if (v == 'delete') {
                                _showDeleteConfirmDialog(vehicle);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('编辑'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('删除', style: TextStyle(color: Colors.red)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVehicleDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
