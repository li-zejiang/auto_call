import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/Customer.dart';
import '../constants/AppConstants.dart';

/// 客户列表项组件
class CustomerTile extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CustomerTile({
    super.key,
    required this.customer,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: theme.cardTheme.elevation,
      margin: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        title: Row(
          children: [
            // 标签容器
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                customer.tag,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            // 姓名显示
            Text(
              '${AppConstants.FIELD_CONTACT}${customer.name}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            // 电话显示
            Text(
              '${AppConstants.FIELD_PHONE}${customer.phone}',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 创建时间
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(customer.createdAt),
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                // 评分星级
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < customer.rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: index < customer.rating
                          ? Colors.amber
                          : colorScheme.onSurface.withValues(alpha: 0.2),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
