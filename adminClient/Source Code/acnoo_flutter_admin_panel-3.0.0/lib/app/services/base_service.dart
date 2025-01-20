import 'package:dio/dio.dart';
import 'dart:html';

class BaseService{
  final Dio dio = Dio();

  List<String> excludeURL = [
    '/admin/login',
    '/admin/v1/join',
  ];

  BaseService(){
    dio.interceptors.add(getInterceptor(dio));
  }

  Interceptor getInterceptor(Dio dio){
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // JWT를 제외할 경로 정의
        final excludedPaths = excludeURL;

        // 현재 요청 경로
        final requestPath = options.path;

        // JWT를 제외할 경로가 아닌 경우 Authorization 헤더 추가
        if (!excludedPaths.contains(requestPath)) {
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
        print('Dio Error: ${e.message}');
        return handler.next(e); // 에러 계속 진행
      }
    );
  }
}