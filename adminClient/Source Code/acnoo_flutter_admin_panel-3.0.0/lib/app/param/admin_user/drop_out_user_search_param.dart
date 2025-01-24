import 'package:json_annotation/json_annotation.dart';
part 'drop_out_user_search_param.g.dart';

@JsonSerializable()
class DropOutUserSearchParam{
  // keyword search
  @JsonKey(includeIfNull: true)
  final String? searchType;
  @JsonKey(includeIfNull: true)
  final String? searchValue;
  // date search
  @JsonKey(includeIfNull: true)
  final String? startDate;
  @JsonKey(includeIfNull: true)
  final String? endDate;

  //pagingParam
  final int page;
  final int limit;

  DropOutUserSearchParam(
      this.searchType,
      this.searchValue,
      this.startDate,
      this.endDate,
      this.page,
      this.limit
  );

  factory DropOutUserSearchParam.fromJson(Map<String, dynamic> json) => _$DropOutUserSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$DropOutUserSearchParamToJson(this);
}