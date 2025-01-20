import 'package:acnoo_flutter_admin_panel/app/models/common/_count_vo.dart';
import 'package:acnoo_flutter_admin_panel/app/param/admin/_admin_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/param/admin/_admin_search_param.dart';
import 'package:acnoo_flutter_admin_panel/app/services/base_service.dart';
import 'package:dio/dio.dart';

import '../../models/admin/admin.dart';
import '../../param/admin/_admin_add_param.dart';
import '../../retrofit/admin_manage_client.dart';

class AdminManageService extends BaseService {
  late AdminManageClient client = AdminManageClient(dio);

  //관리자 리스트 조회
  Future<List<Admin>> getAdminList(AdminSearchParam adminSearchParam) async {
    return await client.getAdminList(adminSearchParam);
  }

  //관리자 리스트 갯수
  Future<int> getAdminListCount(AdminSearchParam adminSearchParam) async {
    CountVo countVo = await client.getAdminListCount(adminSearchParam);
    return countVo.count;
  }

  //관리자 추가
  Future<Admin> addAdmin(AdminAddParam adminAddParam) async {
    return await client.addAdmin(adminAddParam);
  }

  //관리자 정보 수정
  Future<Admin> modAdmin(int adminId,AdminModParam adminModParam) async{
    return await client.modAdmin(adminId, adminModParam);
  }
}