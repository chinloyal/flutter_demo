import 'package:flutter/material.dart';
import 'package:flutter_demo/src/router/base_arguments.dart';
import 'package:flutter_demo/src/sample_feature/sample_item_details_view.dart';
import 'package:flutter_demo/src/sample_feature/sample_item_list_view.dart';
import 'package:flutter_demo/src/ui/views/todo_list_view.dart';

typedef AppRouteBuilder = Widget Function(BaseArguments?);

Map<String, AppRouteBuilder> routes = {
  SampleItemListView.routeName: (args) => const SampleItemListView(),
  SampleItemDetailsView.routeName: (args) =>
      SampleItemDetailsView(args as DetailsArg),
  TodoListView.routeName: (args) => TodoListView(),
};
