import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_demo/src/core/http/app_interceptor.dart';
import 'package:flutter_demo/src/core/utils/env.dart';
import 'package:flutter_demo/src/core/utils/local_storage.dart';
import 'package:flutter_demo/src/core/utils/service_locator.dart';

class HttpClient {
  static final Dio _dio = Dio();
  final LocalStorage localStorage = ServiceLocator.locate<LocalStorage>();
  static const int refreshAttempts = 0;
  static const int maxRetry = 4;

  HttpClient() {
    _initClient();
  }

  void _initClient() {
    _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: env(EnvKey.FLUTTERDEMO_BASE_URL)))
            .interceptor);

    _dio.interceptors.add(AppInterceptor());
  }

  Dio getDioClient() {
    return _dio;
  }
}
