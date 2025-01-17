class ErrorCode{
  final int errorCode;
  final String message;
  final String timestamp;

  ErrorCode({
    required this.errorCode,
    required this.message,
    required this.timestamp,
  });

  //Json To object
  factory ErrorCode.fromJson(Map<String, dynamic> json){
    return ErrorCode(
        errorCode: json['errorCode'],
        message: json['message'],
        timestamp: json['timestamp']
    );
  }
}