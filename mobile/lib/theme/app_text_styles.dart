import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography constants derived from DESIGN.md using Inter font.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle Function() get _inter => GoogleFonts.inter;

  // Display styles
  static TextStyle displayXXL = _inter().copyWith(
    fontSize: 80,
    fontWeight: FontWeight.w600,
    height: 83.2 / 80,
    letterSpacing: -0.8,
  );

  static TextStyle displayXL = _inter().copyWith(
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 58.24 / 56,
  );

  static TextStyle displayLG = _inter().copyWith(
    fontSize: 44.8,
    fontWeight: FontWeight.w600,
    height: 46.6 / 44.8,
  );

  static TextStyle displayMD = _inter().copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 41.6 / 32,
  );

  static TextStyle displaySM = _inter().copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 31.2 / 24,
  );

  static TextStyle displayXS = _inter().copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 28 / 20,
  );

  // Eyebrow styles
  static TextStyle eyebrow = _inter().copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 19.5 / 15,
    letterSpacing: 1.5,
  );

  static TextStyle eyebrowSM = _inter().copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 12 / 12,
    letterSpacing: 0.6,
  );

  // Body styles
  static TextStyle bodyLG = _inter().copyWith(
    fontSize: 28.8,
    fontWeight: FontWeight.w400,
    height: 46.08 / 28.8,
    letterSpacing: -0.288,
  );

  static TextStyle bodyMD = _inter().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 25.6 / 16,
    letterSpacing: -0.16,
  );

  static TextStyle bodyMDStrong = _inter().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 25.6 / 16,
    letterSpacing: -0.16,
  );

  static TextStyle bodySM = _inter().copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22.4 / 14,
  );

  static TextStyle bodySMStrong = _inter().copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 22.4 / 14,
  );

  // Caption and button
  static TextStyle caption = _inter().copyWith(
    fontSize: 12.8,
    fontWeight: FontWeight.w500,
    height: 15.36 / 12.8,
  );

  static TextStyle buttonMD = _inter().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 25.6 / 16,
    letterSpacing: -0.16,
  );

  /// Complete TextTheme mapped to Flutter's Material roles.
  static TextTheme get textTheme => TextTheme(
        headlineLarge: displayXXL,
        headlineMedium: displayXL,
        headlineSmall: displayLG,
        titleLarge: displayMD,
        titleMedium: displaySM,
        titleSmall: displayXS,
        labelLarge: eyebrow,
        bodyLarge: bodyLG,
        bodyMedium: bodyMD,
        bodySmall: bodySM,
        labelSmall: caption,
      );
}
