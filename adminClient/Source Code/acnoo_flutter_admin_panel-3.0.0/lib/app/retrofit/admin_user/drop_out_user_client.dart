import 'package:acnoo_flutter_admin_panel/app/models/admin_user/drop_out_user.dart';
import 'package:acnoo_flutter_admin_panel/app/param/admin_user/drop_out_user_search_param.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/common/count_vo.dart';
import '../../utils/constants/server_uri.dart';

part 'drop_out_user_client.g.dart';

@RestApi(baseUrl: ServerUri.BASE_URL)
abstract class DropOutUserClient{
  factory DropOutUserClient(Dio dio, {String baseUrl}) = _DropOutUserClient;

  @POST("/admin/v1/users/leave/list")
  Future<List<DropOutUser>> getDropOutUserList(@Body() DropOutUserSearchParam dropOutUserSearchParam);

  @POST("/admin/v1/users/leave/list/count")
  Future<CountVo> getDropOutUserListCount(@Body() DropOutUserSearchParam dropOutUserSearchParam);
}