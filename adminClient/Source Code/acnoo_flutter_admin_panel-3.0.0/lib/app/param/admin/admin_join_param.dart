class AdminJoinParam{
  final String email;
  final String password;
  final String name;
  final String mobile;

  AdminJoinParam({
    required this.email,
    required this.password,
    required this.name,
    required this.mobile
  });

  //object To Json
  Map<String, dynamic> toJson() =>{
    'email': email,
    'password': password,
    'name': name,
    'mobile': mobile
  };
}