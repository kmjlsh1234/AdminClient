import 'package:acnoo_flutter_admin_panel/app/param/currency/currency_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/services/currency/currency_service.dart';
import 'package:dio/dio.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import '../../../../generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';

import '../../../models/error/error_code.dart';
import '../../../utils/dialog/error_dialog.dart';
import '../../../widgets/dialog_header/_dialog_header.dart';
import '../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../kanban_page/kanban_view.dart';
class CurrencyModDialog extends StatefulWidget {
  const CurrencyModDialog({super.key, required this.currencyType, required this.userId, required this.amount});
  final String currencyType;
  final int userId;
  final int amount;

  @override
  State<CurrencyModDialog> createState() => _CurrencyModDialogState();
}

class _CurrencyModDialogState extends State<CurrencyModDialog> {
  final _formKey = GlobalKey<FormState>();
  final CurrencyService currencyService = CurrencyService();
  late final currencyController = TextEditingController();
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    currencyController.text = widget.amount.toString(); // 초기값 설정
  }

  Future<void> modCurrency(BuildContext context) async{
    try{
      int? amount = int.tryParse(currencyController.text);
      CurrencyModParam currencyModParam = CurrencyModParam(amount!);
      bool isSuccess = false;

      switch(widget.currencyType){
        case 'Chip':
          isSuccess = await currencyService.modChip(widget.userId, currencyModParam);
          break;
        case 'Coin':
          isSuccess = await currencyService.modCoin(widget.userId, currencyModParam);
          break;
        case 'Diamond':
          isSuccess = await currencyService.modDiamond(widget.userId, currencyModParam);
          break;
        default:
          isSuccess = false;
          break;
      }
      if(isSuccess){
        Navigator.pop(context);
      }
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data, e.response?.statusCode);
      ErrorDialog.showError(context, errorCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isMobile = responsiveValue<bool>(
      context,
      xs: true,
      sm: true,
      md: false,
      lg: false,
      xl: false,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 610),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              // const DialogHeader(headerTitle: 'Create New Board'),
              DialogHeader(headerTitle: lang.userCurrency),
              // Form
              Flexible(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(_isMobile ? 10 : 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Board Name
                        TextFieldLabelWrapper(
                          //labelText: 'Board Name',
                          labelText: lang.userCurrency,
                          inputField: TextFormField(
                            controller: currencyController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //return 'Please enter board name';
                                return lang.pleaseEnterBoardName;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: _isMobile
                    ? const EdgeInsets.fromLTRB(10, 0, 10, 10)
                    : const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context),
                        //child: const Text('Cancel'),
                        child: Text(lang.cancel),
                      ),
                    ),
                    SizedBox(width: _isMobile ? 16 : 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          modCurrency(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        //child: const Text('Save'),
                        child: Text(lang.save),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}