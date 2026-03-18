import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/AppConstants.dart';
import '../../../viewmodels/AuthProvider.dart';
import '../../../components/CommonToast.dart';

/// 设置页面的用户信息头部组件
class SettingsHeader extends ConsumerWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isLoggedIn = authState.isAuthenticated;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _handleHeaderTap(context, isLoggedIn),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: (isLoggedIn && user?.avatar != null)
                  ? NetworkImage(user!.avatar!)
                  : null,
              child: (!isLoggedIn || user?.avatar == null)
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => _handleHeaderTap(context, isLoggedIn),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isLoggedIn ? user!.nickname : '登录/注册',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (isLoggedIn) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.workspace_premium,
                            color: AppColors.VIP_GOLD, size: 18),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLoggedIn
                        ? (user?.membershipExpiry ??
                            AppConstants.LABEL_MEMBER_EXPIRED)
                        : '登录后可同步数据和享受更多特权',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (isLoggedIn) {
                CommonToast.show('跳转到会员购买页面', context: context);
              } else {
                context.push('/login');
              }
            },
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

  void _handleHeaderTap(BuildContext context, bool isLoggedIn) {
    if (isLoggedIn) {
      context.push('/profile');
    } else {
      context.push('/login');
    }
  }
}
