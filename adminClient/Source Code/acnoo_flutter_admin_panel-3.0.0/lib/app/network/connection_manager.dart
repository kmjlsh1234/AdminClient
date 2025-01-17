import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:acnoo_flutter_admin_panel/app/models/error/_rest_exception.dart';
import 'package:diox/diox.dart';

import '../models/error/_error_code.dart';
import '../utils/constants/server_uri.dart';

class ConnectionManager{

  final dio = Dio();

  List<String> excludeUrl = [
    ServerUri.AUTH_LOGIN,
    ServerUri.ADMIN_JOIN,
  ];

  Future<Response> sendRequest(String uri, String method, Map<String, dynamic>? body) async {
    String fullUri = ServerUri.BASE_URI + uri;
    var requestHeaders = setHeaders(uri);

    log('HTTP Method : $method');
    log('FullUri : $fullUri');
    log('RequestHeaders : $requestHeaders');

    var response = await dio.request(
        fullUri,
        data: body,
        options: Options(method: method, headers: requestHeaders));
    return response;
  }

  Map<String, String> setHeaders(String uri) {
    Map<String,String> headers = {};
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = '*/*';
    //jwt 넣을지 검사
    if(!excludeUrl.contains(uri)){
      headers['Authorization'] = window.localStorage['jwt']!;
    }
    return headers;
  }
}