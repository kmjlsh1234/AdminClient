import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/error/_error_code.dart';

class ErrorDialog {
  static void showError(BuildContext context, ErrorCode errorCode) {
    if(errorCode.errorCode == 140001 || errorCode.errorCode == 140002 || errorCode.errorCode == 140003){
      GoRouter.of(context).go('/authentication/signin');
      return;
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