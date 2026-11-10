import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/storage/cache_helper.dart';
import 'package:cospace_customer/core/storage/local_keys.dart';

/// Manages the app's theme mode (Light / Dark) and persists the choice.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_loadInitialTheme());

  static ThemeMode _loadInitialTheme() {
    final stored = CacheHelper.getString(AppLocalKeys.themeMode);
    return stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  /// Toggle between light and dark mode.
  void toggleTheme() {
    final newMode =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    CacheHelper.setString(
      AppLocalKeys.themeMode,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
    emit(newMode);
  }

  /// Whether the current theme is dark.
  bool get isDark => state == ThemeMode.dark;
}
