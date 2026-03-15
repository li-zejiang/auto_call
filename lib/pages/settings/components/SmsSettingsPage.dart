import 'package:flutter/material.dart';
import '../../../components/CustomAppBar.dart';
import '../../../constants/AppConstants.dart';
import '../SettingsWidgets.dart';

/// 短信设置页面
class SmsSettingsPage extends StatefulWidget {
  const SmsSettingsPage({super.key});

  @override
  State<SmsSettingsPage> createState() => _SmsSettingsPageState();
}

class _SmsSettingsPageState extends State<SmsSettingsPage> {
  bool _notConnectedSms = false;
  bool _connectedSms = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: '短信(本地手机卡)',
        showDefaultActions: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('短信记录', style: TextStyle(color: theme.primaryColor)),
          ),
          TextButton(
            onPressed: () {},
            child: Text('添加模板', style: TextStyle(color: theme.primaryColor)),
          ),
        ],
      ),
      body: Column(
        children: [
          SettingsSwitchTile(
            title: '未接通自动发短信',
            value: _notConnectedSms,
            onChanged: (val) => setState(() => _notConnectedSms = val),
            subtitle: '未选择模板',
          ),
          SettingsSwitchTile(
            title: '已接通自动发短信',
            value: _connectedSms,
            onChanged: (val) => setState(() => _connectedSms = val),
            subtitle: '未选择模板',
          ),
          const Divider(height: 1),
          const SettingsSectionHeader('短信模板'),
          const Expanded(
            child: Center(
              child: Text(
                AppConstants.MSG_NO_CONTENT,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
