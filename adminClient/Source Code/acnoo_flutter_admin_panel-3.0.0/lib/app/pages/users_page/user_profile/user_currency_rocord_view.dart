// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/chip_record_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/coin_record_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/diamond_record_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../../models/error/error_code.dart';
import '../../../services/currency/currency_service.dart';
import '../../../utils/dialog/error_dialog.dart';
import '../../../widgets/custom_segment_button/custom_segment_button.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
class UserCurrencyRecordView extends StatefulWidget {
  const UserCurrencyRecordView({super.key, required this.userId});
  final int userId;
  @override
  State<UserCurrencyRecordView> createState() => _UserCurrencyRecordViewState();
}

class _UserCurrencyRecordViewState extends State<UserCurrencyRecordView> with SingleTickerProviderStateMixin{
  bool isLoading = true;
  late int chip;
  late int coin;
  late int diamond;
  String selectCurrencyType = 'CHIP';
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
    initialIndex: _categories.indexOf(l.S.current.userCurrencyRecord)
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
      appBar: TabBar(
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

      body: Scaffold(

        appBar: PreferredSize(preferredSize: const Size.fromHeight(48),
            child: CustomSegmentButton<String>(
              segments: [
                ButtonSegment(
                  label: Text(lang.chip),
                  value: 'CHIP',
                ),
                ButtonSegment(
                  label: Text(lang.coin),
                  value: 'COIN',
                ),
                ButtonSegment(
                  label: Text(lang.diamond),
                  value: 'DIAMOND',
                ),
              ],
              selected: {selectCurrencyType},
              onSelectionChanged: (value) {
                setState(() {
                  selectCurrencyType = value.first;
                });
                // 선택된 뷰에 따라 필요한 작업 수행
              },
            ),
        ),
        body: _buildBody(),
      ),

    );
  }

  Widget _buildBody() {
    switch (selectCurrencyType) {

      case 'CHIP':
        return ChipRecordWidget(userId: widget.userId);
      case 'COIN':
        return Center(
          child: CoinRecordWidget(userId: widget.userId),
        ); // 여기서 COIN에 맞는 위젯으로 변경
      case 'DIAMOND':
        return Center(
          child: DiamondRecordWidget(userId: widget.userId),
        ); // 여기서 DIAMOND에 맞는 위젯으로 변경
      default:
        return Center(
          child: Text('Invalid Type Selected'),
        );
    }
  }
}

