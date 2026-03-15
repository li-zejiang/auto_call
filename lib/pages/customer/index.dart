import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/CustomerProvider.dart';
import '../../components/CustomAppBar.dart';
import '../../components/CustomerTile.dart';
import '../../components/CommonToast.dart';
import '../../constants/AppConstants.dart';

/// 客户管理页面标签状态
final customerTabProvider = StateProvider<int>((ref) => 0);

/// 客户管理页面
class CustomerPage extends ConsumerWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听当前选中的标签 (0: 客户, 1: 待办)
    final selectedTab = ref.watch(customerTabProvider);
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
            onPressed: () =>
                _showNotImplemented(context, AppConstants.LABEL_ADD),
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
          ? _buildCustomerList(context, customerState, colorScheme)
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
      BuildContext context, AsyncValue customerState, ColorScheme colorScheme) {
    return Column(
      children: [
        // 顶部筛选与排序栏
        Padding(
          padding: const EdgeInsets.all(AppConstants.PADDING),
          child: Row(
            children: [
              Text(
                '${AppConstants.LABEL_ALL_CUSTOMERS} | ${AppConstants.LABEL_LATEST_ADDED}',
                style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5)),
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
              if (customers.isEmpty) {
                return Center(
                  child: Text(
                    AppConstants.MSG_NO_CUSTOMER_DATA,
                    style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  ),
                );
              }
              return ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  return CustomerTile(
                    customer: customers[index],
                    onTap: () {
                      // 客户详情逻辑待实现
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
}
