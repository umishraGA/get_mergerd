import 'package:dio/dio.dart';

import 'dio_client.dart';
import 'exceptions/api_exception.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final DioClient _dioClient = DioClient.instance;

  // Generic method to handle API responses
  Future<T> _handleResponse<T>(
    Future<Response> request,
    T Function(dynamic data) parser,
  ) async {
    try {
      final response = await request;
      return parser(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        message: e.message ?? 'An unexpected error occurred',
        statusCode: e.response?.statusCode ?? 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'An unexpected error occurred: $e',
        statusCode: 0,
      );
    }
  }

  // GET request with response handling
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) async {
    return _handleResponse(
      _dioClient.get(
        endpoint, 
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      ),
      parser,
    );
  }

  // POST request with response handling
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) async {
    return _handleResponse(
      _dioClient.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      ),
      parser,
    );
  }

  // PUT request with response handling
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) async {
    return _handleResponse(
      _dioClient.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      ),
      parser,
    );
  }

  // DELETE request with response handling
  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) async {
    return _handleResponse(
      _dioClient.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      ),
      parser,
    );
  }

  // PATCH request with response handling
  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
  }) async {
    return _handleResponse(
      _dioClient.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      ),
      parser,
    );
  }

  // Upload file
  Future<T> upload<T>(
    String endpoint,
    FormData formData, {
    ProgressCallback? onSendProgress,
    required T Function(dynamic data) parser,
  }) async {
    return _handleResponse(
      _dioClient.upload(
        endpoint,
        formData,
        onSendProgress: onSendProgress,
      ),
      parser,
    );
  }

  // Download file
  Future<void> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await _dioClient.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        message: e.message ?? 'Download failed',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  // Convenience methods for common response types

  // For APIs that return a simple success status
  Future<bool> getSuccess(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return get<bool>(
      endpoint,
      queryParameters: queryParameters,
      parser: (data) => (data['success'] as bool?) ?? true,
    );
  }

  // For APIs that return data in a 'data' field
  Future<T> getData<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
  }) async {
    return get<T>(
      endpoint,
      queryParameters: queryParameters,
      parser: (response) => parser(response['data']),
    );
  }

  // For APIs that return a list
  Future<List<T>> getList<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> item) itemParser,
  }) async {
    return get<List<T>>(
      endpoint,
      queryParameters: queryParameters,
      parser: (response) {
        final dynamic listData = response['data'] ?? response;
        final List<dynamic> list = (listData is List) ? listData : [];
        return list
            .map((item) => itemParser(item as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
