import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage] for sensitive session data
/// such as user tokens and IDs.
class SecureStorageHelper {
  SecureStorageHelper._();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Write a value securely.
  static Future<void> write({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a secure value.
  static Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Delete a specific key.
  static Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Clear all secure storage.
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
