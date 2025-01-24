// 🐦 Flutter imports:
import 'dart:developer';
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/providers/admin/admin_provider.dart';
import 'package:acnoo_flutter_admin_panel/app/services/admin/admin_service.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 📦 Package imports:
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/helpers/helpers.dart';
import '../../../../core/static/static.dart';
import '../../../../models/admin/admin.dart';
import '../../../../models/error/error_code.dart';
import '../../../../models/error/_rest_exception.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/dialog/error_dialog.dart';
import '../../../../widgets/widgets.dart';
import '../language_dropdown/_language_dropdown.dart';
import '_admin_profile_popup.dart';

part '_notification_icon_button.dart';
part '_toggle_theme.dart';
part '_user_profile_avatar.dart';

class TopBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const TopBarWidget({super.key, this.onMenuTap});

  final void Function()? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    return AppBar(
      leading: rf.ResponsiveValue<Widget?>(
        context,
        conditionalValues: [
          rf.Condition.largerThan(
            name: BreakpointName.MD.name,
            value: null,
          ),
        ],
        defaultValue: IconButton(
          onPressed: onMenuTap,
          icon: Tooltip(
            // message: 'Open Navigation menu',
            message: lang.openNavigationMenu,
            waitDuration: const Duration(milliseconds: 350),
            child: const Icon(Icons.menu),
          ),
        ),
      ).value,
      toolbarHeight: rf.ResponsiveValue<double?>(
        context,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.SM.name, value: 70)
        ],
      ).value,
      surfaceTintColor: Colors.transparent,
      actions: [
        // Language Dropdown
        Consumer<AppLanguageProvider>(
          builder: (context, lang, child) {
            return LanguageDropdownWidget(
              value: lang.currentLocale,
              supportedLanguage: lang.locales,
              onChanged: lang.changeLocale,
            );
          },
        ),
        const SizedBox(width: 8),

        // Toggle Theme Button
        Consumer<AppThemeProvider>(
          builder: (context, appTheme, child) => ThemeToggler(
            isDarkMode: appTheme.isDarkTheme,
            onChanged: appTheme.toggleTheme,
          ),
        ),

        // Notification Icon
        const Padding(
          padding: EdgeInsetsDirectional.only(start: 0, end: 12),
          child: NotificationIconButton(),
        ),

        // User Avatar
        UserProfileAvatar(),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 64);
}
