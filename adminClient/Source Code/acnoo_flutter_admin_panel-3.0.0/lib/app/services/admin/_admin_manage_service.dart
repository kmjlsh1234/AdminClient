import 'dart:convert';
import 'dart:developer';
import 'package:acnoo_flutter_admin_panel/app/models/common/_count_vo.dart';
import 'package:acnoo_flutter_admin_panel/app/network/connection_manager.dart';
import 'package:acnoo_flutter_admin_panel/app/models/error/_rest_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/param/admin/_admin_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/param/admin/_admin_search_param.dart';
import 'package:dartz/dartz.dart';
import 'package:diox/diox.dart';

import '../../models/admin/admin.dart';
import '../../models/error/_error_code.dart';

import '../../param/admin/_admin_add_param.dart';
import '../../utils/constants/http_method.dart';
import '../../utils/constants/server_uri.dart';

class AdminManageService {
  final ConnectionManager connectionManager = ConnectionManager();

  //관리자 리스트 조회
  Future<Either<ErrorCode, List<Admin>>> getAdminList(AdminSearchParam adminSearchParam) async {
    try{
      Map<String, dynamic> body = adminSearchParam.toJson();
      Response response = await connectionManager.sendRequest(ServerUri.ADMIN_LIST, HTTP.POST.name, body);
      if(response.statusCode == 200){
        final List<Admin> adminList = (response?.data as List)
            .map((json) => Admin.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(adminList);
      } else{
        throw RestException(errorCode: 400, message: "GetAdminList Failed", timestamp: DateTime.now().toString());
      }
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch(e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }

  //관리자 리스트 갯수
  Future<Either<ErrorCode, int>> getAdminListCount(AdminSearchParam adminSearchParam) async {
    try{
      Map<String, dynamic> body = adminSearchParam.toJson();
      Response response = await connectionManager.sendRequest(ServerUri.ADMIN_LIST_COUNT, HTTP.POST.name, body);
      if(response.statusCode == 200){
        CountVo countVo = CountVo.fromJson(response.data);
        return Right(countVo.count);
      } else{
        throw RestException(errorCode: 400, message: "GetAdminListCount Failed", timestamp: DateTime.now().toString());
      }
    }on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch(e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }

  //관리자 추가
  Future<Either<ErrorCode, Admin>> addAdmin(AdminAddParam adminAddParam) async {
    try{
      Map<String, dynamic> body = adminAddParam.toJson();
      Response response = await connectionManager.sendRequest(ServerUri.ADMIN_ADD, HTTP.POST.name, body);
      if(response.statusCode == 200){
        return Right(Admin.fromJson(response.data));
      } else{
        throw RestException(errorCode: 400, message: "AddAdmin Failed", timestamp: DateTime.now().toString());
      }
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch(e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }

  //관리자 정보 수정
  Future<Either<ErrorCode, Admin>> modAdmin(int adminId,AdminModParam adminModParam) async{
    try{
      Map<String, dynamic> body = adminModParam.toJson();
      String uri = ServerUri.ADMIN_MOD.replaceFirst('{adminId}', adminId.toString());
      Response response = await connectionManager.sendRequest(uri, HTTP.PUT.name, body);
      if(response.statusCode == 200){
        return Right(Admin.fromJson(response.data));
      } else{
        throw RestException(errorCode: 400, message: "ModAdmin Failed", timestamp: DateTime.now().toString());
      }
    }on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch(e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }
}