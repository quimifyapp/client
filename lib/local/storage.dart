import 'package:shared_preferences/shared_preferences.dart';

// TODO test on iOS

class Storage {
  static final Storage _singleton = Storage._internal();

  factory Storage() => _singleton;

  Storage._internal();

  late final SharedPreferences sharedPreferences;

  initialize() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  String? get(String key) => sharedPreferences.getString(key);

  save(String key, String value) => sharedPreferences.setString(key, value);
}
