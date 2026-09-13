import 'package:dio/dio.dart';

class DioClient {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // You could add an API key here if you had a Pro CoinGecko account:
          // options.queryParameters['x_cg_demo_api_key'] = 'YOUR_API_KEY';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Centralized error logging could go here
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
