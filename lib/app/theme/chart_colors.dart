import 'package:flutter/material.dart';

/// A palette of colors for charting, keyed by CoinGecko coin ID.
class ChartColors {
  ChartColors._();

  static const Map<String, Color> byCoinId = {
    'bitcoin': Color(0xFFF7931A),
    'ethereum': Color(0xFF627EEA),
    'tether': Color(0xFF26A17B),
    'solana': Color(0xFF9945FF),
    'ripple': Color(0xFF0085C0),
    'binancecoin': Color(0xFFF3BA2F),
    'cardano': Color(0xFF0033AD),
    'dogecoin': Color(0xFFC2A633),
    'polkadot': Color(0xFFE6007A),
    'avalanche-2': Color(0xFFE84142),
  };

  static const _fallbacks = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFE66D),
    Color(0xFF95E1D3),
    Color(0xFFA8E6CF),
    Color(0xFFDCEDC1),
  ];

  /// Returns the brand color for a known coin, or a cycling fallback color.
  static Color forCoin(String coinId, int index) {
    return byCoinId[coinId] ?? _fallbacks[index % _fallbacks.length];
  }
}
