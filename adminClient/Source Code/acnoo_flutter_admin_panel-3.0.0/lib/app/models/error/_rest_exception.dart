import 'package:acnoo_flutter_admin_panel/app/models/error/_error_code.dart';

class RestException implements Exception{
  final int errorCode;
  final String message;
  final String timestamp;

  RestException({
    required this.errorCode,
    required this.message,
    required this.timestamp
  });
}