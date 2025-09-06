class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic response;

  const ApiException({
    required this.message,
    required this.statusCode,
    this.response,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }
}
