import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_colors.dart';

/// Defines Light & Dark [ThemeData] for the entire app.
abstract final class AppTheme {
  // ── Light Theme ──
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          onPrimary: AppColors.lightOnPrimary,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightOnSurface,
          outline: AppColors.lightOutline,
          surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
          error: AppColors.lightError,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightSurface,
          foregroundColor: AppColors.lightOnSurface,
          elevation: 0,
          centerTitle: true,
        ),
      );

  // ── Dark Theme ──
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkOnPrimary,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          outline: AppColors.darkOutline,
          surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
          error: AppColors.darkError,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkOnSurface,
          elevation: 0,
          centerTitle: true,
        ),
      );
}
