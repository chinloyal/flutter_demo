import 'dart:developer';

import 'package:dio/dio.dart';
import '/src/core/utils/local_storage.dart';
import '/src/core/utils/service_locator.dart';

class AppInterceptor extends Interceptor {
  final _localStorage = ServiceLocator.locate<LocalStorage>();

  Map<String, dynamic>? get defaultHeaders {
    final accessToken = _localStorage.retrieve(LSKey.accessToken);

    return {
      if (accessToken.isNotEmpty) 'x-access-token': accessToken,
      'Cache-control': 'no-cache no-store must-revalidate',
      'Content-Type': 'application/json',
      'Expires': '0',
      'Pragma': 'no-cache',
    };
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //use to prevent cache from calling api when there is no cache
    const dioCacheKey = 'dio_cache_force_refresh';
    if (options.extra.containsKey(dioCacheKey) && !options.extra[dioCacheKey]) {
      throw ('didn\'t find cache request');
    }

    options.headers = defaultHeaders;

    log('${options.method} ${options.baseUrl}${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null &&
        err.response?.statusCode != null &&
        err.response?.statusCode == 401) {
      // Fix error
    }
    super.onError(err, handler);
  }
}
