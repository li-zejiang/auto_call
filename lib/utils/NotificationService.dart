import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../routes/AppRouter.dart';

/// 本地通知服务封装
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 初始化通知服务
  Future<void> init() async {
    // Android 设置
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 设置
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 通用设置
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // 初始化
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveNotificationResponse,
    );

    // 创建 Android 通知渠道 (Android 8.0+)
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'auto_call_channel', // id
        '自动拨号通知', // title
        description: '用于显示自动拨号的状态和提醒', // description
        importance: Importance.max,
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// 处理通知点击事件
  @pragma('vm:entry-point')
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      // 如果 payload 是 'todo'，则跳转到待办页面
      if (payload == 'todo') {
        router.push('/todo');
      }
    }
    // 默认行为：点击通知回到 App
  }

  /// 显示简单通知
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'auto_call_channel',
      '自动拨号通知',
      channelDescription: '用于显示自动拨号的状态和提醒',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  /// 请求通知权限 (Android 13+)
  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }
}
