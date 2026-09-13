import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'semantic_colors.dart';

class AppTheme {
  static const _primary = Color(0xFF6C5CE7);
  static const _secondary = Color(0xFF00CEC9);
  static const _bgPrimary = Color(0xFF0B0E14);
  static const _bgSurface = Color(0xFF151A23);
  static const _bgSurfaceLight = Color(0xFF1E2530);

  static ThemeData get lightTheme {
    return FlexThemeData.light(
      colors: FlexSchemeColor.from(primary: _primary),
      keyColors: const FlexKeyColors(
        useKeyColors: true,
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 0,
      appBarStyle: FlexAppBarStyle.primary,
      transparentStatusBar: true,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      tooltipsMatchBackground: true,
      swapColors: false,
      useMaterial3: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: 'Inter',
    ).copyWith(
      extensions: const [
        AppSemanticColors.light,
      ],
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      colors: FlexSchemeColor.from(
        primary: _primary,
        secondary: _secondary,
      ),
      scaffoldBackground: _bgPrimary,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 0, // Tint completely removed
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0.90,
      transparentStatusBar: true,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      tooltipsMatchBackground: true,
      swapColors: false,
      darkIsTrueBlack: false, 
      useMaterial3: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: 'Inter',
    ).copyWith(
      scaffoldBackgroundColor: _bgPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        brightness: Brightness.dark,
        surface: _bgSurface,
        surfaceContainerHighest: _bgSurfaceLight,
        surfaceTint: Colors.transparent, // Explicitly remove M3 surface tint
      ),
      extensions: const [
        AppSemanticColors.dark,
      ],
    );
  }
}
