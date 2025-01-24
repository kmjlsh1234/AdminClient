// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/models/currency/chip_record.dart';
import 'package:acnoo_flutter_admin_panel/app/param/currency/currency_record_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/services/currency/currency_record_service.dart';
import 'package:acnoo_flutter_admin_panel/app/services/currency/currency_service.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../core/static/_static_values.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/currency/coin_record.dart';
import '../../../models/currency/diamond_record.dart';
import '../../../models/error/error_code.dart';
import '../../../utils/dialog/error_dialog.dart';
import '../../../widgets/pagination_widgets/_pagination_widget.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';

class DiamondRecordWidget extends StatefulWidget {

  const DiamondRecordWidget({super.key, required this.userId});
  final int userId;
  @override
  State<DiamondRecordWidget> createState() => _DiamondRecordState();
}

class _DiamondRecordState extends State<DiamondRecordWidget>{
  List<DiamondRecord> diamondRecordList = [];
  final ScrollController _scrollController = ScrollController();
  final CurrencyRecordService currencyRecordService = CurrencyRecordService();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? changeType;
  int _currentPage = 0;
  int _rowsPerPage = 10;
  bool isLoading = true;
  int totalPage = 0;


  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDiamondRecordList(context);
    getDiamondRecordListCount(context);
  }

  Future<void> getDiamondRecordList(BuildContext context) async {
    setState(() => isLoading = true);
    List<DiamondRecord> list = [];
    try{
      CurrencyRecordSearchParam param = CurrencyRecordSearchParam(widget.userId, changeType, _startDateController.text, _endDateController.text, _currentPage + 1, _rowsPerPage);
      list = await currencyRecordService.getDiamondRecordList(param);
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }
    diamondRecordList = list;
    setState(() => isLoading = false);
  }

  Future<void> getDiamondRecordListCount(BuildContext context) async {
    setState(() => isLoading = true);
    int count = 0;
    try{
      CurrencyRecordSearchParam param = CurrencyRecordSearchParam(widget.userId, changeType, _startDateController.text, _endDateController.text, _currentPage + 1, _rowsPerPage);
      count = await currencyRecordService.getDiamondRecordListCount(param);
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }

    setState(() {
      isLoading = false;
      totalPage = (count / _rowsPerPage).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //______________________________________________________________________Header__________________
                    isMobile
                        ? Padding(
                      padding: _sizeInfo.padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              //addUserButton(textTheme),
                            ],
                          ),
                        ],
                      ),
                    )
                        : Padding(
                      padding: _sizeInfo.padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: showingChangeTypeDropDown(
                                isTablet: isTablet,
                                isMobile: isMobile,
                                textTheme: textTheme),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _startDateController,
                              keyboardType: TextInputType.visiblePassword,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                labelText: l.S.of(context).startDate,
                                labelStyle: textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                hintText: 'yyyy-MM-ddTHH:mm:ss',//'mm/dd/yyyy',
                                suffixIcon:
                                const Icon(IconlyLight.calendar, size: 20),
                              ),
                              onTap: () async {
                                final _result = await showDatePicker(
                                  context: context,
                                  firstDate: AppDateConfig.appFirstDate,
                                  lastDate: AppDateConfig.appLastDate,
                                  initialDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                    data: theme.copyWith(
                                      datePickerTheme: DatePickerThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );

                                if (_result != null) {
                                  _startDateController.text = DateFormat(
                                    //AppDateConfig.appNumberOnlyDateFormat,
                                    AppDateConfig.localDateTimeFormat,
                                  ).format(_result);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _endDateController,
                              keyboardType: TextInputType.visiblePassword,
                              readOnly: true,
                              selectionControls: EmptyTextSelectionControls(),
                              decoration: InputDecoration(
                                labelText: l.S.of(context).endDate,
                                labelStyle: textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                hintText: 'yyyy-MM-ddTHH:mm:ss',//'mm/dd/yyyy',
                                suffixIcon:
                                const Icon(IconlyLight.calendar, size: 20),
                              ),
                              onTap: () async {
                                final _result = await showDatePicker(
                                  context: context,
                                  firstDate: AppDateConfig.appFirstDate,
                                  lastDate: AppDateConfig.appLastDate,
                                  initialDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                    data: theme.copyWith(
                                      datePickerTheme: DatePickerThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );

                                if (_result != null) {
                                  _endDateController.text = DateFormat(
                                    //AppDateConfig.appNumberOnlyDateFormat,
                                    AppDateConfig.localDateTimeFormat,
                                  ).format(_result);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    getDiamondRecordList(context);
                                    getDiamondRecordListCount(context);
                                  },
                                  child:
                                  const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor
                                  )
                              )
                          )

                          //addUserButton(textTheme),
                        ],
                      ),
                    ),

                    //______________________________________________________________________Data_table__________________
                    isMobile || isTablet
                        ? RawScrollbar(
                      padding: const EdgeInsets.only(left: 18),
                      trackBorderColor: theme.colorScheme.surface,
                      trackVisibility: true,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 8.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: isLoading ? Center(child: CircularProgressIndicator()) : userListDataTable(context),
                            ),
                          ),
                          Padding(
                            padding: _sizeInfo.padding,
                            child: Text(
                              '${l.S.of(context).showing} ${_currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${_currentPage * _rowsPerPage + diamondRecordList.length} ${l.S.of(context).OF} ${diamondRecordList.length} ${l.S.of(context).entries}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                        : SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: isLoading ? Center(child: CircularProgressIndicator()) : userListDataTable(context),
                      ),
                    ),

                    //______________________________________________________________________footer__________________
                    isTablet || isMobile
                        ? const SizedBox.shrink()
                        : Padding(
                      padding: _sizeInfo.padding,
                      child: paginatedSection(theme, textTheme),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  ///_______________________________________________________________DropDownList___________________________________

  Container showingChangeTypeDropDown(
      {required bool isTablet,
        required bool isMobile,
        required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    //final theme = Theme.of(context);
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<String>(
        hint: Text(
            'ChangeType',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall
        ),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: changeType,
        items: ["ALL", "ADD", "USE"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              //isTablet || isMobile ? '$value' :
              value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            value = (value == 'ALL') ? null : value;
            changeType = value;
          }
        },
      ),
    );
  }
  ///_______________________________________________________________User_List_Data_Table___________________________
  Theme userListDataTable(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Theme(
      data: ThemeData(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: [
          DataColumn(label: Text(lang.serial)),
          DataColumn(label: Text(lang.changeType)),
          DataColumn(label: Text(lang.changeChip)),
          DataColumn(label: Text(lang.resultChip)),
          DataColumn(label: Text(lang.changeDesc)),
          DataColumn(label: Text(lang.createdAt)),
        ],
        rows: diamondRecordList.map(
              (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,//data.isSelected,
              cells: [
                DataCell(Text(data.id.toString(),
                )),

                DataCell(
                  Text(data.changeType),
                  //Text(DateFormat('d MMM yyyy').format(DateTime.now())),
                ),

                DataCell(Row(
                  children: [
                    /*
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AvatarWidget(
                          fit: BoxFit.cover,
                          avatarShape: AvatarShape.circle,
                          size: const Size(40, 40),
                          imagePath: 'assets/images/static_images/avatars/person_images/person_image_01.jpeg'),//data.imagePath
                    ),*/
                    const SizedBox(width: 8.0),
                    Text(data.changeDiamond.toString()),
                  ],
                )),
                DataCell(Text(data.resultDiamond.toString())),
                DataCell(Text(data.changeDesc)),
                DataCell(Text(data.createdAt)),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
  ///_____________________________________________________________________pagination_functions_______________________
  int get _totalPages => isLoading ? 0 : totalPage; //(_filteredData.length / _rowsPerPage).ceil();
  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
        getDiamondRecordList(context);
      });

    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        getDiamondRecordList(context);
      });

    }
  }
  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme) {
    //final lang = l.S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${_currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${_currentPage * _rowsPerPage + diamondRecordList.length} ${l.S.of(context).OF} ${diamondRecordList.length} ${l.S.of(context).entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: _currentPage + 1,
          totalPages: isLoading ? 0 : totalPage,//_totalPage,
          onPreviousTap: _goToPreviousPage,
          onNextTap: _goToNextPage,
        )
      ],
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
