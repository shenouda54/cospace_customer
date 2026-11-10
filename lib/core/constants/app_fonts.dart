import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized font sizes and text styles.
abstract final class AppFonts {
  static const String fontFamily = 'Roboto';

  static double get heading1 => 24.sp;
  static double get heading2 => 20.sp;
  static double get heading3 => 18.sp;
  static double get bodyLarge => 16.sp;
  static double get bodyMedium => 14.sp;
  static double get bodySmall => 12.sp;
  static double get caption => 10.sp;

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
