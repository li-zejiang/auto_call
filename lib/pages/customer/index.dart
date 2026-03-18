import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../viewmodels/CustomerProvider.dart';
import '../../viewmodels/Customer.dart';
import '../../components/CustomAppBar.dart';
import '../../components/CustomerTile.dart';
import '../../components/CommonToast.dart';
import '../../constants/AppConstants.dart';

/// 客户管理页面标签状态
final customerTabProvider = StateProvider<int>((ref) => 0);

enum CustomerSortMode {
  name,
  latest,
}

final customerSortProvider = StateProvider<CustomerSortMode>((ref) {
  return CustomerSortMode.name;
});

/// 客户管理页面
class CustomerPage extends ConsumerWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听当前选中的标签 (0: 客户, 1: 待办)
    final selectedTab = ref.watch(customerTabProvider);
    final sortMode = ref.watch(customerSortProvider);
    final customerState = ref.watch(customerListProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: '', // 标题由 titleWidget 接管
        showLeadingSearch: false, // 隐藏左侧默认搜索
        titleWidget: Row(
          children: [
            _buildTabItem(
                context, ref, AppConstants.LABEL_CUSTOMER, 0, selectedTab),
            const SizedBox(width: 20),
            _buildTabItem(
                context, ref, AppConstants.LABEL_TODO, 1, selectedTab),
          ],
        ),
        actions: [
          AppBarButton(
            icon: Icons.search,
            label: AppConstants.LABEL_SEARCH,
            onPressed: () =>
                _showNotImplemented(context, AppConstants.LABEL_SEARCH),
          ),
          AppBarButton(
            icon: Icons.ios_share,
            label: AppConstants.LABEL_EXPORT,
            onPressed: () =>
                _showNotImplemented(context, AppConstants.LABEL_EXPORT),
          ),
          AppBarButton(
            icon: Icons.person_add_alt_1_outlined,
            label: AppConstants.LABEL_ADD,
            onPressed: () => context.push('/customer/add'),
          ),
          AppBarButton(
            icon: Icons.group_add_outlined,
            label: AppConstants.LABEL_BATCH,
            onPressed: () =>
                _showNotImplemented(context, AppConstants.LABEL_BATCH),
          ),
        ],
      ),
      body: selectedTab == 0
          ? _buildCustomerList(
              context, ref, sortMode, customerState, colorScheme)
          : _buildTodoList(context, colorScheme),
    );
  }

  /// 构建标签项
  Widget _buildTabItem(BuildContext context, WidgetRef ref, String label,
      int index, int selectedIndex) {
    final isSelected = index == selectedIndex;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => ref.read(customerTabProvider.notifier).state = index,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  /// 构建客户列表
  Widget _buildCustomerList(
      BuildContext context,
      WidgetRef ref,
      CustomerSortMode sortMode,
      AsyncValue customerState,
      ColorScheme colorScheme) {
    return Column(
      children: [
        // 顶部筛选与排序栏
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              SegmentedButton<CustomerSortMode>(
                showSelectedIcon: false,
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                ),
                segments: const [
                  ButtonSegment(
                    value: CustomerSortMode.name,
                    label: Text(AppConstants.LABEL_ALL_CUSTOMERS),
                  ),
                  ButtonSegment(
                    value: CustomerSortMode.latest,
                    label: Text(AppConstants.LABEL_LATEST_ADDED),
                  ),
                ],
                selected: {sortMode},
                onSelectionChanged: (selection) {
                  ref.read(customerSortProvider.notifier).state =
                      selection.first;
                },
              ),
              const Spacer(),
              // 筛选按钮
              TextButton.icon(
                onPressed: () =>
                    _showNotImplemented(context, AppConstants.LABEL_FILTER),
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text(AppConstants.LABEL_FILTER),
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  foregroundColor: colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 客户列表区域
        Expanded(
          child: customerState.when(
            data: (customers) {
              final sortedCustomers = [...customers];
              if (sortMode == CustomerSortMode.latest) {
                sortedCustomers
                    .sort((a, b) => b.createdAt.compareTo(a.createdAt));
              } else {
                sortedCustomers.sort((a, b) {
                  final an = a.name.trim().toLowerCase();
                  final bn = b.name.trim().toLowerCase();
                  return an.compareTo(bn);
                });
              }

              if (sortedCustomers.isEmpty) {
                return Center(
                  child: Text(
                    AppConstants.MSG_NO_CUSTOMER_DATA,
                    style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: sortedCustomers.length,
                itemBuilder: (context, index) {
                  final customer = sortedCustomers[index] as Customer;
                  return CustomerTile(
                    customer: customer,
                    onTap: () {
                      context.push('/customer/edit', extra: customer);
                    },
                    onLongPress: () {
                      _showCustomerActions(context, ref, customer);
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text('${AppConstants.MSG_LOADING_ERROR}$err')),
          ),
        ),
      ],
    );
  }

  /// 构建待办列表 (占位)
  Widget _buildTodoList(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rtl,
            size: 80,
            color: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.MSG_NO_TODO_DATA,
            style:
                TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }

  void _showNotImplemented(BuildContext context, String label) {
    CommonToast.show('$label ${AppConstants.MSG_NOT_IMPLEMENTED}',
        context: context);
  }

  Future<void> _showCustomerActions(
      BuildContext context, WidgetRef ref, Customer customer) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.call_outlined),
                title: const Text('拨打'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _dialCustomer(context, customer);
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: const Text('查看'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showCustomerDetails(context, customer);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('编辑'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.push('/customer/edit', extra: customer);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('删除'),
                textColor: Theme.of(context).colorScheme.error,
                iconColor: Theme.of(context).colorScheme.error,
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text('删除客户'),
                        content: Text('确定删除“${customer.name}”吗？'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text(AppConstants.BTN_CANCEL),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('删除'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmed != true) return;
                  await ref
                      .read(customerListProvider.notifier)
                      .deleteCustomer(customer.id);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _dialCustomer(BuildContext context, Customer customer) async {
    final phone = customer.phone.trim();
    final uri = Uri(scheme: 'tel', path: phone);
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      if (!context.mounted) return;
      CommonToast.show('当前平台不支持拨打该号码', context: context);
      return;
    }
    await launchUrl(uri);
  }

  Future<void> _showCustomerDetails(
      BuildContext context, Customer customer) async {
    String? backupPhone;
    String? remark;
    List<String> industries = const [];

    final note = customer.note;
    if (note != null && note.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(note);
        if (decoded is Map) {
          final bp = decoded['backupPhone'];
          final rm = decoded['remark'];
          final inds = decoded['industries'];
          if (bp is String && bp.trim().isNotEmpty) backupPhone = bp.trim();
          if (rm is String && rm.trim().isNotEmpty) remark = rm.trim();
          if (inds is List) {
            industries = inds
                .whereType<String>()
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          }
        }
      } catch (_) {}
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final createdAt =
            DateFormat('yyyy-MM-dd HH:mm').format(customer.createdAt);
        return AlertDialog(
          title: Text(customer.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('电话：${customer.phone}'),
              if (backupPhone != null) Text('备用：$backupPhone'),
              Text('状态：${customer.tag}  意愿：${customer.rating}星'),
              Text('添加时间：$createdAt'),
              if (industries.isNotEmpty) Text('行业：${industries.join('、')}'),
              if (remark != null) Text('备注：$remark'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppConstants.BTN_CONFIRM),
            ),
          ],
        );
      },
    );
  }
}
