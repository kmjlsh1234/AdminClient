import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../models/admin/admin.dart';
import '../models/admin/login_view_model.dart';
import '../param/admin/admin_join_param.dart';
import '../utils/constants/server_uri.dart';

part 'admin_client.g.dart';

@RestApi(baseUrl: ServerUri.BASE_URL)
abstract class AdminClient{
  factory AdminClient(Dio dio, {String baseUrl}) = _AdminClient;

  //로그인
  @POST('/admin/login')
  Future<HttpResponse<Admin>> login(@Body() LoginViewModel loginViewModel);

  //회원가입
  @POST('/admin/v1/join')
  Future<HttpResponse> join(@Body() AdminJoinParam adminJoinParam);

  //로그아웃
  @DELETE('/admin/logout')
  Future<HttpResponse> logout();

  @GET('/admin/v1/admins/self')
  Future<Admin> getAdmin();
}