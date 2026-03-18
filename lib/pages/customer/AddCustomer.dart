import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/AppConstants.dart';
import '../../viewmodels/Customer.dart';
import '../../viewmodels/CustomerProvider.dart';

class AddCustomerPage extends ConsumerStatefulWidget {
  final Customer? initialCustomer;

  const AddCustomerPage({super.key, this.initialCustomer});

  @override
  ConsumerState<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends ConsumerState<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _remarkController = TextEditingController();

  String _followStatus = '初访';
  int _intentionStars = 1;
  String? _backupPhone;
  final List<String> _industries = [];

  @override
  void initState() {
    super.initState();
    final customer = widget.initialCustomer;
    if (customer == null) return;

    _nameController.text = customer.name;
    _phoneController.text = customer.phone;
    _followStatus = customer.tag;
    _intentionStars = customer.rating;

    final note = customer.note;
    if (note == null || note.trim().isEmpty) return;
    try {
      final decoded = jsonDecode(note);
      if (decoded is! Map) return;
      final backupPhone = decoded['backupPhone'];
      final remark = decoded['remark'];
      final industries = decoded['industries'];

      if (backupPhone is String && backupPhone.trim().isNotEmpty) {
        _backupPhone = backupPhone.trim();
      }
      if (remark is String && remark.trim().isNotEmpty) {
        _remarkController.text = remark.trim();
      }
      if (industries is List) {
        _industries
          ..clear()
          ..addAll(industries
              .whereType<String>()
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty));
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    final phone = (value ?? '').trim();
    if (phone.isEmpty) return '请输入电话号码';
    final phoneRegExp = RegExp(r'^\+?\d{6,20}$');
    if (!phoneRegExp.hasMatch(phone)) return '请输入正确的电话号码';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final remark = _remarkController.text.trim();

    final extra = <String, dynamic>{
      'backupPhone': _backupPhone,
      'remark': remark.isEmpty ? null : remark,
      'industries': _industries,
    };

    final customer = Customer()
      ..name = name.isEmpty ? phone : name
      ..phone = phone
      ..tag = _followStatus
      ..rating = _intentionStars
      ..createdAt = widget.initialCustomer?.createdAt ?? DateTime.now()
      ..note = jsonEncode(extra);
    final existing = widget.initialCustomer;
    if (existing != null) {
      customer.id = existing.id;
    }

    await ref.read(customerListProvider.notifier).saveCustomer(customer);
    if (!mounted) return;
    context.pop();
  }

  Future<void> _editBackupPhone() async {
    final controller = TextEditingController(text: _backupPhone ?? '');
    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('备用号码'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: '请输入备用号码'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text(AppConstants.BTN_CANCEL),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text(AppConstants.BTN_CONFIRM),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (!mounted) return;
    setState(() {
      _backupPhone = (result == null || result.isEmpty) ? null : result;
    });
  }

  Future<void> _selectFollowStatus() async {
    final options = ['初访', '跟进中', '有意向', '已成交', '无效'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map(
                (e) => ListTile(
                  title: Text(e),
                  trailing: e == _followStatus ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(e),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (!mounted) return;
    if (selected == null) return;
    setState(() {
      _followStatus = selected;
    });
  }

  Future<void> _selectIntentionStars() async {
    final options = [1, 2, 3, 4, 5];
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map(
                (e) => ListTile(
                  title: Text('$e星'),
                  trailing:
                      e == _intentionStars ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(e),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (!mounted) return;
    if (selected == null) return;
    setState(() {
      _intentionStars = selected;
    });
  }

  Future<void> _addIndustry() async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('行业信息'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '请输入行业/标签'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text(AppConstants.BTN_CANCEL),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text(AppConstants.BTN_CONFIRM),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (!mounted) return;
    final value = result?.trim();
    if (value == null || value.isEmpty) return;
    setState(() {
      if (!_industries.contains(value)) _industries.add(value);
    });
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppConstants.PADDING, 18, AppConstants.PADDING, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.55),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialCustomer != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑客户' : '添加客户'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(isEditing ? '保存' : '确认'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: [
            _sectionTitle('基本信息'),
            _inputRow(
              label: '姓名',
              controller: _nameController,
              hintText: '请输入姓名',
            ),
            _inputRow(
              label: '电话*',
              controller: _phoneController,
              hintText: '请输入电话号码',
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
            ),
            _actionRow(
              label: '备用号码',
              value: _backupPhone ?? '',
              placeholder: ' ',
              onTap: _editBackupPhone,
            ),
            _multilineRow(
              label: '备注',
              controller: _remarkController,
              hintText: '请输入备注',
            ),
            _sectionTitle('跟进信息'),
            _actionRow(
              label: '跟进状态',
              value: _followStatus,
              onTap: _selectFollowStatus,
            ),
            _actionRow(
              label: '客户意愿',
              value: '$_intentionStars星',
              onTap: _selectIntentionStars,
            ),
            _sectionTitle('行业信息'),
            ListTile(
              title: const Text('行业信息'),
              trailing: TextButton.icon(
                onPressed: _addIndustry,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('新增'),
              ),
              subtitle: _industries.isEmpty
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _industries
                            .map(
                              (e) => InputChip(
                                label: Text(e),
                                onDeleted: () {
                                  setState(() => _industries.remove(e));
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 1);

  Widget _inputRow({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(label),
              ),
              Expanded(
                flex: 5,
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  textAlign: TextAlign.right,
                  validator: validator,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _multilineRow({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _actionRow({
    required String label,
    required String value,
    String? placeholder,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(label),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.isEmpty ? (placeholder ?? '') : value,
                style: TextStyle(
                  color: value.isEmpty
                      ? Colors.black.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right,
                  color: Colors.black.withValues(alpha: 0.35)),
            ],
          ),
          onTap: onTap,
        ),
        _divider(),
      ],
    );
  }
}
