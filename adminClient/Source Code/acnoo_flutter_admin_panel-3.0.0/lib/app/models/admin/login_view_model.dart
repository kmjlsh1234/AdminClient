class LoginViewModel{
  final String email;
  final String password;

  LoginViewModel({
    required this.email,
    required this.password
  });

  //Json To object
  factory LoginViewModel.fromJson(Map<String, dynamic> json){
    return LoginViewModel(
      email: json['email'],
      password: json['password']);
  }

  //object To Json
  Map<String, dynamic> toJson() =>{
    'email': email,
    'password': password,
  };
}