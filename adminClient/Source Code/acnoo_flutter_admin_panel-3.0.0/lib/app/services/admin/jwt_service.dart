

import 'package:acnoo_flutter_admin_panel/app/services/base_service.dart';
import 'package:retrofit/dio.dart';

import '../../retrofit/jwt_client.dart';

class JwtService extends BaseService{
  late JwtClient client = JwtClient(dio);

  // auth token 이 동작하는지 확인
  Future<bool> tokenCheck() async {
    HttpResponse res = await client.tokenCheck();
    if(res.response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}