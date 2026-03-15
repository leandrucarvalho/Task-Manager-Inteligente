import 'package:flutter/material.dart';

import 'page_transitions.dart';

class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF2E7D32),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFB7E4C7),
      onPrimaryContainer: Color(0xFF0F2E1B),
      secondary: Color(0xFF1565C0),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFCFE2FF),
      onSecondaryContainer: Color(0xFF0B2A4A),
      tertiary: Color(0xFF6A1B9A),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFE9D7F5),
      onTertiaryContainer: Color(0xFF2C0F3D),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: Color(0xFFF6F7FB),
      onSurface: Color(0xFF1B1B1F),
      surfaceVariant: Color(0xFFE4E6EE),
      onSurfaceVariant: Color(0xFF44474E),
      background: Color(0xFFF6F7FB),
      onBackground: Color(0xFF1B1B1F),
      outline: Color(0xFF757780),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.background,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.iOS: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.macOS: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.windows: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.linux: FadeSlidePageTransitionsBuilder(),
        },
      ),
      textTheme: base.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.surfaceVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceVariant,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.4),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: TextStyle(color: colorScheme.surface),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF81C784),
      onPrimary: Color(0xFF0B1F12),
      primaryContainer: Color(0xFF234F32),
      onPrimaryContainer: Color(0xFFB7E4C7),
      secondary: Color(0xFF90CAF9),
      onSecondary: Color(0xFF0C1A24),
      secondaryContainer: Color(0xFF1E3A56),
      onSecondaryContainer: Color(0xFFCFE2FF),
      tertiary: Color(0xFFCE93D8),
      onTertiary: Color(0xFF2C0F3D),
      tertiaryContainer: Color(0xFF4A235A),
      onTertiaryContainer: Color(0xFFE9D7F5),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF121212),
      onSurface: Color(0xFFE6E1E5),
      surfaceVariant: Color(0xFF2A2D34),
      onSurfaceVariant: Color(0xFFC5C6D0),
      background: Color(0xFF0F0F10),
      onBackground: Color(0xFFE6E1E5),
      outline: Color(0xFF8F9099),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.background,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.iOS: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.macOS: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.windows: FadeSlidePageTransitionsBuilder(),
          TargetPlatform.linux: FadeSlidePageTransitionsBuilder(),
        },
      ),
      textTheme: base.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.surfaceVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceVariant,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.4),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: TextStyle(color: colorScheme.surface),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

