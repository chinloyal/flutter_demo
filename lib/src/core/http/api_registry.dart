import 'package:flutter_demo/src/core/http/http_client.dart';
import 'package:flutter_demo/src/core/utils/env.dart';
import 'package:flutter_demo/src/core/utils/service_locator.dart';
import 'package:flutter_demo/src/domain/todos/apis/todo_api.dart';

class ApiRegistry {
  HttpClient httpClient = HttpClient();
  final baseUrl = env(EnvKey.FLUTTERDEMO_BASE_URL);

  ApiRegistry() {
    ServiceLocator.locate.registerLazySingleton<TodoApi>(() => TodoApi(
          httpClient.getDioClient(),
          baseUrl: baseUrl,
        ));
  }
}
