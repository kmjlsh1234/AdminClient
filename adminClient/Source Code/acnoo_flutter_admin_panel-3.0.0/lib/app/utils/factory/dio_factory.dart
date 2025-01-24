import 'dart:developer';
import 'dart:html';
import 'dart:js_interop';
import 'package:acnoo_flutter_admin_panel/app/utils/dialog/error_dialog.dart';
import 'package:dio/dio.dart';

import '../../models/error/error_code.dart';

class DioFactory {

  static List<String> excludeURL = [
    '/admin/login',
    '/admin/v1/join',
  ];

  static Dio createDio(){
    final Dio dio = Dio();
    dio.interceptors.add(
        InterceptorsWrapper(
            onRequest: (options, handler) {
              // 현재 요청 경로
              final requestPath = options.path;

              // JWT를 제외할 경로가 아닌 경우 Authorization 헤더 추가
              if (!excludeURL.contains(requestPath)) {
                final jwtToken = window.localStorage['jwt'];
                if (jwtToken != null) {
                  options.headers['Authorization'] = jwtToken;
                }
              }
              // 공통 헤더 설정
              options.headers['Content-Type'] = 'application/json';
              return handler.next(options); // 요청 계속 진행
            },
            onError: (DioError e, handler) {
              // 에러 핸들링 로직 추가
              log('Dio Error: ${e.message}');
              return handler.next(e); // 에러 계속 진행
            }
        )
    );
    return dio;
  }
}