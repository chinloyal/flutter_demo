import 'package:flutter_demo/src/core/utils/service_locator.dart';
import 'package:flutter_demo/src/domain/todos/store/todo_store.dart';

class StoreRegistry {
  StoreRegistry() {
    ServiceLocator.locate.registerSingleton<TodoStore>(TodoStore());
  }
}
