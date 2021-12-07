import 'package:flutter/material.dart';
import 'package:flutter_demo/src/core/http/status.dart';

class StatusSwatch extends StatelessWidget {
  final Status status;
  final Widget Function(BuildContext context) pendingBuilder;
  final Widget Function(BuildContext context) doneBuilder;
  final Widget Function(BuildContext context) errorBuilder;

  const StatusSwatch({
    Key? key,
    required this.status,
    required this.pendingBuilder,
    required this.doneBuilder,
    required this.errorBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.pending:
        return pendingBuilder(context);
      case Status.error:
        return errorBuilder(context);
      case Status.done:
        return doneBuilder(context);
    }
  }
}
