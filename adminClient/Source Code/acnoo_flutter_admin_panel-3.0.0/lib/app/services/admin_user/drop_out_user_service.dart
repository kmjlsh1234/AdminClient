import 'package:acnoo_flutter_admin_panel/app/models/admin_user/drop_out_user.dart';
import 'package:acnoo_flutter_admin_panel/app/param/admin_user/drop_out_user_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/utils/factory/dio_factory.dart';

import '../../models/common/count_vo.dart';
import '../../retrofit/admin_user/drop_out_user_client.dart';

class DropOutUserService {
  late DropOutUserClient client = DropOutUserClient(DioFactory.createDio());

  //유저 리스트 조회
  Future<List<DropOutUser>> getDropOutUserList(DropOutUserSearchParam dropOutUserSearchParam) async {
    return await client.getDropOutUserList(dropOutUserSearchParam);
  }

  //유저 리스트 갯수
  Future<int> getAdminUserListCount(DropOutUserSearchParam dropOutUserSearchParam) async {
    CountVo countVo = await client.getDropOutUserListCount(dropOutUserSearchParam);
    return countVo.count;
  }
}