import 'package:flutter/material.dart';
import 'package:mawidak/core/constants/app_colors.dart';
import 'package:mawidak/core/constants/app_text_style.dart';

class AppTheme {
  AppTheme._();

  static final theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyle.h1,
      headlineMedium: AppTextStyle.h2,
      bodyMedium: AppTextStyle.body,
      bodySmall: AppTextStyle.caption,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      foregroundColor: AppColors.textPrimary,
    ),
  );
}
