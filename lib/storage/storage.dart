import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Storage _singleton = Storage._internal();

  factory Storage() => _singleton;

  Storage._internal();

  late final SharedPreferences sharedPreferences;

  // Public:

  initialize() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  String? get(String key) => sharedPreferences.getString(key);

  save(String key, String value) => sharedPreferences.setString(key, value);

  saveBool(String key, bool value) => sharedPreferences.setBool(key, value);

  getBool(String key) => sharedPreferences.getBool(key);
}
