// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserProfile _$AdminUserProfileFromJson(Map<String, dynamic> json) =>
    AdminUserProfile(
      (json['userId'] as num).toInt(),
      json['status'] as String,
      json['mobile'] as String,
      json['email'] as String,
      json['userType'] as String,
      json['loginAt'] as String? ?? '',
      json['logoutAt'] as String? ?? '',
      json['createdAt'] as String,
      json['updatedAt'] as String,
      json['nickname'] as String,
      json['image'] as String,
      (json['basicImageIdx'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AdminUserProfileToJson(AdminUserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'status': instance.status,
      'mobile': instance.mobile,
      'email': instance.email,
      'userType': instance.userType,
      'loginAt': instance.loginAt,
      'logoutAt': instance.logoutAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'nickname': instance.nickname,
      'image': instance.image,
      'basicImageIdx': instance.basicImageIdx,
    };
