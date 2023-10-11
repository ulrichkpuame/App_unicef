// ignore_for_file: file_names, constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:unicefapp/_api/endpoints.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';

class DioClient {
  // dio instance
  final Dio _dio;
  Dio dioLogin = Dio();

  String? accessToken;
  // String? tenantID;
  static const String TOKEN_KEY = "TOKEN";
  final tokenStorageService = locator<TokenStorageService>();
  // injecting dio instance
  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout as Duration?
      ..options.receiveTimeout = Endpoints.receiveTimeout as Duration?
      ..options.responseType = ResponseType.json
      ..interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        accessToken = await tokenStorageService.retrieveAccessToken();
        // tenantID = await tokenStorageService.retrieveTenant();
        //print(tenantID);
        options.headers['Authorization'] = 'Bearer $accessToken';
        //options.headers['X-TenantID'] = '$tenantID';
        return handler.next(options);
      }, onError: (DioError err, handler) async {
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
      }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    final refreshToken = await tokenStorageService.retrieveRefreshToken();
    // final tenantID = await tokenStorageService.retrieveTenant();
    String url = 'https://www.digitale-it.com/unicef/api/auth/signin';
    try {
      final Response response = await dioLogin.post(url,
          data: {
            "refresh_token": refreshToken,
            "grant_type": "refresh_token",
          },
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              responseType: ResponseType.json));
      tokenStorageService.deleteToken(TOKEN_KEY);
      tokenStorageService.saveToken(json.encode(response.data));
      accessToken = await tokenStorageService.retrieveAccessToken();
      return true;
    } on DioError {
      // refresh token is wrong
      // accessToken = null;
      // tokenStorageService.deleteAllToken();
      return false;
    }
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
