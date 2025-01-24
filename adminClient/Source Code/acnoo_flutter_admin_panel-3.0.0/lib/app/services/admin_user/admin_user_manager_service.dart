import 'package:acnoo_flutter_admin_panel/app/models/admin_user/admin_user_detail.dart';

import '../../models/admin_user/admin_user_profile.dart';
import '../../models/common/count_vo.dart';
import '../../param/admin_user/admin_user_search_param.dart';
import '../../retrofit/admin_user/admin_user_manage_client.dart';
import '../../utils/factory/dio_factory.dart';

class AdminUserManageService {
  late AdminUserManageClient client = AdminUserManageClient(DioFactory.createDio());

  //유저 리스트 조회
  Future<List<AdminUserProfile>> getAdminUserList(AdminUserSearchParam adminUserSearchParam) async {
    return await client.getAdminUserList(adminUserSearchParam);
  }

  //유저 리스트 갯수
  Future<int> getAdminUserListCount(AdminUserSearchParam adminUserSearchParam) async {
    CountVo countVo = await client.getAdminUserListCount(adminUserSearchParam);
    return countVo.count;
  }

  //유저 단일 조회(detail)
  Future<AdminUserDetail> getAdminUser(int userId) async{
    return await client.getAdminUser(userId);
  }
}