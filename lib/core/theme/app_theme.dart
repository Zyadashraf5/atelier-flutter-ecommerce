import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';

abstract final class AppTheme {
  static TextStyle get brandSerif => GoogleFonts.playfairDisplay(
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
    fontSize: 28,
  );

  static TextStyle brandSerifSize(double size) => GoogleFonts.playfairDisplay(
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
    fontSize: size,
  );

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: Colors.black87,
  );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelCaps => GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w600,
    fontSize: 11,
    letterSpacing: 1.2,
    color: AppColors.textLabel,
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.navy,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.navy,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.navy,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        fontSize: 22,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
  );
}
