import 'package:flutter/material.dart';
import '../constants/AppConstants.dart';
import 'CommonToast.dart';

/// 自定义通用 AppBar 组件
///
/// 具备以下特性：
/// 1. 标题居中显示
/// 2. 自动根据路由状态切换左侧按钮：
///    - 若可返回，显示 iOS 风格的返回图标
///    - 若不可返回，显示搜索按钮（默认）
/// 3. 支持自定义右侧动作按钮，默认提供分享和下载按钮
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 标题文字
  final String title;

  /// 右侧操作按钮列表
  final List<Widget>? actions;

  /// 左侧自定义组件，若提供则覆盖默认逻辑
  final Widget? leading;

  /// 是否显示默认的右侧动作（分享、下载）
  final bool showDefaultActions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showDefaultActions = true,
  });

  @override
  Widget build(BuildContext context) {
    // 检查当前路由是否可以返回
    final bool canPop = Navigator.of(context).canPop();

    return AppBar(
      centerTitle: true,
      elevation: 0,
      // 自动决定左侧按钮：如果能返回则显示返回按钮，否则显示默认搜索（除非手动指定 leading）
      leading: leading ??
          (canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : AppBarButton(
                  icon: Icons.search,
                  label: AppConstants.LABEL_SEARCH,
                  onPressed: () {
                    CommonToast.show(
                        '${AppConstants.LABEL_SEARCH}${AppConstants.MSG_NOT_IMPLEMENTED}',
                        context: context);
                  },
                )),
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: actions ??
          (showDefaultActions
              ? [
                  AppBarButton(
                    icon: Icons.ios_share,
                    label: AppConstants.LABEL_SHARE,
                    onPressed: () {
                      CommonToast.show(
                          '${AppConstants.LABEL_SHARE}${AppConstants.MSG_NOT_IMPLEMENTED}',
                          context: context);
                    },
                  ),
                  AppBarButton(
                    icon: Icons.cloud_download,
                    label: AppConstants.LABEL_DOWNLOAD,
                    onPressed: () {
                      CommonToast.show(
                          '${AppConstants.LABEL_DOWNLOAD}${AppConstants.MSG_NOT_IMPLEMENTED}',
                          context: context);
                    },
                  ),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar 专用按钮组件
///
/// 采用垂直布局：上方图标 + 下方小字描述
class AppBarButton extends StatelessWidget {
  /// 按钮图标
  final IconData icon;

  /// 图标下方的文字标签
  final String label;

  /// 点击回调
  final VoidCallback onPressed;

  /// 图标颜色，默认为 AppBar 的图标主题色
  final Color? color;

  const AppBarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 优先使用传入颜色，其次使用 AppBarTheme 的图标颜色，最后使用主题主色
    final iconColor =
        color ?? theme.appBarTheme.iconTheme?.color ?? theme.primaryColor;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: iconColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
