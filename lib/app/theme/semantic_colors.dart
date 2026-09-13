import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color positive;
  final Color negative;

  const AppSemanticColors({required this.positive, required this.negative});

  static const light = AppSemanticColors(
    positive: Color(0xFF22C55E),
    negative: Color(0xFFEF4444),
  );

  static const dark = AppSemanticColors(
    positive: Color(0xFF22C55E),
    negative: Color(0xFFEF4444),
  );

  @override
  AppSemanticColors copyWith({Color? positive, Color? negative}) {
    return AppSemanticColors(
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
    );
  }

  @override
  AppSemanticColors lerp(covariant AppSemanticColors? other, double t) {
    if (other == null) return this;

    return AppSemanticColors(
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
    );
  }
}
