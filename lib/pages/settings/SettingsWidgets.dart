import 'package:flutter/material.dart';

/// 设置页面的通用分组头部
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.brightness == Brightness.dark 
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) 
          : colorScheme.surfaceContainerHighest,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12, 
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// 设置页面的导航列表项
class SettingsNavigationTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const SettingsNavigationTile({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value, 
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          Icon(
            Icons.chevron_right, 
            color: colorScheme.onSurface.withValues(alpha: 0.3), 
            size: 20,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// 设置页面的开关列表项
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            title,
            style: TextStyle(color: colorScheme.onSurface),
          ),
          value: value,
          onChanged: onChanged,
          activeColor: colorScheme.primary,
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12, 
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
      ],
    );
  }
}

/// 设置页面的下拉选择项
class SettingsDropdownTile<T> extends StatelessWidget {
  final String title;
  final String value;
  final List<T> options;
  final ValueChanged<T> onChanged;

  const SettingsDropdownTile({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value, 
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          Icon(
            Icons.keyboard_arrow_down, 
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
      onTap: () {
        // 这里可以弹出选择器逻辑
      },
    );
  }
}
