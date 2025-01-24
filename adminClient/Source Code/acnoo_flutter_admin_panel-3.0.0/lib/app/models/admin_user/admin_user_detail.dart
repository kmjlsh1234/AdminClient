import 'package:json_annotation/json_annotation.dart';
part 'admin_user_detail.g.dart';
@JsonSerializable()
class AdminUserDetail{
  //user
  final int userId;
  final String status;
  final String mobile;
  final String email;
  final String userType;
  @JsonKey(defaultValue: "")
  final String loginAt;
  @JsonKey(defaultValue: "")
  final String logoutAt;
  final String createdAt;
  final String updatedAt;
  //profile
  final String nickname;
  final String image;
  final int basicImageIdx;
  //Agreement
  final bool agreeTerm;
  final bool agreePrivacy;
  final bool agreeSensitive;
  final bool agreeMarketing;
  final String marketingModifiedAt;

  AdminUserDetail(
      this.userId,
      this.status,
      this.mobile,
      this.email,
      this.userType,
      this.loginAt,
      this.logoutAt,
      this.createdAt,
      this.updatedAt,
      this.nickname,
      this.image,
      this.basicImageIdx,
      this.agreeTerm,
      this.agreePrivacy,
      this.agreeSensitive,
      this.agreeMarketing,
      this.marketingModifiedAt
  );
  factory AdminUserDetail.fromJson(Map<String, dynamic> json) => _$AdminUserDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserDetailToJson(this);
}