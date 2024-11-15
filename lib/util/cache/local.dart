import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  SharedPreferences? _prefs;


  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //  Singleton pattern for the service

  static final LocalCache _instance = LocalCache._internal();

  factory LocalCache(){
    return _instance;
  }

  LocalCache._internal();

  // Save a value of any type T in shared preferences
  Future<void> saveValue<T>(String key, T value) async {
    if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else {
      throw ArgumentError("Unsupported value type");
    }
  }

  // Get a value of any type T from shared preferences
  T? getValue<T>(String key) {
    if (T == String) {
      return _prefs?.getString(key) as T?;
    } else if (T == int) {
      return _prefs?.getInt(key) as T?;
    } else if (T == double) {
      return _prefs?.getDouble(key) as T?;
    } else if (T == bool) {
      return _prefs?.getBool(key) as T?;
    } else {
      throw ArgumentError("Unsupported value type");
    }
  }

  // Clear a specific key from shared preferences
  Future<void> clearKey(String key) async {
    await _prefs?.remove(key);
  }

  // Clear all data from shared preferences
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}