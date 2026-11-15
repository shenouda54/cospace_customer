/// Keys used for local storage (SharedPreferences & SecureStorage).
abstract final class AppLocalKeys {
  // ── SharedPreferences (non-sensitive) ──
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';

  // ── SecureStorage (sensitive) ──
  static const String userToken = 'user_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userFullName = 'user_full_name';
  static const String userPhone = 'user_phone';
}
