import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'semantic_colors.dart';

class AppTheme {
  static const _primary = ColorTokens.accentPrimary;

  static ThemeData get lightTheme {
    return FlexThemeData.light(
      colors: FlexSchemeColor.from(primary: _primary),
      keyColors: const FlexKeyColors(
        useKeyColors: true,
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 10,
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
        secondary: ColorTokens.accentSecondary,
      ),
      scaffoldBackground: ColorTokens.bgPrimary,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 5, // Lowered blend so surfaces don't become muddy purple
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0.90,
      transparentStatusBar: true,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      tooltipsMatchBackground: true,
      swapColors: false,
      darkIsTrueBlack: false, // Turn this off so our custom bgPrimary isn't overridden to #000000
      useMaterial3: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: 'Inter',
    ).copyWith(
      scaffoldBackgroundColor: ColorTokens.bgPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        brightness: Brightness.dark,
        surface: ColorTokens.bgSurface,
        surfaceContainerHighest: ColorTokens.bgSurfaceLight,
      ),
      extensions: const [
        AppSemanticColors.dark,
      ],
    );
  }
}
