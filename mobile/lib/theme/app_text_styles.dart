import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography styles derived from the DESIGN.md token definitions.
///
/// Uses Inter as the open-source substitute for the proprietary WF Visual Sans Variable.
class AppTextStyles {
  AppTextStyles._();

  // ─── Display Styles ────────────────────────────────────

  static TextStyle displayXXL = GoogleFonts.inter(
    fontSize: 80,
    fontWeight: FontWeight.w600,
    height: 83.2 / 80,
    letterSpacing: -0.8,
  );

  static TextStyle displayXL = GoogleFonts.inter(
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 58.24 / 56,
  );

  static TextStyle displayLG = GoogleFonts.inter(
    fontSize: 44.8,
    fontWeight: FontWeight.w600,
    height: 46.6 / 44.8,
  );

  static TextStyle displayMD = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 41.6 / 32,
  );

  static TextStyle displaySM = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 31.2 / 24,
  );

  static TextStyle displayXS = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 28 / 20,
  );

  // ─── Eyebrow Styles ────────────────────────────────────

  static TextStyle eyebrowUppercase = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 19.5 / 15,
    letterSpacing: 1.5,
  );

  static TextStyle eyebrowUppercaseSM = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 12 / 12,
    letterSpacing: 0.6,
  );

  // ─── Body Styles ───────────────────────────────────────

  static TextStyle bodyLG = GoogleFonts.inter(
    fontSize: 28.8,
    fontWeight: FontWeight.w400,
    height: 46.08 / 28.8,
    letterSpacing: -0.288,
  );

  static TextStyle bodyMD = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 25.6 / 16,
    letterSpacing: -0.16,
  );

  static TextStyle bodyMDStrong = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 25.6 / 16,
    letterSpacing: -0.16,
  );

  static TextStyle bodySM = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22.4 / 14,
  );

  static TextStyle bodySMStrong = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 22.4 / 14,
  );

  // ─── Caption / Mono ────────────────────────────────────

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12.8,
    fontWeight: FontWeight.w500,
    height: 15.36 / 12.8,
  );

  static TextStyle captionMono = GoogleFonts.inconsolata(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
  );

  // ─── Button Styles ─────────────────────────────────────

  static TextStyle buttonMD = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 25.6 / 16,
    letterSpacing: -0.16,
  );

  // ─── TextTheme ─────────────────────────────────────────

  /// A base TextTheme using our design token typography.
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayXXL,
        displayMedium: displayXL,
        displaySmall: displayLG,
        headlineMedium: displayMD,
        headlineSmall: displaySM,
        titleLarge: displayXS,
        bodyLarge: bodyLG,
        bodyMedium: bodyMD,
        bodySmall: bodySM,
        labelLarge: bodyMDStrong,
        labelMedium: bodySMStrong,
        labelSmall: caption,
      );
}
