import 'package:auto_call/components/CommonToast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/CustomAppBar.dart';
import '../../components/GridItem.dart';
import '../../constants/AppConstants.dart';
import 'components/SettingsHeader.dart';
import 'components/TeamSpaceCard.dart';
import 'components/SettingsGridSection.dart';

/// 设置与个人中心页面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 更多设置项
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
      const GridItem(AppConstants.LABEL_BLACKLIST, Icons.block_flipped),
    ];

    // 服务中心项
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
            label: AppConstants.LABEL_PERSONAL_INFO,
            onPressed: () {
              CommonToast.show(
                  '${AppConstants.LABEL_PERSONAL_INFO}${AppConstants.MSG_NOT_IMPLEMENTED}',
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
            const SettingsHeader(),
            const SizedBox(height: 4),

            // 2. 团队空间卡片
            const TeamSpaceCard(),
            const SizedBox(height: 8),

            // 3. 服务中心
            SettingsGridSection(
              title: AppConstants.LABEL_SERVICE_CENTER,
              items: moreSettingsItems, // 拨号设置等属于服务/业务核心
            ),
            const SizedBox(height: 8),

            // 4. 更多设置
            const SettingsGridSection(
              title: AppConstants.LABEL_MORE_SETTINGS,
              items: serviceCenterItems, // 分享、关于等属于更多/通用设置
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
