
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../models/admin/admin.dart';
import '../utils/constants/server_uri.dart';
part 'jwt_client.g.dart';

@RestApi(baseUrl: ServerUri.BASE_URL)
abstract class JwtClient{
  factory JwtClient(Dio dio, {String baseUrl}) = _JwtClient;

  //auth token 이 동작하는지 확인
  @POST('/admin/token/check')
  Future<HttpResponse> tokenCheck();

}