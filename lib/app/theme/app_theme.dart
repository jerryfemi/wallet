import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'semantic_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static const _primary = Color(0xFF6C5CE7);

  static const _subThemesData = FlexSubThemesData(
    defaultRadius: 16.0,
    buttonMinSize: Size(double.infinity, 56),
    inputDecoratorRadius: 12.0,
    inputDecoratorUnfocusedHasBorder: false,
    bottomSheetRadius: 24.0,
    cardRadius: 16.0,
  );

  static const _textTheme = TextTheme(
    displayLarge: AppTextStyles.h1,
    titleLarge: AppTextStyles.h2,
    titleMedium: AppTextStyles.subtitle,
    bodyLarge: AppTextStyles.body,
    bodyMedium: AppTextStyles.body,
    labelSmall: AppTextStyles.caption,
  );

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
      subThemesData: _subThemesData,
      textTheme: _textTheme,
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
      subThemesData: _subThemesData,
      textTheme: _textTheme,
    ).copyWith(extensions: const [AppSemanticColors.dark]);
  }
}
