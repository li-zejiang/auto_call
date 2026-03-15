import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用主题模式枚举
enum AppThemeMode {
  system, // 跟随系统
  light, // 浅色模式
  dark, // 深色模式
  eyeProtection // 护眼模式
}

/// 主题状态管理类
/// 负责主题模式的持久化存储以及 ThemeData 的动态生成
class ThemeProvider extends StateNotifier<AppThemeMode> {
  ThemeProvider() : super(AppThemeMode.system) {
    _loadTheme(); // 初始化时加载存储的主题
  }

  static const String _themeKey = 'app_theme_mode';

  /// 从本地存储加载主题模式
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey);
    if (index != null) {
      state = AppThemeMode.values[index];
    }
  }

  /// 设置新的主题模式并持久化
  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  /// 根据模式获取对应的 ThemeData
  ThemeData getThemeDataByMode(AppThemeMode mode, BuildContext context) {
    switch (mode) {
      case AppThemeMode.light:
        return _lightTheme;
      case AppThemeMode.dark:
        return _darkTheme;
      case AppThemeMode.eyeProtection:
        return _eyeProtectionTheme;
      case AppThemeMode.system:
        final brightness = MediaQuery.platformBrightnessOf(context);
        return brightness == Brightness.dark ? _darkTheme : _lightTheme;
    }
  }

  /// 抽取通用的 AppBar 主题配置逻辑
  /// [brightness] 亮度设置
  /// [bgColor] 背景色
  /// [textColor] 文字和图标颜色
  static AppBarTheme _buildAppBarTheme(
      Brightness brightness, Color bgColor, Color textColor) {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: bgColor,
      foregroundColor: textColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }

  /// 浅色模式配置
  final _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.light,
      surface: Colors.white,
      onSurface: const Color(0xFF333333),
      outline: const Color(0xFFEEEEEE),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    appBarTheme: _buildAppBarTheme(
        Brightness.light, Colors.white, const Color(0xFF333333)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF2196F3),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      enableFeedback: false, // 禁用触觉反馈，减少动画感
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
    ),
  );

  /// 深色模式配置
  final _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.dark,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
      outline: const Color(0xFF333333),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    // 顶部状态栏和导航栏配置
    appBarTheme: _buildAppBarTheme(
        Brightness.dark, const Color(0xFF1E1E1E), Colors.white),
    // 底部导航栏配置
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF2196F3),
      unselectedItemColor: Color(0xFFB0B0B0),
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      enableFeedback: false,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF333333),
      thickness: 1,
      space: 1,
    ),
    // 卡片样式配置
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF333333)),
      ),
    ),
    // 针对 Material 3 的 NavigationBar 样式
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: const Color(0xFF2196F3).withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 11, color: Colors.white),
      ),
    ),
  );

  /// 护眼模式配置
  final _eyeProtectionTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.light,
      surface: const Color(0xFFF5EBD7),
      onSurface: const Color(0xFF5D4037),
      outline: const Color(0xFFE5D5C0),
    ),
    scaffoldBackgroundColor: const Color(0xFFFAF2E6),
    appBarTheme: _buildAppBarTheme(
        Brightness.light, const Color(0xFFF5EBD7), const Color(0xFF5D4037)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF5EBD7),
      selectedItemColor: Color(0xFF2196F3),
      unselectedItemColor: Color(0xFF8D6E63),
      selectedLabelStyle: TextStyle(fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      enableFeedback: false,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5D5C0),
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFF5EBD7),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5D5C0)),
      ),
    ),
  );
}

/// 全局主题 Provider
final themeProvider = StateNotifierProvider<ThemeProvider, AppThemeMode>((ref) {
  return ThemeProvider();
});
