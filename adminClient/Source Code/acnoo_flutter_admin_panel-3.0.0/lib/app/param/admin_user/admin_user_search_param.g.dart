// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserSearchParam _$AdminUserSearchParamFromJson(
        Map<String, dynamic> json) =>
    AdminUserSearchParam(
      json['searchType'] as String?,
      json['searchValue'] as String?,
      json['searchDateType'] as String?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$AdminUserSearchParamToJson(
        AdminUserSearchParam instance) =>
    <String, dynamic>{
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'searchDateType': instance.searchDateType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'page': instance.page,
      'limit': instance.limit,
    };
