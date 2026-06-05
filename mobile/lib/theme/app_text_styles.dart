import 'package:flutter/material.dart';

/// Typography constants derived from DESIGN.md using the platform system font.
class AppTextStyles {
  AppTextStyles._();

  static const String _family = '.SF Pro Text';

  static TextStyle heroDisplay = const TextStyle(
    fontFamily: _family,
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 1.07,
    letterSpacing: -0.28,
  );

  static TextStyle displayLG = const TextStyle(
    fontFamily: _family,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  static TextStyle displayMD = const TextStyle(
    fontFamily: _family,
    fontSize: 34,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.374,
  );

  static TextStyle title = const TextStyle(
    fontFamily: _family,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.14,
  );

  static TextStyle tagline = const TextStyle(
    fontFamily: _family,
    fontSize: 21,
    fontWeight: FontWeight.w600,
    height: 1.19,
    letterSpacing: 0.231,
  );

  static TextStyle body = const TextStyle(
    fontFamily: _family,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.47,
    letterSpacing: -0.374,
  );

  static TextStyle bodyStrong = body.copyWith(fontWeight: FontWeight.w600);

  static TextStyle lead = const TextStyle(
    fontFamily: _family,
    fontSize: 24,
    fontWeight: FontWeight.w300,
    height: 1.5,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: -0.224,
  );

  static TextStyle captionStrong = caption.copyWith(fontWeight: FontWeight.w600);

  static TextStyle button = const TextStyle(
    fontFamily: _family,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  static TextStyle finePrint = const TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.12,
  );

  /// Complete TextTheme mapped to Flutter's Material roles.
  static TextTheme get textTheme => TextTheme(
        headlineLarge: heroDisplay,
        headlineMedium: displayLG,
        headlineSmall: displayLG,
        titleLarge: displayMD,
        titleMedium: title,
        titleSmall: tagline,
        labelLarge: captionStrong,
        bodyLarge: lead,
        bodyMedium: body,
        bodySmall: caption,
        labelSmall: caption,
      );
}
