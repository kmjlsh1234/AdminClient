

import 'package:retrofit/dio.dart';

import '../../retrofit/admin/jwt_client.dart';
import '../../utils/factory/dio_factory.dart';



class JwtService {
  late JwtClient client = JwtClient(DioFactory.createDio());

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