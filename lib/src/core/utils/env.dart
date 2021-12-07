/// Following effective dart style guide:
/// https://dart.dev/guides/language/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members
/// Avoid defining a class that contains ONLY static members.
/// Dart has top-level functions, variables, and constants, so you don’t need
/// a class just to define something, unlike in Java or C#.

// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvKey {
  APP_NAME,
  FLUTTERDEMO_BASE_URL,
}

String env(EnvKey key) {
  return _getValue(key);
}

Future loadEnv({String type = ''}) async {
  log('Loading $type.env');
  return await dotenv.load(fileName: 'config/$type.env');
}

String _getValue(EnvKey key) => dotenv.env[key.toString().split('.')[1]] ?? '';
