import 'package:flutter/material.dart';
import 'package:cospace_customer/l10n/app_localizations.dart';

/// Convenient extensions on [BuildContext].
extension ContextExtensions on BuildContext {
  /// Shortcut to access the current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Shortcut to access the current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Shortcut to access localized strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Show a [SnackBar] with the given [message].
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
