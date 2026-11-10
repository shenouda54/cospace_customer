import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/storage/cache_helper.dart';
import 'package:cospace_customer/core/storage/local_keys.dart';

/// Manages the app locale (AR / EN) and persists the choice.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_loadInitialLocale());

  static Locale _loadInitialLocale() {
    final stored = CacheHelper.getString(AppLocalKeys.languageCode);
    return Locale(stored ?? 'en');
  }

  /// Switch to Arabic.
  void switchToArabic() {
    CacheHelper.setString(AppLocalKeys.languageCode, 'ar');
    emit(const Locale('ar'));
  }

  /// Switch to English.
  void switchToEnglish() {
    CacheHelper.setString(AppLocalKeys.languageCode, 'en');
    emit(const Locale('en'));
  }

  /// Toggle between AR and EN.
  void toggleLocale() {
    if (state.languageCode == 'ar') {
      switchToEnglish();
    } else {
      switchToArabic();
    }
  }

  /// Whether the current locale is Arabic.
  bool get isArabic => state.languageCode == 'ar';
}
