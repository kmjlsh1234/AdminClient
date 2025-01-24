import 'package:json_annotation/json_annotation.dart';
part 'admin_user_profile.g.dart';
@JsonSerializable()
class AdminUserProfile{
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
  final int? basicImageIdx;

  AdminUserProfile(
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
      this.basicImageIdx
  );

  factory AdminUserProfile.fromJson(Map<String, dynamic> json) => _$AdminUserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserProfileToJson(this);
}