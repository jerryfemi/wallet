import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'color_tokens.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: ColorTokens.accentPrimary,
        primaryContainer: ColorTokens.bgSurfaceLight,
        secondary: ColorTokens.accentSecondary,
        secondaryContainer: ColorTokens.bgSurface,
        tertiary: ColorTokens.positive,
        tertiaryContainer: ColorTokens.negative,
        appBarColor: ColorTokens.bgPrimary,
        error: ColorTokens.negative,
      ),
      scaffoldBackground: ColorTokens.bgPrimary,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 15,
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0.90,
      transparentStatusBar: true,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      tooltipsMatchBackground: true,
      swapColors: false,
      darkIsTrueBlack: true,
      useMaterial3: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: 'Inter',
    );
  }
}
