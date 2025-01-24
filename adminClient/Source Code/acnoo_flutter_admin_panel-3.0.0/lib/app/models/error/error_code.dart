class ErrorCode{
  final int errorCode;
  final String message;
  final String timestamp;
  final int statusCode;
  ErrorCode({
    required this.errorCode,
    required this.message,
    required this.timestamp,
    required this.statusCode
  });

  //Json To object
  factory ErrorCode.fromJson(Map<String, dynamic> json, int? statusCode){
    return ErrorCode(
        errorCode: json['errorCode'],
        message: json['message'],
        timestamp: json['timestamp'],
        statusCode: statusCode ?? 500,
    );
  }
}