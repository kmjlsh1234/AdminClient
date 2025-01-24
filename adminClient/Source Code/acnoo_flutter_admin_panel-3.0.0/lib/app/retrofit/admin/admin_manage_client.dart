

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/admin/admin.dart';
import '../../models/common/count_vo.dart';
import '../../param/admin/admin_add_param.dart';
import '../../param/admin/admin_mod_param.dart';
import '../../param/admin/admin_search_param.dart';
import '../../utils/constants/server_uri.dart';
part 'admin_manage_client.g.dart';

@RestApi(baseUrl: ServerUri.BASE_URL)
abstract class AdminManageClient {
  factory AdminManageClient(Dio dio, {String baseUrl}) = _AdminManageClient;

  @POST("/admin/v1/admins/list")
  Future<List<Admin>> getAdminList(@Body() AdminSearchParam adminSearchParam);

  @POST("/admin/v1/admins/list/count")
  Future<CountVo> getAdminListCount(@Body() AdminSearchParam adminSearchParam);

  @POST("/admin/v1/admins")
  Future<Admin> addAdmin(@Body() AdminAddParam adminAddParam);

  @PUT("/admin/v1/admins/{adminId}")
  Future<Admin> modAdmin(@Path() int adminId, @Body() AdminModParam adminModParam);
}