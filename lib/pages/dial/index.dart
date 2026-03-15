import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/CallStatsProvider.dart';
import '../../utils/CallUtils.dart';
import '../../constants/AppConstants.dart';
import '../../components/CustomAppBar.dart';

/// 自动拨号主页面
class DialPage extends ConsumerWidget {
  const DialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听拨打统计状态
    final stats = ref.watch(callStatsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: AppConstants.TITLE_DIAL),
      body: Column(
        children: [
          // 今日统计信息栏
          Padding(
            padding: const EdgeInsets.all(AppConstants.PADDING),
            child: Row(
              children: [
                Text(
                  '${AppConstants.LABEL_DIALED_TODAY}${stats.dialedToday}',
                  style: TextStyle(
                    fontSize: AppConstants.FONT_SIZE_BODY,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${AppConstants.LABEL_CONNECTED_TODAY}${stats.connectedToday}',
                  style: TextStyle(
                    fontSize: AppConstants.FONT_SIZE_BODY,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(Icons.bar_chart, color: colorScheme.primary),
              ],
            ),
          ),
          const Divider(),
          // 列表区域（目前为占位图）
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 80,
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.MSG_NO_CONTENT,
                    style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.4)),
                  ),
                  Text(
                    AppConstants.MSG_CLICK_TO_REFRESH,
                    style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.4)),
                  ),
                ],
              ),
            ),
          ),
          // 底部操作按钮栏
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.PADDING,
              vertical: 12,
            ),
            child: Row(
              children: [
                // 手动拨号按钮
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showManualDial(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      AppConstants.LABEL_MANUAL_DIAL,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 导入号码按钮
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      AppConstants.LABEL_IMPORT_PHONE,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示手动拨号弹窗
  void _showManualDial(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.LABEL_MANUAL_DIAL),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(hintText: AppConstants.HINT_INPUT_PHONE),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.BTN_CANCEL),
          ),
          TextButton(
            onPressed: () {
              final number = controller.text.trim();
              if (number.isNotEmpty) {
                // 更新统计并拨号
                ref.read(callStatsProvider.notifier).addDialed();
                CallUtils.makeCall(context, number);
                Navigator.pop(context);
              }
            },
            child: const Text(AppConstants.BTN_DIAL),
          ),
        ],
      ),
    );
  }
}
