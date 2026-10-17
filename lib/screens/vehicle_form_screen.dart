import 'package:flutter/material.dart';
import 'package:vehicle_manager/models/vehicle_model.dart';
import 'package:vehicle_manager/services/vehicle_service.dart';
import 'package:vehicle_manager/theme/app_theme.dart';

/// 添加 / 编辑车辆表单
class VehicleFormScreen extends StatefulWidget {
  final VehicleService service;
  final Vehicle? vehicle; // null = 新增
  final VoidCallback onDone;

  const VehicleFormScreen({
    super.key,
    required this.service,
    required this.onDone,
    this.vehicle,
  });

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _brand;
  late final TextEditingController _model;
  late final TextEditingController _plate;
  late final TextEditingController _vin;
  late final TextEditingController _mileage;
  late final TextEditingController _battery;
  late final TextEditingController _range;
  late final TextEditingController _location;
  late final TextEditingController _color;
  late final TextEditingController _desc;

  late DateTime _purchaseDate;
  bool _online = false;
  bool _charging = false;
  late bool _isEdit;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _isEdit = v != null;
    _name = TextEditingController(text: v?.name ?? '');
    _brand = TextEditingController(text: v?.brand ?? '');
    _model = TextEditingController(text: v?.model ?? '');
    _plate = TextEditingController(text: v?.plateNumber ?? '');
    _vin = TextEditingController(text: v?.vin ?? '');
    _mileage = TextEditingController(
        text: v == null ? '' : v.mileage.round().toString());
    _battery = TextEditingController(
        text: v == null ? '50' : v.battery.round().toString());
    _range = TextEditingController(
        text: v == null ? '' : v.range.round().toString());
    _location = TextEditingController(text: v?.location ?? '');
    _color = TextEditingController(text: v?.color ?? '');
    _desc = TextEditingController(text: v?.description ?? '');
    _purchaseDate = v?.purchaseDate ?? DateTime.now();
    _online = v?.online ?? false;
    _charging = v?.charging ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _brand.dispose();
    _model.dispose();
    _plate.dispose();
    _vin.dispose();
    _mileage.dispose();
    _battery.dispose();
    _range.dispose();
    _location.dispose();
    _color.dispose();
    _desc.dispose();
    super.dispose();
  }

  String? _req(String? v) => (v == null || v.isEmpty) ? '必填项' : null;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _purchaseDate = picked);
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final mileage = double.tryParse(_mileage.text) ?? 0;
    final battery = ((double.tryParse(_battery.text) ?? 0).clamp(0, 100)).toDouble();
    final range = double.tryParse(_range.text) ?? 0;

    final v = widget.vehicle;
    final vehicle = Vehicle(
      id: v?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      brand: _brand.text.trim(),
      model: _model.text.trim(),
      plateNumber: _plate.text.trim(),
      vin: _vin.text.trim(),
      purchaseDate: _purchaseDate,
      mileage: mileage,
      battery: battery,
      range: range,
      online: _online,
      charging: _charging,
      location: _location.text.trim(),
      lastRide: v?.lastRide,
      color: _color.text.isEmpty ? null : _color.text.trim(),
      description: _desc.text.isEmpty ? null : _desc.text.trim(),
    );

    if (v == null) {
      widget.service.addVehicle(vehicle);
    } else {
      widget.service.updateVehicle(vehicle);
    }
    widget.onDone();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? '编辑车辆' : '添加车辆')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionLabel('基本信息'),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: '车辆名称 *'),
              validator: _req,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _brand,
              decoration: const InputDecoration(labelText: '品牌 *'),
              validator: _req,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _model,
              decoration: const InputDecoration(labelText: '型号 *'),
              validator: _req,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _plate,
              decoration: const InputDecoration(labelText: '车牌号 *'),
              validator: _req,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _vin,
              decoration: const InputDecoration(labelText: '车架号(VIN) *'),
              validator: _req,
            ),
            const SizedBox(height: 12),
            _FieldLabel('购买日期'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_purchaseDate.toIso8601String().split('T')[0]),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            _SectionLabel('状态'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _mileage,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: '总里程(km)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _battery,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: '电量(%)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _range,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '估算续航(km)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _location,
              decoration:
                  const InputDecoration(labelText: '最近位置'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    value: _online,
                    onChanged: (b) => setState(() => _online = b),
                    title: const Text('在线'),
                    secondary:
                        const Icon(Icons.cloud_done_outlined),
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    value: _charging,
                    onChanged: (b) => setState(() => _charging = b),
                    title: const Text('充电中'),
                    secondary:
                        const Icon(Icons.charging_station),
                  ),
                ),
              ],
            ),
            _SectionLabel('其他'),
            TextFormField(
              controller: _color,
              decoration: const InputDecoration(labelText: '颜色'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: '备注'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(_isEdit ? '保存修改' : '添加车辆'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor)),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: const TextStyle(
              fontSize: 13, color: AppTheme.textSecondary)),
    );
  }
}
