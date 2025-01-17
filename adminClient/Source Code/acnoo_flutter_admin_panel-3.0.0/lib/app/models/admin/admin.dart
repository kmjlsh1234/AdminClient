import 'package:flutter/cupertino.dart';

class Admin{
  final int adminId;
  final int? roleId;
  final String status;
  final String email;
  final String name;
  final String mobile;
  final String? loginAt;
  final String createdAt;
  final String updatedAt;
  bool isSelected = false;

  factory Admin.fromJson(Map<String, dynamic> json){
    return Admin(
        adminId: json['adminId'],
        roleId: json['roleId'] as int?,
        status: json['status'],
        email: json['email'],
        name: json['name'],
        mobile: json['mobile'],
        loginAt: json['loginAt'] as String?,
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']
    );
  }

  Admin({
    required this.adminId,
    this.roleId,
    required this.status,
    required this.email,
    required this.name,
    required this.mobile,
    this.loginAt,
    required this.createdAt,
    required this.updatedAt
});
}