import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color bg = Color(0xFF161826);
  static const Color bgDeep = Color(0xFF0D0E17);
  static const Color surface = Color(0xFF232532);
  static const Color surfaceSunken = Color(0xFF1C1E2B);
  static const Color surfaceHover = Color(0xFF242636);
  static const Color line = Color(0xFF2F313E);
  static const Color lineSoft = Color(0xFF262836);
  static const Color lineStrong = Color(0xFF3F424D);
  static const Color text = Color(0xFFE9E9ED);
  static const Color textSoft = Color(0xFFCFD3E5);
  static const Color muted = Color(0xFF9397AB);
  static const Color dim = Color(0xFF75798C);
  static const Color faint = Color(0xFF595D6C);
  static const Color accent = Color(0xFF9184D9);
  static const Color accent300 = Color(0xFFD2CEFD);
  static const Color accent400 = Color(0xFFB5ABFC);
  static const Color accent700 = Color(0xFF5D5294);
  static const Color accent800 = Color(0xFF423A6A);
  static const Color accent900 = Color(0xFF2B2741);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.accent,
        secondary: AppColors.accent400,
        error: AppColors.muted,
        onPrimary: AppColors.text,
        onSurface: AppColors.text,
        onError: AppColors.text,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        surfaceTintColor: AppColors.bg,
        foregroundColor: AppColors.text,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.accent300,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.accent, width: 1),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.muted,
          textStyle: GoogleFonts.inter(fontSize: 12.5, letterSpacing: 1.4),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSoft),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surfaceSunken,
        surfaceTintColor: AppColors.surfaceSunken,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.accent800, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.muted,
          fontSize: 13.5,
          height: 1.45,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: const TextStyle(color: AppColors.muted),
        hintStyle: const TextStyle(color: AppColors.dim),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lineStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
      dividerColor: AppColors.line,
      splashFactory: InkRipple.splashFactory,
      splashColor: AppColors.accent.withOpacity(0.10),
      highlightColor: AppColors.accent.withOpacity(0.08),
    );
  }
}
