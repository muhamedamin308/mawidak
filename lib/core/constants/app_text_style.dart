import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mawidak/core/constants/app_colors.dart';

class AppTextStyle {
  const AppTextStyle._();

  static TextStyle get h1 => GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static TextStyle get h2 => GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle get body => GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static TextStyle get caption => GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get link => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );
}
