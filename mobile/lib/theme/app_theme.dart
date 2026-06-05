import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Global theme configuration — light and dark.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.canvas,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.canvas,
          onSurface: AppColors.ink,
          error: AppColors.accentRed,
          onError: AppColors.onPrimary,
        ),
        textTheme: AppTextStyles.textTheme.apply(
          bodyColor: AppColors.body,
          displayColor: AppColors.ink,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.canvas,
          foregroundColor: AppColors.ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: AppTextStyles.bodyStrong.copyWith(color: AppColors.ink),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfacePearl,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.dividerSoft),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.dividerSoft),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.accentRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.accentRed, width: 1.5),
          ),
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.mute),
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.mute),
        ),
        cardTheme: CardThemeData(
          color: AppColors.canvas,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.hairline),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            textStyle: AppTextStyles.button,
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.hairline),
            textStyle: AppTextStyles.button,
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.canvas,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.mute,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerColor: AppColors.hairline,
        dividerTheme: const DividerThemeData(
          thickness: 1,
          space: 1,
          color: AppColors.hairline,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.darkPrimary,
        scaffoldBackgroundColor: AppColors.darkCanvas,
        colorScheme: ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkOnPrimary,
          surface: AppColors.darkCanvas,
          onSurface: AppColors.darkInk,
          error: AppColors.accentRed,
          onError: AppColors.darkCanvas,
        ),
        textTheme: AppTextStyles.textTheme.apply(
          bodyColor: AppColors.darkBody,
          displayColor: AppColors.darkInk,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkCanvas,
          foregroundColor: AppColors.darkInk,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: AppTextStyles.bodyStrong.copyWith(color: AppColors.darkInk),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.darkHairline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.darkHairline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.accentRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.accentRed, width: 1.5),
          ),
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.darkMute),
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.darkMuteSoft),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.darkHairline),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPrimary,
            foregroundColor: AppColors.darkOnPrimary,
            textStyle: AppTextStyles.button,
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkInk,
            side: const BorderSide(color: AppColors.darkHairline),
            textStyle: AppTextStyles.button,
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkCanvas,
          selectedItemColor: AppColors.darkPrimary,
          unselectedItemColor: AppColors.darkMute,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerColor: AppColors.darkHairline,
        dividerTheme: const DividerThemeData(
          thickness: 1,
          space: 1,
          color: AppColors.darkHairline,
        ),
      );
}
