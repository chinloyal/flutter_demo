import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_demo/src/core/utils/service_locator.dart';
import 'package:flutter_demo/src/domain/todos/store/todo_store.dart';
import 'package:flutter_demo/src/router/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_demo/src/settings/settings_view.dart';
import 'package:flutter_demo/src/ui/widgets/status_swatch.dart';

/// Displays a list of SampleItems.
class TodoListView extends StatelessWidget {
  static const routeName = '/';
  final todoStore = ServiceLocator.locate<TodoStore>();

  TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    todoStore.loadTodos();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.todosTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              AppRouter.push(SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Observer(
        builder: (context) => StatusSwatch(
          status: todoStore.status,
          pendingBuilder: (_) {
            return const CircularProgressIndicator.adaptive();
          },
          doneBuilder: (_) => ListView.builder(
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'TodoListView',
            itemCount: todoStore.todos.length,
            itemBuilder: (BuildContext context, int index) {
              final item = todoStore.todos[index];

              return ListTile(
                  title: Text(item.title),
                  leading: const CircleAvatar(
                    // Display the Flutter Logo image asset.
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ));
            },
          ),
          errorBuilder: (_) => const Text('An error has occurred'),
        ),
      ),
    );
  }
}
