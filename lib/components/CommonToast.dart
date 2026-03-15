import 'package:flutter/material.dart';
import '../constants/AppConstants.dart';

/// 全局 ScaffoldMessengerKey，用于在没有 context 的情况下显示 SnackBar
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// 通用提示组件封装
class CommonToast {
  /// 获取 ScaffoldMessengerState
  static ScaffoldMessengerState? _getMessenger(BuildContext? context) {
    if (context != null) {
      return ScaffoldMessenger.of(context);
    }
    return scaffoldMessengerKey.currentState;
  }

  /// 显示普通消息提示
  static void show(String message,
      {BuildContext? context, Duration? duration}) {
    _getMessenger(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.BORDER_RADIUS),
        ),
      ),
    );
  }

  /// 显示成功提示
  static void success(String message, {BuildContext? context}) {
    _getMessenger(context)?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.SUCCESS,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.BORDER_RADIUS),
        ),
      ),
    );
  }

  /// 显示错误提示
  static void error(String message, {BuildContext? context}) {
    _getMessenger(context)?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.ERROR,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.BORDER_RADIUS),
        ),
      ),
    );
  }

  /// 显示警告提示
  static void warning(String message, {BuildContext? context}) {
    _getMessenger(context)?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.WARNING,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.BORDER_RADIUS),
        ),
      ),
    );
  }
}
