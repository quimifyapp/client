import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static final Cache _singleton = Cache._internal();

  factory Cache() => _singleton;

  Cache._internal();

  late final SharedPreferences sharedPreferences;

  // Private:

  // Public:

  initialize() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  String? get(String key) => sharedPreferences.getString(key);

  save(String key, String value) => sharedPreferences.setString(key, value);
}
