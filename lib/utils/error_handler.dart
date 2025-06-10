import 'package:dio/dio.dart';

class ErrorHandler {
  static Exception handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('The connection to the server timed out');
      
      case DioExceptionType.badResponse:
        return _handleResponseError(e.response);
      
      case DioExceptionType.cancel:
        return Exception('The request was canceled');
      
      default:
        return Exception('Connection error: ${e.message}');
    }
  }

  static Exception _handleResponseError(Response? response) {
    final statusCode = response?.statusCode;
    final message = response?.data?['message'] ?? 'Unknown error.';
    
    switch (statusCode) {
      case 400:
        return Exception('Invalid data: $message');
      case 401:
        return Exception('Access denied: $message');
      case 403:
        return Exception('Access refused: $message');
      case 404:
        return Exception('Data not found: $message');
      case 409:
        return Exception('Data conflict: $message');
      case 422:
        return Exception('Invalid data: $message');
      case 500:
        return Exception('Server error: $message');
      default:
        return Exception('Unknown error: $message');
    }
  }

  // Các helper method khác
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      final exception = handleError(error);
      return exception.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }

  static bool isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }

  static bool isAuthError(DioException error) {
    return error.response?.statusCode == 401;
  }
} 