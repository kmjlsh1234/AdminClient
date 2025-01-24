import 'package:acnoo_flutter_admin_panel/app/models/admin_user/admin_user_detail.dart';
import 'package:acnoo_flutter_admin_panel/app/models/admin_user/admin_user_profile.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../models/common/count_vo.dart';
import '../../param/admin_user/admin_user_search_param.dart';
import '../../utils/constants/server_uri.dart';

part 'admin_user_manage_client.g.dart';

@RestApi(baseUrl: ServerUri.BASE_URL)
abstract class AdminUserManageClient {
  factory AdminUserManageClient(Dio dio, {String baseUrl}) = _AdminUserManageClient;

  @POST("/admin/v1/users/list")
  Future<List<AdminUserProfile>> getAdminUserList(@Body() AdminUserSearchParam adminUserSearchParam);

  @POST("/admin/v1/users/list/count")
  Future<CountVo> getAdminUserListCount(@Body() AdminUserSearchParam adminUserSearchParam);
  
  @GET("/admin/v1/users/{userId}")
  Future<AdminUserDetail> getAdminUser(@Path('userId') int userId);
}