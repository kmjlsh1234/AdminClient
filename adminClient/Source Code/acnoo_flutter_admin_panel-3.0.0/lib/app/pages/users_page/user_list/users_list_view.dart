// 🎯 Dart imports:
import 'dart:developer';
import 'dart:ui';
import 'package:acnoo_flutter_admin_panel/app/core/static/_static_values.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin_user/admin_user_detail.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/pages.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:dartz/dartz_unsafe.dart';
import 'package:dio/dio.dart';
// 🐦 Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/helpers.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/admin/admin.dart';
import '../../../models/admin_user/admin_user_profile.dart';
import '../../../models/error/error_code.dart';
import '../../../models/error/_rest_exception.dart';
import '../../../param/admin/admin_search_param.dart';
import '../../../param/admin_user/admin_user_search_param.dart';
import '../../../services/admin/admin_manage_service.dart';
import '../../../services/admin_user/admin_user_manager_service.dart';
import '../../../utils/constants/user_status.dart';
import '../../../utils/dialog/error_dialog.dart';
import '../../../widgets/widgets.dart';
import 'user_profile_popup.dart';
import 'demo_model.dart';
import 'mod_user_popup.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  ///_____________________________________________________________________Variables_______________________________
  List<AdminUserProfile> adminUserList = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final List<UserDataModel> users = AllUsers.allData;
  final AdminUserManageService adminUserManageService = AdminUserManageService();
  int _currentPage = 0;
  int _rowsPerPage = 10;
  int totalPage = 0;
  String? searchType;
  String? searchDateType;
  String _searchQuery = '';
  bool _selectAll = false;
  bool isLoading = true;
  @override
  void initState(){
    super.initState();
    getAdminList(context);
    getAdminListCount(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  ///_____________________________________________________________________api__________________________________
  //유저 리스트 조회
  Future<void> getAdminList(BuildContext context) async{
    List<AdminUserProfile> list = [];
    try{
      setState(() => isLoading = true);
      AdminUserSearchParam adminUserSearchParam = AdminUserSearchParam(searchType, _searchQuery, searchDateType,_startDateController.text,_endDateController.text,_currentPage + 1, _rowsPerPage);
      list = await adminUserManageService.getAdminUserList(adminUserSearchParam);
    }on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }
    setState((){
      adminUserList = list;
      isLoading = false;
    });
  }

  //유저 리스트 갯수 조회
  Future<void> getAdminListCount(BuildContext context) async{
    int count = 1;
    try{
      setState(() => isLoading = true);
      AdminUserSearchParam adminUserSearchParam = AdminUserSearchParam(searchType, _searchQuery, searchDateType,"","",_currentPage + 1, _rowsPerPage);
      count = await adminUserManageService.getAdminUserListCount(adminUserSearchParam);
    }on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }
    setState(() {
      totalPage = (count / _rowsPerPage).ceil();
      isLoading = false;
    });
  }

  Future<void> getAdminInfo(BuildContext context, int userId) async {
    try{
      context.push("/users/profile/$userId" ?? '/404');
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }
  }

  ///_____________________________________________________________________data__________________________________
  /*
  List<UserDataModel> get _currentPageData {
    if (_searchQuery.isNotEmpty) {
      _filteredData = users
          .where(
            (data) =>
                data.username
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                data.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                data.phone.contains(
                  _searchQuery,
                ),
          )
          .toList();
    } else {
      _filteredData = List.from(users);
    }

    int start = _currentPage * _rowsPerPage;
    int end = start + _rowsPerPage;
    return _filteredData.sublist(
        start, end > _filteredData.length ? _filteredData.length : end);
  }
  */
  ///_____________________________________________________________________Search_query_________________________
  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 0; // Reset to the first page when searching
    });
  }

  ///_____________________________________________________________________Add_User_____________________________
  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const UserProfileDialog());
      },
    );
  }
  ///_____________________________________________________________________Mod_User_____________________________
  void _showModFormDialog(BuildContext context, Admin admin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModUserDialog(selectAdmin: admin));
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
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

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

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
                                const SizedBox(height: 16.0),
                                searchFormField(textTheme: textTheme),
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
                                  child: showingSearchTypeDropDown(
                                      isTablet: isTablet,
                                      isMobile: isMobile,
                                      textTheme: textTheme),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: isTablet || isMobile ? 2 : 3,
                                  child: searchFormField(textTheme: textTheme),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: 1,
                                  child: showingSearchDateTypeDropDown(
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
                                          data: _theme.copyWith(
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
                                          data: _theme.copyWith(
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
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
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
                                    '${l.S.of(context).showing} ${_currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${_currentPage * _rowsPerPage + adminUserList.length} ${l.S.of(context).OF} ${adminUserList.length} ${l.S.of(context).entries}',
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

  ///_____________________________________________________________________add_user_button___________________________
  ElevatedButton addUserButton(TextTheme textTheme) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          _showFormDialog(context);
        });
      },
      label: Text(
        lang.addNewUser,
        //'Add New User',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  ///_____________________________________________________________________pagination_functions_______________________
  int get _totalPages => isLoading ? 0 : totalPage; //(_filteredData.length / _rowsPerPage).ceil();

  ///_____________________________________select_dropdown_val_________
  void _setRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
  }

  void _setSearchType(String value){
    setState(() {
      searchType = value;
    });
  }

  void _setSearchDateType(String value){
    setState(() {
      searchDateType = value;
    });
  }
  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
        getAdminList(context);
      });

    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        getAdminList(context);
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
            '${l.S.of(context).showing} ${_currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${_currentPage * _rowsPerPage + adminUserList.length} ${l.S.of(context).OF} ${adminUserList.length} ${l.S.of(context).entries}',
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

  ///_______________________________________________________________Search_Field___________________________________
  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        // hintText: 'Search...',
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              ElevatedButton(onPressed: () {
                getAdminList(context);
                getAdminListCount(context);
              },
                  child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor))
        ),
      ),
      onChanged: (value) {
        _setSearchQuery(value);
      },
    );
  }

  ///_______________________________________________________________DropDownList___________________________________

  Container showingSearchTypeDropDown(
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
            'SearchType',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall
        ),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: ["NICKNAME", "EMAIL", "MOBILE"].map((String value) {
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
            _setSearchType(value);
          }
        },
      ),
    );
  }

  Container showingSearchDateTypeDropDown(
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
            'SearchDateType',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall
        ),
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchDateType,
        items: ["CREATED_AT", "UPDATED_AT", "LOGIN_AT"].map((String value) {
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
            _setSearchDateType(value);
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
          DataColumn(label: Text(lang.createdAt)),
          DataColumn(label: Text(lang.userName)),
          DataColumn(label: Text(lang.email)),
          DataColumn(label: Text(lang.phone)),
          DataColumn(label: Text(lang.position)),
          DataColumn(label: Text(lang.status)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: adminUserList.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,//data.isSelected,
              cells: [
                DataCell(Text(data.userId.toString(),
                )),

                DataCell(
                  Text(data.createdAt),
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
                    Text(data.nickname),
                  ],
                )),
                DataCell(Text(data.email)),
                DataCell(Text(data.mobile)),
                DataCell(Text(data.userType.toString())),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.status == 'Active'
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      data.status,
                      style: textTheme.bodySmall?.copyWith(
                          color: data.status == 'Active'
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit':
                          //_showModFormDialog(context, data);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${lang.edit} ${data.nickname}')),
                          );
                          break;
                        case 'View':
                          GoRouter.of(context).go('/users/profile/${data.userId}'?? '/404');
                          //context.push("/users/profile/${data.userId}" ?? '/404');
                          break;
                        case 'Delete':
                          setState(() {
                            //users.remove(data);
                            adminUserList.remove(data);
                          });
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text(
                            lang.edit,
                            //'Edit',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'View',
                          child: Text(lang.view,
                              // 'View',
                              style: textTheme.bodyMedium),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(lang.delete,
                              // 'Delete',
                              style: textTheme.bodyMedium),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  ///_____________________________________________________________________Selected_datatable_________________________
  /*
  void _selectAllRows(bool select) {
    setState(() {
      for (var data in _currentPageData) {
        data.isSelected = select;
      }
      _selectAll = select;
    });
  }*/
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
