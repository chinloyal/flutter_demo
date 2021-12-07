import 'package:flutter/material.dart';
import 'package:flutter_demo/src/router/base_arguments.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  final DetailsArg? args;
  const SampleItemDetailsView(this.args, {Key? key}) : super(key: key);

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: Text(args?.title ?? ''),
      ),
    );
  }
}

class DetailsArg extends BaseArguments {
  final String title;

  DetailsArg(this.title);
}
