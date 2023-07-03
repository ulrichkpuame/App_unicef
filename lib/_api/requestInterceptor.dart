import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';

class RequestInterceptor extends Interceptor {
  final Dio dio = Dio();
  String? accessToken;
  static const String TOKEN_KEY = "TOKEN";
  final tokenStorageService = locator<TokenStorageService>();
  RequestInterceptor();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('-----------------interceptor-----------------');
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    accessToken = await tokenStorageService.retrieveAccessToken();
    print('-----------------access token retrieved-----------------');
    print(accessToken);
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if ((err.response?.statusCode ==
            401 /*&&
        err.response?.data['message'] == "Invalid JWT"*/
        )) {
      if (await tokenStorageService.isTokenExist()) {
        if (await refreshToken()) {
          return handler.resolve(await _retry(err.requestOptions));
        }
      }
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    print('-----------------Testing refresh token-----------------');
    final refreshToken = await tokenStorageService.retrieveRefreshToken();
    String url = 'https://www.digitale-it.com/unicef/api/auth/signin';
    var response = await http.post(Uri.parse(url), headers: {
      "Content-Type": "application/json"
    }, body: {
      "refresh_token": refreshToken,
      "grant_type": "refresh_token",
    });
    // final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
    if (response.statusCode == 200) {
      tokenStorageService.deleteToken(TOKEN_KEY);
      tokenStorageService.saveToken(response.body);
      accessToken = await tokenStorageService.retrieveAccessToken();
      //accessToken = response.data;
      log('-----------------token refreshed-----------------');
      return true;
    } else {
      print('-----------------refresh token is wrong-----------------');
      // refresh token is wrong
      accessToken = null;
      tokenStorageService.deleteAllToken();
      return false;
    }
  }
}
