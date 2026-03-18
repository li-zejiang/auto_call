import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/AppConstants.dart';
import '../../components/CustomAppBar.dart';
import '../../components/CommonToast.dart';
import '../../viewmodels/AuthProvider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAgreed = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_isAgreed) {
      CommonToast.show('请阅读并同意用户协议和隐私政策', context: context);
      return;
    }

    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      CommonToast.show('请输入手机号和密码', context: context);
      return;
    }

    // 手机号正则校验
    final phoneRegExp = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegExp.hasMatch(phone)) {
      CommonToast.show('请输入正确的手机号', context: context);
      return;
    }

    try {
      await ref.read(authProvider.notifier).loginWithPhone(phone, password);
      if (mounted) {
        context.pop(); // 登录成功返回
      }
    } catch (e) {
      if (!mounted) return;
      CommonToast.show('登录失败: $e', context: context);
    }
  }

  void _handleWeChatLogin() async {
    if (!_isAgreed) {
      CommonToast.show('请阅读并同意用户协议和隐私政策', context: context);
      return;
    }

    try {
      await ref.read(authProvider.notifier).loginWithWeChat();
      if (mounted) {
        context.pop(); // 登录成功返回
      }
    } catch (e) {
      if (!mounted) return;
      CommonToast.show('微信登录失败: $e', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: AppConstants.TITLE_LOGIN,
        showDefaultActions: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            // 手机号输入
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '输入手机号',
                prefixIcon: Icon(Icons.smartphone_outlined),
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 密码输入
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '输入密码',
                prefixIcon: Icon(Icons.lock_outline),
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 协议勾选
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isAgreed,
                    onChanged: (val) =>
                        setState(() => _isAgreed = val ?? false),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    children: [
                      const Text('已阅读并同意',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      GestureDetector(
                        onTap: () => CommonToast.show('用户协议', context: context),
                        child: const Text('《用户协议》',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.PRIMARY)),
                      ),
                      const Text('和',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      GestureDetector(
                        onTap: () => CommonToast.show('隐私政策', context: context),
                        child: const Text('《隐私政策》',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.PRIMARY)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 登录按钮
            ElevatedButton(
              onPressed: authState.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.PRIMARY,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: authState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('登录',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            // 忘记密码和注册
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => CommonToast.show('功能开发中', context: context),
                  child: const Text('忘记密码?',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
                TextButton(
                  onPressed: () => CommonToast.show('功能开发中', context: context),
                  child: const Text('新用户注册',
                      style: TextStyle(color: AppColors.PRIMARY, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 60),
            // 其他登录方式
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('其他登录方式',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 32),
            // 微信登录
            Column(
              children: [
                GestureDetector(
                  onTap: authState.isLoading ? null : _handleWeChatLogin,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF07C160),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.wechat, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('微信登录',
                    style: TextStyle(color: Color(0xFF07C160), fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
