import 'package:dio/dio.dart';
import '../config/env_config.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add any request modifications here
          print('🌐 Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
          
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          // Handle successful responses
          print('✅ Response: ${response.statusCode}');
          print('Data: ${response.data}');
          
          return handler.next(response);
        },
        onError: (error, handler) async {
          // Handle errors
          print('❌ Error: ${error.message}');
          print('Response: ${error.response}');
          
          // You can modify the error before passing it
          if (error.response?.statusCode == 401) {
            // Handle unauthorized error
            // Example: Refresh token or logout
          }
          
          return handler.next(error);
        },
      ),
    );
  }

  // Helper methods for common HTTP operations
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Add other methods as needed (put, delete, etc.)
} 