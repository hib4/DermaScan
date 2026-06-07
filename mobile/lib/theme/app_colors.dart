import 'package:flutter/material.dart';

/// Design system color constants derived from DESIGN.md.
class AppColors {
  AppColors._();

  // Light mode

  static const Color primary = Color(0xFF0066CC);
  static const Color primaryFocus = Color(0xFF0071E3);
  static const Color primaryOnDark = Color(0xFF2997FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color canvasParchment = Color(0xFFF5F5F7);
  static const Color surfacePearl = Color(0xFFFAFAFC);
  static const Color surfaceBlack = Color(0xFF000000);
  static const Color surfaceTile1 = Color(0xFF272729);
  static const Color surfaceTile2 = Color(0xFF2A2A2C);
  static const Color hairline = Color(0xFFE0E0E0);
  static const Color hairlineSoft = Color(0x14000000); // rgba(0, 0, 0, 0.08)
  static const Color dividerSoft = Color(0xFFF0F0F0);

  static const Color ink = Color(0xFF1D1D1F);
  static const Color inkStrong = Color(0xFF1D1D1F);
  static const Color body = Color(0xFF1D1D1F);
  static const Color bodyMid = Color(0xFF333333);
  static const Color mute = Color(0xFF7A7A7A);
  static const Color muteSoft = Color(0xFFCCCCCC);

  // Semantic colors are restrained and used only for status text/chips.
  static const Color accentOrange = Color(0xFFB85C00);
  static const Color accentGreen = Color(0xFF267A3E);
  static const Color accentRed = Color(0xFFB42318);

  // Dark mode

  static const Color darkPrimary = primaryOnDark;
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkCanvas = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1D1D1F);
  static const Color darkHairline = Color(0xFF333333);

  static const Color darkInk = Color(0xFFFFFFFF);
  static const Color darkInkStrong = Color(0xFFEEEEEE);
  static const Color darkBody = Color(0xFFFFFFFF);
  static const Color darkBodyMid = Color(0xFFCCCCCC);
  static const Color darkMute = Color(0xFF999999);
  static const Color darkMuteSoft = Color(0xFF777777);
}
