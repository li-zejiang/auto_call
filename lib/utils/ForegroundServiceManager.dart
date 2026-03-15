import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../constants/AppConstants.dart';

/// 前台任务处理类
class MyTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // 任务启动时的逻辑
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    // 循环执行的任务
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isRepeatingEvent) async {
    // 任务销毁时的逻辑
  }

  @override
  void onNotificationPressed() {
    // 通知被点击时的逻辑
    FlutterForegroundTask.launchApp();
  }
}

/// 前台服务管理类
class ForegroundServiceManager {
  static final ForegroundServiceManager _instance =
      ForegroundServiceManager._internal();
  factory ForegroundServiceManager() => _instance;
  ForegroundServiceManager._internal();

  /// 初始化前台服务配置
  void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'auto_call_foreground',
        channelName: '应用运行状态',
        channelDescription: '提示应用正在后台运行',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  /// 启动前台服务
  Future<ServiceRequestResult> start() async {
    // 检查是否已经在运行
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    }

    return FlutterForegroundTask.startService(
      notificationTitle: AppConstants.APP_NAME,
      notificationText: '应用正在后台运行中',
      callback: startCallback,
    );
  }

  /// 停止前台服务
  Future<ServiceRequestResult> stop() {
    return FlutterForegroundTask.stopService();
  }
}

/// 前台任务回调入口
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}
