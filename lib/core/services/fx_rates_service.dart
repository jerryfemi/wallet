import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FxRatesService {
  static const String _cacheKey = 'fx_rates_cache';
  static const String _lastFetchKey = 'fx_rates_last_fetch';
  final Dio _dio = Dio();

  /// Default offline fallback rates (USD as base)
  static const Map<String, double> _fallbackRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'NGN': 1500.0,
    'JPY': 155.0,
    'CAD': 1.37,
    'AUD': 1.52,
    'CHF': 0.91,
  };

  Future<Map<String, double>> getRates() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check cache first (valid for 1 hour)
    final lastFetchRaw = prefs.getString(_lastFetchKey);
    final cachedData = prefs.getString(_cacheKey);
    
    if (lastFetchRaw != null && cachedData != null) {
      final lastFetch = DateTime.tryParse(lastFetchRaw);
      if (lastFetch != null && DateTime.now().difference(lastFetch).inHours < 1) {
        try {
          final decoded = jsonDecode(cachedData) as Map<String, dynamic>;
          return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
        } catch (_) {
          // Fall through to fetch if cache is corrupted
        }
      }
    }

    try {
      final response = await _dio.get(
        'https://open.er-api.com/v6/latest/USD',
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data['result'] == 'success') {
        final ratesRaw = response.data['rates'] as Map<String, dynamic>;
        final rates = ratesRaw.map((key, value) => MapEntry(key, (value as num).toDouble()));
        
        // Save to cache
        await prefs.setString(_cacheKey, jsonEncode(rates));
        await prefs.setString(_lastFetchKey, DateTime.now().toIso8601String());
        
        return rates;
      }
    } catch (_) {
      // Offline or network error
    }

    // Return cached if available even if expired, else fallback
    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData) as Map<String, dynamic>;
        return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
      } catch (_) {}
    }

    return _fallbackRates;
  }
}
