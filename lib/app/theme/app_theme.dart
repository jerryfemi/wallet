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
      colors: FlexSchemeColor.from(primary: _primary),
      keyColors: const FlexKeyColors(
        useKeyColors: true,
      ),
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
    ).copyWith(
      extensions: const [
        AppSemanticColors.dark,
      ],
    );
  }
}
