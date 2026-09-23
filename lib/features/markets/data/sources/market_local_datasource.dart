import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/features/markets/data/models/coin_model.dart';

/// Persists market coin data to disk via [SharedPreferences] so the app can
/// render instantly on subsequent launches without waiting for a network call.
class MarketLocalDataSource {
  static const _coinsKey = 'market_coins_cache';
  static const _cachedAtKey = 'market_coins_cached_at';

  /// Serializes [coins] to JSON and writes them to SharedPreferences alongside
  /// a timestamp so consumers can determine staleness.
  Future<void> saveCoins(List<CoinModel> coins) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = coins.map((c) => c.toJson()).toList();
    await prefs.setString(_coinsKey, jsonEncode(jsonList));
    await prefs.setString(_cachedAtKey, DateTime.now().toIso8601String());
  }

  /// Returns the previously cached coin list, or `null` if no cache exists.
  Future<List<CoinModel>?> getCachedCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_coinsKey);
    if (raw == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((json) => CoinModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupted cache — treat as empty.
      return null;
    }
  }

  /// How long ago the cache was written. Returns `null` if no timestamp is
  /// stored (i.e. no cache has ever been saved).
  Future<Duration?> getCacheAge() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cachedAtKey);
    if (raw == null) return null;
    final cachedAt = DateTime.tryParse(raw);
    if (cachedAt == null) return null;
    return DateTime.now().difference(cachedAt);
  }

  /// Wipes all cached market data from disk.
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coinsKey);
    await prefs.remove(_cachedAtKey);
  }
}
