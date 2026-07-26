import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF83B692);
  static const Color onPrimary = Color(0xFF16281F);
  static const Color primaryContainer = Color(0xFFC6E3D1);
  static const Color onPrimaryContainer = Color(0xFF1B3A2B);

  static const Color secondary = Color(0xFFF9627D);
  static const Color onSecondary = Color(0xFF3A0E16);
  static const Color secondaryContainer = Color(0xFFFFD9DF);
  static const Color onSecondaryContainer = Color(0xFF5C1A24);

  static const Color tertiary = Color(0xFFF9ADA0);
  static const Color onTertiary = Color(0xFF4A2620);
  static const Color tertiaryContainer = Color(0xFFFFE4DF);
  static const Color onTertiaryContainer = Color(0xFF5C2A22);

  static const Color error = Color(0xFFD32F2F);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFFFBF9);
  static const Color onBackground = Color(0xFF201A19);
  static const Color surface = Color(0xFFFFFBF9);
  static const Color onSurface = Color(0xFF201A19);
  static const Color surfaceVariant = Color(0xFFF5DDD9);
  static const Color onSurfaceVariant = Color(0xFF534341);
  static const Color outline = Color(0xFF857370);
}

final ColorScheme appColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryContainer,
  onPrimaryContainer: AppColors.onPrimaryContainer,
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  secondaryContainer: AppColors.secondaryContainer,
  onSecondaryContainer: AppColors.onSecondaryContainer,
  tertiary: AppColors.tertiary,
  onTertiary: AppColors.onTertiary,
  tertiaryContainer: AppColors.tertiaryContainer,
  onTertiaryContainer: AppColors.onTertiaryContainer,
  error: AppColors.error,
  onError: AppColors.onError,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  surfaceContainerHighest: AppColors.surfaceVariant,
  onSurfaceVariant: AppColors.onSurfaceVariant,
  outline: AppColors.outline,
);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: appColorScheme,
  scaffoldBackgroundColor: AppColors.background,
);