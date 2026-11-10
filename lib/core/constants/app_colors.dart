import 'package:flutter/material.dart';

/// Centralized color palette for Light & Dark themes.
/// All colors used across the app MUST be referenced from here.
abstract final class AppColors {
  // ── Light Mode ──
  static const Color lightPrimary = Color(0xFF1A73E8);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Color(0xFF202124);
  static const Color lightOutline = Color(0xFFDADCE0);
  static const Color lightSurfaceContainerHighest = Color(0xFFE8EAED);
  static const Color lightError = Color(0xFFD93025);

  // ── Dark Mode ──
  static const Color darkPrimary = Color(0xFF8AB4F8);
  static const Color darkOnPrimary = Color(0xFF1A1A2E);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkOnSurface = Color(0xFFE8EAED);
  static const Color darkOutline = Color(0xFF5F6368);
  static const Color darkSurfaceContainerHighest = Color(0xFF303134);
  static const Color darkError = Color(0xFFF28B82);
}
