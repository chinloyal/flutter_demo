// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<LocalStorage> create() async {
    LocalStorage._prefs = await SharedPreferences.getInstance();
    return LocalStorage();
  }

  /// Use this retrieve method to retrieve data from storage,
  /// be sure to add your key to LSKey enum
  String retrieve(LSKey key) {
    return LocalStorage._prefs.getString(key.toString()) ?? '';
  }

  /// Use this new method to save data to storage,
  /// be sure to add your key to LSKey enum
  Future<void> save(LSKey key, String data) async {
    await LocalStorage._prefs.setString(key.toString(), data);
  }

  bool? retrieveBool(LSKey key) {
    return LocalStorage._prefs.getBool(key.toString());
  }

  Future<void> saveBool(LSKey key, bool data) async {
    await LocalStorage._prefs.setBool(key.toString(), data);
  }

  int retrieveInt(LSKey key) {
    return LocalStorage._prefs.getInt(key.toString()) ?? 0;
  }

  Future<void> saveInt(LSKey key, int data) async {
    await LocalStorage._prefs.setInt(key.toString(), data);
  }

  double retrieveDouble(LSKey key) {
    return LocalStorage._prefs.getDouble(key.toString()) ?? 0.0;
  }

  Future<void> saveDouble(LSKey key, double data) async {
    await LocalStorage._prefs.setDouble(key.toString(), data);
  }

  void remove(LSKey key) {
    LocalStorage._prefs.remove(key.toString());
  }

  void clearAll({List<dynamic>? exclude}) {
    if (exclude == null) {
      LocalStorage._prefs.clear();
      return;
    }

    var tempValues = <dynamic>[];

    //extract key value in excluded List
    for (final value in exclude) {
      tempValues.add(LocalStorage._prefs.getString(value.toString()));
    }
    //clear all
    LocalStorage._prefs.clear();

    //add back excludes items
    for (var x = 0; x < tempValues.length; x++) {
      LocalStorage._prefs.setString(exclude[x].toString(), tempValues[x]);
    }
  }

  bool containsKey(LSKey key) {
    return LocalStorage._prefs.containsKey(key.toString());
  }
}

/// Define all keys used in local storage under this enum, this prevents passing
/// around strings as keys which can easily cause errors that are difficult to
/// debug if strings are mistyped. (LocalStorageKey)
enum LSKey {
  accessToken,
  refreshToken,
  isFirstLaunch,
}
