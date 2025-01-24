import 'package:json_annotation/json_annotation.dart';
part 'drop_out_user.g.dart';

@JsonSerializable()
class DropOutUser{
  final int id;
  final int userId;
  final String mobile;
  final String email;
  final String dropAt;

  DropOutUser(
      this.id,
      this.userId,
      this.mobile,
      this.email,
      this.dropAt
  );

  factory DropOutUser.fromJson(Map<String, dynamic> json) => _$DropOutUserFromJson(json);
  Map<String, dynamic> toJson() => _$DropOutUserToJson(this);
}