import 'package:flutter/material.dart';
import '../../../constants/AppConstants.dart';

/// 设置页面的用户信息头部组件
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(
                'https://p.qqan.com/up/2021-3/16151684606439132.jpg'), // 占位图
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '繁星若尘',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.workspace_premium,
                        color: AppColors.VIP_GOLD, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.LABEL_MEMBER_EXPIRED,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.MEMBER_BTN_DARK,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(AppConstants.LABEL_BUY_MEMBER,
                style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
