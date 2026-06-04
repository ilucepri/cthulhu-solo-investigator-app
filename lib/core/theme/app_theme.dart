import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF0B0F0E);
  static const Color inkDeep = Color(0xFF050807);
  static const Color surface = Color(0xFF1A1611);
  static const Color surfaceRaised = Color(0xFF2B2620);
  static const Color parchment = Color(0xFFE8DCC3);
  static const Color parchmentDim = Color(0xFFA99B7B);
  static const Color border = Color(0xFFA1834A);
  static const Color primary = Color(0xFF3C5B41);
  static const Color primaryDim = Color(0xFF2A3F2E);
  static const Color blood = Color(0xFF6B1F1A);
  static const Color mythos = Color(0xFFBFA46F);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.crimsonTextTextTheme(base.textTheme).apply(
      bodyColor: AppColors.parchment,
      displayColor: AppColors.parchment,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.ink,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.primary,
        secondary: AppColors.mythos,
        error: AppColors.blood,
        onPrimary: AppColors.parchment,
        onSurface: AppColors.parchment,
        onError: AppColors.parchment,
      ),
      textTheme: textTheme.copyWith(
        titleLarge: GoogleFonts.cinzel(
          textStyle: textTheme.titleLarge,
          color: AppColors.parchment,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        titleMedium: GoogleFonts.cinzel(
          textStyle: textTheme.titleMedium,
          color: AppColors.parchment,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        labelLarge: GoogleFonts.cinzel(
          textStyle: textTheme.labelLarge,
          color: AppColors.parchment,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.inkDeep,
        surfaceTintColor: AppColors.inkDeep,
        foregroundColor: AppColors.parchment,
        elevation: 0,
        titleTextStyle: GoogleFonts.cinzel(
          color: AppColors.parchment,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.parchment,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
          textStyle: GoogleFonts.cinzel(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.parchmentDim),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.parchment,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        titleTextStyle: GoogleFonts.cinzel(
          color: AppColors.parchment,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        contentTextStyle: GoogleFonts.crimsonText(
          color: AppColors.parchment,
          fontSize: 16,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceRaised,
        labelStyle: const TextStyle(color: AppColors.parchmentDim),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.mythos, width: 1.5),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.mythos,
        unselectedLabelColor: AppColors.parchmentDim,
        indicatorColor: AppColors.mythos,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.cinzel(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        unselectedLabelStyle: GoogleFonts.cinzel(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.0,
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      dividerColor: AppColors.border,
    );
  }
}
