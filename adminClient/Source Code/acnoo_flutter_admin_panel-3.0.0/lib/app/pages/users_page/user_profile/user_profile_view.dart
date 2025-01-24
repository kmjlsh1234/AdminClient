// 🐦 Flutter imports:
import 'dart:developer';

import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/chip_record_widget.dart';
// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_profile_details_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';
import '../../../models/admin_user/admin_user_detail.dart';
import '../../../models/error/error_code.dart';
import '../../../services/admin_user/admin_user_manager_service.dart';
import '../../../utils/dialog/error_dialog.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.userId});
  final int userId;
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> with SingleTickerProviderStateMixin{
  bool isLoading = true;
  String _selectedCategory = l.S.current.profile;
  List<String> get _categories => [
    l.S.current.profile,
    l.S.current.userCurrency,
    l.S.current.userCurrencyRecord,
    l.S.current.uIUXDesign,
    l.S.current.Development
  ];

  late final tabController = TabController(
    length: _categories.length,
    vsync: this,
    initialIndex: _categories.indexOf(l.S.current.profile)
  );
  late final AdminUserDetail adminUserDetail;
  ///------------------------API-----------------------------------------------------------------------------------
  final AdminUserManageService adminUserManageService = AdminUserManageService();
  Future<void> getAdminUser(BuildContext context) async {
    try{
      adminUserDetail = await adminUserManageService.getAdminUser(widget.userId);
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }
    loadingComplete();
  }
  ///------------------------API-----------------------------------------------------------------------------------

  @override
  void initState(){
    super.initState();
    getAdminUser(context);
  }

  void handleMenu(int category){
    switch(category){
      case 0:
        GoRouter.of(context).go('/users/profile/${widget.userId}'?? '/404');
        break;
      case 1:
        GoRouter.of(context).go('/users/currency/${widget.userId}'?? '/404');
        break;
      case 2:
        GoRouter.of(context).go('/users/currency/record/${widget.userId}'?? '/404');
        break;
    }
  }

  void loadingComplete() {
    setState(() {
      isLoading = false;
    });
  }
  @override
  void dispose() {
    // TabController의 dispose 호출
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final textTheme = theme.textTheme;

    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );
    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    if(isLoading){
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: ShadowContainer(
        margin: EdgeInsetsDirectional.all(_innerSpacing),
        // headerPadding: EdgeInsets.zero,
        customHeader: TabBar(
          controller: tabController,
          isScrollable: true,
          dividerColor: Colors.transparent,
          padding: EdgeInsets.zero,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.tab,
          splashBorderRadius: BorderRadius.circular(12),
          onTap: (category) => setState(
                () {
                  _selectedCategory = _categories[category];
                  handleMenu(category);
                },
          ),
          tabs: _categories
              .map(
                (e) => Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _innerSpacing / 2,
                ),
                child: Text(e),
              ),
            ),
          )
              .toList(),
        ),
        child: Scaffold(
          backgroundColor: theme.colorScheme.primaryContainer,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(_padding),
            child: ResponsiveGridRow(
              children: [
                ///-----------------------------user_profile_details
                ResponsiveGridCol(
                  lg: 6,
                  child: Padding(
                    padding: EdgeInsets.all(_padding),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ShadowContainer(
                          contentPadding: EdgeInsets.zero,
                          showHeader: false,
                          child:
                          UserProfileDetailsWidget(
                              padding: _padding,
                              theme: theme,
                              textTheme: textTheme,
                              adminUserDetail: adminUserDetail,
                          ),
                        ),

                        /// -------------image

                        Positioned(
                          top: 123,
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: getImageType(
                              _userProfile.$1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                ///-----------------------------user_profile_update
                /*
                ResponsiveGridCol(
                  lg: 6,
                  child: Padding(
                    padding: EdgeInsets.all(_padding),
                    child: ShadowContainer(
                        contentPadding: EdgeInsets.all(_padding),
                        // headerText: 'User Profile',
                        headerText: lang.userCurrency,
                        child: UserCurrencyWidget(textTheme: textTheme, userId: widget.userId)//UserProfileUpdateWidget(textTheme: textTheme, adminUserDetail: widget.adminUserDetail),
                    ),
                  ),
                ),
*/
              ],
            ),
          ),
        ),
      ),
    );

  }
}
const (String,) _userProfile =
    ('assets/images/static_images/avatars/person_images/person_image_01.jpeg',);
