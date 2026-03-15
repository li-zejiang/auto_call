import 'package:flutter/material.dart';

/// 应用颜色常量
class AppColors {
  static const Color PRIMARY = Color(0xFF2196F3);
  static const Color BACKGROUND = Color(0xFFF5F7FA);
  static const Color CARD_BACKGROUND = Colors.white;
  static const Color TEXT_PRIMARY = Color(0xFF333333);
  static const Color TEXT_SECONDARY = Color(0xFF999999);
  static const Color DIVIDER = Color(0xFFEEEEEE);
  static const Color SUCCESS = Color(0xFF4CAF50);
  static const Color WARNING = Color(0xFFFFC107);
  static const Color ERROR = Color(0xFFF44336);
  static const Color TEAM_SPACE_BLUE = Color(0xFF4A78F0);
  static const Color MEMBER_BTN_DARK = Color(0xFF2D2D3A);
  static const Color VIP_GOLD = Color(0xFFFFD700);
}

/// 全局业务常量与文案配置
class AppConstants {
  // 应用基本配置
  static const String APP_NAME = '自动拨号';
  static const double BORDER_RADIUS = 12.0;
  static const double PADDING = 16.0;

  // 页面标题
  static const String TITLE_DIAL = '自动拨号';
  static const String TITLE_CUSTOMER = '客户管理';
  static const String TITLE_STATS = '拨打统计';
  static const String TITLE_PROFILE = '个人中心';

  // 底部导航栏标签
  static const String NAV_DIAL = '拨号';
  static const String NAV_CUSTOMER = '客户';
  static const String NAV_SETTINGS = '设置';

  // 客户与待办标签
  static const String LABEL_CUSTOMER = '客户';
  static const String LABEL_TODO = '待办';
  static const String LABEL_EXPORT = '导出';
  static const String LABEL_ADD = '新增';
  static const String LABEL_BATCH = '批量';

  // 按钮文本
  static const String BTN_CANCEL = '取消';
  static const String BTN_DIAL = '拨打';
  static const String BTN_CONFIRM = '确定';

  // 提示语
  static const String HINT_INPUT_PHONE = '请输入电话号码';
  static const String MSG_NOT_IMPLEMENTED = '功能暂未实现';
  static const String MSG_NO_CONTENT = '暂无内容';
  static const String MSG_CLICK_TO_REFRESH = '点击刷新';
  static const String MSG_LOADING_ERROR = '加载出错: ';
  static const String MSG_NO_CUSTOMER_DATA = '暂无客户数据';
  static const String MSG_NO_TODO_DATA = '暂无待办事项';

  // 统计与列表标签
  static const String LABEL_DIALED_TODAY = '今日已拨打: ';
  static const String LABEL_CONNECTED_TODAY = '已接通: ';
  static const String LABEL_ALL_CUSTOMERS = '全部客户';
  static const String LABEL_LATEST_ADDED = '最新添加';
  static const String LABEL_FILTER = '筛选';

  // 设置页与功能标签
  static const String LABEL_DIAL_SETTINGS = '拨号设置';
  static const String LABEL_ACCESSIBILITY = '辅助功能';
  static const String LABEL_BACKEND_ADMIN = '后台管理';
  static const String LABEL_SMS_SETTINGS = '短信设置';
  static const String LABEL_LAYOUT_SETTINGS = '布局设置';
  static const String LABEL_BLACKLIST = '黑名单';
  static const String LABEL_SHARE_APP = '分享App';
  static const String LABEL_PRIVACY_POLICY = '隐私政策';
  static const String LABEL_CONTACT_SERVICE = '联系客服';
  static const String LABEL_ABOUT_US = '关于我们';
  static const String LABEL_INSTRUCTIONS = '使用说明';
  static const String LABEL_SUPPORT = '好评支持';
  static const String LABEL_TEAM_SPACE = '团队空间';
  static const String LABEL_TEAM_SPACE_SUBTITLE = '数据统计、任务分配';
  static const String LABEL_SERVICE_CENTER = '服务中心';
  static const String LABEL_MORE_SETTINGS = '更多设置';
  static const String LABEL_BUY_MEMBER = '购买会员';
  static const String LABEL_MEMBER_EXPIRED = '会员特权已到期';
  static const String LABEL_PERSONAL_INFO = '个人信息';
  static const String LABEL_LEARN_MORE = '了解更多';
  static const String LABEL_MANUAL_DIAL = '手动拨号';
  static const String LABEL_IMPORT_PHONE = '导入号码';
  static const String LABEL_REFRESH = '刷新';
  static const String LABEL_SEARCH = '搜索';
  static const String LABEL_SHARE = '分享';
  static const String LABEL_DOWNLOAD = '下载';

  // 字段文本
  static const String FIELD_CONTACT = '联系人：';
  static const String FIELD_PHONE = '电话：';

  // 字体大小配置
  static const double FONT_SIZE_TITLE = 18.0;
  static const double FONT_SIZE_BODY = 16.0;
  static const double FONT_SIZE_SMALL = 12.0;
  static const double FONT_SIZE_MINI = 10.0;

  // 公共文本样式
  static const TextStyle TITLE_STYLE = TextStyle(
    fontSize: FONT_SIZE_TITLE,
    fontWeight: FontWeight.w400,
    color: AppColors.TEXT_PRIMARY,
  );
}
