import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/AppConstants.dart';
import '../../components/CustomAppBar.dart';
import '../../components/CommonToast.dart';
import '../../viewmodels/AuthProvider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听登录状态，如果退出登录则返回
    ref.listen(authProvider, (previous, next) {
      if (previous?.user != null && next.user == null) {
        if (context.mounted) {
          context.pop();
        }
      }
    });

    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: AppConstants.TITLE_USER_INFO,
        showDefaultActions: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildInfoRow(
                  '头像',
                  trailing: CircleAvatar(
                    radius: 18,
                    backgroundImage: user.avatar != null 
                        ? NetworkImage(user.avatar!) 
                        : null,
                    child: user.avatar == null 
                        ? const Icon(Icons.person, size: 24, color: Colors.grey) 
                        : null,
                  ),
                  onTap: () {
                    if (user.isWeChatLogin) {
                      CommonToast.show('微信登录用户不支持修改头像', context: context);
                    } else {
                      CommonToast.show('功能开发中', context: context);
                    }
                  },
                ),
                _buildInfoRow(
                  '昵称',
                  value: user.nickname,
                  onTap: () => CommonToast.show('修改昵称功能开发中', context: context),
                ),
                _buildInfoRow(
                  '手机号',
                  value: user.phoneNumber ?? '未绑定',
                  onTap: () => CommonToast.show('手机号修改功能开发中', context: context),
                ),
                _buildInfoRow(
                  '修改密码',
                  onTap: () => CommonToast.show('功能开发中', context: context),
                ),
                _buildInfoRow(
                  'ID',
                  value: user.id,
                  showArrow: false,
                ),
                _buildInfoRow(
                  '会员有效期',
                  value: user.membershipExpiry ?? AppConstants.LABEL_MEMBER_EXPIRED,
                  showArrow: false,
                ),
              ],
            ),
          ),
          // 底部退出登录和注销按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 只执行登出，不在这里 pop
                    // 页面顶部的 ref.watch(authProvider) 会监听到 user 为 null
                    // 并触发 ref.listen 中的 context.pop()
                    ref.read(authProvider.notifier).logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('退出登录', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => CommonToast.show('注销账号流程开发中', context: context),
                  child: const Text('注销账号', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, {
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
            const Spacer(),
            if (value != null)
              Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            if (trailing != null) trailing,
            if (showArrow)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
