import 'package:flutter/material.dart';
import '../constants/AppConstants.dart';
import 'CommonToast.dart';

/// 网格菜单项组件
class GridItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const GridItem(this.label, this.icon, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap ??
          () {
            // 默认未实现提示
            CommonToast.show('$label ${AppConstants.MSG_NOT_IMPLEMENTED}', context: context);
          },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 图标容器
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(height: 8),
          // 标签文字
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.FONT_SIZE_SMALL,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
