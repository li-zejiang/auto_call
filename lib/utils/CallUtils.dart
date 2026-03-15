import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/CommonToast.dart';

class CallUtils {
  static Future<void> makeCall(BuildContext context, String phoneNumber) async {
    // 移除所有非数字字符（保留+号）
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanNumber.isEmpty) return;

    final Uri url = Uri.parse('tel:$cleanNumber');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // 如果无法直接拨号，尝试复制到剪贴板并提示
        await _fallbackToClipboard(context, cleanNumber);
      }
    } catch (e) {
      debugPrint('拨号失败: $e');
      if (context.mounted) {
        await _fallbackToClipboard(context, cleanNumber, error: e.toString());
      }
    }
  }

  static Future<void> _fallbackToClipboard(BuildContext context, String number,
      {String? error}) async {
    await Clipboard.setData(ClipboardData(text: number));
    if (context.mounted) {
      String message = '已复制号码: $number';
      if (error != null) {
        message = '拨号失败 ($error)，号码已复制到剪贴板';
        CommonToast.error(message, context: context);
      } else {
        message = '该平台可能不支持直接拨号，号码已复制到剪贴板';
        CommonToast.show(message, context: context);
      }
    }
  }
}
