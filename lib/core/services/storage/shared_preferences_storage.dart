import 'package:shared_preferences/shared_preferences.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';

/// SharedPreferences implementation of [KeyValueStorage].
class SharedPreferencesStorage implements KeyValueStorage {
  const SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async =>
      _prefs.setString(key, value);

  @override
  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async =>
      _prefs.setBool(key, value);

  @override
  Future<int?> getInt(String key) async => _prefs.getInt(key);

  @override
  Future<void> setInt(String key, int value) async => _prefs.setInt(key, value);

  @override
  Future<List<String>?> getStringList(String key) async =>
      _prefs.getStringList(key);

  @override
  Future<void> setStringList(String key, List<String> value) async =>
      _prefs.setStringList(key, value);

  @override
  Future<void> remove(String key) async => _prefs.remove(key);

  @override
  Future<void> clear() async => _prefs.clear();

  @override
  Future<bool> containsKey(String key) async => _prefs.containsKey(key);
}
