# FlutterDemo Mobile

## Prequisites
1. Install [Flutter](https://flutter.dev/docs/get-started/install) SDK version 2.5.3.
2. Install VSCode and Android studio with their flutter and dart plugins.

## Initial Setup
After cloning the project for the first time, go ahead and run the `setup.sh` script to setup the project.

If for some reason you are unable to run the scripts, then go ahead and run these commands manually:

```sh
cp config/.env.example config/.env;
cp config/.env.example config/prod.env;
flutter pub get;
flutter packages pub run build_runner build --delete-conflicting-outputs;
flutter gen-l10n
git config core.hooksPath .hooks
```

### Run the project
You can run the project using the launch configurations set in VSCode, Android Studio or XCode (Using the IDE is recommended). If you choose to command line then run:
```sh
# Running this first command will run prod by default
flutter run
# For prod flavor
flutter run --dart-define ENV=prod --flavor prod
# For staging flavor
flutter run --dart-define ENV=staging --flavor staging
```

## Design Patterns

The main design pattern of choice is Domain Driven Design (DDD) where features are grouped under a single domain. This provides our project with these properties:

1. Maintainability: No cross-referencing between segments.
2. Scalability: You can add new functionality more easily.
3. Testability: Easier to mock dependencies.

The next pattern is MVVM (Model-View-ViewModel). This is the most common design pattern used in mobile and frontend applications. This will be the subpattern for any new/existing feature.

- Model: This will be used to represent data in app. For example a `User` model represents a user of the app
- View: This will be the pages/screens that are shown in the app. In short the UI.
- ViewModel: This is a class that is designed the manage and hold the state of the app. It holds and manipulates data that it shown on the "View"


## Project Structure

    .
    ├── config # environment settings here
    ├── assets # icons, images and fonts
    ├── lib
    └── src                 
        │   ├── core # code that can be applied across other projects
        │   ├── domain
        │   │   └── feature   
        │   │       ├── models      
        │   │       ├── stores   
        │   │       └── apis # classes that pulls data remotely or locally
        │   │  
        │   ├── router # definition of navigation routes in the app
        │   └── ui
        │       ├── views
        │       └── widgets # custom widgets
        └── test # unit test, widget test

## Adding new features

Most features will consist of these main components:
- A view/page/screen, this should be added under lib/src/ui/views
- Views may also be made up of custom widgets, widgets should go in lib/src/ui/widgets
- To make a view routable so it can be accessed by the navigator, register the route in lib/src/router/routes.dart. Be sure to stick to the convention of adding a `routeName` static variable to your view and reference that variable in the routes file, for example:
    ```dart
    {
        ViewName.routeName: (args) => ViewName(),
    }
    ```
- Now to add business logic, open lib/src/domain/ and add a folder, give it the name of the overall feature you are working on. For example "shipment". This folder will consist of 3 subfolders: apis, models, store.
- The models folder should contain data classes needed for the feature, here's an example of what a model should look like:
    ```dart
    import 'package:json_annotation/json_annotation.dart';

    part 'todo.g.dart';

    @JsonSerializable()
    class Todo {
    int userId;
    int id;
    String title;
    bool completed;

    Todo({
        required this.userId,
        required this.id,
        required this.title,
        this.completed = false,
    });

    factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

    Map<String, dynamic> toJson() => _$TodoToJson(this);
    }
    ```
    All models should be serializable, we do this by adding the `@JsonSerializable()` annotation and implementing a `fromJson` method and `toJson` method. Your model will be linked to generated code as can be seen from the `part` directive. Add the `part` directive with the name of the file you want the code to be generated in, then run `flutter packages pub run build_runner build --delete-conflicting-outputs` to get the generated code and remove any errors. Follow the naming conventions by naming your part file, the same as your model file, but with a '.g.dart' extension.

- The apis folder should contain classes that are used to make REST api requests. Here is an example of what an api class should look like:
    ``` dart
    import 'package:flutter_demo/src/domain/todos/models/todo.dart';
    import 'package:retrofit/http.dart';
    import 'package:dio/dio.dart' hide Headers;

    part 'todo_api.g.dart';

    @RestApi()
    abstract class TodoApi {
    factory TodoApi(Dio dio, {String baseUrl}) = _TodoApi;

    @GET('/todos')
    Future<List<Todo>> getTodos();
    }
    ```
    Also stick to the naming convention, the name of the file should end with '_api', the name of the class should end with 'Api'. This file is linked to generated code as can be seen by the `part` directive. To generate the code for your new api class run `flutter packages pub run build_runner build --delete-conflicting-outputs`.

    **NOTE:** The `getTodos` method here is able to resolve the api request to a list of `Todo` instances because the `Todo` class is json serializable
- Once you've created your api class, you need to register it in the `ApiRegistry` class, this can be found at lib/src/core/http/api_registry.dart. Add a new line to the body of the `ApiRegistry`, the registration should look like this:
    ```dart
        ServiceLocator.locate.registerLazySingleton<TodoApi>(() => TodoApi(
            httpClient.getDioClient(),
            baseUrl: baseUrl,
        ));
    ```
    Your api can now be accessed from anywhere in the app, using the `ServiceLocator`.
    ```dart
    final todoApi = ServiceLocator.locate<TodoApi>();
    ```

- The next component is a store, this is where the state of your feature will be stored and managed. Flutter has quite a few state management approaches (BLoC, redux, provider, mobx). This app will be taking the mobx approach. The file name of your store should end with '_store.dart'. The contents of the file should look like this:

    ```dart
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
    Status status = Status.pending; // The status variable should be used to track the state of Api requests.
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

    ```
    **NOTE:** There are two classes in this file, a public concrete `TodoStore` that extends a abstract private `_TodoStore` and uses a mixin, which is generated, called `_$TodoStore` (this is in the part file "todo_store.g.dart"). The second class is the private abstract `_TodoStore` that uses a mixin called `Store`, which is from the mobx package, this is where the methods and state management will be implemented.

    In the `_TodoStore` note that class properties are used as state and are marked with an `@observable` annotation, this allows the UI to show the changes to the state in real time. Methods need to be marked with `@action` annotation if they will be used to manipulate state.

    Let's walk through the `loadTodos()` method:
    1. Firstly the `status` property is set to `Status.pending`, this lets the UI know some process is going to take some time to complete.
    2. An api request is made to get a list of todos. **NOTE** that instead of using an await async syntax, we use the `.then` approach. This is to prevent us from pausing changes happening in the UI.
    3. Once we've gotten a response from the server, the app should update the list of todos, then set that status property to `Status.done`.
    4. If an error had occured instead we set the `errorMessage` property and change the status to `Status.error`.

    After creating the store, register it in the `StoreRegistry` class. This can be found at lib/src/core/store/store_registry.dart. Add new line to the body of the constructor and add your store,it would look like this for example:
    ```dart
    ServiceLocator.locate.registerSingleton<TodoStore>(TodoStore());
    ```

### How to use data from the store
To use the store in your view or widget, inject it using the `ServiceLocator`:
```dart
final todoStore = ServiceLocator.locate<TodoStore>();
```
Now call the method you use to initialize your store data, in this case `loadTodos()`, in your `build()` method **if** your view/widget is **stateless**. If you are using a **stateful** view/widget, then call the method in `initState()`. Here's an example of what your build method would look like in a stateless widget:
```dart
Widget build(BuildContext context) {
    todoStore.loadTodos(); // Initialize the store data
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.todosTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              AppRouter.push(SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Observer( // Use the Observer widget to listen to changes in the store
        builder: (context) => StatusSwatch( // Use the StatusSwatch widget to change what is displayed based on the status
          status: todoStore.status, // pass the store status here
          // When the status is pending, display a loading indicator
          pendingBuilder: (_) {
            return const CircularProgressIndicator.adaptive();
          },
          // When the status is done, display the list of todos
          doneBuilder: (_) => ListView.builder(
            restorationId: 'TodoListView',
            itemCount: todoStore.todos.length,
            itemBuilder: (BuildContext context, int index) {
              final item = todoStore.todos[index];

              return ListTile(
                  title: Text(item.title),
                  leading: const CircleAvatar(
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ));
            },
          ),
          // If an error occured, display an error message
          errorBuilder: (_) => const Text(todoStore.errorMessage),
        ),
      ),
    );
  }
```
The comments in the above code explain how the store reads data

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
