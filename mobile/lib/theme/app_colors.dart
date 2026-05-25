import 'package:flutter/material.dart';

/// Design system color constants derived from DESIGN.md.
class AppColors {
  AppColors._();

  // ─── Light Mode ──────────────────────────────────────

  static const Color primary = Color(0xFF080808);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color hairline = Color(0xFFD8D8D8);

  static const Color ink = Color(0xFF080808);
  static const Color inkStrong = Color(0xFF222222);
  static const Color body = Color(0xFF363636);
  static const Color bodyMid = Color(0xFF5A5A5A);
  static const Color mute = Color(0xFF898989);
  static const Color muteSoft = Color(0xFFABABAB);

  // Accent colors
  static const Color accentPurple = Color(0xFF7A3DFF);
  static const Color accentPink = Color(0xFFED52CB);
  static const Color accentBlue = Color(0xFF3B89FF);
  static const Color accentBlueDeep = Color(0xFF006ACC);
  static const Color accentBlueInfo = Color(0xFF146EF5);
  static const Color accentOrange = Color(0xFFFF6B00);
  static const Color accentGreen = Color(0xFF00D722);
  static const Color accentYellow = Color(0xFFFFAE13);
  static const Color accentRed = Color(0xFFEE1D36);

  // ─── Dark Mode (polarity-flipped) ────────────────────

  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkOnPrimary = Color(0xFF080808);
  static const Color darkCanvas = Color(0xFF080808);
  static const Color darkHairline = Color(0xFF333333);

  static const Color darkInk = Color(0xFFFFFFFF);
  static const Color darkInkStrong = Color(0xFFEEEEEE);
  static const Color darkBody = Color(0xFFCCCCCC);
  static const Color darkBodyMid = Color(0xFF999999);
  static const Color darkMute = Color(0xFF777777);
  static const Color darkMuteSoft = Color(0xFF555555);
}
