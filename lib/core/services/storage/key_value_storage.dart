import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contract for key-value storage operations (non-sensitive preferences & cache).
abstract class KeyValueStorage {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);

  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);

  Future<List<String>?> getStringList(String key);
  Future<void> setStringList(String key, List<String> value);

  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

/// Global provider for KeyValueStorage, overridden in main.dart / bootstrap.
final keyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  throw UnimplementedError(
      'keyValueStorageProvider must be initialized in main()');
});
