import 'package:flutter_demo/src/core/http/status.dart';
import 'package:flutter_demo/src/core/utils/service_locator.dart';
import 'package:flutter_demo/src/domain/todos/apis/todo_api.dart';
import 'package:flutter_demo/src/domain/todos/models/todo.dart';
import 'package:mobx/mobx.dart';

part 'todo_store.g.dart';

class TodoStore extends _TodoStore with _$TodoStore {}

abstract class _TodoStore with Store {
  TodoApi api = ServiceLocator.locate<TodoApi>();

  @observable
  Status status = Status.pending;
  @observable
  String errorMessage = '';
  @observable
  ObservableList<Todo> todos = ObservableList();

  @action
  void loadTodos() {
    status = Status.pending;

    api.getTodos().then((value) {
      todos.addAll(value);
      status = Status.done;
    }).catchError((error) {
      errorMessage = error.message;
      status = Status.error;
    });
  }
}
