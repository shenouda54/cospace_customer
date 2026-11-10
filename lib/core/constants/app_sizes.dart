import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Standard design dimensions based on Figma 393×852 canvas.
abstract final class AppSizes {
  // ── Design Base ──
  static const double designWidth = 393;
  static const double designHeight = 852;

  // ── Padding & Margin ──
  static double get p4 => 4.w;
  static double get p8 => 8.w;
  static double get p12 => 12.w;
  static double get p16 => 16.w;
  static double get p20 => 20.w;
  static double get p24 => 24.w;
  static double get p32 => 32.w;

  // ── Vertical Spacing ──
  static double get v4 => 4.h;
  static double get v8 => 8.h;
  static double get v12 => 12.h;
  static double get v16 => 16.h;
  static double get v20 => 20.h;
  static double get v24 => 24.h;
  static double get v32 => 32.h;
  static double get v48 => 48.h;

  // ── Border Radius ──
  static double get r8 => 8.r;
  static double get r12 => 12.r;
  static double get r16 => 16.r;
  static double get r24 => 24.r;
  static double get r50 => 50.r;

  // ── Icon Sizes ──
  static double get iconSmall => 16.w;
  static double get iconMedium => 24.w;
  static double get iconLarge => 32.w;

  // ── Button Heights ──
  static double get buttonHeight => 48.h;
  static double get buttonHeightSmall => 36.h;
}
