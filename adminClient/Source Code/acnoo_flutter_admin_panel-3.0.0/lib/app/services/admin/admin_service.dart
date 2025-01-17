import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'package:acnoo_flutter_admin_panel/app/network/connection_manager.dart';
import 'package:acnoo_flutter_admin_panel/app/param/admin/admin_join_param.dart';
import 'package:acnoo_flutter_admin_panel/app/utils/constants/server_uri.dart';
import 'package:dartz/dartz.dart';
import 'package:diox/diox.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/admin/admin.dart';
import '../../models/admin/login_view_model.dart';
import '../../models/error/_error_code.dart';
import '../../models/error/_rest_exception.dart';
import '../../utils/constants/http_method.dart';

class AdminService{
  final ConnectionManager connectionManager = ConnectionManager();

  //로그인
  Future<Either<ErrorCode, Admin>> login(LoginViewModel loginViewModel) async {
    try{
      Map<String, dynamic> body = loginViewModel.toJson();
      Response response = await connectionManager.sendRequest(ServerUri.AUTH_LOGIN, HTTP.POST.name, body);
      if(response.statusCode == 200) {
        final jwtToken = response.headers['authorization']?.first;
        window.localStorage['jwt'] = jwtToken!;
        return Right(Admin.fromJson(response.data));
      } else{
        throw RestException(errorCode: 400, message: "Login Failed", timestamp: DateTime.now().toString());
      }
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch(e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }

  //회원가입
  Future<Either<ErrorCode, bool>> join(AdminJoinParam adminJoinParam) async {
    try{
      Map<String, dynamic> body =  adminJoinParam.toJson();
      Response response = await connectionManager.sendRequest(ServerUri.ADMIN_JOIN, HTTP.POST.name, body);
      if(response.statusCode == 200) {
        return Right(true);
      } else{
        throw RestException(errorCode: 400, message: "Join Failed", timestamp: DateTime.now().toString());
      }
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch(e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }

  //로그아웃
  Future<Either<ErrorCode, bool>> logout() async {
    try{
      Response response = await connectionManager.sendRequest(ServerUri.ADMIN_LOGOUT, HTTP.DELETE.name, null);
      if(response.statusCode == 204){
        window.localStorage.remove('jwt');
        return Right(true);
      } else{
        throw RestException(errorCode: 400, message: "Logout Failed", timestamp: DateTime.now().toString());
      }
    } on DioError catch (e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch(e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }

  //자기 자신 조회
  Future<Either<ErrorCode, Admin>> getAdmin() async {
    try{
      Response response = await connectionManager.sendRequest(ServerUri.ADMIN_INFO, HTTP.GET.name, null);
      if(response.statusCode == 200){
        return Right(Admin.fromJson(response.data));
      } else{
        throw RestException(errorCode: 400, message: "GetAdmin Failed", timestamp: DateTime.now().toString());
      }
    } on DioError catch(e){
      ErrorCode errorCode = ErrorCode.fromJson(e.response?.data);
      return Left(errorCode);
    } on RestException catch (e){
      ErrorCode errorCode = ErrorCode(errorCode: e.errorCode, message: e.message, timestamp: e.timestamp);
      return Left(errorCode);
    }
  }
}
