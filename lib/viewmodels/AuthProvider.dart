import 'dart:async';
import 'dart:convert';
import 'package:auto_call/constants/AppConstants.dart';
import 'package:fluwx/fluwx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/FluwxInstance.dart';
import 'User.dart';

/// 身份验证状态类
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 身份验证 Provider
class AuthProvider extends StateNotifier<AuthState> {
  final Fluwx _fluwx = fluwxInstance;
  Completer<String>? _weChatAuthCompleter;

  AuthProvider() : super(AuthState()) {
    _loadUser();
    _fluwx.addSubscriber(_handleWeChatResponse);
  }

  static const String _userKey = 'auth_user';

  void _handleWeChatResponse(Object response) {
    final completer = _weChatAuthCompleter;
    if (completer == null || completer.isCompleted) return;

    if (response is WeChatAuthResponse) {
      final code = response.code;
      if (code != null && code.isNotEmpty) {
        completer.complete(code);
      } else {
        completer.completeError(response.errStr ?? '微信授权失败');
      }
    }
  }

  /// 从本地加载用户信息
  Future<void> _loadUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString(_userKey);
      if (userStr != null) {
        final userData = jsonDecode(userStr);
        state = state.copyWith(user: User.fromJson(userData), isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 手机号登录 (模拟)
  Future<void> loginWithPhone(String phone, String password) async {
    state = state.copyWith(isLoading: true);
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    // 模拟成功
    final user = User(
      id: 'mock_user_123',
      nickname: '繁星若尘',
      phoneNumber: phone,
      membershipExpiry: AppConstants.LABEL_MEMBER_EXPIRED, // 默认状态
    );

    await _saveUser(user);
    state = state.copyWith(user: user, isLoading: false);
  }

  @override
  void dispose() {
    _fluwx.removeSubscriber(_handleWeChatResponse);
    super.dispose();
  }

  /// 微信登录
  Future<void> loginWithWeChat() async {
    state = state.copyWith(isLoading: true);
    try {
      final installed = await _fluwx.isWeChatInstalled;
      if (!installed) {
        state = state.copyWith(isLoading: false, error: '未安装微信');
        throw Exception('未安装微信');
      }

      _weChatAuthCompleter?.completeError('canceled');
      _weChatAuthCompleter = Completer<String>();

      await _fluwx.authBy(
        which: NormalAuth(
          scope: 'snsapi_userinfo',
          state: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );

      final code = await _weChatAuthCompleter!.future.timeout(
        const Duration(seconds: 60),
      );

      final user = await _mockLoginWithWeChatCode(code);
      await _saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<User> _mockLoginWithWeChatCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: 'mock_wechat_${code.hashCode}',
      nickname: '微信用户',
      avatar: 'https://img.yzcdn.cn/vant/cat.jpeg',
      isWeChatLogin: true,
      membershipExpiry: AppConstants.LABEL_MEMBER_EXPIRED,
    );
  }

  /// 退出登录
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    state = AuthState();
  }

  /// 保存用户信息
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// 更新用户信息 (用于预留后端接口)
  Future<void> refreshUserInfo() async {
    if (state.user == null) return;

    // 这里未来调用后端接口
    // final updatedUser = await api.getUserInfo(state.user!.id);
    // state = state.copyWith(user: updatedUser);
  }
}

/// 全局 Auth Provider
final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider();
});
