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

    // 更多设置 (More Settings)
    final moreSettingsItems = [
      GridItem(AppConstants.LABEL_DIAL_SETTINGS, Icons.settings_phone,
          onTap: () => context.push('/dial-settings')),
      GridItem(AppConstants.LABEL_ACCESSIBILITY, Icons.accessibility_new,
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

    // 服务中心 (Service Center)
    const serviceCenterItems = [
      GridItem(AppConstants.LABEL_SHARE_APP, Icons.share),
      GridItem(AppConstants.LABEL_PRIVACY_POLICY, Icons.lock_outline),
      GridItem(AppConstants.LABEL_CONTACT_SERVICE, Icons.headset_mic_outlined),
      GridItem(AppConstants.LABEL_ABOUT_US, Icons.info_outline),
      GridItem(AppConstants.LABEL_INSTRUCTIONS, Icons.help_outline),
      GridItem(AppConstants.LABEL_SUPPORT, Icons.thumb_up_alt),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showDefaultActions: false,
        showLeadingSearch: false,
        actions: [
          AppBarButton(
            icon: Icons.person_outline,
            label: '个人信息',
            onPressed: () {
              CommonToast.show('个人信息${AppConstants.MSG_NOT_IMPLEMENTED}',
                  context: context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.PADDING),
        child: Column(
          children: [
            // 1. 用户信息 Header
            Padding(
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
                                color: Colors.amber, size: 18),
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
                      backgroundColor: const Color(0xFF2D2D3A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text(AppConstants.LABEL_BUY_MEMBER,
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 2. 团队空间 (Blue Card)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4A78F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_queue, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppConstants.LABEL_TEAM_SPACE,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '数据统计、任务分配',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '了解更多',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. 服务中心
            _buildGridSection(
              context,
              title: AppConstants.LABEL_SERVICE_CENTER,
              items: [
                GridItem(
                    AppConstants.LABEL_DIAL_SETTINGS, Icons.settings_outlined,
                    onTap: () => context.push('/dial-settings')),
                GridItem(AppConstants.LABEL_ACCESSIBILITY,
                    Icons.airplanemode_active_outlined,
                    onTap: () => context.push('/accessibility')),
                GridItem(
                    AppConstants.LABEL_BACKEND_ADMIN, Icons.dashboard_outlined,
                    onTap: () {
                  CommonToast.show(
                      '${AppConstants.LABEL_BACKEND_ADMIN}${AppConstants.MSG_NOT_IMPLEMENTED}',
                      context: context);
                }),
                GridItem(AppConstants.LABEL_SMS_SETTINGS, Icons.mail_outline,
                    onTap: () => context.push('/sms-settings')),
                const GridItem(
                    AppConstants.LABEL_LAYOUT_SETTINGS, Icons.grid_view),
                const GridItem(
                    AppConstants.LABEL_BLACKLIST, Icons.block_flipped),
              ],
            ),
            const SizedBox(height: 16),

            // 4. 更多设置
            _buildGridSection(
              context,
              title: AppConstants.LABEL_MORE_SETTINGS,
              items: serviceCenterItems, // 这里原本 serviceCenterItems 其实放的是分享等项
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 构建网格分组区域
  Widget _buildGridSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: theme.cardTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              children: items,
            ),
          ),
        ),
      ],
    );
  }
}
