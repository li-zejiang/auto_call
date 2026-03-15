import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/CustomAppBar.dart';
import '../../../constants/AppConstants.dart';
import '../../../viewmodels/ThemeProvider.dart';

/// 无障碍设置页面
///
/// 目前主要提供外观主题切换功能
class AccessibilityPage extends ConsumerWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听当前主题状态
    final currentThemeMode = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppConstants.LABEL_ACCESSIBILITY,
        showDefaultActions: false,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, '外观设置'),
          ListTile(
            title: const Text('主题模式', style: TextStyle(fontSize: 16)),
            subtitle: Text(_getThemeModeName(currentThemeMode),
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeSelection(context, ref, currentThemeMode),
          ),
          const Divider(height: 1, indent: 16),
        ],
      ),
    );
  }

  /// 获取主题模式对应的显示名称
  String _getThemeModeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return '跟随系统';
      case AppThemeMode.light:
        return '浅色模式';
      case AppThemeMode.dark:
        return '深色模式';
      case AppThemeMode.eyeProtection:
        return '护眼模式';
    }
  }

  /// 显示主题选择底部弹窗
  void _showThemeSelection(
      BuildContext context, WidgetRef ref, AppThemeMode currentMode) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('选择主题',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildThemeOption(
                  context, ref, AppThemeMode.system, '跟随系统', currentMode),
              _buildThemeOption(
                  context, ref, AppThemeMode.light, '浅色模式', currentMode),
              _buildThemeOption(
                  context, ref, AppThemeMode.dark, '深色模式', currentMode),
              _buildThemeOption(context, ref, AppThemeMode.eyeProtection,
                  '护眼模式', currentMode),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// 构建单个主题选项
  Widget _buildThemeOption(BuildContext context, WidgetRef ref,
      AppThemeMode mode, String label, AppThemeMode currentMode) {
    final isSelected = mode == currentMode;
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        ref.read(themeProvider.notifier).setTheme(mode);
        Navigator.pop(context);
      },
    );
  }

  /// 构建分组标题
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // 这里的背景色根据主题亮度自动调整
      color: theme.brightness == Brightness.dark
          ? Colors.black26
          : Colors.grey[100],
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 12, color: theme.hintColor),
      ),
    );
  }
}
