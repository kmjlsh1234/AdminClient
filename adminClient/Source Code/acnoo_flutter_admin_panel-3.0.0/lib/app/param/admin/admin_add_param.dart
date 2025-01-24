class AdminAddParam{
  final int roleId;
  final String email;
  final String password;
  final String name;
  final String mobile;

  AdminAddParam({
    required this.roleId,
    required this.email,
    required this.password,
    required this.name,
    required this.mobile
  });

  //object To Json
  Map<String, dynamic> toJson() =>{
    'roleId': roleId,
    'email': email,
    'password': password,
    'name': name,
    'mobile': mobile
  };
}