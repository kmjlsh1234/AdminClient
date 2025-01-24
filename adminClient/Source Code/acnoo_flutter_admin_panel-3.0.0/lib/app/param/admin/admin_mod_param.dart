class AdminModParam{
  final int roleId;
  final String email;
  final String? password;
  final String name;
  final String mobile;

  AdminModParam({
    required this.roleId,
    required this.email,
    this.password,
    required this.name,
    required this.mobile
  });

  Map<String, dynamic> toJson() =>{
    'roleId': roleId,
    'email': email,
    'password': password,
    'name': name,
    'mobile': mobile
  };
}