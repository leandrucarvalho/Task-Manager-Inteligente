import 'package:flutter/material.dart';

class AppTheme {
  static const _radius = 16.0;

  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF3F51B5),
      onPrimary: Colors.white,
      secondary: Color(0xFF14B8A6),
      onSecondary: Colors.white,
      tertiary: Color(0xFFF59E0B),
      surface: Color(0xFFF8FAFC),
      onSurface: Color(0xFF0F172A),
      error: Color(0xFFDC2626),
      outline: Color(0xFFE2E8F0),
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF8B9DFF),
      onPrimary: Color(0xFF111827),
      secondary: Color(0xFF2DD4BF),
      onSecondary: Color(0xFF042F2E),
      tertiary: Color(0xFFFBBF24),
      surface: Color(0xFF0B1220),
      onSurface: Color(0xFFE2E8F0),
      error: Color(0xFFF87171),
      outline: Color(0xFF334155),
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final baseText = Typography.blackMountainView;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: baseText.copyWith(
        headlineSmall: baseText.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(height: 1.4),
        bodyMedium: baseText.bodyMedium?.copyWith(height: 1.35),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
        ),
        color: colorScheme.brightness == Brightness.dark
            ? const Color(0xFF111827)
            : Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.brightness == Brightness.dark
            ? const Color(0xFF111827)
            : Colors.white,
        hintStyle:
            TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.55)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: colorScheme.outline),
        selectedColor: colorScheme.primary.withValues(alpha: 0.14),
      ),
    );
  }
}
