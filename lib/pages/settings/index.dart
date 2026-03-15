import 'package:auto_call/components/CommonToast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/CustomAppBar.dart';
import '../../components/GridItem.dart';
import '../../constants/AppConstants.dart';

/// 设置与个人中心页面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 菜单配置 A
    final itemsA = [
      GridItem(AppConstants.LABEL_DIAL_SETTINGS, Icons.settings_phone,
          onTap: () => context.push('/dial-settings')),
      GridItem(AppConstants.LABEL_ACCESSIBILITY, Icons.palette_outlined,
          onTap: () => context.push('/accessibility')),
      GridItem(AppConstants.LABEL_BACKEND_ADMIN, Icons.dashboard_customize,
          onTap: () {
        CommonToast.show(
            '${AppConstants.LABEL_BACKEND_ADMIN}${AppConstants.MSG_NOT_IMPLEMENTED}',
            context: context);
      }),
      GridItem(AppConstants.LABEL_SMS_SETTINGS, Icons.mail_outline,
          onTap: () => context.push('/sms-settings')),
      const GridItem(AppConstants.LABEL_LAYOUT_SETTINGS, Icons.grid_view),
      const GridItem(AppConstants.LABEL_BLACKLIST, Icons.block),
    ];

    // 菜单配置 B
    const itemsB = [
      GridItem(AppConstants.LABEL_SHARE_APP, Icons.share),
      GridItem(AppConstants.LABEL_PRIVACY_POLICY, Icons.lock_outline),
      GridItem(AppConstants.LABEL_CONTACT_SERVICE, Icons.headset_mic_outlined),
      GridItem(AppConstants.LABEL_ABOUT_US, Icons.info_outline),
      GridItem(AppConstants.LABEL_INSTRUCTIONS, Icons.help_outline),
      GridItem(AppConstants.LABEL_SUPPORT, Icons.thumb_up_alt),
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppConstants.TITLE_PROFILE,
        showDefaultActions: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.PADDING),
        child: Column(
          children: [
            // 用户信息卡片
            Card(
              elevation: theme.cardTheme.elevation,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(Icons.person,
                          color: colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '繁星若尘',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppConstants.LABEL_MEMBER_EXPIRED,
                            style: TextStyle(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text(AppConstants.LABEL_BUY_MEMBER),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 功能网格 A
            Card(
              elevation: theme.cardTheme.elevation,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          AppConstants.LABEL_TEAM_SPACE,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      children: itemsA,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 功能网格 B
            Card(
              elevation: theme.cardTheme.elevation,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  children: itemsB,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
