import 'package:auto_call/viewmodels/CustomerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/AppRouter.dart';
import 'constants/AppConstants.dart';
import 'stores/StorageService.dart';
import 'components/CommonToast.dart';
import 'utils/NotificationService.dart';
import 'utils/ForegroundServiceManager.dart';
import 'viewmodels/ThemeProvider.dart';

/// 应用启动入口
void main() async {
  // 确保 Flutter 绑定初始化（异步操作前置条件）
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化本地通知服务
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  // 2. 初始化前台服务（Android 保活常驻通知）
  final foregroundService = ForegroundServiceManager();
  foregroundService.init();
  await foregroundService.start();

  // 3. 初始化持久化存储服务 (Isar)
  final storage = StorageService();

  runApp(
    ProviderScope(
      overrides: [
        // 注入存储服务单例
        storageServiceProvider.overrideWithValue(storage),
      ],
      child: const MyApp(),
    ),
  );
}

/// 应用根组件
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听主题状态变化，确保 UI 能够实时响应切换
    final themeMode = ref.watch(themeProvider);
    // 根据当前模式获取 ThemeData 对象
    final themeData =
        ref.read(themeProvider.notifier).getThemeDataByMode(themeMode, context);

    return MaterialApp.router(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      // 注册全局 ScaffoldMessenger 状态 Key，用于无 context 弹出 Toast
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: themeData,
      // 使用 GoRouter 路由配置
      routerConfig: router,
    );
  }
}
