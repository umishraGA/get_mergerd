import 'package:dio/dio.dart';

import '../exceptions/api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiException apiException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        apiException = const ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );
        break;

      case DioExceptionType.badResponse:
        apiException = _handleHttpError(err.response!);
        break;

      case DioExceptionType.cancel:
        apiException = const ApiException(
          message: 'Request was cancelled',
          statusCode: 0,
        );
        break;

      case DioExceptionType.connectionError:
        apiException = const ApiException(
          message: 'No internet connection. Please check your connection.',
          statusCode: 0,
        );
        break;

      case DioExceptionType.badCertificate:
        apiException = const ApiException(
          message: 'Certificate verification failed',
          statusCode: 0,
        );
        break;

      case DioExceptionType.unknown:
      default:
        apiException = const ApiException(
          message: 'An unexpected error occurred. Please try again.',
          statusCode: 0,
        );
        break;
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        type: err.type,
        response: err.response,
      ),
    );
  }

  ApiException _handleHttpError(Response response) {
    final statusCode = response.statusCode ?? 0;
    String message;

    switch (statusCode) {
      case 400:
        message = _extractErrorMessage(response) ?? 'Bad request';
        break;
      case 401:
        message = 'Unauthorized. Please login again.';
        break;
      case 403:
        message = 'Access forbidden';
        break;
      case 404:
        message = 'Resource not found';
        break;
      case 422:
        message = _extractErrorMessage(response) ?? 'Validation error';
        break;
      case 500:
        message = 'Internal server error. Please try again later.';
        break;
      case 502:
        message = 'Bad gateway. Please try again later.';
        break;
      case 503:
        message = 'Service unavailable. Please try again later.';
        break;
      default:
        message = 'An error occurred. Please try again.';
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      response: response.data,
    );
  }

  String? _extractErrorMessage(Response response) {
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Try different common error message fields
        final message = data['message'] ??
            data['error'] ??
            data['error_description'] ??
            data['msg'];
        return message?.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
