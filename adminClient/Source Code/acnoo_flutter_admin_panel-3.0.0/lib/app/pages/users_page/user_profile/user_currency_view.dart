// 🐦 Flutter imports:
import 'dart:developer';
import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/chip_record_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/currency_mod_dialog.dart';
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
import '../../../services/currency/currency_service.dart';
import '../../../utils/dialog/error_dialog.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';

class UserCurrencyView extends StatefulWidget {
  const UserCurrencyView({super.key, required this.userId});
  final int userId;
  @override
  State<UserCurrencyView> createState() => _UserCurrencyViewState();
}

class _UserCurrencyViewState extends State<UserCurrencyView> with SingleTickerProviderStateMixin{
  bool isLoading = true;
  late int chip;
  late int coin;
  late int diamond;

  String _selectedCategory = l.S.current.userCurrency;
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
    initialIndex: _categories.indexOf(l.S.current.userCurrency)
  );
  ///------------------------API-----------------------------------------------------------------------------------

  final CurrencyService currencyService = CurrencyService();

  Future<void> getCurrency(BuildContext context) async {
    try{
      chip = await currencyService.getChip(widget.userId);
      coin = await currencyService.getCoin(widget.userId);
      diamond = await currencyService.getDiamond(widget.userId);
    } on DioError catch(e) {
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }
    loadingComplete();
  }
  ///------------------------API-----------------------------------------------------------------------------------

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


  @override
  void dispose() {
    // TabController의 dispose 호출
    tabController.dispose();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    getCurrency(context);
  }

  void loadingComplete() {
    setState(() {
      isLoading = false;
    });
  }
  Widget _buildTextFormField({
    required String initialValue,
    required bool obscureText,
  }) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      decoration: const InputDecoration(),
    );
  }

  Widget _buildRow({
    required String label,
    required bool obscureText,
    required int futureValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼 우측 정렬
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label과 FutureBuilder를 좌측 정렬
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Label과 FutureBuilder 간 간격 균등
            children: [
              // Label
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                //style: textTheme.bodyLarge,
              ),
              // FutureBuilder
              Text(futureValue.toString()),
            ],
          ),
        ),
        const SizedBox(width: 50),
        // 버튼 우측 정렬
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text(
            'Change',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            _showCurrencyModDialog(context, label, widget.userId, futureValue);
            // 버튼 클릭 동작
          },
        ),
      ],
    );
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
                }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(
              // label: 'chip',
              label: lang.chip,
              futureValue: chip,
              obscureText: false,
            ),
            const SizedBox(height: 16),
            _buildRow(
              //label: 'Coin',
              label: lang.coin,
              futureValue: coin,
              obscureText: false,
            ),
            const SizedBox(height: 16),

            _buildRow(
              //label: 'Current Mobile',
              label: lang.diamond,
              futureValue: diamond,
              obscureText: false,
            ),
          ],
        ),
      ),
    );

  }

  void _showCurrencyModDialog(BuildContext context, String currencyType, int userId, int amount) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: CurrencyModDialog(currencyType: currencyType, userId: userId, amount: amount));
      },
    );
  }
}


const (String,) _userProfile =
    ('assets/images/static_images/avatars/person_images/person_image_01.jpeg',);
