import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'semantic_colors.dart';

class AppTheme {
  static const _primary = Color(0xFF6C5CE7);

  static ThemeData get lightTheme {
    return FlexThemeData.light(
      colors: FlexSchemeColor.from(primary: _primary),
      keyColors: const FlexKeyColors(useKeyColors: false),
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
    ).copyWith(extensions: const [AppSemanticColors.light]);
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      colors: FlexSchemeColor.from(primary: _primary),
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 0,
      appBarStyle: FlexAppBarStyle.background,
      transparentStatusBar: true,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      tooltipsMatchBackground: true,
      swapColors: false,
      useMaterial3: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: 'Inter',
    ).copyWith(extensions: const [AppSemanticColors.dark]);
  }
}
