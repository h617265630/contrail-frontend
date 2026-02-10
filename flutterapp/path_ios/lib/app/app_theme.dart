import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const border = Color(0xFFE5E7EB);
    const background = Color(0xFFF8FAFC);
    const card = Colors.white;
    const foreground = Color(0xFF0F172A);
    const muted = Color(0xFF64748B);

    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F172A),
      brightness: Brightness.light,
      surface: card,
    ).copyWith(
      primary: foreground,
      onPrimary: Colors.white,
      secondary: foreground,
      onSecondary: Colors.white,
      surface: card,
      onSurface: foreground,
      background: background,
      onBackground: foreground,
      outline: border,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.1),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.1),
        bodySmall: TextStyle(fontSize: 12, height: 1.35),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.25),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: border, width: 1),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: muted,
        textColor: foreground,
      ),
    );

    return base.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: card,
        labelStyle: TextStyle(color: muted),
        hintStyle: TextStyle(color: muted),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: foreground, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: foreground,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          minimumSize: const Size(0, 40),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          side: const BorderSide(color: border, width: 1),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          minimumSize: const Size(0, 40),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          minimumSize: const Size(0, 40),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: border, width: 1),
        ),
      ),
    );
  }
}
