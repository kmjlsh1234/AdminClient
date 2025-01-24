import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/error/error_code.dart';

class ErrorDialog {

  static void showError(BuildContext context, ErrorCode errorCode) {
    log('errorCode : ${errorCode.errorCode}');
    log('message : ${errorCode.message.toString()}');
    log('statusCode : ${errorCode.statusCode.toString()}');

    if(errorCode.statusCode == 401){
      return GoRouter.of(context!).go('/authentication/signin');
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(errorCode.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}