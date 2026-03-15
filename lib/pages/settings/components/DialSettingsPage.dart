import 'package:flutter/material.dart';
import '../../../components/CustomAppBar.dart';
import '../../../constants/AppConstants.dart';
import '../SettingsWidgets.dart';

/// 拨号设置页面
class DialSettingsPage extends StatefulWidget {
  const DialSettingsPage({super.key});

  @override
  State<DialSettingsPage> createState() => _DialSettingsPageState();
}

class _DialSettingsPageState extends State<DialSettingsPage> {
  bool _autoDialNext = true;
  int _dialInterval = 5;
  String _simCard = '跟随系统';
  bool _fixOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppConstants.LABEL_DIAL_SETTINGS,
        showDefaultActions: false,
      ),
      body: ListView(
        children: [
          const SettingsSectionHeader(''),
          const SettingsNavigationTile(title: '拨号前缀', value: '未设置'),
          const SettingsNavigationTile(title: '拨打提醒', value: '开启'),
          const SettingsSectionHeader('自动拨号'),
          SettingsSwitchTile(
            title: '自动拨打下一个',
            value: _autoDialNext,
            onChanged: (val) => setState(() => _autoDialNext = val),
          ),
          SettingsDropdownTile<int>(
            title: '拨号间隔',
            value: '${_dialInterval}秒',
            options: const [3, 5, 10, 15, 30],
            onChanged: (val) => setState(() => _dialInterval = val),
          ),
          const SettingsSectionHeader('双卡设置'),
          SettingsDropdownTile<String>(
            title: '拨号卡',
            value: _simCard,
            options: const ['跟随系统', 'SIM卡 1', 'SIM卡 2'],
            onChanged: (val) => setState(() => _simCard = val),
          ),
          const SettingsSectionHeader(''),
          SettingsSwitchTile(
            title: '修复开启',
            value: _fixOpen,
            onChanged: (val) => setState(() => _fixOpen = val),
            subtitle: '一般不开启，开启了反而可能导致异常',
          ),
        ],
      ),
    );
  }
}
