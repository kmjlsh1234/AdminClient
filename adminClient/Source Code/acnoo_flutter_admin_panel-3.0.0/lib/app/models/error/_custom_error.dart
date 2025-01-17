import 'package:http/http.dart';

class CustomError implements Exception{
  final int errorCode;
  final String message;
  final String timestamp;

  CustomError({
  required this.errorCode,
  required this.message,
  required this.timestamp,
  });

  //Json To object
  factory CustomError.fromJson(Map<String, dynamic> json){
    return CustomError(
        errorCode: json['errorCode'],
        message: json['message'],
        timestamp: json['timestamp']
    );
  }

}