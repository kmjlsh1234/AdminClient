import 'dart:html';

import 'package:acnoo_flutter_admin_panel/app/param/admin/admin_join_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/admin/admin.dart';
import '../../models/admin/login_view_model.dart';
import '../../retrofit/admin/admin_client.dart';
import '../../utils/factory/dio_factory.dart';

class AdminService {
  late AdminClient client = AdminClient(DioFactory.createDio());

  //로그인
  Future<Admin> login(LoginViewModel loginViewModel) async {
    HttpResponse<Admin> result = await client.login(loginViewModel);
    final jwtToken = result.response.headers['authorization']?.first;
    window.localStorage['jwt'] = jwtToken!;
    return result.data;
  }

  //회원가입
  Future<int?> join(AdminJoinParam adminJoinParam) async {
    HttpResponse res = await client.join(adminJoinParam);
    return res.response.statusCode;
  }

  //로그아웃
  Future<bool> logout() async {
    HttpResponse res = await client.logout();
    if(res.response.statusCode == 204){
      window.localStorage.remove('jwt');
      return true;
    }
    return false;
  }

  //자기 자신 조회
  Future<Admin> getAdmin() async {
    return await client.getAdmin();
  }
}
