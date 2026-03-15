import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/CustomerProvider.dart';
import '../../components/CustomAppBar.dart';
import '../../components/CustomerTile.dart';
import '../../components/CommonToast.dart';
import '../../constants/AppConstants.dart';

/// 客户管理页面
class CustomerPage extends ConsumerWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听客户列表状态
    final customerState = ref.watch(customerListProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: AppConstants.TITLE_CUSTOMER),
      body: Column(
        children: [
          // 顶部筛选与排序栏
          Padding(
            padding: const EdgeInsets.all(AppConstants.PADDING),
            child: Row(
              children: [
                Text(
                  '${AppConstants.LABEL_ALL_CUSTOMERS} | ${AppConstants.LABEL_LATEST_ADDED}',
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                ),
                const Spacer(),
                // 筛选按钮
                TextButton.icon(
                  onPressed: () {
                    CommonToast.show(
                        '${AppConstants.LABEL_FILTER}${AppConstants.MSG_NOT_IMPLEMENTED}',
                        context: context);
                  },
                  icon: const Icon(Icons.filter_list),
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
                      style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
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
      ),
    );
  }
}
