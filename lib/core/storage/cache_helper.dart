import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for non-sensitive local data
/// such as theme mode and language preference.
class CacheHelper {
  CacheHelper._();
  static late final SharedPreferences _prefs;

  /// Must be called in main() before runApp.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── String ──
  static Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  static String? getString(String key) => _prefs.getString(key);

  // ── Bool ──
  static Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  static bool? getBool(String key) => _prefs.getBool(key);

  // ── Int ──
  static Future<bool> setInt(String key, int value) =>
      _prefs.setInt(key, value);

  static int? getInt(String key) => _prefs.getInt(key);

  // ── Remove / Clear ──
  static Future<bool> remove(String key) => _prefs.remove(key);
  static Future<bool> clear() => _prefs.clear();
}
