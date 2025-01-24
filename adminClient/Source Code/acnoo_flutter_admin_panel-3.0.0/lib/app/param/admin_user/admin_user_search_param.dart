import 'package:json_annotation/json_annotation.dart';
part 'admin_user_search_param.g.dart';
@JsonSerializable()
class AdminUserSearchParam{
  // keyword search
  @JsonKey(includeIfNull: true)
  final String? searchType;
  @JsonKey(includeIfNull: true)
  final String? searchValue;

  // date search
  @JsonKey(includeIfNull: true)
  final String? searchDateType;
  @JsonKey(includeIfNull: true)
  final String? startDate;
  @JsonKey(includeIfNull: true)
  final String? endDate;

  //pagingParam
  final int page;
  final int limit;

  AdminUserSearchParam(
      this.searchType,
      this.searchValue,
      this.searchDateType,
      this.startDate,
      this.endDate,
      this.page,
      this.limit
  );
  factory AdminUserSearchParam.fromJson(Map<String, dynamic> json) => _$AdminUserSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserSearchParamToJson(this);
}